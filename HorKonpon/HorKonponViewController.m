//
//  HorKonponViewController.m
//  HorKonpon
//
//  Copyright (c) 2014 Kubbit Information Technology. All rights reserved.
//

#import "HorKonponViewController.h"

@interface HorKonponViewController ()

- (IBAction)takePhoto:(id)sender;

@end

@implementation HorKonponViewController

CLLocationManager *locationManager;
CLGeocoder *geocoder;
CLPlacemark *placemark;
Gertakaria *gertakaria;
HttpPost *httpPost;
UIAlertView *waitDialog;
UIImage *camera;
Boolean keyboardVisible;
CGFloat tsvViewHeight;

- (void) viewDidLoad
{
	[super viewDidLoad];

	// tintColor in iOS >= 7 changes font color while in iOS <= 6 it changes background color
	if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
	{
		[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:(51/255.f) green:(181/255.f) blue:(229/255.f) alpha:1.0f]];
		[self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:(51/255.f) green:(181/255.f) blue:(229/255.f) alpha:1.0f]];
	}

	locationManager = [[CLLocationManager alloc] init];
	geocoder = [[CLGeocoder alloc] init];
	gertakaria = [[Gertakaria alloc] init];
	httpPost = [[HttpPost alloc] init];
	httpPost.delegate = self;
	camera = [UIImage imageNamed:@"camera.png"];

	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;

	self.lbTitle.title = NSLocalizedString(@"Kokapena bilatzen...", @"");
	[locationManager startUpdatingLocation];

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Bidali", @"")
	 style:UIBarButtonItemStylePlain target:self action:@selector(sendOnClick:)];

	// fix to prevent keyboard hiding text edition
	tsvViewHeight = self.tsvView.contentSize.height;
	NSNotificationCenter* notifCenter = [NSNotificationCenter defaultCenter];

	[notifCenter addObserver:self selector:@selector(onShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
	[notifCenter addObserver:self selector:@selector(onHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];

	[self cleanUp];
}

- (void) onShowKeyboard:(NSNotification*)notif
{
	NSDictionary* userInfo = [notif userInfo];
	CGRect keyboardFrame;

	[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];

	CGFloat keyboardHeight = 0;
	switch ([UIApplication sharedApplication].statusBarOrientation)
	{
		case UIInterfaceOrientationPortrait:
		case UIInterfaceOrientationPortraitUpsideDown:
			keyboardHeight = keyboardFrame.size.height;
			break;
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:
			keyboardHeight = keyboardFrame.size.width;
			break;
	}

	// enlarge scrollview
	CGFloat newHeight = self.tsvView.contentSize.height + keyboardHeight;
	[self.tsvView setContentSize:(CGSizeMake(self.tsvView.contentSize.width, newHeight))];

	// scroll to text box
	CGPoint bottomOffset = CGPointMake(0, self.lbOharrak.frame.origin.y);
	[self.tsvView setContentOffset:bottomOffset animated:YES];
}

- (void) onHideKeyboard:(NSNotification*)notif
{
	// revert scrollview to original size
	[self.tsvView setContentSize:(CGSizeMake(self.tsvView.contentSize.width, tsvViewHeight))];
}

- (void) didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void) cleanUp
{
	self.btPhoto.imageView.contentMode = UIViewContentModeCenter;
	[self.btPhoto setImage:camera forState:UIControlStateNormal];

	self.txtOharrak.text = @"";

	[gertakaria gehituArgazkia:nil];
        gertakaria.oharrak = nil;
}

- (void) showWait
{
	waitDialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Bidaltzen...", @"")
	 message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];

	UIActivityIndicatorView *progress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
	[progress startAnimating];

	// iOS < 7
	if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
	{
		[waitDialog addSubview:progress];
		[waitDialog show];

		progress.frame = CGRectMake
		(
			waitDialog.frame.size.width / 2 - progress.frame.size.width,
			waitDialog.frame.size.height - progress.frame.size.height * 3.5,
			progress.frame.size.width,
			progress.frame.size.height
		);
	}
	// iOS >= 7
	else
	{
		[waitDialog setValue:progress forKey:@"accessoryView"];
		[waitDialog show];
	}

}

- (IBAction) takePhoto:(id)sender
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;

	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	else
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

	[self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction) sendOnClick:(id)sender
{
	gertakaria.oharrak = self.txtOharrak.text;

	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	gertakaria.izena = [prefs stringForKey:@"pref_fullname"];
	gertakaria.telefonoa = [prefs stringForKey:@"pref_phone"];
	gertakaria.posta = [prefs stringForKey:@"pref_mail"];
	gertakaria.hizkuntza = [prefs stringForKey:@"pref_language"];
	gertakaria.ohartarazi = [prefs boolForKey:@"pref_notify"];

	if (![gertakaria validate])
		return;

	[self showWait];

	DebugLog(@"%@", [gertakaria asJSON]);
	[httpPost send: HORKONPON_API_URL data: [NSString stringWithFormat:@"datuak=%@", [gertakaria asJSON]]];
}

- (void) httpPost:(HttpPost*)httpPost responseReceived:(NSString*)response;
{
	[waitDialog dismissWithClickedButtonIndex:0 animated:YES];

	NSError *jsonParsingError = nil;
	NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];

	NSDictionary* json = [NSJSONSerialization
	JSONObjectWithData:jsonData
	 options:kNilOptions
	 error:&jsonParsingError];

	NSString *result;
	if (jsonParsingError == nil)
	{
		result = [json objectForKey:@"mezua"];
		[self cleanUp];
	}
	else
	{
		DebugLog(@"Error parsing JSON: %@", jsonParsingError);
		result = NSLocalizedString(@"Bidaltzerakoan errorea. Beranduago saiatu berriz ere.", @"");
	}

	UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
	 message:result
	 delegate:self
	 cancelButtonTitle:NSLocalizedString(@"Onartu", @"")
	 otherButtonTitles:nil];
	[message show];
}

- (void) httpPost:(HttpPost*)httpPost onError:(NSString*)message
{
	[waitDialog dismissWithClickedButtonIndex:0 animated:YES];

	[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Errorea", @"")
	 message:message
	 delegate:nil
	 cancelButtonTitle:NSLocalizedString(@"Onartu", @"")
	 otherButtonTitles:nil] show];
}

- (void) locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
	DebugLog(@"didFailWithError: %@", error);
	self.lbTitle.title = NSLocalizedString(@"Kokapena ezin izan da ezarri. GPS-a aktibo dagoelaz ziurtatu", @"");
}

- (void) locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation
{
	DebugLog(@"didUpdateToLocation: %@", newLocation);
	CLLocation *currentLocation = newLocation;
	
	if (currentLocation != nil)
	{
		gertakaria.latitudea = [NSNumber numberWithDouble: currentLocation.coordinate.latitude];
		gertakaria.longitudea = [NSNumber numberWithDouble: currentLocation.coordinate.longitude];
		gertakaria.zehaztasuna = [NSNumber numberWithDouble: currentLocation.horizontalAccuracy];

		DebugLog(@"%.8f, %.8f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);

		self.lbTitle.title = NSLocalizedString(@"Kokapena ezarrita", @"");
	}

	// Stop Location Manager
	[locationManager stopUpdatingLocation];

	// Reverse Geocoding
	DebugLog(@"Resolving the Address");
	[geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
	{
		DebugLog(@"Found placemarks: %@, error: %@", placemarks, error);
		if (error == nil && [placemarks count] > 0)
		{
			placemark = [placemarks lastObject];
			DebugLog(@"%@ %@\n%@ %@\n%@\n%@",
			 placemark.subThoroughfare, placemark.thoroughfare,
			 placemark.postalCode, placemark.locality,
			 placemark.administrativeArea,
			 placemark.country);
			self.lbTitle.title = placemark.locality;
		}
		else
		{
			DebugLog(@"%@", error.debugDescription);
		}
	}];
}

- (void) imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
	UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
	chosenImage = [Image resize:chosenImage];
	[gertakaria gehituArgazkia:chosenImage];
	self.btPhoto.imageView.contentMode = UIViewContentModeScaleAspectFill;
	[self.btPhoto setImage:chosenImage forState:UIControlStateNormal];

	[picker dismissViewControllerAnimated:YES completion:NULL];

	self.lbTitle.title = NSLocalizedString(@"Kokapena bilatzen...", @"");
	[locationManager startUpdatingLocation];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
	[picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	UITouch *touch = [touches anyObject];

	if ([self.txtOharrak isFirstResponder] && [touch view] != self.txtOharrak)
		[self.txtOharrak resignFirstResponder];
}

@end

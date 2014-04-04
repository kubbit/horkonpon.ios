//
//  DisclaimerViewController.m
//  HorKonpon
//
//  Copyright (c) 2014 Kubbit Information Technology. All rights reserved.
//

#import "DisclaimerViewController.h"

@interface DisclaimerViewController ()

@end

@implementation DisclaimerViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

	if (self)
	{
		// Custom initialization
	}

	return self;
}

- (void) viewDidLoad
{
	[super viewDidLoad];

	NSString *html = NSLocalizedString(@"DISCLAIMER", @"");

	[self.wvDisclaimer loadHTMLString:html baseURL:nil];
}

- (void) didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end

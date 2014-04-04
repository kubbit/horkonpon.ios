//
//  Gertakaria.m
//  HorKonpon
//
//  Copyright (c) 2014 Kubbit Information Technology. All rights reserved.
//

#import "Gertakaria.h"
#import "base64.h"
#import "Constants.h"

@implementation Gertakaria

@synthesize argazkia;
@synthesize fitxategiIzena;
@synthesize latitudea;
@synthesize longitudea;
@synthesize zehaztasuna;
@synthesize herria;
@synthesize izena;
@synthesize telefonoa;
@synthesize posta;
@synthesize oharrak;
@synthesize ohartarazi;
@synthesize hizkuntza;

- (void) gehituArgazkia:(UIImage*)pArgazkia
{
	NSData* data = UIImageJPEGRepresentation(pArgazkia, 0.9f);
	[Base64 initialize];
	self.argazkia = [Base64 encode:data];
}


- (BOOL) validate
{
	UIAlertView *message;

	if ((self.argazkia == nil || [self.argazkia isEqual: @""]) && (self.oharrak == nil || [self.oharrak isEqual: @""]))
	{
		message = [[UIAlertView alloc] initWithTitle:@""
		 message:NSLocalizedString(@"Argazkia edo oharra beharrezkoa da", @"")
		 delegate:self
		 cancelButtonTitle:NSLocalizedString(@"Onartu", @"")
		 otherButtonTitles:nil];
		[message show];

		return NO;
	}

	if ((self.latitudea == nil || self.latitudea == 0) && (self.longitudea == nil || self.longitudea == 0))
	{
		message = [[UIAlertView alloc] initWithTitle:@""
		 message:NSLocalizedString(@"Kokapena ezin izan da ezarri. GPS-a aktibo dagoelaz ziurtatu", @"")
		 delegate:self
		 cancelButtonTitle:NSLocalizedString(@"Onartu", @"")
		 otherButtonTitles:nil];
		[message show];

		return NO;
	}

	return YES;
}

- (NSString*) asJSON
{
	NSMutableDictionary *json =
	[@{
		@"bertsioa": [NSNumber numberWithInteger:HORKONPON_API_MESSAGE_VERSION]
	} mutableCopy];

	NSDictionary *jsApp =
	@{
		@"os": [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion],
		@"version": [NSString stringWithFormat:@"%@-%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], HORKONPON_REVISION]
	};
	json[@"app"] = jsApp;

	if (self.argazkia != nil && ![self.argazkia isEqual: @""])
	{
		NSDictionary *jsArgazkia =
		@{
			@"izena": @"",
			@"edukia": self.argazkia
		};

		json[@"argazkia"] = jsArgazkia;
	}

	if (self.latitudea != 0 || self.longitudea != 0)
	{
		NSDictionary *jsGPS =
		@{
			@"latitudea": self.latitudea,
			@"longitudea": self.longitudea,
			@"zehaztasuna": self.zehaztasuna
		};

		json[@"gps"] = jsGPS;
	}

	if (self.herria != nil && ![self.herria isEqual: @""])
		json[@"herria"] = self.herria;

	if (self.izena != nil && ![self.izena isEqual: @""])
		json[@"izena"] = self.izena;

	if (self.telefonoa != nil && ![self.telefonoa isEqual: @""])
		json[@"telefonoa"] = self.telefonoa;

	if (self.posta != nil && ![self.posta isEqual: @""])
		json[@"posta"] = self.posta;

	if (self.oharrak != nil && ![self.oharrak isEqual: @""])
		json[@"oharrak"] = self.oharrak;

	if (self.ohartarazi)
		[json setValue:[NSNumber numberWithBool:self.ohartarazi] forKey:@"ohartarazi"];

	if (self.hizkuntza == nil || [self.hizkuntza isEqual: @""])
		json[@"hizkuntza"] = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
	else
		json[@"hizkuntza"] = self.hizkuntza;

	NSError* error = nil;
	NSData* jsGertakaria;
	if ([NSJSONSerialization isValidJSONObject:json])
	{
		// Serialize the dictionary
		jsGertakaria = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];

		// If no errors, let's view the JSON
		if (jsGertakaria != nil && error == nil)
		{
			NSString *jsonString = [[NSString alloc] initWithData:jsGertakaria encoding:NSUTF8StringEncoding];

			DebugLog(@"JSON: %@", jsonString);

			return jsonString;
		}
	}

	return @"";
}

@end

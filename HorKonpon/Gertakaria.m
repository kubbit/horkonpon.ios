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

@synthesize sortzeData;
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

- (id) init
{
	self = [super init];
	if (self == nil)
		return self;

	[self ezarriData];

	return self;
}

- (void) gehituArgazkia:(UIImage*)pArgazkia
{
	NSData* data = UIImageJPEGRepresentation(pArgazkia, 0.9f);
	[Base64 initialize];
	self.argazkia = [Base64 encode:data];

	[self ezarriData];
}

- (void) ezarriData;
{
	self.sortzeData = [NSDate date];
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
		@"version": [NSNumber numberWithInteger:HORKONPON_API_MESSAGE_VERSION]
	} mutableCopy];

	NSDateFormatter *formatter;
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
	json[@"date"] = [formatter stringFromDate:self.sortzeData];

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
			@"filename": @"",
			@"content": self.argazkia
		};

		json[@"file"] = jsArgazkia;
	}

	if (self.latitudea != 0 || self.longitudea != 0)
	{
		NSDictionary *jsGPS =
		@{
			@"latitude": self.latitudea,
			@"longitude": self.longitudea,
			@"accuracy": self.zehaztasuna
		};

		json[@"gps"] = jsGPS;
	}

	if (self.herria != nil && ![self.herria isEqual: @""])
	{
		NSDictionary *jsHelbidea =
		@{
			json[@"locality"]: self.herria
		};

		json[@"address"] = jsHelbidea;
	}

	NSMutableDictionary *jsErabiltzailea =
	[@{
	} mutableCopy];

	if (!self.anonimoa)
	{
		if (self.izena != nil && ![self.izena isEqual: @""])
			jsErabiltzailea[@"fullname"] = self.izena;

		if (self.telefonoa != nil && ![self.telefonoa isEqual: @""])
			jsErabiltzailea[@"phone"] = self.telefonoa;

		if (self.posta != nil && ![self.posta isEqual: @""])
			jsErabiltzailea[@"mail"] = self.posta;

		if (self.ohartarazi)
			[jsErabiltzailea setValue:[NSNumber numberWithBool:self.ohartarazi] forKey:@"notify"];
	}
	else
                [jsErabiltzailea setValue:[NSNumber numberWithBool:self.ohartarazi] forKey:@"anonymous"];

	if (self.hizkuntza == nil || [self.hizkuntza isEqual: @""])
		jsErabiltzailea[@"language"] = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
	else
		jsErabiltzailea[@"language"] = self.hizkuntza;

	json[@"user"] = jsErabiltzailea;

	if (self.oharrak != nil && ![self.oharrak isEqual: @""])
		json[@"comments"] = self.oharrak;

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

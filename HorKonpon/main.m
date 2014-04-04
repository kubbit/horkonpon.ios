//
//  main.m
//  HorKonpon
//
//  Copyright (c) 2014 Kubbit Information Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HorKonponAppDelegate.h"

void setLanguage()
{
	NSString* language = [[NSUserDefaults standardUserDefaults] stringForKey:@"pref_language"];

	BOOL useSystemLanguage = language == nil || [language isEqual: @""];

	if (!useSystemLanguage)
	{
		[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:language, nil] forKey:@"AppleLanguages"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

int main(int argc, char *argv[])
{
	setLanguage();

	@autoreleasepool
	{
		return UIApplicationMain(argc, argv, nil, NSStringFromClass([HorKonponAppDelegate class]));
	}
}

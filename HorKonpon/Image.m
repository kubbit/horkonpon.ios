//
//  Image.m
//  HorKonpon
//
//  Copyright (c) 2014 Kubbit Information Technology. All rights reserved.
//

#import "Image.h"

@implementation Image

+ (UIImage*) resize:(UIImage*)image
{
	float MAX_WIDTH = 800;
	float MAX_HEIGHT = 800;

	float actualHeight = image.size.height;
	float actualWidth = image.size.width;
	float imgRatio = actualWidth / actualHeight;
	float maxRatio = MAX_WIDTH / MAX_HEIGHT;

	if (actualWidth > MAX_WIDTH || actualHeight > MAX_HEIGHT)
	{
		if (imgRatio < maxRatio)
		{
			imgRatio = MAX_HEIGHT / actualHeight;
			actualWidth = imgRatio * actualWidth;
			actualHeight = MAX_HEIGHT;
		}
		else
		{
			imgRatio = MAX_WIDTH / actualWidth;
			actualHeight = imgRatio * actualHeight;
			actualWidth = MAX_WIDTH;
		}
	}


	CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
	UIGraphicsBeginImageContext(rect.size);
	[image drawInRect:rect];

	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return newImage;
}

@end

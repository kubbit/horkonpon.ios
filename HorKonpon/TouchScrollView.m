//
//  TouchScrollView.m
//  HorKonpon
//
//  Copyright (c) 2014 Kubbit Information Technology. All rights reserved.
//

#import "TouchScrollView.h"

@implementation TouchScrollView

- (id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	return self;
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	if (!self.dragging)
		[self.nextResponder touchesEnded: touches withEvent:event];

	[super touchesEnded: touches withEvent: event];
}

@end

//
//  HorKonponViewController.h
//  HorKonpon
//
//  Copyright (c) 2014 Kubbit Information Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TouchScrollView.h"
#import "Gertakaria.h"
#import "HttpPost.h"
#import "Image.h"
#import "Constants.h"

@interface HorKonponViewController : UIViewController <CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, HttpPostDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btPhoto;
@property (weak, nonatomic) IBOutlet UINavigationItem *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbOharrak;
@property (weak, nonatomic) IBOutlet UITextView *txtOharrak;
@property (strong, nonatomic) IBOutlet TouchScrollView *tsvView;

@end

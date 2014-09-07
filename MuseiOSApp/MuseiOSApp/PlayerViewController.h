//
//  PlayerViewController.h
//  MuseiOSApp
//
//  Created by George Lo on 9/22/13.
//  Copyright (c) 2013 George Lo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"

@interface PlayerViewController : UIViewController <MPMediaPickerControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *detail;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSInteger index;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

@end

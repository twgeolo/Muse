//
//  YoutubeViewController.h
//  MuseiOSApp
//
//  Created by George Lo on 9/22/13.
//  Copyright (c) 2013 George Lo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YoutubeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) NSString *urlStr;

@end

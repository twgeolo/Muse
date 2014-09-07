//
//  AppDelegate.h
//  MuseiOSApp
//
//  Created by George Lo on 9/21/13.
//  Copyright (c) 2013 George Lo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (NSData *)sendHTTPRequestWithPostStr: (NSString *)postStr andURL: (NSString *)URLStr;

- (NSData *)sendHTTPRequestWithURL: (NSString *)URLStr;

@end

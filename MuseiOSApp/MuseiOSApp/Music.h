//
//  Music.h
//  MuseiOSApp
//
//  Created by George Lo on 9/22/13.
//  Copyright (c) 2013 George Lo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Music : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *detail;
@property (nonatomic) UIImage *image;

- (Music *)initWithTitle: (NSString *)m_title andDetail: (NSString *)m_detail andImage: (UIImage *)m_image;

@end

//
//  Music.m
//  MuseiOSApp
//
//  Created by George Lo on 9/22/13.
//  Copyright (c) 2013 George Lo. All rights reserved.
//

#import "Music.h"

@implementation Music

@synthesize title;
@synthesize detail;
@synthesize image;

- (Music *)initWithTitle:(NSString *)m_title andDetail:(NSString *)m_detail andImage:(UIImage *)m_image {
    title = m_title;
    detail = m_detail;
    image = m_image;
    return self;
}

@end

//
//  SearchViewController.h
//  MuseiOSApp
//
//  Created by George Lo on 9/21/13.
//  Copyright (c) 2013 George Lo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SearchViewController : UITableViewController <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchUserBar;

@end

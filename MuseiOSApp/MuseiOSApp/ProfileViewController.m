//
//  ProfileViewController.m
//  MuseiOSApp
//
//  Created by George Lo on 9/21/13.
//  Copyright (c) 2013 George Lo. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController {
    NSMutableArray *sectionTitles;
    NSMutableArray *rowTitles;
    NSMutableArray *rowDetails;
    NSString *song;
    NSString *weatherURL;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSData *data = [appDelegate sendHTTPRequestWithURL:[NSString stringWithFormat:@"http://api.wunderground.com/api/5b62669a811c7768/forecast/q/%@.json",[[NSUserDefaults standardUserDefaults] objectForKey:@"Country"]]];
    NSString *condition;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *days = [[[dict objectForKey:@"forecast"] objectForKey:@"txt_forecast"] objectForKey:@"forecastday"];
    for( NSDictionary *dict in days ) {
        condition = [dict objectForKey:@"icon"];
        weatherURL = [dict objectForKey:@"icon_url"];
        break;
    }
    if( [condition rangeOfString:@"cloudy"].location!=NSNotFound ) {
        song = @"David Guetta - Crank It Up";
    } else if( [condition rangeOfString:@"clear"].location!=NSNotFound ) {
        song = @"Carly Jepsen - Call me maybe";
    } else if( [condition rangeOfString:@"rain"].location!=NSNotFound ) {
        song = @"Taylor Swift - Back to December";
    } else {
        song = @"PSY - Gangnam Style";
    }
    
    self.navigationItem.title = [[NSUserDefaults standardUserDefaults] objectForKey:@"Profile"];
    sectionTitles = [[NSMutableArray alloc] initWithObjects:@"Name", @"Location", @"Others", @"Change Password", @"", @"", nil];
    NSMutableArray *name = [[NSMutableArray alloc] initWithObjects:@"First", @"Last", nil];
    NSMutableArray *location = [[NSMutableArray alloc] initWithObjects:@"Zip Code", @"", nil];
    NSMutableArray *others = [[NSMutableArray alloc] initWithObjects:@"Age", @"Privacy", @"UserId", nil];
    NSMutableArray *password = [[NSMutableArray alloc] initWithObjects:@"Old Pass", @"New Pass", @"Confirm Pass", nil];
    NSMutableArray *button = [[NSMutableArray alloc] initWithObjects:@"", nil];
    NSMutableArray *button2 = [[NSMutableArray alloc] initWithObjects:@"", nil];
    rowTitles = [[NSMutableArray alloc] initWithObjects:name, location, others, password, button, button2, nil];
    // Picture
    NSMutableArray *dname = [[NSMutableArray alloc] initWithObjects:[[NSUserDefaults standardUserDefaults] objectForKey:@"First"], [[NSUserDefaults standardUserDefaults] objectForKey:@"Last"], nil];
    NSMutableArray *dlocation = [[NSMutableArray alloc] initWithObjects:[[NSUserDefaults standardUserDefaults] objectForKey:@"Country"], @"", nil];
    NSString *privacy;
    if( [[[NSUserDefaults standardUserDefaults] objectForKey:@"Privacy"] integerValue]==0 ) {
        privacy = @"Only me";
    } else if( [[[NSUserDefaults standardUserDefaults] objectForKey:@"Privacy"] integerValue]==1 ) {
        privacy = @"Followers only";
    } else {
        privacy = @"Everyone";
    }
    NSMutableArray *dothers = [[NSMutableArray alloc] initWithObjects:[[NSUserDefaults standardUserDefaults] objectForKey:@"Age"],  privacy, [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"], nil];
    NSMutableArray *dpassword = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", nil];
    NSMutableArray *dbutton = [[NSMutableArray alloc] initWithObjects:@"", nil];
    NSMutableArray *dbutton2 = [[NSMutableArray alloc] initWithObjects:@"", nil];
    rowDetails = [[NSMutableArray alloc] initWithObjects:dname, dlocation, dothers, dpassword, dbutton, dbutton2, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if( indexPath.section==1 && indexPath.row==1 ) {
        return 65;
    }
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionTitles objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[rowTitles objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Profile Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    for(UIView *view in cell.contentView.subviews){
        if( [view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIImageView class]] ) {
            [view removeFromSuperview];
        }
    }
    
    if( indexPath.section==1 && indexPath.row==1 ) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(20, 2, 60, 56)];
        iv.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:weatherURL]]];
        [cell.contentView addSubview:iv];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 2, 160, 56)];
        label.text = [NSString stringWithFormat:@"We suggest you listen to \"%@\"",song];
        label.font = [UIFont boldSystemFontOfSize:13];
        label.textColor = [UIColor grayColor];
        label.numberOfLines=3;
        [cell.contentView addSubview:label];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if( indexPath.section<4 ) {
        cell.textLabel.text = [[rowTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [[rowDetails objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    } else if( indexPath.section==4 ) {
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = nil;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, cell.frame.size.height)];
        label.text = @"Save";
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = [UIColor colorWithRed:0 green:(102.0/255.0) blue:(204.0/255.0) alpha:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
    } else {
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = nil;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, cell.frame.size.height)];
        label.text = @"Log Off";
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if( indexPath.section==1 && indexPath.row==1 ) {
        [self performSegueWithIdentifier:@"toYoutube" sender:self];
    }
    if( indexPath.section==4 ) {
        [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Info Saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    if( indexPath.section==5 ) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [segue.identifier isEqualToString:@"toYoutube"] ) {
        YoutubeViewController *yvc = segue.destinationViewController;
        yvc.urlStr = [NSString stringWithFormat:@"https://www.youtube.com/results?search_query=%@", [song stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end

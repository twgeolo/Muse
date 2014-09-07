//
//  TimelineViewController.m
//  MuseiOSApp
//
//  Created by George Lo on 9/21/13.
//  Copyright (c) 2013 George Lo. All rights reserved.
//

#import "TimelineViewController.h"

@interface TimelineViewController ()

@end

@implementation TimelineViewController {
    NSMutableArray *sectionTitles;
    NSMutableArray *rowTitles;
    NSMutableArray *likeAry;
    NSMutableArray *timelineAry;
    UIButton *composeBtn;
    NSInteger selectedSec;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIButton *)makeComposeBtnWithCGRect: (CGRect) rect {
    UIButton *composeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    composeButton.frame = rect;
    composeButton.layer.shadowColor = [UIColor blackColor].CGColor;
    composeButton.layer.shadowOpacity = 0.8;
    composeButton.layer.shadowRadius = 10;
    composeButton.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    composeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    composeButton.layer.borderWidth = 2.0f;
    composeButton.layer.cornerRadius = 20.0f;
    [composeButton setImage:[UIImage imageNamed:@"Compose.png"] forState:UIControlStateNormal];
    [composeButton addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchDown];
    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = composeButton.bounds;
    btnGradient.cornerRadius = 20.0f;
    btnGradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:100/255.0 green:123/255.0 blue:142/255.0 alpha:0.8].CGColor,(id)[UIColor colorWithRed:17/255.0 green:48/255.0 blue:90/255.0 alpha:1].CGColor,nil];
    [composeButton.layer insertSublayer:btnGradient atIndex:0];
    [composeButton bringSubviewToFront:composeButton.imageView];
    return composeButton;
}

- (IBAction)addBtnClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"What's on your mind?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Post", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if( [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Post"] ) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSData *data = [appDelegate sendHTTPRequestWithURL:[NSString stringWithFormat:@"http://muse.azurewebsites.net/api/Timeline/?userid=%li&content=%@&privacy=%li", (long)[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] integerValue], [[[alertView textFieldAtIndex:0]text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], (long)[[[NSUserDefaults standardUserDefaults] objectForKey:@"Privacy"] integerValue] ]];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if([[array objectAtIndex:0] isEqualToString:@"Success"] ) {
            [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Posted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            [self refresh];
            [self.tableView reloadData];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:composeBtn];
}

- (void)viewWillDisappear:(BOOL)animated {
    [composeBtn removeFromSuperview];
}

- (void)refresh {
    [sectionTitles removeAllObjects];
    [rowTitles removeAllObjects];
    [timelineAry removeAllObjects];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSData *data = [appDelegate sendHTTPRequestWithURL:@"http://muse.azurewebsites.net/api/Timeline/"];
    NSArray *ary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    for( NSDictionary *dict in ary ) {
        NSLog(@"%@",dict);
        NSData *data2 = [appDelegate sendHTTPRequestWithURL:[NSString stringWithFormat:@"http://muse.azurewebsites.net/api/Timeline/?userID=%li",(long)[[dict objectForKey:@"userID"] integerValue]]];
        NSArray *ary2 =[NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingAllowFragments error:nil];
        for( NSDictionary *dict2 in ary2 ) {
            [sectionTitles addObject:[dict2 objectForKey:@"Profile"]];
        }
        [rowTitles addObject:[dict objectForKey:@"content"]];
        [likeAry addObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"like"]]];
        [timelineAry addObject:[NSNumber numberWithInt:[[dict objectForKey:@"timelineID"] integerValue]]];
        
    }
    [self.refreshControl endRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    composeBtn = [self makeComposeBtnWithCGRect:CGRectMake([[UIScreen mainScreen] bounds].size.width-60, [[UIScreen mainScreen] bounds].size.height-110 , 45, 45)];

    sectionTitles = [[NSMutableArray alloc] init];
    rowTitles = [[NSMutableArray alloc] init];
    likeAry = [[NSMutableArray alloc] init];
    timelineAry = [[NSMutableArray alloc] init];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self refresh];
}

- (IBAction)refresh:(id)sender {
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[sectionTitles objectAtIndex:(sectionTitles.count-section-1)] stringByAppendingString:@" said:"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (void)like: (UITapGestureRecognizer *)gestureRecognizer {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate sendHTTPRequestWithURL:[NSString stringWithFormat:@"http://muse.azurewebsites.net/api/Timeline/?timelineID=%i&count=1",[[timelineAry objectAtIndex:timelineAry.count-selectedSec-1] integerValue]]];
    [self refresh];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Timeline Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(like:)];
    tapGesture.numberOfTapsRequired = 2;
    [cell addGestureRecognizer:tapGesture];
    
    cell.textLabel.text = [rowTitles objectAtIndex:(rowTitles.count-indexPath.section-1)];
    cell.detailTextLabel.text = [[likeAry objectAtIndex:(likeAry.count-indexPath.section-1)] stringByAppendingString:@" Likes"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedSec = indexPath.section;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

//
//  RegistrationViewController.m
//  MuseiOSApp
//
//  Created by George Lo on 9/21/13.
//  Copyright (c) 2013 George Lo. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController {
    NSMutableArray *sectionTitles;
    NSMutableArray *rowTitles;
    NSMutableArray *rowData;
    UITextField *selectedTF;
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

    sectionTitles = [[NSMutableArray alloc] initWithObjects:@"Name", @"Password", @"Others", @"", nil];
    NSMutableArray *names = [[NSMutableArray alloc] initWithObjects:@"First", @"Last", @"Profile", nil];
    NSMutableArray *pass = [[NSMutableArray alloc] initWithObjects:@"Password", @"Confirm Pass", nil];
    NSMutableArray *others = [[NSMutableArray alloc] initWithObjects:@"Age", @"Zip Code", @"Privacy", nil];
    NSMutableArray *btn = [[NSMutableArray alloc] initWithObjects:@"", nil];
    rowTitles = [[NSMutableArray alloc] initWithObjects:names, pass, others, btn, nil];
    rowData = [[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc] initWithObjects:@"", @"", @"", nil], [[NSMutableArray alloc] initWithObjects:@"", @"", nil], [[NSMutableArray alloc] initWithObjects:@"", @"", @"", nil], [[NSMutableArray alloc] initWithObjects:@"", nil], nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
    static NSString *CellIdentifier = @"Register Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    for(UIView *view in cell.contentView.subviews ) {
        if( [view isKindOfClass:[UITextField class]] ) {
            [view removeFromSuperview];
        }
    }
    
    cell.textLabel.text = [[rowTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    int x;
    if( indexPath.section==0 ) {
        x = 105;
    } else if( indexPath.section==1 ) {
        x = 140;
    } else {
        x = 120;
    }
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(x, 7, 310-x, 30)];
    textField.placeholder = @"Required";
    textField.font = [UIFont systemFontOfSize:17];
    textField.text = [[rowData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.textColor = [UIColor grayColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.returnKeyType = UIReturnKeyDone;
    textField.tag = [[NSString stringWithFormat:@"%i%i",indexPath.section,indexPath.row] integerValue];
    textField.delegate = self;
    if( indexPath.section==1 ) {
        textField.secureTextEntry = YES;
    }
    if( indexPath.section==2 && indexPath.row!=2 ) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    if( indexPath.section!=3 ) {
        [cell.contentView addSubview:textField];
    } else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, cell.frame.size.height)];
        label.text = @"Register";
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = [UIColor colorWithRed:0 green:(102.0/255.0) blue:(204.0/255.0) alpha:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
    }
    
    
    
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    selectedTF = textField;
    if( textField.tag==22 ) {
        [textField resignFirstResponder];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Privacy" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Only me", @"All followers", @"Everyone", nil];
        [actionSheet showFromRect:textField.frame inView:self.view animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if( [actionSheet.title isEqualToString:@"Privacy"] ) {
        selectedTF.text = [actionSheet buttonTitleAtIndex:buttonIndex];
        if( [[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Only me"] ) {
            [[rowData objectAtIndex:2] replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:0]];
        } else if( [[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"All followers"] ) {
            [[rowData objectAtIndex:2] replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:1]];
        } else {
            [[rowData objectAtIndex:2] replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:2]];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[rowData objectAtIndex:textField.tag/10] replaceObjectAtIndex:textField.tag%10 withObject:textField.text];
}

- (void)registerAcc {
    [selectedTF resignFirstResponder];
    if( ![[[rowData objectAtIndex:1] objectAtIndex:0] isEqualToString:[[rowData objectAtIndex:1] objectAtIndex:1]] ) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"'Password' and 'Confirm Password' are different'" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    } else if( [[[rowData objectAtIndex:2] objectAtIndex:1] length]!=5 ) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Zip Code must be 5-digit !" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    } else if( [[[rowData objectAtIndex:2] objectAtIndex:0] integerValue]>160 ) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid Age" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"%@",[NSString stringWithFormat:@"http://muse.azurewebsites.net/api/User/?first=%@&last=%@&profile=%@&country=%@&age=%@&password=%@&privacy=%@",[[rowData objectAtIndex:0] objectAtIndex:0],[[rowData objectAtIndex:0] objectAtIndex:1], [[rowData objectAtIndex:0] objectAtIndex:2], [[rowData objectAtIndex:2] objectAtIndex:1], [[rowData objectAtIndex:2] objectAtIndex:0], [[rowData objectAtIndex:1] objectAtIndex:0], [[rowData objectAtIndex:2] objectAtIndex:2]]);
    NSData *data = [appDelegate sendHTTPRequestWithURL:[NSString stringWithFormat:@"http://muse.azurewebsites.net/api/User/?first=%@&last=%@&profile=%@&country=%@&age=%@&password=%@&privacy=%@",[[rowData objectAtIndex:0] objectAtIndex:0],[[rowData objectAtIndex:0] objectAtIndex:1], [[rowData objectAtIndex:0] objectAtIndex:2], [[rowData objectAtIndex:2] objectAtIndex:1], [[rowData objectAtIndex:2] objectAtIndex:0], [[rowData objectAtIndex:1] objectAtIndex:0], [[rowData objectAtIndex:2] objectAtIndex:2]]];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if( [[array objectAtIndex:0] isEqualToString:@"Success"] ) {
        [[[UIAlertView alloc] initWithTitle:@"Success" message:@"You are registered ! Can sign in with the new account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if( indexPath.section==3 ) {
        [selectedTF resignFirstResponder];
        [self registerAcc];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)closeBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];    
}
@end

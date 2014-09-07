//
//  ViewController.m
//  MuseiOSApp
//
//  Created by George Lo on 9/21/13.
//  Copyright (c) 2013 George Lo. All rights reserved.
//

#import "ViewController.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 264;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 352;

@interface ViewController ()

@end

@implementation ViewController {
    NSMutableArray *data;
    CGFloat animatedDistance;
    UITextField *selectedTF;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    data = [[NSMutableArray alloc] initWithObjects:@"", @"", nil];
    
    UITextField *accountTF = [[UITextField alloc] initWithFrame:CGRectMake(70, 283, 320-70-44, 44)];
    accountTF.tag = 10;
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Profile"]);
    accountTF.delegate = self;
    accountTF.placeholder = @"Profile";
    accountTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    accountTF.autocorrectionType = UITextAutocorrectionTypeNo;
    accountTF.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:accountTF];
    
    UITextField *passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(70, 328, 320-70-44, 44)];
    passwordTF.tag = 11;
    passwordTF.delegate = self;
    passwordTF.placeholder = @"Password";
    passwordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordTF.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordTF.secureTextEntry = YES;
    passwordTF.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:passwordTF];
    
    _signInImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signInProcess:)];
    gestureRecognizer.delegate = self;
    [_signInImgView addGestureRecognizer:gestureRecognizer];
    
    _registerLbl.userInteractionEnabled = YES;
    UITapGestureRecognizer *gestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerProcess:)];
    gestureRecognizer2.delegate = self;
    [_registerLbl addGestureRecognizer:gestureRecognizer2];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)registerProcess: (UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"toRegister" sender:self];
}

- (BOOL)loginSuccess {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSData *response = [appDelegate sendHTTPRequestWithURL:[NSString stringWithFormat:@"http://muse.azurewebsites.net/api/User/?profile=%@&password=%@",[data objectAtIndex:0], [data objectAtIndex:1]]];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    if( array.count==0 ) {
        [[[UIAlertView alloc] initWithTitle:@"Unable to login" message:@"Wrong Username/Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return 0;
    }
    for( NSDictionary *dict in array ) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"Age"]] forKey:@"Age"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"Country"]] forKey:@"Country"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"First"]] forKey:@"First"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"Last"]] forKey:@"Last"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"Password"]] forKey:@"Password"];
        if( [dict objectForKey:@"Picture"]!=[NSNull null] ) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"Picture"]] forKey:@"Picture"];
        }
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"Privacy"]] forKey:@"Privacy"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"Profile"]] forKey:@"Profile"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"UserId"]] forKey:@"UserId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return 1;
}

- (void)signInProcess: (UITapGestureRecognizer *)sender {
    [selectedTF resignFirstResponder];
    if( [self loginSuccess] ) {
        [self performSegueWithIdentifier:@"toMain" sender:self];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    selectedTF = textField;
    
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size. height;
    
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [data replaceObjectAtIndex:textField.tag-10 withObject:textField.text];
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

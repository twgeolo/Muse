//
//  PlayerViewController.m
//  MuseiOSApp
//
//  Created by George Lo on 9/22/13.
//  Copyright (c) 2013 George Lo. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController {
    UIImageView *midImageView;
    MPMusicPlayerController *musicPlayer;
    UILabel *pblabel;
}

@synthesize title;
@synthesize detail;
@synthesize image;
@synthesize index;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)updateSliderTime:(NSTimer *)timer {
    NSInteger minutes = musicPlayer.currentPlaybackTime/60;
    NSInteger seconds = musicPlayer.currentPlaybackTime-60*minutes;
    pblabel.text = [NSString stringWithFormat:@"%.1i:%.2i",minutes,seconds];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tabBarController.tabBar setHidden:YES];
    NSArray *arraySongs = [[MPMediaQuery songsQuery] items];
    [musicPlayer stop];
    MPMediaItem *item =(MPMediaItem *)[arraySongs objectAtIndex:index];
    [musicPlayer setNowPlayingItem:item];
    UILabel *durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(320-47, 388, 47, 30)];
    durationLabel.textAlignment = NSTextAlignmentLeft;
    NSInteger minutes = [[item valueForProperty:MPMediaItemPropertyPlaybackDuration] integerValue]/60;
    NSInteger seconds = [[item valueForProperty:MPMediaItemPropertyPlaybackDuration] integerValue]%60;
    durationLabel.text = [NSString stringWithFormat:@"%.1i:%.2i",minutes,seconds];
    [self.view addSubview:durationLabel];
    [musicPlayer play];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%i of %i",musicPlayer.indexOfNowPlayingItem+1,arraySongs.count];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    pblabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 388, 47, 30)];
    pblabel.textAlignment = NSTextAlignmentRight;
    pblabel.text = @"0:00";
    [self.view addSubview:pblabel];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 320)];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 410, 320, 50)];
    label.numberOfLines = 2;
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:24];
    label.textColor = [UIColor darkTextColor];
    [self.view addSubview:label];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate sendHTTPRequestWithURL:[NSString stringWithFormat:@"http://muse.azurewebsites.net/api/Timeline/?userid=%li&content=%@&privacy=%li", (long)[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] integerValue], [[NSString stringWithFormat:@"Listening to %@ !",title] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], (long)[[[NSUserDefaults standardUserDefaults] objectForKey:@"Privacy"] integerValue] ]];
    
    UILabel *detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 440, 320, 40)];
    detailLbl.text = detail;
    detailLbl.textAlignment = NSTextAlignmentCenter;
    detailLbl.font = [UIFont boldSystemFontOfSize:20];
    detailLbl.textColor = [UIColor darkTextColor];
    [self.view addSubview:detailLbl];
    
    UITapGestureRecognizer *ppGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playPause:)];
    ppGesture.delegate = self;
    midImageView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 508, 30, 30)];
    midImageView.userInteractionEnabled = YES;
    [midImageView addGestureRecognizer:ppGesture];
    midImageView.image = [UIImage imageNamed:@"Pause.png"];
    [self.view addSubview:midImageView];
    
    UITapGestureRecognizer *backwardGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
    backwardGesture.delegate = self;
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 513, 20, 20)];
    leftImageView.userInteractionEnabled = YES;
    [leftImageView addGestureRecognizer:backwardGesture];
    leftImageView.image = [UIImage imageNamed:@"Backward.png"];
    [self.view addSubview:leftImageView];
    
    UITapGestureRecognizer *forwardGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goNext:)];
    forwardGesture.delegate = self;
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 513, 20, 20)];
    rightImageView.userInteractionEnabled = YES;
    [rightImageView addGestureRecognizer:forwardGesture];
    rightImageView.image = [UIImage imageNamed:@"Forward.png"];
    [self.view addSubview:rightImageView];
    
    musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        midImageView.image = [UIImage imageNamed:@"Pause.png"];
    } else {
        midImageView.image = [UIImage imageNamed:@"Play.png"];
    }
    
    [musicPlayer setQueueWithQuery:[MPMediaQuery songsQuery]];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateSliderTime:) userInfo:nil repeats:YES];
}

- (void)playPause: (UITapGestureRecognizer *)gestureRecognizer {
    if([midImageView.image isEqual:[UIImage imageNamed:@"Pause.png"]] ) {
        [musicPlayer pause];
        midImageView.image = [UIImage imageNamed:@"Play.png"];
    } else {
        [musicPlayer play];
        midImageView.image = [UIImage imageNamed:@"Pause.png"];
    }
}

- (void)goBack: (UITapGestureRecognizer *)gestureRecognizer {
    [musicPlayer skipToPreviousItem];
}

- (void)goNext: (UITapGestureRecognizer *)gestureRecognizer {
    [musicPlayer skipToNextItem];
}

- (void)registerMPNotifications {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver: self
                           selector: @selector (handle_NowPlayingItemChanged:)
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: musicPlayer];
    [notificationCenter addObserver: self
                           selector: @selector (handle_PlaybackStateChanged:)
                               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object: musicPlayer];
    [notificationCenter addObserver: self
                           selector: @selector (handle_VolumeChanged:)
                               name: MPMusicPlayerControllerVolumeDidChangeNotification
                             object: musicPlayer];
    [musicPlayer beginGeneratingPlaybackNotifications];
}

- (void) handle_PlaybackStateChanged: (id) notification
{
    MPMusicPlaybackState playbackState = [musicPlayer playbackState];
    if (playbackState == MPMusicPlaybackStatePaused) {
         midImageView.image = [UIImage imageNamed:@"Play.png"];
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
         midImageView.image = [UIImage imageNamed:@"Pause.png"];
    } else if (playbackState == MPMusicPlaybackStateStopped) {
         midImageView.image = [UIImage imageNamed:@"Play.png"];
        [musicPlayer stop];
    }
}

- (void) handle_VolumeChanged: (id) notification
{
    [_volumeSlider setValue:musicPlayer.volume];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

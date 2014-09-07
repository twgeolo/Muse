//
//  MusicViewController.m
//  MuseiOSApp
//
//  Created by George Lo on 9/21/13.
//  Copyright (c) 2013 George Lo. All rights reserved.
//

#import "MusicViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MusicViewController ()

@end

@implementation MusicViewController {
    NSMutableArray *allMusic;
    NSMutableArray *filterMusic;
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

    MPMediaQuery *querySongs = [MPMediaQuery songsQuery];
    NSArray *arraySongs = [querySongs collections];
    
    allMusic = [[NSMutableArray alloc] init];
    
    for(MPMediaItemCollection *collection in arraySongs){
        MPMediaItem *album = [collection representativeItem];
        NSString *title = [album valueForKey:MPMediaItemPropertyTitle];
        NSString *detail = [NSString stringWithFormat:@"%@ - %@",[album valueForKey:MPMediaItemPropertyAlbumArtist],[album valueForKey:MPMediaItemPropertyAlbumTitle]];
        MPMediaItemArtwork *artwork = [album valueForProperty:MPMediaItemPropertyArtwork];
        UIImage *image = [artwork imageWithSize:CGSizeMake(320, 320)];
        Music *tempMus = [[Music alloc] initWithTitle:title andDetail:detail andImage:image];
        [allMusic addObject:tempMus];
    }
    filterMusic = [NSMutableArray arrayWithCapacity:allMusic.count];
}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [filterMusic removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@",searchText];
    filterMusic = [NSMutableArray arrayWithArray:[allMusic filteredArrayUsingPredicate:predicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filterMusic count];
    } else {
        return [allMusic count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Song Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if( cell==nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Music *tempMusic;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        tempMusic = [filterMusic objectAtIndex:indexPath.row];
    } else {
        tempMusic = [allMusic objectAtIndex:indexPath.row];
    }
    cell.imageView.image = tempMusic.image;
    cell.textLabel.text = tempMusic.title;
    cell.detailTextLabel.text = tempMusic.detail;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"toMusicPlayer" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [segue.identifier isEqualToString:@"toMusicPlayer"] ) {
        PlayerViewController *pvc = segue.destinationViewController;
        int selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        Music *tempMusic = [allMusic objectAtIndex:selectedIndex];
        pvc.title = tempMusic.title;
        pvc.detail = tempMusic.detail;
        pvc.image = tempMusic.image;
        pvc.index = selectedIndex;
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
}

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

//
//  TableViewController.m
//  QuickPlaylist
//
//  Created by Kelby on 3/28/14.
//  Copyright (c) 2014 Kelby Green. All rights reserved.
//

#import "TableViewController.h"

#import "MediaManager.h"

@interface TableViewController()<UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray * songs;
@property UIRefreshControl * refreshControl;

@end

@implementation TableViewController

@synthesize songs;
@synthesize ibTable;
@synthesize refreshControl;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    ibTable.dataSource = self;
    ibTable.delegate = self;
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [ibTable addSubview:refreshControl];
    
    [self refresh];
}

-(void)refresh
{
    const int SONGS_PER_PAGE = 7;
    NSMutableArray * randomSongs = [NSMutableArray array];
    for(int i = 0; i < SONGS_PER_PAGE; ++i){
        [randomSongs addObject:[[MediaManager shared] getRandomSong]];
    }
    
    songs = randomSongs;
    
    [refreshControl endRefreshing];
    [ibTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    }
    
    MPMediaItem * song = [songs objectAtIndex:[indexPath indexAtPosition:1]];
    
    cell.textLabel.text = [song valueForProperty: MPMediaItemPropertyTitle];
    cell.detailTextLabel.text = [song valueForProperty:MPMediaItemPropertyArtist];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return songs.count;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPMediaItem * song = [songs objectAtIndex:[indexPath indexAtPosition:1]];
    [[MediaManager shared] addSongToPlaylist:song];
    [songs removeObject:song];
    [ibTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Tap to add to playlist, pull down to refresh.";
}

@end

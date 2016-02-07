//
//  ControlView.m
//  EvilFartz
//
//  Created by Stephan Hennion on 2/6/16.
//  Copyright © 2016 sjhennion. All rights reserved.
//

#import "ControlView.h"

@implementation ControlView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self) {
        float statusBarH = 22.0;
        UIColor *bgColor = [UIColor colorWithRed:3.0/16.0 green:6.0/16.0 blue:9.0/16.0 alpha:1.0];
        bgColor = [UIColor colorWithRed:153.0/255.0 green:195.0/255.0 blue:209.0/255.0 alpha:1.0];
        [self setBackgroundColor:bgColor];
        
        // FileNamesTableView
        float buf = 10.0;
        
        float labelH = 20.0;
        CGRect labelF = CGRectMake(buf, statusBarH, frame.size.width - buf, labelH);
        UILabel *tableLabel = [[UILabel alloc] initWithFrame:labelF];
        [tableLabel setText:@"filenames:"];
        [tableLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:tableLabel];

        float tableH = frame.size.height*0.3;
        CGRect tableF = CGRectMake(buf, statusBarH+labelH+buf, frame.size.width - buf*2.0, tableH);
        self.fileNameTableViewController = [[FileNameTableViewController alloc] init];
        
        [self addSubview:self.fileNameTableViewController.tableView];
        [self.fileNameTableViewController.tableView setFrame:tableF];
        
        // Play Buttons
        UIView *playButtonView = [self buildPlayButtonsAtPoint:CGPointMake(0.0, statusBarH + labelH + buf + tableH + buf)];
        [self addSubview:playButtonView];
        
        // ActiveSoundsTableView
        labelF = CGRectMake(buf, playButtonView.frame.origin.y + playButtonView.frame.size.height + buf*2.0, frame.size.width - buf, labelH);
        UILabel *activeLabel = [[UILabel alloc] initWithFrame:labelF];
        [activeLabel setText:@"active sounds:"];
        [activeLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:activeLabel];
        
        self.activeSoundsTableViewController = [[ActiveSoundsTableViewController alloc] init];
        [self addSubview:self.activeSoundsTableViewController.tableView];
        tableF = CGRectMake(buf, labelF.origin.y + labelF.size.height + buf, frame.size.width - buf*2.0, tableH);
        [self.activeSoundsTableViewController.tableView setFrame:tableF];
        
        // Active Buttons
        UIView *activeButtonView = [self buildActiveButtonsAtPoint:CGPointMake(0.0, tableF.origin.y + tableF.size.height + buf)];
        [self addSubview:activeButtonView];
    }
    
    return self;
}

- (UIView*)buildPlayButtonsAtPoint:(CGPoint)origin {
    float buttonH = 40.0;
    float buf = 10.0;
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, self.frame.size.width, buttonH)];
    
    // Play once
    UIColor *buttonColor = [UIColor colorWithRed:106.0/255.0 green:156.0/255.0 blue:173.0/255.0 alpha:1.0];
    float buttonW = (buttonView.frame.size.width - buf*3.0)/2.0;
    CGRect buttonF = CGRectMake(buf, 0.0, buttonW, buttonH);
    UIButton *playOnceButton = [[UIButton alloc] initWithFrame:buttonF];
    [playOnceButton addTarget:self action:@selector(playOnceButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [playOnceButton setBackgroundColor:buttonColor];
    [playOnceButton setTitle:@"Play Once" forState:UIControlStateNormal];
    [playOnceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playOnceButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    
    [buttonView addSubview:playOnceButton];
    
    // Play loop
    buttonF = CGRectMake(buf + buttonW + buf, 0.0, buttonW, buttonH);
    UIButton *playLoopButton = [[UIButton alloc] initWithFrame:buttonF];
    [playLoopButton addTarget:self action:@selector(playLoopButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [playLoopButton setBackgroundColor:buttonColor];
    [playLoopButton setTitle:@"Play Loop" forState:UIControlStateNormal];
    [playLoopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playLoopButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    
    [buttonView addSubview:playLoopButton];

    return buttonView;
}

- (UIView*)buildActiveButtonsAtPoint:(CGPoint)origin {
    float buttonH = 40.0;
    float buf = 10.0;
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, self.frame.size.width, buttonH)];
    
    // Stop play
    UIColor *buttonColor = [UIColor colorWithRed:106.0/255.0 green:156.0/255.0 blue:173.0/255.0 alpha:1.0];
    float buttonW = (buttonView.frame.size.width - buf*3.0)/2.0;
    CGRect buttonF = CGRectMake(buf, 0.0, buttonW, buttonH);
    UIButton *pauseButton = [[UIButton alloc] initWithFrame:buttonF];
    [pauseButton addTarget:self action:@selector(pauseButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [pauseButton setBackgroundColor:buttonColor];
    [pauseButton setTitle:@"Play/Pause" forState:UIControlStateNormal];
    [pauseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pauseButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    
    [buttonView addSubview:pauseButton];
    
    // Pause/play buttton?
    buttonF = CGRectMake(buf + buttonW + buf, 0.0, buttonW, buttonH);
    UIButton *removeButton = [[UIButton alloc] initWithFrame:buttonF];
    [removeButton addTarget:self action:@selector(removeButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [removeButton setBackgroundColor:buttonColor];
    [removeButton setTitle:@"Remove" forState:UIControlStateNormal];
    [removeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [removeButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    
    [buttonView addSubview:removeButton];
    
    return buttonView;
}

#pragma mark -
#pragma mark - External methods
- (void)updateFileNames:(NSArray*)fileNamesIn {
    self.fileNameTableViewController.fileNames = fileNamesIn;
    [self.fileNameTableViewController.tableView reloadData];
}

- (void)updateActiveTable:(NSArray*)activeSounds {
    [self.activeSoundsTableViewController reloadWithSounds:activeSounds];
}

#pragma mark -
#pragma mark - Button methods
- (void)playOnceButtonPressed:(id)sender {
    NSLog(@"Play file once button pressed");
    NSUInteger row = [[self.fileNameTableViewController selected] row];
    [self.delegate playFileName:[self.fileNameTableViewController.fileNames objectAtIndex:row] OnRepeat:false];
}

- (void)playLoopButtonPressed:(id)sender {
    NSLog(@"Play file loop button pressed");
    NSUInteger row = [[self.fileNameTableViewController selected] row];
    [self.delegate playFileName:[self.fileNameTableViewController.fileNames objectAtIndex:row] OnRepeat:true];
}

- (void)pauseButtonPressed:(id)sender {
    NSLog(@"Play/Pause button pressed");
    NSUInteger row = [[self.activeSoundsTableViewController.tableView indexPathForSelectedRow] row];
    ActivePlayer *activePlayer = [self.activeSoundsTableViewController.sounds objectAtIndex:row];
    if ([activePlayer.player isPlaying]) {
        [activePlayer.player pause];
    } else {
        [activePlayer.player play];
    }
}

- (void)removeButtonPressed:(id)sender {
    NSLog(@"Remove button pressed");
    NSUInteger row = [[self.activeSoundsTableViewController.tableView indexPathForSelectedRow] row];
    [self.delegate removeActivePlayer:[self.activeSoundsTableViewController.sounds objectAtIndex:row]];
}

@end
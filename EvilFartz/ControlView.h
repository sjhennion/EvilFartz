//
//  ControlView.h
//  EvilFartz
//
//  Created by Stephan Hennion on 2/6/16.
//  Copyright © 2016 sjhennion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileNameTableViewController.h"
#import "ActiveSoundsTableViewController.h"

@protocol ControlViewDelegate <NSObject>

- (void)playFileName:(NSString*)fileName OnRepeat:(bool)loop;
- (void)removeActivePlayer:(ActivePlayer*)activePlayer;

@end

@interface ControlView : UIView

@property id<ControlViewDelegate> delegate;
@property FileNameTableViewController *fileNameTableViewController;
@property ActiveSoundsTableViewController *activeSoundsTableViewController;

//@property UITableView *fileNamesTable;
//@property NSArray *fileNames;

- (void)updateFileNames:(NSArray*)fileNamesIn;
- (void)updateActiveTable:(NSArray*)activeSounds;

@end

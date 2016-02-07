//
//  ActiveSoundsTableViewController.h
//  EvilFartz
//
//  Created by Stephan Hennion on 2/6/16.
//  Copyright © 2016 sjhennion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ActivePlayer.h"

@interface ActiveSoundsTableViewController : UITableViewController

@property NSArray *sounds;
@property NSIndexPath *selected;

@property UIColor *cellColor;
@property UIColor *cellHighlight;

- (void)reloadWithSounds:(NSArray*)soundsIn;

@end

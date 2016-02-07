//
//  FileNameTableViewController.h
//  EvilFartz
//
//  Created by Stephan Hennion on 2/6/16.
//  Copyright © 2016 sjhennion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileNameTableViewController : UITableViewController

@property NSArray *fileNames;

@property NSIndexPath *selected;

@property UIColor *cellColor;
@property UIColor *cellHighlight;

@end

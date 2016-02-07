//
//  ActiveSoundsTableViewController.m
//  EvilFartz
//
//  Created by Stephan Hennion on 2/6/16.
//  Copyright © 2016 sjhennion. All rights reserved.
//

#import "ActiveSoundsTableViewController.h"

@interface ActiveSoundsTableViewController ()

@end

@implementation ActiveSoundsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *bgColor = [UIColor colorWithRed:106.0/255.0 green:156.0/255.0 blue:173.0/255.0 alpha:1.0];
    [self.tableView setBackgroundColor:bgColor];
    
    self.cellColor = [UIColor colorWithRed:106.0/255.0 green:156.0/255.0 blue:173.0/255.0 alpha:1.0];
    self.cellHighlight = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:230.0/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - External
- (void)reloadWithSounds:(NSArray*)soundsIn {
    self.sounds = soundsIn;
    NSIndexPath *ipath = [self.tableView indexPathForSelectedRow];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:ipath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sounds count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selected = indexPath;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:self.cellColor];
        [cell.textLabel setText:@""];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
    }
    
    if (indexPath == self.selected) {
        [cell setBackgroundColor:self.cellHighlight];
    } else {
        [cell setBackgroundColor:self.cellColor];
    }
    
    if ([self.sounds count] == 0) {
        return cell;
    }
    ActivePlayer *actP = [self.sounds objectAtIndex:indexPath.row];
    float playerPercentage = actP.player.currentTime/actP.player.duration;
    NSString *text = [NSString stringWithFormat:@"%@",[actP fileName]];
    
    for (UIView *view in [cell subviews]) {
        if ([view tag] == 1000) {
            [view removeFromSuperview];
        }
    }
    
    float barH = 5.0;
    CGRect barBgF = CGRectMake(0.0, cell.frame.size.height*.9, cell.frame.size.width, barH);
    UIView *percentBarBG = [[UIView alloc] initWithFrame:barBgF];
    [percentBarBG setTag:1000];
    float bgGray = 0.7;
    [percentBarBG setBackgroundColor:[UIColor colorWithRed:bgGray green:bgGray blue:bgGray alpha:1.0]];
    [cell addSubview:percentBarBG];
    
    float actualBuf = 1.0;
    CGRect barActualF = CGRectMake(actualBuf,
                                   cell.frame.size.height*.9+actualBuf,
                                   cell.frame.size.width*playerPercentage - actualBuf*2.0,
                                   barH - actualBuf*2.0);
    UIView *percentBarActual = [[UIView alloc] initWithFrame:barActualF];
    [percentBarBG setTag:1000];
    [percentBarActual setBackgroundColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.7]];
    [cell addSubview:percentBarActual];
    
    cell.textLabel.text = text;
    
    return cell;
}

@end

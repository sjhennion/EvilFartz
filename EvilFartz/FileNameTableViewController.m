//
//  FileNameTableViewController.m
//  EvilFartz
//
//  Created by Stephan Hennion on 2/6/16.
//  Copyright © 2016 sjhennion. All rights reserved.
//

#import "FileNameTableViewController.h"

@interface FileNameTableViewController ()

@end

@implementation FileNameTableViewController

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fileNames count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selected = indexPath;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:self.cellColor];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
    }
    
    if (indexPath == self.selected) {
        [cell setBackgroundColor:self.cellHighlight];
    } else {
        [cell setBackgroundColor:self.cellColor];
    }
    
    NSString *fileNameTitle = [self.fileNames objectAtIndex:indexPath.row];
    cell.textLabel.text = fileNameTitle;
    
    return cell;
}

@end

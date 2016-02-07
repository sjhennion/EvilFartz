//
//  ViewController.m
//  EvilFartz
//
//  Created by Stephan Hennion on 2/3/16.
//  Copyright © 2016 sjhennion. All rights reserved.
//

#import "ViewController.h"
#import "AudioSamplePlayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.controlV = [[ControlView alloc] initWithFrame:self.view.frame];
    self.controlV.delegate = self;
    [self.view addSubview:self.controlV];
    
    [self setupSoundDefaults];
}

- (void)setupSoundDefaults {
    // All the filetypes we'll search for
    NSArray *fileTypes = [NSArray arrayWithObjects:@"wav",@"mp3",@"aif",@"aiff",nil];

    [[SoundManager sharedManager] setDelegate:self];
    [[SoundManager sharedManager] loadSoundFilesWithFiletypes:fileTypes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark SoundManagerDelegate methods
- (void)soundFilesLoadedForFileTypes:(NSArray *)fileTypes {
    [self.controlV updateFileNames:[[SoundManager sharedManager] getFileNamesForFileTypesAlphabetical:fileTypes]];
}

- (void)updateActivePoolDependants:(NSArray*)activeSounds {
    [self.controlV updateActiveTable:activeSounds];
}

#pragma mark -
#pragma mark ControlViewDelegate methods
- (void)playFileName:(NSString*)fileName OnRepeat:(bool)loop;{
    [[SoundManager sharedManager] playFile:fileName OnRepeat:loop];
}

- (void)removeActivePlayer:(ActivePlayer*)activePlayer {
    [[SoundManager sharedManager] removeActivePlayer:activePlayer];
}

@end

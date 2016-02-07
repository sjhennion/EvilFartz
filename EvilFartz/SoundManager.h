//
//  SoundManager.h
//  EvilFartz
//
//  Created by Stephan Hennion on 2/3/16.
//  Copyright © 2016 sjhennion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "ActivePlayer.h"

@protocol SoundManagerDelegate <NSObject>

- (void)soundFilesLoadedForFileTypes:(NSArray*)fileTypes;
- (void)updateActivePoolDependants:(NSArray*)activeSounds;

@end

@interface SoundManager : NSObject <AVAudioPlayerDelegate>

@property id<SoundManagerDelegate> delegate;
@property NSMutableDictionary *allPaths;
@property NSMutableArray *playerPool;
@property NSTimer *activePoolTrackerTimer;

+ (id)sharedManager;

// Actions
- (void)loadSoundFilesWithFiletypes:(NSArray*)fileTypes;
- (void)playFile:(NSString*)fileName OnRepeat:(BOOL)repeat;
- (void)removeActivePlayer:(ActivePlayer*)activePlayer;

// Returns
- (NSArray*)getFileNamesForFileTypes:(NSArray*)fileTypes;
- (NSArray*)getFileNamesForFileTypesAlphabetical:(NSArray *)fileTypes;
- (NSUInteger)getNumberOfActivePlayers;
- (void)printFileNames;


@end

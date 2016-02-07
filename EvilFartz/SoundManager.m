//
//  SoundManager.m
//  EvilFartz
//
//  Created by Stephan Hennion on 2/3/16.
//  Copyright © 2016 sjhennion. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

+ (id)sharedManager {
    static SoundManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {
        // Init the playerPool
        _playerPool = [NSMutableArray array];
        
        // Init the filename/path storage dict
        _allPaths = [NSMutableDictionary dictionary];

        // Initialize the timer that sends out alerts about active sound players
        NSMethodSignature *methodSig = [self methodSignatureForSelector:@selector(checkActive:)];
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:methodSig];
        [inv setSelector:@selector(checkActive:)];
        [inv setTarget:self];
        _activePoolTrackerTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 invocation:inv repeats:true];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

#pragma mark - Action methods
// This takes an array of filetypes and builds the allPaths dictionary, so
// that the path of any file can be found with [[_allPaths @"fileType"] @"fileName"]
- (void)loadSoundFilesWithFiletypes:(NSArray*)fileTypes {
    int count = 0;
    
    // Dictionary to hold all the paths we come across, organized first by fileType to get a
    // second dictionary which holds file paths, with the filenames as keys
    for (NSString *ext in fileTypes) {
        if ([[_allPaths allKeys] containsObject:ext]) {
            NSLog(@"SoundManager already loaded type: %@\n", ext);
            continue;
        }
        
        // First get all the paths for a type
        NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:ext inDirectory:nil];
        
        // This will hold the paths indexed by the filename keys
        NSMutableDictionary *extPaths = [NSMutableDictionary dictionaryWithCapacity:[paths count]];
        for (NSString *path in paths) {
            // Parse the filename from the path
            NSString *filename = path;
            NSRange slashRange = [filename rangeOfString:@"/"];
            while(slashRange.length != 0) {
                filename = [filename substringFromIndex:slashRange.location+1];
                slashRange = [filename rangeOfString:@"/"];
            }
            
            [extPaths setObject:path forKey:filename];
            count++;
        }
        
        // Store the filename/path dictionary for the ext type
        [_allPaths setObject:extPaths forKey:ext];
    }
    
    [self.delegate soundFilesLoadedForFileTypes:fileTypes];
    
    NSLog(@"Loaded %d files", count);
}

- (void)playFile:(NSString*)fileName OnRepeat:(BOOL)repeat {
    NSRange extRange = [fileName rangeOfString:@"."];
    if (extRange.length == 0) {
        NSLog(@"playFile failed, file not of form fileName.ext\n");
        return;
    }
    NSString *ext = [fileName substringFromIndex:extRange.location+1];
    
    NSString *path = [[_allPaths objectForKey:ext] objectForKey:fileName];
    if (path == nil) {
        NSLog(@"playFile failed, file path not found. Have you loaded the appropriate filetype,\n or perhaps filename is incorrect\n.");
        return;
    }
    
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    NSError *error;
    ActivePlayer *activePlayer = [[ActivePlayer alloc] init];
    [activePlayer setFileName:fileName];
    
    activePlayer.player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    if (repeat) {
        [activePlayer.player setNumberOfLoops:-1];
    }
    
    activePlayer.player.delegate = self;
    [activePlayer.player play];
    [_playerPool addObject:activePlayer];
}

- (void)removeActivePlayer:(ActivePlayer*)activePlayer {
    [[activePlayer player] stop];
    [_playerPool removeObject:activePlayer];
}

#pragma mark - Return methods
- (NSArray*)getFileNamesForFileTypes:(NSArray*)fileTypes {
    NSMutableArray *fileNames = [NSMutableArray array];
    for (NSString *ext in [_allPaths allKeys]) {
        if ([fileTypes containsObject:ext]) {
            for (NSString *filename in [[_allPaths objectForKey:ext] allKeys]) {
                [fileNames addObject:filename];
            }
        }
    }
    
    return [NSArray arrayWithArray:fileNames];
}

- (NSArray*)getFileNamesForFileTypesAlphabetical:(NSArray *)fileTypes {
    NSMutableArray *fileNames = [NSMutableArray array];
    for (NSString *ext in [_allPaths allKeys]) {
        if ([fileTypes containsObject:ext]) {
            for (NSString *filename in [[_allPaths objectForKey:ext] allKeys]) {
                [fileNames addObject:filename];
            }
        }
    }
    
    [fileNames sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return [NSArray arrayWithArray:fileNames];
}

- (NSUInteger)getNumberOfActivePlayers {
    return [_playerPool count];
}

- (void)printFileNames {
    // Print all the filenames we gathered
    for (NSString *ext in [_allPaths allKeys]) {
        for (NSString *filename in [[_allPaths objectForKey:ext] allKeys]) {
            NSLog(@"%@\n", filename);
        }
    }
}

# pragma mark - AVAudioPlayerDelegate methods
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag {
    //NSLog(@"Cleaning pool\n");
    
    // AVAudioPlayer doesn't conform to NSCopying, and can't be used as a key in a
    // MutableDictionary.  The proper way to do this I think would be to subclass
    // AVAudioPlayer and then override this delegate method (I think?), but there
    // shouldn't ever be a ton of players (famous last words) and this should work
    // for proof of concept.
    for (int i = 0; i < [_playerPool count]; ++i) {
        ActivePlayer *activePlayer = [_playerPool objectAtIndex:i];
        if ([[activePlayer player] isEqual:player]) {
            [_playerPool removeObject:activePlayer];
            break;
        }
    }
}

# pragma mark - Active Timer methods
- (void)checkActive:(NSTimer*)timer {
    //NSLog(@"Checking active\n");
    [self.delegate updateActivePoolDependants:_playerPool];
}

@end

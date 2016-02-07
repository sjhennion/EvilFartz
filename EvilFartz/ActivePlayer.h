//
//  ActivePlayer.h
//  EvilFartz
//
//  Created by Stephan Hennion on 2/6/16.
//  Copyright © 2016 sjhennion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ActivePlayer : NSObject

@property AVAudioPlayer *player;
@property NSString *fileName;

@end

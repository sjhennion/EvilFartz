//
//  ViewController.h
//  EvilFartz
//
//  Created by Stephan Hennion on 2/3/16.
//  Copyright © 2016 sjhennion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundManager.h"
#import "ControlView.h"

@interface ViewController : UIViewController <SoundManagerDelegate, ControlViewDelegate>

@property ControlView *controlV;

@end


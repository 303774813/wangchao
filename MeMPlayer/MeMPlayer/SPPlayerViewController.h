//
//  SPPlayerViewController.h
//  SportsViedo
//
//  Created by mellow on 15/8/21.
//  Copyright (c) 2015年 mellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "KrVideoPlayer/Classes/KrVideoPlayerController.h"
@interface SPPlayerViewController : UIViewController
@property (nonatomic, strong) KrVideoPlayerController  *videoController;

@property (copy,nonatomic)NSString *sportid;
@property (copy,nonatomic)NSString *titleV;
@property (nonatomic,copy) NSString *urlStr;
@property (nonatomic,copy) NSString *shareStr;
@property (nonatomic,copy) NSString *shareDescStr;

@property (nonatomic,assign)  BOOL isLive;
@end

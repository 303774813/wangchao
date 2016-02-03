//
//  KrVideoPlayerController.h
//  KrVideoPlayerPlus
//
//  Created by JiaHaiyang on 15/6/19.
//  Copyright (c) 2015年 JiaHaiyang. All rights reserved.
//
//if (self.videoController.isPreparedToPlay) {
//    
//    
//}

#import <UIKit/UIKit.h>
#import "KrVideoRateProtocol.h"

@import MediaPlayer;

@interface KrVideoPlayerController : MPMoviePlayerController
/** video.view 消失 */
@property (nonatomic, copy)void(^dimissCompleteBlock)(void);
/** 进入最小化状态 */
@property (nonatomic, copy)void(^willBackOrientationPortrait)(void);
/** 进入全屏状态 */
@property (nonatomic, copy)void(^willChangeToFullscreenMode)(void);
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) NSString *titleS;
@property (nonatomic,assign) id<KrVideoRateProtocol> krDelegate;
@property (nonatomic,assign)  BOOL isLive;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)showInWindow;
- (void)dismiss;
-(void)setProgressValue:(double)currentTime;
-(double)getCurrentPlayTimeDuring;
- (void)videoPlay;
-(void)setHiddenProgressView;
/**
 *  获取视频截图
 */
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
@end

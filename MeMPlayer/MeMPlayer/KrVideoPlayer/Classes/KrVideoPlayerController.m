//
//  KrVideoPlayerController.m
//  KrVideoPlayerPlus
//
//  Created by JiaHaiyang on 15/6/19.
//  Copyright (c) 2015年 JiaHaiyang. All rights reserved.
//

#import "KrVideoPlayerController.h"
#import "KrVideoPlayerControlView.h"
#import <AVFoundation/AVFoundation.h>
#import "Tools.h"
static const CGFloat kVideoPlayerControllerAnimationTimeinterval = 0.3f;

@interface KrVideoPlayerController()

@property (nonatomic, strong) KrVideoPlayerControlView *videoControl;
@property (nonatomic, strong) UIView *movieBackgroundView;
@property (nonatomic, assign) BOOL isFullscreenMode;
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, strong) NSTimer *durationTimer;
@property (nonatomic, assign) BOOL playErrorState;
@end
  
@implementation KrVideoPlayerController

- (void)dealloc
{
    [self cancelObserver];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.view.frame = frame;
        self.view.backgroundColor = [UIColor blackColor];
        self.controlStyle = MPMovieControlStyleNone;
        [self.view addSubview:self.videoControl];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        self.videoControl.frame = self.view.bounds;
        [self configObserver];
        _playErrorState = NO;
        [self configControlAction];
       // [self ListeningRotating];
        
    }
    return self;
}
 #pragma mark - Override Method

- (void)setContentURL:(NSURL *)contentURL
{
    self.videoControl.titleLab.text=_titleS;
    NSLog(@"啦啦啦啦啦啦");
 //  [self stop];
    [super setContentURL:contentURL];
    [self  prepareToPlay];
    if ([[Tools sharedManager] isLandscapeScreen]) {
        [self fullScreenButtonClick];
    }
     //    if (self.isPreparedToPlay) {
//    
//    }
    
   // [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getVideoDatas) userInfo:nil repeats:YES];

    //[self performSelector:@selector(getVideoDatas) withObject:self afterDelay:1];
    
}
- (void)videoPlay
{
    if ([self respondsToSelector:@selector(loadState)])
    {

        // 有助于减少延迟
        [self prepareToPlay];
        [self setShouldAutoplay:YES];
        // Register that the load state changed (movie is ready)

    } 
    else
    {
        // Play the movie For 3.1.x devices
        [self setShouldAutoplay:NO];
        [self play];
    }    //[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getVideoDatas) userInfo:nil repeats:YES];

}
//- (void)videoPlay
//{
//    if (self.isPreparedToPlay) {
//        NSLog(@"准备播放");
//        
//    }else{
//        NSLog(@"未准备播放");
//        
//    }
//    [self setShouldAutoplay:YES];
//    
//    [self play];
//    //[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getVideoDatas) userInfo:nil repeats:YES];
//    
//}
#pragma mark - Publick Method

- (void)showInWindow
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (!keyWindow) {
        keyWindow = [[[UIApplication sharedApplication] windows] firstObject];
    }
    [keyWindow addSubview:self.view];
    self.view.alpha = 0.0;
    [UIView animateWithDuration:kVideoPlayerControllerAnimationTimeinterval animations:^{
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {


    }];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)dismiss
{
    [self stopDurationTimer];


    [self stop];
    [UIView animateWithDuration:kVideoPlayerControllerAnimationTimeinterval animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        if (self.dimissCompleteBlock) {
            self.dimissCompleteBlock();
        }
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

#pragma mark - Private Method

- (void)configObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerPlaybackStateDidChangeNotification) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerLoadStateDidChangeNotification:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerReadyForDisplayDidChangeNotification) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMovieDurationAvailableNotification) name:MPMovieDurationAvailableNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMovieNowPlayingMovieDidChangeNotification) name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMovieMediaTypesAvailableNotification)
                                                 name:MPMovieMediaTypesAvailableNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMediaPlaybackIsPreparedToPlayDidChangeNotification:)
                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:nil];
    
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpOutside];
    [self setProgressSliderMaxMinValues];
    [self monitorVideoPlayback];

    
//
//        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(onMPMediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)setProgressSliderMaxMinValues {
    CGFloat duration = self.duration;
    self.videoControl.progressSlider.minimumValue = 0.f;
    self.videoControl.progressSlider.maximumValue = duration;
}


- (void)monitorVideoPlayback
{
    double currentTime = floor(self.currentPlaybackTime);
    double totalTime = floor(self.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    self.videoControl.progressSlider.value = ceil(currentTime);
}

- (void)progressSliderTouchEnded:(UISlider *)slider {
    self.videoControl.progressTimeView.alpha=0;
    NSLog(@"hideee");
    [self setCurrentPlaybackTime:floor(slider.value)];
    [self play];
    [self.videoControl autoFadeOutControlBar];

}

- (void)progressSliderValueChanged:(UISlider *)slider {
    double currentTime = floor(slider.value);
    double totalTime = floor(self.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    
    [self.videoControl updateProfressTimeLabl];
    
}

#pragma mark - set Time 
-(void)setProgressValue:(double)currentTime
{
    [self setCurrentPlaybackTime:currentTime];
    //[self play];
    [self.videoControl autoFadeOutControlBar];

}
-(double)getCurrentPlayTimeDuring
{
    double currentTime = floor(self.currentPlaybackTime);

    return currentTime;
}

- (void)setTimeLabelValues:(double)currentTime totalTime:(double)totalTime {
    double minutesElapsed = floor(currentTime / 60.0);
    double secondsElapsed = fmod(currentTime, 60.0);
    NSString *timeElapsedString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesElapsed, secondsElapsed];
    
    double minutesRemaining = floor(totalTime / 60.0);;
    double secondsRemaining = floor(fmod(totalTime, 60.0));;
    NSString *timeRmainingString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesRemaining, secondsRemaining];
    
    self.videoControl.timeLabel.text = [NSString stringWithFormat:@"%@/%@",timeElapsedString,timeRmainingString];
}

- (void)cancelObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)onMPMediaPlayerPlaybackFinished:(NSNotification *)notification{
    NSLog(@"播放完成.%li",(long)self.playbackState);
}
- (void)configControlAction
{
    
    [self.videoControl.playBtn addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.videoControl.playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.videoControl.pauseButton addTarget:self action:@selector(pauseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.shareButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.fullScreenButton addTarget:self action:@selector(fullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.shrinkScreenButton addTarget:self action:@selector(shrinkScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.volumeButton addTarget:self action:@selector(volumeChangeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.btnType1 addTarget:self action:@selector(rateChangeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.btnType2 addTarget:self action:@selector(rateChangeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.backBuntton addTarget:self action:@selector(shrinkScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.chargebtn addTarget:self action:@selector(hiddenChargeBar) forControlEvents:UIControlEventTouchUpInside];
//    [self setProgressSliderMaxMinValues];
//    [self monitorVideoPlayback];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpOutside];
    [self setProgressSliderMaxMinValues];
   [self monitorVideoPlayback];
}
- (void)onMPMovieMediaTypesAvailableNotification
{
    
    _playErrorState =YES;
    NSLog(@"777%s    state:%ld   %d",__FUNCTION__,(long)self.playbackState,self.movieMediaTypes);
    [self.videoControl.indicatorView startAnimating];
}
- (void)onMPMovieNowPlayingMovieDidChangeNotification
{
    //NSLog(@"开始载入    state:%ld   %d",__FUNCTION__,(long)self.playbackState,self.loadState);
  [self.videoControl.indicatorView startAnimating];
}
- (void)onMPMoviePlayerPlaybackStateDidChangeNotification
{
    


    NSLog(@"111%s    state:%ld   %d",__FUNCTION__,(long)self.playbackState,self.loadState);
    switch (self.playbackState) {
        case MPMoviePlaybackStateInterrupted:
            //中断
            NSLog(@"中断");
            break;
        case MPMoviePlaybackStatePaused:
            //暂停
            NSLog(@"暂停");
            break;
        case MPMoviePlaybackStatePlaying:
            //播放中
            NSLog(@"播放中");
            break;
        case MPMoviePlaybackStateSeekingBackward:
            //后退
            NSLog(@"后退");
            break;
        case MPMoviePlaybackStateSeekingForward:
            //快进
            NSLog(@"快进");
            break;
        case MPMoviePlaybackStateStopped:
            //停止
            NSLog(@"停止");
            break;
            
        default:
            break;
    }
    if (self.playbackState == MPMoviePlaybackStatePlaying) {
//        self.videoControl.pauseButton.hidden = NO;
//        self.videoControl.playButton.hidden = YES;
        [self startDurationTimer];
       [self.videoControl.indicatorView stopAnimating];
        [self.videoControl autoFadeOutControlBar];
    } else {
//        self.videoControl.pauseButton.hidden = YES;
//        self.videoControl.playButton.hidden = NO;
        [self stopDurationTimer];
        if (self.playbackState == MPMoviePlaybackStateStopped) {
            [self.videoControl animateShow];
        }
    }
    
    
//    if (_playErrorState == NO) {
//        [self.videoControl.indicatorView stopAnimating];
//        [self showFailView];
//        
//        NSLog(@"出错了！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！");
//        
//    }
    
}

- (void)onMPMoviePlayerLoadStateDidChangeNotification:(NSNotification *)notif
{          NSLog(@"222%s    state:%ld   %d   %@",__FUNCTION__,(long)self.playbackState,self.loadState,notif.userInfo );



//    if (self.loadState & MPMovieLoadStateStalled) {
//        [self.videoControl.indicatorView startAnimating];
//    }if (self.loadState==3) {
//        [self.videoControl.indicatorView stopAnimating];
//
//    }

    if(self.loadState & MPMovieLoadStateUnknown){
        NSLog(@"未知状态");
    }
    
    if(self.loadState & MPMovieLoadStatePlayable){
        
        [self.videoControl.indicatorView startAnimating];

        //第一次加载，或者前后拖动完成之后
        NSLog(@"可播放");
        
    }
    
    if(self.loadState & MPMovieLoadStatePlaythroughOK){
        [self.videoControl.indicatorView stopAnimating];

        NSLog(@"网络缓冲完成");
        if (self.playbackState==MPMoviePlaybackStatePaused) {
            [self play];
        }
    }
    
    if(self.loadState & MPMovieLoadStateStalled){
        [self.videoControl.indicatorView startAnimating];

        NSLog(@"网络缓冲");
    }
    
    
}

- (void)onMPMoviePlayerReadyForDisplayDidChangeNotification
{
    NSLog(@"333%s    state:%ld   %d",__FUNCTION__,(long)self.controlStyle,self.loadState);
//self.loadState=3

}
-(void)volumeChangeButtonClick
{
    
    
    
    NSLog(@"MPMusicPlayerController");
    MPMusicPlayerController *mp=[MPMusicPlayerController applicationMusicPlayer];
    if (mp.volume==0) {
        mp.volume=0.3;
        [self.videoControl.volumeButton setImage:[UIImage imageNamed:@"音量"] forState:UIControlStateNormal];
    }else{
        mp.volume=0;
         [self.videoControl.volumeButton setImage:[UIImage imageNamed:@"静音"] forState:UIControlStateNormal];
    }
}

- (void)onMPMovieDurationAvailableNotification
{
    NSLog(@"444%s    state:%ld",__FUNCTION__,(long)self.playbackState);

    [self setProgressSliderMaxMinValues];
}

- (void)playButtonClick:(UIButton *)button
{
    
    button.selected = !button.selected;
    if (button.selected) {
        // 暂停
        [self pause];
    }else{
        // 播放
        [self play];
    }
    

    
    
//    [self play];
//    self.videoControl.playButton.hidden = YES;
//    self.videoControl.pauseButton.hidden = NO;
}


- (void)closeButtonClick
{
   // [self dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SP_SHARE_NOTIFICATION" object:nil];
   }

- (void)fullScreenButtonClick
{

    if (self.isFullscreenMode) {
        return;
    }

    if (_videoControl.isOpen) {
        NSLog(@"fish");
        [_videoControl showList];
    }
    [self setDeviceOrientationLandscapeRight];
}
- (void)hiddenChargeBar
{
    [self.videoControl hiddenChargeBar];
}
- (void)shrinkScreenButtonClick
{
    NSLog(@"fish111");

    if (!self.isFullscreenMode) {
        [[self getCurrentVC] dismissViewControllerAnimated:YES completion:^{
            ;
        }];
        return;
    }
    if (_videoControl.isOpen) {
        NSLog(@"fish");
        [_videoControl showList];
    }
    [self backOrientationPortrait];
    
}

-(void)rateChangeButtonClick:(UIButton *)button
{
    //_playErrorState = NO;
    [self stop];
    [self.videoControl animateHide];
    NSLog(@"hajhfhkalfhkajlfskfjlsafsahjkhaslkhfaksfhak33 %@",button.titleLabel.text);
    if ([button.titleLabel.text isEqualToString:@"流畅"]) {
        [self.krDelegate KrVideoRateChanged:0];
    }else if([button.titleLabel.text isEqualToString:@"标清"])
    {
        [self.krDelegate KrVideoRateChanged:1];

    }else
    {
        [self.krDelegate KrVideoRateChanged:3];

    }
}
#pragma mark -- 设备旋转监听 改变视频全屏状态显示方向 --
//监听设备旋转方向
- (void)ListeningRotating{
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
}
- (UIViewController *)getCurrentVC
{
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)onDeviceOrientationChange{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if (_videoControl.isOpen) {
        NSLog(@"fish");
        [_videoControl showList];
    }
    switch (interfaceOrientation) {
            /**        case UIInterfaceOrientationUnknown:
             NSLog(@"未知方向");
             break;
             */
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
            [self backOrientationPortrait];
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            [self backOrientationPortrait];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在右");
            
            [self setDeviceOrientationLandscapeLeft];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            
            NSLog(@"第1个旋转方向---电池栏在左");
            
            [self setDeviceOrientationLandscapeRight];
            
        }
            break;
            
        default:
            break;
    }
    
}
//返回小屏幕
- (void)backOrientationPortrait{
    if (!self.isFullscreenMode) {
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        [self.view setTransform:CGAffineTransformIdentity];
        self.frame = self.originFrame;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    } completion:^(BOOL finished) {
        self.isFullscreenMode = NO;
        _videoControl.isFullscreenMode=NO;
        self.videoControl.fullScreenButton.hidden = NO;
        self.videoControl.shrinkScreenButton.hidden = YES;
        if (self.willBackOrientationPortrait) {
            self.willBackOrientationPortrait();
        }
    }];
}



//电池栏在左全屏
- (void)setDeviceOrientationLandscapeRight{
    //    if (self.integer==2) {
    //        self.originFrame = self.view.frame;
    //        CGFloat height = [[UIScreen mainScreen] bounds].size.width;
    //        CGFloat width = [[UIScreen mainScreen] bounds].size.height;
    //        CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);;
    //        [UIView animateWithDuration:0.3f animations:^{
    //            self.frame = frame;
    //            [self.view setTransform:CGAffineTransformMakeRotation(M_PI)];
    //        } completion:^(BOOL finished) {
    //            self.integer = 1;
    //            self.isFullscreenMode = YES;
    //            self.videoControl.fullScreenButton.hidden = YES;
    //            self.videoControl.shrinkScreenButton.hidden = NO;
    //        }];
    //    }
    if (self.isFullscreenMode) {
        return;
    }
    
    self.originFrame = self.view.frame;
    CGFloat height = [[UIScreen mainScreen] bounds].size.width;
    CGFloat width = [[UIScreen mainScreen] bounds].size.height;
    CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);;
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = frame;
        [self.view setTransform:CGAffineTransformMakeRotation(M_PI_2)];

    } completion:^(BOOL finished) {
        self.isFullscreenMode = YES;
        _videoControl.isFullscreenMode=YES;

        self.videoControl.fullScreenButton.hidden = YES;
        self.videoControl.shrinkScreenButton.hidden = NO;
        if (self.willChangeToFullscreenMode) {
            self.willChangeToFullscreenMode();
        }
        NSLog(@"zhuan");
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changedevice" object:nil];
    
}
//电池栏在右全屏
- (void)setDeviceOrientationLandscapeLeft{
    
    //    if  (self.integer==1){
    //        self.originFrame = self.view.frame;
    //        CGFloat height = [[UIScreen mainScreen] bounds].size.width;
    //        CGFloat width = [[UIScreen mainScreen] bounds].size.height;
    //        CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);;
    //        [UIView animateWithDuration:0.3f animations:^{
    //            self.frame = frame;
    //            [self.view setTransform:CGAffineTransformMakeRotation(-M_PI)];
    //        } completion:^(BOOL finished) {
    //            self.integer = 2;
    //            self.isFullscreenMode = YES;
    //            self.videoControl.fullScreenButton.hidden = YES;
    //            self.videoControl.shrinkScreenButton.hidden = NO;
    //        }];
    //    }
    if (self.isFullscreenMode) {
        return;
    }
    self.originFrame = self.view.frame;
    CGFloat height = [[UIScreen mainScreen] bounds].size.width;
    CGFloat width = [[UIScreen mainScreen] bounds].size.height;
    CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);;
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = frame;
        [self.view setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
    } completion:^(BOOL finished) {
        self.isFullscreenMode = YES;
        _videoControl.isFullscreenMode=YES;

        self.videoControl.fullScreenButton.hidden = YES;
        self.videoControl.shrinkScreenButton.hidden = NO;
        if (self.willChangeToFullscreenMode) {
            self.willChangeToFullscreenMode();
        }
    }];
}



- (void)progressSliderTouchBegan:(UISlider *)slider {
    [self pause];
    [self.videoControl cancelAutoFadeOutControlBar];
    double totalTime = floor(self.duration);
    float currentTime= floor(slider.value);
    self.videoControl.movieLength=totalTime;
    self.videoControl.ProgressBeginToMove=currentTime;
    self.videoControl.progressTimeView.alpha=1;
}



- (void)startDurationTimer
{
    self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(monitorVideoPlayback) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.durationTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopDurationTimer
{
    [self.durationTimer invalidate];
}

- (void)fadeDismissControl
{
    [self.videoControl animateHide];
}

#pragma mark - Property

- (KrVideoPlayerControlView *)videoControl
{
    if (!_videoControl) {
        _videoControl = [[KrVideoPlayerControlView alloc] init];
    }
    return _videoControl;
}

- (UIView *)movieBackgroundView
{
    if (!_movieBackgroundView) {
        _movieBackgroundView = [UIView new];
        _movieBackgroundView.alpha = 0.0;
        _movieBackgroundView.backgroundColor = [UIColor blackColor];
    }
    return _movieBackgroundView;
}

- (void)setFrame:(CGRect)frame
{
    [self.view setFrame:frame];
    [self.videoControl setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.videoControl setNeedsLayout];
    [self.videoControl layoutIfNeeded];
}

#pragma mark - 取出视频图片
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}
- (void)onMPMediaPlaybackIsPreparedToPlayDidChangeNotification:(NSNotification*)notification
{
    
    NSNumber* reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    NSLog(@"888888   reason %@",reason);
}

- (void)movieFinishedCallback:(NSNotification*)notification
{
    NSNumber* reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([reason intValue]) {
        case MPMovieFinishReasonPlaybackEnded:{
      //      [self showFailView];
            [self.videoControl.indicatorView stopAnimating];

            NSLog(@"playbackFinished. Reason: Playback Ended");
        }
            break;
        case MPMovieFinishReasonPlaybackError:{
        //    [self showFailView];
            NSLog(@"playbackFinished. Reason: Playback Error");
        }
            break;
        case MPMovieFinishReasonUserExited:
            NSLog(@"playbackFinished. Reason: User Exited");
            break;
        default:
            break;
    }
}
-(void)showFailView
{
    
    NSLog(@"显示失败弹框  ");
    UIView *failview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    failview.tag=1002;
    failview.backgroundColor= [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    UIButton *freshBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    freshBtn.tag=100;
    freshBtn.center=failview.center;
    [freshBtn addTarget:self action:@selector(freshAction) forControlEvents:UIControlEventTouchUpInside];
    [freshBtn setImage:[UIImage imageNamed:@"fresh.png"] forState:UIControlStateNormal];
    [failview addSubview:freshBtn];
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 85, 30)];
    lab.tag=101;

    lab.textColor=[UIColor whiteColor];
    lab.center=CGPointMake(failview.center.x, freshBtn.frame.origin.y+65);
    lab.text=@"加载出错了!";
    [failview addSubview:lab];
    [self.view addSubview:failview];
}

-(void)freshAction
{
    UIView *failView= [self.view viewWithTag:1002];

    
    dispatch_async(dispatch_get_main_queue(), ^{
        
                NSLog(@"remove2");
        
        
                for (UIView *vi in [failView subviews]) {
                    [vi removeFromSuperview];
                    NSLog(@"remove1");
                }
                [failView removeFromSuperview];
        
    });
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAY_FAIL_NOTIFICATION" object:nil];
}


-(void)displayDownLoadSpeed
{
    NSArray *events = self.accessLog.events;
    int count = events.count;
    for (int i = 0; i < count; i++)
    {
        MPMovieAccessLogEvent *currentEvent = [events objectAtIndex:i];
        MPMovieAccessLog *accessLog = self.accessLog;

        double byts = currentEvent.indicatedBitrate;//传输速率单位为bits
        int64_t byte = currentEvent.numberOfBytesTransferred;//播放视频缓冲的大小单位为byte,
        int64_t bytes = currentEvent.numberOfBytesTransferred >> 10;
        NSMutableString *strBytes = [[NSMutableString alloc] initWithCapacity:100];
        [strBytes appendFormat:@"totalSize = %lld byte", bytes];
        if (bytes > 1024)
        {
            bytes = bytes >> 10;
            [strBytes setString:@""];
            [strBytes appendFormat:@"total = %lld M", bytes];
        }
        NSLog(@"byte = %f M bytes = %lld", (float)byte / (1024 * 1024), bytes);
    }
}
-(void)setHiddenProgressView
{
    self.videoControl.progressSlider.hidden=YES;
    self.videoControl.timeLabel.hidden=YES;
}

- (void) getVideoDatas
{
    NSArray *events = self.accessLog.events;
    int count = events.count;
    NSLog(@"events count = %d", count);
    for (int i = 0; i < count; ++i) {
        MPMovieAccessLogEvent *currenEvent = [events objectAtIndex:i];
        double byts =  currenEvent.indicatedBitrate ;;//传输速率单位为bits
        int64_t tmp = byts / 8;
        tmp = tmp / 1024;
        int64_t byte = currenEvent.numberOfBytesTransferred;//播放视频缓冲的大小单位为byte,
        int64_t bytes =  currenEvent.numberOfBytesTransferred >> 10;
        NSMutableString *bytesS = [[NSMutableString alloc] initWithCapacity:100];
        [bytesS appendFormat:@"totalSize = %lld byte",bytes];
        if(bytes > 1024)
        {
            bytes = bytes >> 10;
            [bytesS setString:@""];
            [bytesS appendFormat:@"totalSize = %lld M",bytes];
        }
        NSLog(@"byts = %f, byte = %lld bytes = %lld bits = %lld", byts,byte, bytes, tmp);
        [bytesS appendFormat:@" || speed = %d k",tmp];
        NSLog(@"byte = %f M bytes = %lld", (float)byte / (1024 * 1024), bytes);

        NSLog(@"播放视频缓:%@",bytesS);
      //  [mSpeedLabel setText:bytesS];
       // [bytesS release];
    }
}
#pragma mark - pan垂直移动的方法
- (void)verticalMoved:(CGFloat)value
{
    // 更改音量控件value
//    self.volume.value -= value / 10000; // 越小幅度越小
//    // 更改系统的音量
//    self.volumeSlider.value = self.volume.value;
    
}


@end

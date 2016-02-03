//
//  KrVideoPlayerControlView.m
//  KrVideoPlayerPlus
//
//  Created by JiaHaiyang on 15/6/19.
//  Copyright (c) 2015年 JiaHaiyang. All rights reserved.
//

#import "KrVideoPlayerControlView.h"
#import <AVFoundation/AVFoundation.h>
#import "Tools.h"
static const CGFloat kVideoControlBarHeight = 40.0;
static const CGFloat kVideoControlAnimationTimeinterval = 0.3;
static const CGFloat kVideoControlTimeLabelFontSize = 10.0;
static const CGFloat kVideoControlBarAutoFadeOutTimeinterval = 5.0;
#define VIDEO_H self.frame.size.height
#define VIDEO_W  self.frame.size.width

@interface KrVideoPlayerControlView()

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIView *chargeBar;
@property (nonatomic, strong) UIButton *chargebtn;
@property (nonatomic, strong) UILabel *chargeLab;

//@property (nonatomic, strong) UIButton *playButton;
//@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) UIButton *shrinkScreenButton;
@property (nonatomic, strong) UIButton *videoType;
@property (nonatomic, strong) UIView *videoTypeList;
@property (nonatomic, strong) UIButton *backBuntton;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UIButton *volumeButton;
@property (nonatomic, strong) UIButton *playBtn; // 播放按钮

@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) BOOL isBarShowing;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL isAnimatting;
@property (nonatomic, assign) BOOL isStartPainting;
@property (nonatomic, assign) BOOL ishiddenChargeBar;
@property (nonatomic, strong) MPVolumeView *volum;
@property (nonatomic, strong) UISlider *volumeSlider; // 用来接收系统音量条
//@property (nonatomic, strong) Slider *progressSlider;
@property (nonatomic,strong)UIImageView *brightnessView;
@property (nonatomic,strong)UIProgressView *brightnessProgress;

@property (nonatomic,strong)UIImageView *volumeView;
@property (nonatomic,strong)UIProgressView *volumeProgress;


@property (nonatomic,strong)UIView *progressTimeView;
@property (nonatomic,strong)UILabel *progressTimeLable_top;
@property (nonatomic,strong)UILabel *progressTimeLable_bottom;
@property (nonatomic, assign) CGPoint touchPoint;
@end
@interface KrVideoPlayerControlView()
{
    PanDirection panDirection; // 定义一个实例变量，保存枚举值

    float systemVolume;//系统音量值
    CGPoint startPoint;//起始位置

}
@end
@implementation KrVideoPlayerControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.topBar];
        [self addSubview:self.brightnessProgress];
        [self addSubview:self.volumeProgress];
      //  [self.topBar addSubview:self.shareButton];
        [self.topBar addSubview:self.titleLab];
       // [self.topBar addSubview:self.backBuntton];
        [self addSubview:self.bottomBar];
        [self addSubview:self.brightnessView];
        [self addSubview:self.volumeView];
        [self addSubview:self.progressTimeView];

//        [self.chargeBar addSubview:self.chargebtn];
//        [self.chargeBar addSubview:self.chargeLab];
//        [self addSubview:self.chargeBar];
_volum = [[MPVolumeView alloc]initWithFrame:CGRectMake(-100, 0, 30, 30)];
        [self addSubview:_volum];
        // 添加暂停播放按钮


        for (UIView *view in _volum.subviews) {
            if ([view isKindOfClass:[UISlider class]]) {
                // 接收系统音量条
                self.volumeSlider = (UISlider *)view;
                // 把系统音量的值赋给自定义音量条
            }
        }
    //    [self.bottomBar addSubview:self.playButton];
      //  [self.bottomBar addSubview:self.payButton];
        [self.bottomBar addSubview:self.volumeButton];
       // [self.bottomBar addSubview:self.pauseButton];
      //  self.pauseButton.hidden = YES;
        [self.bottomBar addSubview:self.fullScreenButton];
        [self.bottomBar addSubview:self.shrinkScreenButton];
        self.shrinkScreenButton.hidden = YES;
        [self.bottomBar addSubview:self.timeLabel];
        [self addSubview:self.videoTypeList];
     //   [self.bottomBar addSubview:self.videoType];
        [self addSubview:self.indicatorView];
        [self addSubview:self.playBtn];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tapGesture];
        // 添加平移手势，用来控制音量和快进快退
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
        [self addGestureRecognizer:pan];

        
        [self.bottomBar addSubview:self.progressSlider];
//        self.playBtn.hidden=YES;
//        self.bottomBar.alpha=0;
//        self.topBar.alpha=0;
           }
    return self;
}
//声音增加
- (void)volumeAdd:(CGFloat)step{
    [MPMusicPlayerController applicationMusicPlayer].volume += step;;
}
//亮度增加
- (void)brightnessAdd:(CGFloat)step{
    
    [UIScreen mainScreen].brightness  -= step / 10000; // 越小幅度越小
    self.brightnessProgress.progress= [UIScreen mainScreen].brightness ;
    

}
//快进／快退
- (void)movieProgressAdd:(CGFloat)step{
//    _movieProgressSlider.value += (step/_movieLength);
//    [self scrubberIsScrolling];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.playBtn.frame =CGRectMake(CGRectGetMidX(self.bounds)-20, CGRectGetMidY(self.bounds)-20, 40, 40);
    self.topBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), CGRectGetWidth(self.bounds), kVideoControlBarHeight);
    
    self.backBuntton.frame = CGRectMake(5, CGRectGetMinX(self.topBar.bounds), CGRectGetWidth(self.backBuntton.bounds), CGRectGetHeight(self.backBuntton.bounds));
    
    
    self.shareButton.frame = CGRectMake(CGRectGetWidth(self.topBar.bounds) - CGRectGetWidth(self.shareButton.bounds)-10, CGRectGetMinX(self.topBar.bounds), CGRectGetWidth(self.shareButton.bounds), CGRectGetHeight(self.shareButton.bounds));
    self.titleLab.frame=CGRectMake(45, CGRectGetMinX(self.topBar.bounds), CGRectGetWidth(self.topBar.bounds)-CGRectGetWidth(self.shareButton.bounds)-35, CGRectGetHeight(self.shareButton.bounds));
    
    self.bottomBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetHeight(self.bounds) - kVideoControlBarHeight, CGRectGetWidth(self.bounds), kVideoControlBarHeight);
    if (_ishiddenChargeBar==YES) {
            self.chargeBar.frame = CGRectMake( CGRectGetWidth(self.bounds)-30, CGRectGetHeight(self.bounds)/2, 30, kVideoControlBarHeight);
        self.chargebtn.frame=CGRectMake(CGRectGetWidth(self.chargeBar.bounds)-CGRectGetWidth(self.chargebtn.bounds), 0, CGRectGetWidth(self.chargebtn.bounds),  CGRectGetHeight(self.chargebtn.bounds));
        self.chargeLab.frame=CGRectMake(0, 0, 0,  0);
    }else
    {
        self.chargeBar.frame = CGRectMake( CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2, CGRectGetWidth(self.bounds)/2, kVideoControlBarHeight);
        self.chargebtn.frame=CGRectMake(CGRectGetWidth(self.chargeBar.bounds)-CGRectGetWidth(self.chargebtn.bounds), 0, CGRectGetWidth(self.chargebtn.bounds),  CGRectGetHeight(self.chargebtn.bounds));
        self.chargeLab.frame=CGRectMake(5, 0, CGRectGetWidth(self.chargeBar.bounds)-CGRectGetWidth(self.chargebtn.bounds)-5,  CGRectGetHeight(self.chargebtn.bounds));
    }
    
        
//    self.playButton.frame = CGRectMake(6+CGRectGetMinX(self.bottomBar.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.playButton.bounds)/2, CGRectGetWidth(self.playButton.bounds), CGRectGetHeight(self.playButton.bounds));
//    self.payButton.frame = CGRectMake(80+CGRectGetMinX(self.bottomBar.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.playButton.bounds)/2, CGRectGetWidth(self.playButton.bounds), CGRectGetHeight(self.playButton.bounds));
//
    
    self.volumeButton.frame = CGRectMake(6+CGRectGetMinX(self.bottomBar.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.volumeButton.bounds)/2, CGRectGetWidth(self.volumeButton.bounds), CGRectGetHeight(self.volumeButton.bounds));
  //  self.pauseButton.frame = self.playButton.frame;
    self.fullScreenButton.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - CGRectGetWidth(self.fullScreenButton.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.fullScreenButton.bounds)/2, CGRectGetWidth(self.fullScreenButton.bounds), CGRectGetHeight(self.fullScreenButton.bounds));
    
    self.shrinkScreenButton.frame = self.fullScreenButton.frame;
    
 //   self.videoType.frame=CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - 2*CGRectGetWidth(self.fullScreenButton.bounds)-3, 0, CGRectGetWidth(self.videoType.bounds), kVideoControlBarHeight);
    
   // self.videoTypeList.frame=CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - 2*CGRectGetWidth(self.fullScreenButton.bounds)-3, CGRectGetHeight(self.bounds)-kVideoControlBarHeight-60, CGRectGetWidth(self.videoType.bounds), 60);
   // [self.videoType addTarget:self action:@selector(showList) forControlEvents:UIControlEventTouchUpInside];
   [self.indicatorView setCenter:self.center];
    self.progressSlider.frame = CGRectMake(CGRectGetMaxX(self.volumeButton.frame), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.progressSlider.bounds)/2, CGRectGetMinX(self.shrinkScreenButton.frame) - CGRectGetMaxX(self.volumeButton.frame), CGRectGetHeight(self.progressSlider.bounds));
    self.timeLabel.frame = CGRectMake(CGRectGetMidX(self.progressSlider.frame), CGRectGetHeight(self.bottomBar.bounds) - CGRectGetHeight(self.timeLabel.bounds) - 2.0, CGRectGetWidth(self.progressSlider.bounds)/2, CGRectGetHeight(self.timeLabel.bounds));
    self.indicatorView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.brightnessView.center= CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.volumeView.center= CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.progressTimeView.center= CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
   // self.brightnessView.center= CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.isBarShowing = YES;
}

- (void)animateHide
{
    if (!self.isBarShowing) {
        return;
    }
//    if (_isOpen) {
//        [self showList];
//
//    }
    self.progressTimeView.alpha=0;
    self.playBtn.hidden=YES;

    [UIView animateWithDuration:kVideoControlAnimationTimeinterval animations:^{
        self.topBar.alpha = 0.0;
        self.bottomBar.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.isBarShowing = NO;

    }];
}

- (void)animateShow
{
    if (self.isBarShowing) {
        return;
    }
    MPMusicPlayerController *mp=[MPMusicPlayerController applicationMusicPlayer];

    if (mp.volume==0.0) {
        [_volumeButton setImage:[UIImage imageNamed:@"静音"] forState:UIControlStateNormal];
        
    }else
    {
        [_volumeButton setImage:[UIImage imageNamed:@"音量"] forState:UIControlStateNormal];
        
    }
    self.playBtn.hidden=NO;

   // [_videoType setTitle:[[[User_OBJ sharedManager] getRateList] objectAtIndex:0] forState:UIControlStateNormal];
    [UIView animateWithDuration:kVideoControlAnimationTimeinterval animations:^{
        self.topBar.alpha = 1.0;
        self.bottomBar.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.isBarShowing = YES;

        [self autoFadeOutControlBar];
        
    }];
}

- (void)autoFadeOutControlBar
{
    if (!self.isBarShowing) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:kVideoControlBarAutoFadeOutTimeinterval];
}

- (void)cancelAutoFadeOutControlBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
}

- (void)onTap:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self];

    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (self.isBarShowing) {
            if ((point.y<=kVideoControlBarHeight)||(point.y>=self.frame.size.height- kVideoControlBarHeight)) {
                return;
            }

            [self animateHide];
        } else {
            [self animateShow];
        }
    }
}


//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    _touchPoint=[[touches anyObject] locationInView:self];
////    NSLog(@"firstpoint: %f,    %f",[[touches anyObject] locationInView:self].x,[[touches anyObject] locationInView:self].y);
////    NSLog(@"VIDEO_H:%f",VIDEO_H);
////    if (_isFullscreenMode) {
////        if (_touchPoint.x>(VIDEO_H*3/4)) {
////            _isStartPainting=YES;
////        }else
////        {
////            _isStartPainting=NO;
////        }
////    }
////   
////    MPMusicPlayerController *mp=[MPMusicPlayerController applicationMusicPlayer];
////   systemVolume= mp.volume;
////    
////    
////    if(event.allTouches.count == 1){
////        //保存当前触摸的位置
////        startPoint = _touchPoint;
////    }
//    
//    
//}
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if ((_isBarShowing==NO)&&(_isStartPainting==YES)&&(_isFullscreenMode==YES)) {
//        
////     //   CGPoint t=[[touches anyObject] locationInView:self];
////        
////        NSLog(@"move:%f,    %f",[[touches anyObject] locationInView:self].x,[[touches anyObject] locationInView:self].y);
////        NSLog(@"VIDEO_H:%f",VIDEO_H);
////        float fen=([[touches anyObject] locationInView:self].y/VIDEO_W);
////        if (fen>=0.97) {
////            fen=1.0;
////        }
////        if (fen<=0.03) {
////            fen=0.0;
////        }
////        [self volumeChangeWith:fen];
//        
//        if(event.allTouches.count == 1){
//            //计算位移
//            CGPoint point = [[touches anyObject] locationInView:self];
//            //        float dx = point.x - startPoint.x;
//            float dy = point.y - startPoint.y;
//            int index = (int)dy;
//            if(index>0){
//                if(index%5==0){//每10个像素声音减一格
//                    NSLog(@"%.2f",systemVolume);
//                    if(systemVolume>0.1){
//                        systemVolume = systemVolume-0.05;
//                        [self volumeChangeWith:systemVolume];
//                        
//                        
//                        // [volumeViewSlider setValue:systemVolume animated:YES];
//                        //[volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
//                    }
//                }
//            }else{
//                if(index%5==0){//每10个像素声音增加一格
//                    NSLog(@"+x ==%d",index);
//                    NSLog(@"%.2f",systemVolume);
//                    if(systemVolume>=0 && systemVolume<1){
//                        systemVolume = systemVolume+0.05;
//                        [self volumeChangeWith:systemVolume];
//                        
//                        //  [volumeViewSlider setValue:systemVolume animated:YES];
//                        //  [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
//                    }
//                }
//            }
//            //亮度调节
//            //        [UIScreen mainScreen].brightness = (float) dx/self.view.bounds.size.width;
//        }
//  
//        
//        
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//    
//}

//-(void)volumeChangeWith:(float)flag
//{
//    NSLog(@"MPMusicPlayerController");
//    MPMusicPlayerController *mp=[MPMusicPlayerController applicationMusicPlayer];
//    mp.volume=flag;
//}
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    _isStartPainting=NO;
//}
//-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    _isStartPainting=NO;
//}
#pragma mark - Property

- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      //  [_playBtn setImage:[UIImage imageNamed:@"kr-video-player-play"] forState:UIControlStateNormal];
        
//        self.play = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.play.frame = CGRectMake(0, 0, 40, 40);
//        self.play.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [_playBtn setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];
        //  self.play.hidden = YES;
        
        
        _playBtn.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _playBtn;
}

- (UIView *)topBar
{
    if (!_topBar) {
        _topBar = [UIView new];
        _topBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    }
    return _topBar;
}

- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [UIView new];
        _bottomBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    }
    return _bottomBar;
}
- (UIView *)chargeBar
{
    if (!_chargeBar) {
        _chargeBar = [UIView new];
       _chargeBar.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.7];
       // _chargeBar.backgroundColor = [UIColor whiteColor];

    }
    return _chargeBar;
}
//
//- (UIButton *)playButton
//{
//    if (!_playButton) {
//        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_playButton setImage:[UIImage imageNamed:@"kr-video-player-play"] forState:UIControlStateNormal];
//        _playButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
//    }
//    return _playButton;
//}
//
//- (UIButton *)pauseButton
//{
//    if (!_pauseButton) {
//        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_pauseButton setImage:[UIImage imageNamed:@"kr-video-player-pause"] forState:UIControlStateNormal];
//        _pauseButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
//    }
//    return _pauseButton;
//}

- (UIButton *)fullScreenButton
{
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:@"kr-video-player-fullscreen"] forState:UIControlStateNormal];
        _fullScreenButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _fullScreenButton;
}

- (UIButton *)shrinkScreenButton
{
    if (!_shrinkScreenButton) {
        _shrinkScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shrinkScreenButton setImage:[UIImage imageNamed:@"kr-video-player-shrinkscreen"] forState:UIControlStateNormal];
        _shrinkScreenButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _shrinkScreenButton;
}

- (UIButton *)videoType
{
    if (!_videoType) {
        _videoType = [UIButton buttonWithType:UIButtonTypeCustom];
     //   [_videoType setTitle:@"高清" forState:UIControlStateNormal];
        
       // [_videoType setTitle:[[[User_OBJ sharedManager] getRateList] objectAtIndex:0] forState:UIControlStateNormal];

        _videoType.titleLabel.font=[UIFont boldSystemFontOfSize:12];
        //[_videoType setImage:[UIImage imageNamed:@"kr-video-player-shrinkscreen"] forState:UIControlStateNormal];
        _videoType.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _videoType;
}

- (UIButton *)payButton
{
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setImage:[UIImage imageNamed:@"付费按键"] forState:UIControlStateNormal];
        _payButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight/2);
    }
    return _payButton;
}

- (UIButton *)volumeButton
{
    if (!_volumeButton) {
        _volumeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        MPMusicPlayerController *mp=[MPMusicPlayerController applicationMusicPlayer];

        if (mp.volume==0.0) {
            [_volumeButton setImage:[UIImage imageNamed:@"静音"] forState:UIControlStateNormal];
            
        }else
        {
            [_volumeButton setImage:[UIImage imageNamed:@"音量"] forState:UIControlStateNormal];
            
        }
        
        _volumeButton.bounds = CGRectMake(0, 0, 30, kVideoControlBarHeight/2);
    }
    return _volumeButton;
}
- (UISlider *)progressSlider
{
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"kr-video-player-point"] forState:UIControlStateNormal];
        [_progressSlider setMinimumTrackTintColor:[UIColor whiteColor]];
        [_progressSlider setMaximumTrackTintColor:[UIColor lightGrayColor]];
        _progressSlider.value = 0.f;
        _progressSlider.continuous = YES;
    }
    return _progressSlider;
}
- (UIButton *)backBuntton
{
    if (!_backBuntton) {
        _backBuntton = [UIButton buttonWithType:UIButtonTypeCustom];
       [_backBuntton setImage:[UIImage imageNamed:@"reg_title_back"] forState:UIControlStateNormal];        _backBuntton.titleLabel.font=[UIFont boldSystemFontOfSize:12];
        // [_closeButton setImage:[UIImage imageNamed:@"kr-video-player-close"] forState:UIControlStateNormal];
        _backBuntton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _backBuntton;
}


- (UIButton *)shareButton
{
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        
        _shareButton.titleLabel.font=[UIFont boldSystemFontOfSize:12];
       // [_closeButton setImage:[UIImage imageNamed:@"kr-video-player-close"] forState:UIControlStateNormal];
        _shareButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _shareButton;
}
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.font = [UIFont systemFontOfSize:13];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.bounds = CGRectMake(0, 0, kVideoControlTimeLabelFontSize, kVideoControlTimeLabelFontSize);
    }
    return _titleLab;
}




- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:kVideoControlTimeLabelFontSize];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.bounds = CGRectMake(0, 0, kVideoControlTimeLabelFontSize, kVideoControlTimeLabelFontSize);
    }
    return _timeLabel;
}
//


-(UIImageView *)volumeView
{
    
    
    if (!_volumeView) {
        _volumeView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.height/2-63, self.frame.size.width/2-63, 100, 100)];
        _volumeView.image = [UIImage imageNamed:@"video_volume_bg"];
        
        _volumeProgress = [[UIProgressView alloc]initWithFrame:CGRectMake(_volumeView.frame.size.width/2-30, _volumeView.frame.size.height-20, 60, 10)];
        _volumeProgress.trackImage = [UIImage imageNamed:@"video_num_bg"];
        _volumeProgress.progressImage = [UIImage imageNamed:@"video_num_front"];
        _volumeProgress.progress = [UIScreen mainScreen].brightness;
        [_volumeView addSubview:_volumeProgress];
        _volumeView.alpha = 0;
    }
    return _volumeView;
}


-(UIImageView *)brightnessView
{
    

    if (!_brightnessView) {
        _brightnessView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.height/2-63, self.frame.size.width/2-63, 100, 100)];
        _brightnessView.image = [UIImage imageNamed:@"video_brightness_bg"];
        
        _brightnessProgress = [[UIProgressView alloc]initWithFrame:CGRectMake(_brightnessView.frame.size.width/2-30, _brightnessView.frame.size.height-20, 60, 10)];
        _brightnessProgress.trackImage = [UIImage imageNamed:@"video_num_bg"];
        _brightnessProgress.progressImage = [UIImage imageNamed:@"video_num_front"];
        _brightnessProgress.progress = [UIScreen mainScreen].brightness;
        [_brightnessView addSubview:_brightnessProgress];
        _brightnessView.alpha = 0;
    }
    return _brightnessView;
}

-(UIView*)progressTimeView
{
    if (!_progressTimeView) {
        _progressTimeView = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.height/2-100, self.bounds.size.width/2-30, 200, 60)];
        _progressTimeLable_top = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
        _progressTimeLable_top.textAlignment = NSTextAlignmentCenter;
        _progressTimeLable_top.textColor = [UIColor whiteColor];
        _progressTimeLable_top.backgroundColor = [UIColor clearColor];
        _progressTimeLable_top.font = [UIFont systemFontOfSize:25];
        _progressTimeLable_top.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _progressTimeLable_top.shadowOffset = CGSizeMake(1.0, 1.0);
        [_progressTimeView addSubview:_progressTimeLable_top];
        
        _progressTimeLable_bottom = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 200, 30)];
        _progressTimeLable_bottom.textAlignment = NSTextAlignmentCenter;
        _progressTimeLable_bottom.textColor = [UIColor whiteColor];
        _progressTimeLable_bottom.backgroundColor = [UIColor clearColor];
        _progressTimeLable_bottom.font = [UIFont systemFontOfSize:25];
        _progressTimeLable_bottom.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _progressTimeLable_bottom.shadowOffset = CGSizeMake(1.0, 1.0);
        [_progressTimeView addSubview:_progressTimeLable_bottom];
        
    }
    return _progressTimeView;
}






- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_indicatorView stopAnimating];
    }
    return _indicatorView;
}


#pragma mark - 平移手势方法
- (void)panDirection:(UIPanGestureRecognizer *)pan
{
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    CGPoint currentPoint=[pan locationInView:self];
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            //            NSLog(@"x:%f  y:%f",veloctyPoint.x, veloctyPoint.y);
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                panDirection = PanDirectionHorizontalMoved;
                // 取消隐藏
           //     self.horizontalLabel.hidden = NO;
                // 给sumTime初值
            //    sumTime = self.moviePlayer.currentPlaybackTime;
            }
            else if (x < y){ // 垂直移动
                panDirection = PanDirectionVerticalMoved;
                // 显示音量控件
            //    self.volume.hidden = NO;
                // 开始滑动的时候，状态改为正在控制音量
          //      isVolume = YES;
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (panDirection) {
                case PanDirectionHorizontalMoved:{
               //     [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    break;
                }
                case PanDirectionVerticalMoved:{
                  //  self.brightnessView.alpha=1;
                    NSLog(@"_________%f",currentPoint.x);
                 //   [self brightnessAdd:veloctyPoint.x];
                    
                    if (currentPoint.x>VIDEO_W/2) {
                        
                        
                        if ([[Tools sharedManager] isOpenVolume] ) {
                            self.volumeView.alpha=1;
                            [self verticalMoved:veloctyPoint.y];
                        }


                    }else
                    {
                        if ([[Tools sharedManager] isOpenScreenbrightness]) {
                            self.brightnessView.alpha=1;
                            [self brightnessAdd:veloctyPoint.y];
                        }

                    }
//                    if (veloctyPoint.x<VIDEO_W/2) {
//                        //[self verticalMoved:veloctyPoint.y];
//                         [self brightnessAdd:0.1];[self brightnessAdd:0.1];
//// 垂直移动方法只要y方向的值
//
//                    }else
//                    {
//                        [self volumeAdd:0.1];
//                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (panDirection) {
                case PanDirectionHorizontalMoved:{
                    // 隐藏视图
                  //  self.horizontalLabel.hidden = YES;
                    // ⚠️在滑动结束后，视屏要跳转
                //    self.moviePlayer.currentPlaybackTime = sumTime;
                    // 把sumTime滞空，不然会越加越多
              //      sumTime = 0;

                    break;
                }
                case PanDirectionVerticalMoved:{
                    self.volumeView.alpha=0;
                    self.brightnessView.alpha=0;
                    // 垂直移动结束后，隐藏音量控件
               //     self.volume.hidden = YES;
                    // 且，把状态改为不再控制音量
               //     isVolume = NO;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}
- (void)updateProfressTimeLabl{
    double currentTime = floor(_movieLength *_progressSlider.value);
    double changeTime = floor(_movieLength*ABS(_progressSlider.value-_ProgressBeginToMove));
    //转成秒数
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:currentTime];
    NSDate *changeDate = [NSDate dateWithTimeIntervalSince1970:changeTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    [formatter setDateFormat:(currentTime/3600>=1)? @"h:mm:ss":@"mm:ss"];
    NSString *currentTimeStr = [formatter stringFromDate:currentDate];
    
    [formatter setDateFormat:(changeTime/3600>=1)? @"h:mm:ss":@"mm:ss"];
    NSString *changeTimeStr = [formatter stringFromDate:changeDate];
    
    _progressTimeLable_top.text = currentTimeStr;
    _progressTimeLable_bottom.text = [NSString stringWithFormat:@"[%@ %@]",(_progressSlider.value-_ProgressBeginToMove) < 0? @"-":@"+",changeTimeStr];
    
}

#pragma mark - pan垂直移动的方法
- (void)verticalMoved:(CGFloat)value
{
    // 更改音量控件value
    
    if (self.volumeSlider.value ==0.0f) {
    }
    self.volumeSlider.value -= value / 10000; // 越小幅度越小
    self.volumeProgress.progress=self.volumeSlider.value;
    if (self.volumeSlider.value ==0.0f) {
        ;
    }
    // 更改系统的音量
    
}
@end

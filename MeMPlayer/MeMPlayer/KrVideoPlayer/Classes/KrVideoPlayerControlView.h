//
//  KrVideoPlayerControlView.h
//  KrVideoPlayerPlus
//
//  Created by JiaHaiyang on 15/6/19.
//  Copyright (c) 2015年 JiaHaiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "User_OBJ.h"
//#import "Slider.h"

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved,
    PanDirectionVerticalMoved
};


typedef NS_ENUM(NSInteger, GestureType){
    GestureTypeOfNone = 0,
    GestureTypeOfVolume,
    GestureTypeOfBrightness,
    GestureTypeOfProgress,
};

#define VolumeStep 0.02f
#define BrightnessStep 0.02f
#define MovieProgressStep 5.0f
@import MediaPlayer;

@interface KrVideoPlayerControlView : UIView
@property (nonatomic, strong, readonly) UIView *topBar;
@property (nonatomic, strong, readonly) UIView *bottomBar;
@property (nonatomic, strong, readonly) UIView *chargeBar;

@property (nonatomic, strong, readonly) UIButton *chargebtn;
@property (nonatomic, strong, readonly) UILabel *chargeLab;

//@property (nonatomic, strong, readonly) UIButton *playButton;
//@property (nonatomic, strong, readonly) UIButton *pauseButton;
@property (nonatomic, strong, readonly) UIButton *fullScreenButton;
@property (nonatomic, strong, readonly) UIButton *shrinkScreenButton;
@property (nonatomic, strong, readonly) UIButton *payButton;
@property (nonatomic, strong, readonly) UIButton *backBuntton;
@property (nonatomic, assign) BOOL isFullscreenMode;
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UIButton *playBtn; // 播放按钮

@property (nonatomic, strong, readonly) UIButton *volumeButton;
@property (nonatomic, strong) UIButton *btnType1;
@property (nonatomic, strong) UIButton *btnType2;
@property (nonatomic, assign, readonly) BOOL isOpen;
//@property (nonatomic, strong, readonly) UISlider *progressSlider;
@property (nonatomic, strong, readonly) UISlider *progressSlider;

@property (nonatomic, strong, readonly) UIButton *shareButton;
@property (nonatomic, strong, readonly) UIButton *videoType;

@property (nonatomic,strong, readonly)UIImageView *brightnessView;
@property (nonatomic,strong, readonly)UIProgressView *brightnessProgress;
@property (nonatomic,strong, readonly)UIImageView *volumeView;
@property (nonatomic,strong, readonly)UIProgressView *volumeProgress;
@property (nonatomic,strong, readonly)UIView *progressTimeView;
@property (nonatomic,strong, readonly)UILabel *progressTimeLable_top;
@property (nonatomic,strong, readonly)UILabel *progressTimeLable_bottom;
@property (nonatomic,assign)CGFloat ProgressBeginToMove;

@property (nonatomic)CGFloat movieLength;




//@property (nonatomic, strong) Slider *progressSlider;

//@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *indicatorView;
@property (nonatomic,strong) UILabel *titleLab;
- (void)showList;
- (void)animateHide;
- (void)animateShow;
- (void)autoFadeOutControlBar;
- (void)cancelAutoFadeOutControlBar;
- (void)hiddenChargeBar;
- (void)updateProfressTimeLabl;
@end

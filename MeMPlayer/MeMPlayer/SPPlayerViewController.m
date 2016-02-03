//
//  SPPlayerViewController.m
//  SportsViedo
//
//  Created by mellow on 15/8/21.
//  Copyright (c) 2015年 mellow. All rights reserved.
//
#import "SPPlayerViewController.h"
#import "KrVideoPlayerController.h"
#import<AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface SPPlayerViewController()<UIWebViewDelegate,AVAudioSessionDelegate>
@property (nonatomic, strong)UIWebView *webView;
@end

@implementation SPPlayerViewController
-(void)dealloc{
    _webView.delegate=nil;
    _webView=nil;
    _videoController =nil;
    NSLog(@"release");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"Defaut1_plus"]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];

    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [button setBackgroundImage:[UIImage imageNamed:@"back_Main"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:button];

    if (!self.videoController) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;

        self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0, height/2-width*(4.5/16.0), width, width*(9.0/16.0))];
        self.videoController.shouldAutoplay=NO;
        self.videoController.titleS=self.titleV;

        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
        }];
        [self.videoController setWillBackOrientationPortrait:^{
            [weakSelf toolbarHidden:NO];
        }];
        [self.videoController setWillChangeToFullscreenMode:^{
            [weakSelf toolbarHidden:YES];
        }];
        [self.view addSubview:self.videoController.view];
    }


   // [self playVideoWithRate:[[User_OBJ sharedManager] getCurrentRate] andSportid:_sportid];
  [self playVideo];
}
//void audioRouteChangeListenerCallback (
//                                       void                      *inUserData,
//                                       AudioSessionPropertyID    inPropertyID,
//                                       UInt32                    inPropertyValueS,
//                                       const void                *inPropertyValue
//                                       ) {
//    UInt32 propertySize = sizeof(CFStringRef);
//    AudioSessionInitialize(NULL, NULL, NULL, NULL);
//    CFStringRef state = nil;
//
//    //获取音频路线
//    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute
//                            ,&propertySize,&state);//kAudioSessionProperty_AudioRoute：音频路线
//    NSLog(@"%@",(__bridge NSString *)state);//Headphone 耳机  Speaker 喇叭.
//}
//- (BOOL)addHeadPhoneListener{
//    OSStatus status = AudioSessionAddPropertyListener(
//                                                      kAudioSessionProperty_AudioRouteChange,
//                                                      audioRouteChangeListenerCallback,(__bridge void *)(self));
//    /*21
//     AudioSessionAddPropertyListener(
//     AudioSessionPropertyID              inID,
//     AudioSessionPropertyListener        inProc,
//     void                                *inClientData
//     )
//     注册一个监听：audioRouteChangeListenerCallback，当音频会话传递的方式（耳机/喇叭）发生改变的时候，会触发这个监听
//     kAudioSessionProperty_AudioRouteChange ：就是检测音频路线是否改变
//     */
//    return YES;
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    // Disable user selection
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
//    // Disable callout
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
//}
-(void)returnAction
{
    [self.videoController stop];
    [self.videoController dismiss];
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


}


-(void)playVideoWithRate:(NSInteger)rate andSportid:(NSString *)sportid
{
    
                        //isPreparedToPlay
                    [self playVideo];

 
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:msg
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    });
    
}
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    
//    NSString *requestString = [[request URL] absoluteString];
//    NSArray *components = [requestString componentsSeparatedByString:@":"];
//    NSLog(@"web :%@",components);//userid:sportid
//    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"playVideo"]) {
//        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"alert"])
//        {
//            UIAlertView *alert = [[UIAlertView alloc]
//                                  initWithTitle:@"Alert from Cocoa Touch" message:[components objectAtIndex:2]
//                                  delegate:self cancelButtonTitle:nil
//                                  otherButtonTitles:@"OK", nil];
//            [alert show];
//        }
//        return NO;
//    }
//    return YES;
//}
- (void)playVideo{
    
    NSLog(@"self.urlStr:%@",self.urlStr);
   NSURL *url = [NSURL URLWithString:[self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
     [self addVideoPlayerWithURL:url];
       [self.videoController videoPlay];
   // [self performSelector:@selector(startplayVideo) withObject:self afterDelay:3];
    
//    double delayInSeconds = 1;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        //[MBProgressHUD  hideHUDForView:[[UIApplication sharedApplication].windows firstObject] animated:YES];
//        
//        double time= 11;
//        if (time >60.0f) {
//
//        }else{
//
//        }
//    });

    
    
}

- (void)addVideoPlayerWithURL:(NSURL *)url{

  //  self.videoController.contentURL = url;
    
     [self.videoController setContentURL:url];
    
}

//隐藏navigation tabbar 电池栏
- (void)toolbarHidden:(BOOL)Bool{
    self.navigationController.navigationBar.hidden = Bool;
    self.tabBarController.tabBar.hidden = Bool;
    [[UIApplication sharedApplication] setStatusBarHidden:Bool withAnimation:UIStatusBarAnimationFade];
}

- (BOOL)shouldAutorotate {
    return YES;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end

//
//  UploadViewController.m
//  MeMPlayer
//
//  Created by mellow on 16/1/29.
//  Copyright © 2016年 mellow. All rights reserved.
//

#import "UploadViewController.h"
#define PORT 8080

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define iOS7GE [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0
#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegat
@interface UploadViewController ()

@end

@implementation UploadViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [button setBackgroundImage:[UIImage imageNamed:@"back_Main"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.title=@"文件添加";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    
    //
    //    UIButton *return_btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    //    [return_btn setBackgroundImage:[UIImage imageNamed:@"return_vc.png"] forState:UIControlStateNormal];
    //    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:return_btn];
    //
    //    [return_btn addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self startServer];
    
}
//-(void)returnAboutVC
//{    [self stopServer];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_Notification" object:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}



-(void)returnAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) startServer{
    
    //    [wifi setHighlighted:YES];
    //    [UIView beginAnimations:@"animationID" context:nil];
    //    [UIView setAnimationDuration:0.5f];
    //    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //    [UIView setAnimationRepeatAutoreverses:NO];
    //    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    //    self.view.hidden = NO;
    //    [UIView commitAnimations];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *ip = [GetAddress localWiFiIPAddress];
    
    self.ipLab.text =[NSString stringWithFormat:@"http://%@:8080",ip];
    
    if(ip == NULL){
        self.ipLab.text =[NSString stringWithFormat:@"wifi未连接，请检查！"];
        
        return;
    }
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    self.httpServer = [[HTTPServer alloc] init];
    
    [_httpServer setType:@"_http._tcp."];
    [_httpServer setPort:PORT];
    
    [_httpServer setDocumentRoot:documentsDirectory];
    [_httpServer setConnectionClass:[MyHTTPConnection class]];
    
    NSError *error = nil;
    if (![_httpServer start:&error]) {
        //  NSLog(@" error");
    }
    else{
        //     NSLog(@"no error");
    }
    
}

-(void)dealloc
{
    _httpServer=nil;
    _text= nil;
    _url=nil;
    _wifi=nil;
    _ipLab=nil;
}
-(void)stopServer{
    
    [_httpServer stop:NO];
    
}
@end

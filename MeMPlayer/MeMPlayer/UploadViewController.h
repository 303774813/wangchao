//
//  UploadViewController.h
//  MeMPlayer
//
//  Created by mellow on 16/1/29.
//  Copyright © 2016年 mellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyHTTPConnection.h"
#import "GetAddress.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "HTTPServer.h"
@interface UploadViewController : UIViewController
@property (nonatomic, retain) HTTPServer *httpServer;
@property (nonatomic, retain) UILabel *text;
@property (nonatomic, retain) UILabel *url;
@property (nonatomic, retain) UIButton *wifi;
@property (weak, nonatomic) IBOutlet UILabel *ipLab;
-(void) startServer;
-(void) stopServer;
@end

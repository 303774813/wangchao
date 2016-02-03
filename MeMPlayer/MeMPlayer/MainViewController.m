//
//  MainViewController.m
//  MeMPlayer
//
//  Created by mellow on 16/1/19.
//  Copyright © 2016年 mellow. All rights reserved.
//

#import "MainViewController.h"
#import "AboutViewController.h"
#import "SetViewController.h"
//#import "SetTableViewController.h"
#import "KeyViewController.h"
#import "MediaTableViewController.h"
#import "StreamViewController.h"
#import "LocTableViewController.h"
#import "Tools.h"
#import "UploadViewController.h"
#define First_Launched @"firstLaunch"
#define IsIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] <8.0 ? YES : NO)
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960),[[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define LOADIMAGE(file,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
@interface MainViewController ()
{
    UIStoryboard *board;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"default1"]];
    board=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  //  self.navigationController.navigationBarHidden=YES;
}

-(IBAction)openFileFromDocument:(UIButton *)sender
{
    LocTableViewController *media=[board instantiateViewControllerWithIdentifier:@"LocTableViewController" ];
    [self.navigationController pushViewController:media animated:YES];

}

-(IBAction)openMediaLib:(UIButton *)sender
{
    MediaTableViewController *media=[board instantiateViewControllerWithIdentifier:@"MediaTableViewController" ];
    [self.navigationController pushViewController:media animated:YES];
    
}

-(IBAction)openStreamFromWeb:(UIButton *)sender
{
    StreamViewController *media=[board instantiateViewControllerWithIdentifier:@"StreamViewController" ];
    [self.navigationController pushViewController:media animated:YES];

}

-(IBAction)downloadHistory:(UIButton *)sender
{
    KeyViewController *abvc=[board instantiateViewControllerWithIdentifier:@"KeyViewController" ];
    [self.navigationController pushViewController:abvc animated:YES];
}

-(IBAction)uplaodFromPC:(UIButton *)sender
{
    UploadViewController *abvc=[board instantiateViewControllerWithIdentifier:@"UploadViewController" ];
    [self.navigationController pushViewController:abvc animated:YES];

}

-(IBAction)setForDevice:(UIButton *)sender
{
    
   
        SetViewController *abvc=[board instantiateViewControllerWithIdentifier:@"SetViewController" ];
        [self.navigationController pushViewController:abvc animated:YES];

}

-(IBAction)openAboutPage:(UIButton *)sender
{
    AboutViewController *abvc=[board instantiateViewControllerWithIdentifier:@"AboutViewController" ];
    [self.navigationController pushViewController:abvc animated:YES];
 
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

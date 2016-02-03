//
//  AppDelegate.m
//  MeMPlayer
//
//  Created by mellow on 16/1/19.
//  Copyright © 2016年 mellow. All rights reserved.
//
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#import "AppDelegate.h"
#import "MainViewController.h"
#import "Tools.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
   
     
   // MainViewController *mainVC=[[MainViewController alloc] init];
  //  UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:mainVC];
    
   UINavigationBar *bar=[UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"bar-mid"] forBarMetrics:UIBarMetricsCompactPrompt];

    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"First_Regist"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"First" forKey:@"First_Regist"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[Tools sharedManager] openPlayerLandscape:YES];
        [[Tools sharedManager] openVolume:YES];
        [[Tools sharedManager] openScreenbrightness:YES];
        
    }
 //   [self.window setRootViewController:nav];
    
//    NSMutableDictionary *dic1=(NSMutableDictionary *)[[NSBundle mainBundle]infoDictionary];
//   [dic1 setObject:@[@"UIInterfaceOrientationLandscapeLeft"] forKey:@"UISupportedInterfaceOrientations"];
//    NSLog(@"%@",[dic1 objectForKey:@"UISupportedInterfaceOrientations"]);
//    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
//    KeyViewController *keyVC=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"KeyViewController" ];;
//    [self.window.rootViewController presentViewController:keyVC animated:YES completion:^{
//        ;
//    }];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"lan_Screen"]) {
//        return  UIInterfaceOrientationMaskLandscapeLeft;
//    }
    return UIInterfaceOrientationMaskPortrait;
}
@end

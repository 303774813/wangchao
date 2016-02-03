//
//  Tools.m
//  MeMPlayer
//
//  Created by mellow on 16/1/21.
//  Copyright © 2016年 mellow. All rights reserved.
//

#import "Tools.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation Tools

+ (Tools *)sharedManager
{
    static Tools *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

-(BOOL)isLandscapeScreen
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"MeM_LandscapeScreen"]) {
        return YES;
    }
    return NO;
}

-(BOOL)isOpenVolume
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"MeM_Volume"]) {
        return YES;
    }
    return NO;
}

-(BOOL)isOpenScreenbrightness
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"MeM_Screenbrightness"]) {
        return YES;
    }
    return NO;
}

-(NumKeyBoardVerification )isOpenNumKeyboard
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"mem_password"]&&[[[NSUserDefaults standardUserDefaults]objectForKey:@"MeM_NumKeyboard"] isEqualToString:@"yes"]) {
        
        return NumKeyBoardOpenVerification;
    }else if([[NSUserDefaults standardUserDefaults] objectForKey:@"mem_password"]&&[[[NSUserDefaults standardUserDefaults]objectForKey:@"MeM_NumKeyboard"] isEqualToString:@"no"])
    {
        return NumKeyBoardNotOpenVerification;
    }
    return NumKeyBoardNotSet;
}

-(BOOL)isOpenTouchID
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"MeM_TouchID"]) {
        return YES;
    }
    return NO;
}

-(BOOL)isOpenPlayerCircle
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"MeM_PlayerCircle"]) {
        return YES;
    }
    return NO;}

-(void)openPlayerLandscape:(BOOL)isTrue
{
    if (isTrue) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"MeM_LandscapeScreen"];

    }else{
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"MeM_LandscapeScreen"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)openVolume:(BOOL)isTrue
{
    if (isTrue) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"MeM_Volume"];
        
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"MeM_Volume"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)openScreenbrightness:(BOOL)isTrue
{
    if (isTrue) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"MeM_Screenbrightness"];
        
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"MeM_Screenbrightness"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)openNumKeyboard:(BOOL)isTrue
{
    if (isTrue) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"MeM_NumKeyboard"];
        
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"MeM_NumKeyboard"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)openTouchID:(BOOL)isTrue
{
    if (isTrue) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"MeM_TouchID"];
        
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"MeM_TouchID"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)openPlayerCircle:(BOOL)isTrue{
    if (isTrue) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"MeM_PlayerCircle"];
        
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"MeM_PlayerCircle"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)isSupportTouchID
{
    LAContext* context = [[LAContext alloc] init];
    NSError* error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        return YES;
    }else
    {

        
        return NO;
    }
}
- (void)authenticateUser:(executeFinishedBlock )block
{
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError* error = nil;
    NSString* result = @"Authentication is needed to access your notes.";
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            
            if (success) {
                //验证成功，主线程处理UI
                block(success);
            }
            else
            {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"Authentication was cancelled by the system");
                        //切换到其他APP，系统取消验证Touch ID
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"Authentication was cancelled by the user");
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        NSLog(@"User selected to enter custom password");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                        }];
                        break;
                    }
                    default:
                    {
                        
                        block(success);

//                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                            //其他情况，切换主线程处理
//                            
//                            
//                        }];
                        break;
                    }
                }
            }
        }];
    }
    else
    {
        //不支持指纹识别，LOG出错误详情
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
    }
}




-(void)triggerStorage:(NSString *)urlString
{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"history.plist"];
    NSFileManager* fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:filename]==NO) {
        
        
       BOOL isSuccess=  [fm createFileAtPath:filename contents:nil attributes:nil];
        if (isSuccess) {
        }
    }
    NSMutableArray *array=[NSMutableArray arrayWithContentsOfFile:filename];
    if (!array) {
        
        array=[[NSMutableArray alloc] init];
    }
    [array addObject:urlString];


   BOOL isSuccess =[array writeToFile:filename atomically:YES];
    if (!isSuccess) {
        NSLog(@"error");
    }
    
    //NSArray *array1=[NSArray arrayWithContentsOfFile:filename];

}


-(NSArray *)getHistoryFromtriggerStorage
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"history.plist"];
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filename]) {
        [fm createFileAtPath:filename contents:nil attributes:nil];

    }

    NSArray *array=[NSArray arrayWithContentsOfFile:filename];
    return array;
}

-(void )deleteHistoryFromtriggerStorage
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"history.plist"];
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filename]) {
        [fm removeItemAtPath:filename error:nil];
    }
 }

-(void)deleteVideoWithFilePath:(NSString *)filePath
{
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        [fm removeItemAtPath:filePath error:nil];
    }
    
}
@end

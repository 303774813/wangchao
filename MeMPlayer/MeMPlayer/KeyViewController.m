//
//  KeyViewController.m
//  MeMPlayer
//
//  Created by mellow on 16/1/20.
//  Copyright © 2016年 mellow. All rights reserved.
//

#import "KeyViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#define KEYBOARD_PASSWARD_VERIFY @"KEYBOARD_PASSWARD_VERIFY"
#import <LocalAuthentication/LocalAuthentication.h>

@interface KeyViewController ()
{
    SystemSoundID sound;//系统声音的id 取值范围为：1000-2000
   // NSString *firstPwd;
   // NSString *secondPwd;
}
@property (nonatomic) NSMutableString *numString;
@property (nonatomic,copy)NSString *firstPwd;
@end

@implementation KeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.passOne.layer.cornerRadius=10;
    self.passOne.hidden=YES;
    self.passTwo.layer.cornerRadius=10;
    self.passTwo.hidden=YES;
    self.passThree.layer.cornerRadius=10;
    self.passThree.hidden=YES;
    self.passfour.layer.cornerRadius=10;
    self.passfour.hidden=YES;
    self.numString=[[NSMutableString alloc] initWithCapacity:4];
    self.firstPwd=@"";
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bkip5"]];
    
    [self initSystemSound];
    if (!_isFirst) {
        self.msgLable.text=@"";
        if ([[Tools sharedManager] isOpenTouchID]) {
            [self authenticateUser:^(BOOL issuccess) {
                
                if (issuccess) {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:KEYBOARD_PASSWARD_VERIFY object:nil];
                }


            }];
        }
    }else{
        self.msgLable.text=@"设置新密码";

    }
    self.msgLable.textColor=[UIColor greenColor];

    // Do any additional setup after loading the view.
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

- (void)initSystemSound
{
        NSURL *path =[[NSBundle mainBundle] URLForResource: @"Tock" withExtension: @"wav"];
        if (path) {
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(path),&sound);
            
            if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
              //  sound = nil;
            }
        }
}

- (void)play
{
    AudioServicesPlaySystemSound(sound);
    
    
}
- (IBAction)numPress:(UIButton *)sender {

    [self play];
    int  legnth=[self.numString length];

    int  num=sender.tag-100;
    
    if (legnth>=4&&num<10) {
        return;
    }

    if (num>=10) {
        if (legnth==0) {
            return;
        }
        
        NSRange rang=NSMakeRange(legnth-1, 1);
        [self.numString deleteCharactersInRange:rang];
        switch (legnth) {
            case 1:
                [self.passOne setHidden:YES];
                
                break;
            case 2:
                [self.passTwo setHidden:YES];
                
                break;
            case 3:
                YES;
                [self.passThree setHidden:YES];

                break;
            case 4:
                [self.passfour setHidden:YES];
                
                break;
                
            default:
                break;
        }
    }else
    {
        [self.numString appendString:[NSString stringWithFormat:@"%d",num]];
        switch (legnth) {
            case 0:
                [self.passOne setHidden:NO];

                break;
            case 1:
                [self.passTwo setHidden:NO];

                break;
            case 2:
                [self.passThree setHidden:NO];

                break;
            case 3:
                [self.passfour setHidden:NO];
                [self performSelector:@selector(verificationFromKeyChain) withObject:self afterDelay:0.5];
              //  [self verificationFromKeyChain];
                break;
                
            default:
                break;
        }
        
        
    }
    
    
}
-(void)verificationFinish:(executeFinishedBlock)block
{
    
}

-(void)verificationFromKeyChain
{
    NSLog(@"%@   %@",self.firstPwd ,self.numString);
    
    if (_isFirst) {
        if ([self.firstPwd isEqualToString:@""]) {
            self.firstPwd=self.numString;
            [self.numString setString:@""];
            [self.passOne setHidden:YES];
            [self.passTwo setHidden:YES];
            [self.passThree setHidden:YES];
            [self.passfour setHidden:YES];
            
            self.msgLable.text=@"请输入确认密码";
            self.msgLable.alpha=1.0;
            self.msgLable.textColor=[UIColor greenColor];
        }else{
            
            if ([self.firstPwd isEqualToString:self.numString]) {
                [[NSUserDefaults standardUserDefaults] setObject:self.firstPwd forKey:@"mem_password"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.numString setString:@""];
                self.firstPwd=@"";

                [self.passOne setHidden:YES];
                [self.passTwo setHidden:YES];
                [self.passThree setHidden:YES];
                [self.passfour setHidden:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:KEYBOARD_PASSWARD_VERIFY object:nil];
//                [self dismissViewControllerAnimated:YES completion:^{
//                    ;
//                }];
            }else
            {
                [self.numString setString:@""];
                [self.passOne setHidden:YES];
                [self.passTwo setHidden:YES];
                [self.passThree setHidden:YES];
                [self.passfour setHidden:YES];
                self.firstPwd=@"";
                
                self.msgLable.text=@"两次密码输入不一致，请重新设置新密码";
                self.msgLable.alpha=1.0;
                self.msgLable.textColor=[UIColor redColor];

            }
        }
      
    }else
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"mem_password"]&&[self.numString isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"mem_password"]]) {
            //成功操作
            [self.numString setString:@""];
            
            [self.passOne setHidden:YES];
            [self.passTwo setHidden:YES];
            [self.passThree setHidden:YES];
            [self.passfour setHidden:YES];
            self.firstPwd=@"";

            [[NSNotificationCenter defaultCenter] postNotificationName:KEYBOARD_PASSWARD_VERIFY object:nil];
            
        }else{
            self.msgLable.text=@"密码输入错误";
            self.msgLable.textColor=[UIColor redColor];
        }
        
 
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



- (IBAction)deleteNum:(UIButton *)sender {
}
@end

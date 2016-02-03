//
//  KeyViewController.h
//  MeMPlayer
//
//  Created by mellow on 16/1/20.
//  Copyright © 2016年 mellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"
@interface KeyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *passOne;
@property (weak, nonatomic) IBOutlet UIView *passTwo;
@property (weak, nonatomic) IBOutlet UIView *passThree;
@property (weak, nonatomic) IBOutlet UIView *passfour;
@property (weak, nonatomic) IBOutlet UILabel *msgLable;
@property (assign,nonatomic)BOOL isFirst;
- (IBAction)numPress:(UIButton *)sender;
- (IBAction)deleteNum:(UIButton *)sender;
-(void)verificationFinish:(executeFinishedBlock)block;
@end

//
//  SetViewController.m
//  MeMPlayer
//
//  Created by mellow on 16/1/20.
//  Copyright © 2016年 mellow. All rights reserved.
//

#import "SetViewController.h"
#import "SetTableViewCell.h"
#import "Tools.h"
#import "KeyViewController.h"
#import "JCAlertView.h"

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    BOOL isClose;
    BOOL isClearPass;
    KeyViewController *keyVC;
}
@property (nonatomic,copy)NSArray *titles1;
@property (nonatomic,copy)NSArray *titles2;
@property (nonatomic,copy)NSArray *titles3;
@end

@implementation SetViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isClearPass=NO;
    isClose=NO;
    self.title=@"设置";
[self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.navigationController.navigationBarHidden=NO;
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"default1"]];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bkip5"]];

    self.titles1=@[@"默认横屏模式"];
    self.titles2=@[@"使用键盘解锁",@"清除密码"];
    self.titles3=@[@"手势左侧上下滑动调节音量",@"手势右侧上下滑动调节亮度"];
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [button setBackgroundImage:[UIImage imageNamed:@"back_Main"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    self.tableview.backgroundColor=[UIColor clearColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verifySuccess ) name:@"KEYBOARD_PASSWARD_VERIFY" object:nil];

    // Do any additional setup after loading the view.
}

-(void)verifySuccess{

    [keyVC dismissViewControllerAnimated:YES completion:^{
        if (isClearPass) {
            isClearPass=NO;
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"mem_password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [JCAlertView showOneButtonWithTitle:@"Message" Message:@"清除密码成功" ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:@"确定" Click:^{
                [self.tableview reloadData];
            }];
        }else{
            if (isClose) {
                [[Tools sharedManager] openNumKeyboard:NO];
                [self.tableview reloadData];

            }
        }

    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomCellIdentifier = @"SetTableViewCell";

    SetTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier forIndexPath:indexPath];
    cell.switchV.on=NO;
    cell.switchV.hidden =NO;

    switch (indexPath.section) {
        case 0:
            cell.s_title.text=[self.titles1 objectAtIndex:indexPath.row];
            
            if (indexPath.row==0) {
                cell.switchV.on=[[Tools sharedManager] isLandscapeScreen];
            }
            break;
        case 1:
            cell.s_title.text=[self.titles2 objectAtIndex:indexPath.row];
            if (indexPath.row==0) {
                if ([[Tools sharedManager] isOpenNumKeyboard]==NumKeyBoardOpenVerification) {
                    cell.switchV.on=YES;
                }
            }else if(indexPath.row==1) {
                cell.switchV.hidden =YES;
            }
            break;
        case 2:
            cell.s_title.text=[self.titles3 objectAtIndex:indexPath.row];
            if (indexPath.row==0) {
                cell.switchV.on=[[Tools sharedManager] isOpenVolume];
            }else{
                cell.switchV.on=[[Tools sharedManager] isOpenScreenbrightness];
            }
            break;

        default:
            break;
    }
    [cell.switchV addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    return cell;
}
-(void)returnAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - switch value changed
-(void)switchValueChanged:(UISwitch *)sw
{
    NSLog(@"dwajkwfaljfk");
         SetTableViewCell *cell=(SetTableViewCell *)[[[sw superview] superview]superview];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        cell=(SetTableViewCell *)[[sw superview] superview];

    }

    NSIndexPath *index=[self.tableview indexPathForCell:cell];
    
    if (index.row==0&&index.section==0) {
        [[Tools sharedManager] openPlayerLandscape:sw.on];
    }else if(index.row==1&&index.section==0)
    {
        [[Tools sharedManager] openPlayerCircle:sw.on];
    }else if(index.row==0&&index.section==1)
    {

        NSLog(@"%ld",(long)[[Tools sharedManager]isOpenNumKeyboard]);
        
        if ([[Tools sharedManager] isOpenNumKeyboard]==NumKeyBoardNotOpenVerification) {
            
            [[Tools sharedManager] openNumKeyboard:sw.on];

        }else if ([[Tools sharedManager] isOpenNumKeyboard]==NumKeyBoardNotSet)
        {
            [[Tools sharedManager] openNumKeyboard:sw.on];
            keyVC=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"KeyViewController" ];
            keyVC.isFirst=YES;
            
            [self presentViewController:keyVC animated:YES completion:^{
                ;
            }];
        }else
        {
            if (sw.on==NO) {
                keyVC=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"KeyViewController" ];
                keyVC.isFirst=NO;
                isClose=YES;
                [self presentViewController:keyVC animated:YES completion:^{
                    ;
                }];
            }
        }

        
    }else if (index.row==1&&index.section==1)
    {
        [[Tools sharedManager] openTouchID:sw.on];
    }else if (index.row==0&&index.section==2)
    {
        [[Tools sharedManager] openVolume:sw.on];
    }else if (index.row==1&&index.section==2)
    {
        [[Tools sharedManager] openScreenbrightness:sw.on];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section==0) {
        return 1;
    }
    return 2;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==1&&indexPath.row==1) {
        if ([[Tools sharedManager] isOpenNumKeyboard]==NumKeyBoardNotSet) {
            [JCAlertView showOneButtonWithTitle:@"Message" Message:@"未设置密码" ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:@"确定" Click:^{
                ;
            }];
        }else
        {

            
            isClearPass=YES;
            keyVC=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"KeyViewController" ];;
            keyVC.isFirst=NO;
            [self presentViewController:keyVC animated:YES completion:^{
                ;
            }];
        }
    }


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

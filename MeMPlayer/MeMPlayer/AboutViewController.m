//
//  AboutViewController.m
//  MeMPlayer
//
//  Created by mellow on 16/1/20.
//  Copyright © 2016年 mellow. All rights reserved.
//

#import "AboutViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutViewController ()<MFMailComposeViewControllerDelegate,UIAlertViewDelegate>

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.navigationController.navigationBarHidden=NO;
    self.title=@"关于";
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bkip5"]];
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [button setBackgroundImage:[UIImage imageNamed:@"back_Main"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:button];

    UIButton *button1=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button1 setTitle:@"联系" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(connectionWithEmai) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:button1];

    self.labelabout.text=@"  本软件使用开源框架开发支持多种视频格式，并收录了幼儿折纸视频教程，为大家提供学习，并且将代码已经开源。";
    // Do any additional setup after loading the view.
}
-(void)returnAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
- (IBAction)gotoAppStoreGrade:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1076103498" ];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
        str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1076103498"];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark - 在应用内发送邮件
//激活邮件功能
- (void)connectionWithEmai
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        //[self alertWithMessage:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替"];
        return;
    }
    if (![mailClass canSendMail]) {
        // [self alertWithMessage:@"用户没有设置邮件账户"];
        return;
    }
    [self displayMailPicker];
}

//调出邮件发送窗口
- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"问题反馈"];
    
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"itnovel@163.com"];
    [mailPicker setToRecipients: toRecipients];
    //添加抄送
    //  NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    // [mailPicker setCcRecipients:ccRecipients];
    //添加密送
    // NSArray *bccRecipients = [NSArray arrayWithObjects:@"fourth@example.com", nil];
    // [mailPicker setBccRecipients:bccRecipients];
    
    // 添加一张图片
//    UIImage *addPic = [UIImage imageNamed: @"iTunesArtwork"];
//    NSData *imageData = UIImagePNGRepresentation(addPic);            // png
//    // 关于mimeType：http://www.iana.org/assignments/media-types/index.html
//    [mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"Icon.png"];
    //添加一个pdf附件
    //  NSString *file = [self fullBundlePathFromRelativePath:@"高质量C++编程指南.pdf"];
    //  NSData *pdf = [NSData dataWithContentsOfFile:file];
    //    [mailPicker addAttachmentData: pdf mimeType: @"" fileName: @"高质量C++编程指南.pdf"];
    NSString *emailBody = @"<font color='red'>建议或需求</font> @me";
    [mailPicker setMessageBody:emailBody isHTML:YES];
    [self presentViewController:mailPicker animated:YES completion:^{
        ;
    }];
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"用户点击发送，将邮件放到队列中，还没发送";
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
}

@end

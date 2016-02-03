//
//  StreamViewController.m
//  MeMPlayer
//
//  Created by mellow on 16/1/22.
//  Copyright © 2016年 mellow. All rights reserved.
//

#import "StreamViewController.h"
#import "KxMovieViewController.h"
#import "SPPlayerViewController.h"
#import "Tools.h"
@interface StreamViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy)NSArray *dataArray;
@end

@implementation StreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [button setBackgroundImage:[UIImage imageNamed:@"back_Main"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    self.title=@"视频串流";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"Defaut3x1"]];
    self.serverTextField.keyboardType=UIKeyboardTypeURL;
    self.serverTextField.returnKeyType=UIReturnKeyGo;
    self.serverTextField.delegate=self;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    self.dataArray=  [[Tools sharedManager] getHistoryFromtriggerStorage];
}

-(void)tapAction:(UITapGestureRecognizer *)ges{
    if (ges.numberOfTouches==1) {
        [self.serverTextField resignFirstResponder];
    }
}
-(void)returnAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (BOOL)isIncludeSpace
{
    NSString *   regex = @"^[^\\s]+$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self.serverTextField.text];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.mesTF.text=@"支持HTTP、RTSP、FTP、UDP/RTP";
    self.mesTF.textColor=[UIColor blackColor];

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    
    if (![self isIncludeSpace]) {
        self.mesTF.text=@"地址格式错误";
        self.mesTF.textColor=[UIColor redColor];
        [textField resignFirstResponder];
        return NO;
    }

    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    [[Tools sharedManager] triggerStorage:self.serverTextField.text];
    [self playVideo];
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)playVideo
{
    
    NSString *path=self.serverTextField.text;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //        if (indexPath.section == 0) {
    //
    //            if (indexPath.row >= _remoteMovies.count) return;
    //            path = _remoteMovies[indexPath.row];
    //
    //        } else {
    //
    //            if (indexPath.row >= _localMovies.count) return;
    //            path = _localMovies[indexPath.row];
    //        }
    //
    //        // increase buffering for .wmv, it solves problem with delaying audio frames
    if ([path.pathExtension isEqualToString:@"wmv"])
        parameters[KxMovieParameterMinBufferedDuration] = @(5.0);
    
    // disable deinterlacing for iPhone, because it's complex operation can cause stuttering
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
    parameters[KxMovieParameterMinBufferedDuration] = @(0.0f);
    parameters[KxMovieParameterMaxBufferedDuration] = @(0.0f);
    KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:path
                                                                               parameters:parameters];
    

    [self presentViewController:vc animated:YES completion:nil];
    

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier=@"streamcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        cell.textLabel.textColor=[UIColor whiteColor];
    }
    cell.textLabel.text=[self.dataArray objectAtIndex:indexPath.row] ;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (IBAction)clearHisrtoryList:(UIButton *)sender {
    
    
    [[Tools sharedManager] deleteHistoryFromtriggerStorage];
    self.dataArray=nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];

        ;
    });
    
}
@end

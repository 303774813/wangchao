//
//  LocTableViewController.m
//  MeMPlayer
//
//  Created by mellow on 16/1/22.
//  Copyright © 2016年 mellow. All rights reserved.
//

#import "LocTableViewController.h"
#import "LocationTableViewCell.h"
#import "JCAlertView.h"
#import "KxMovieViewController.h"
#import "AppDelegate.h"
#import "SPPlayerViewController.h"
#import "mpViewController.h"
#import "Tools.h"
#import "KeyViewController.h"
@interface LocTableViewController ()
{
    BOOL isPresent;
    BOOL Editting;
    KeyViewController *keyVC;
}
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *fileArray;

@end

@implementation LocTableViewController
-(void)dealloc
{
    _dataArray=nil;
    self.tableView.delegate=nil;
    self.tableView.dataSource=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"本地文件";
    isPresent=NO;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [button setBackgroundImage:[UIImage imageNamed:@"back_Main"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)];
    rightItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=rightItem;
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"default1"]];
    [self performSelector:@selector(refreshData) withObject:self afterDelay:0.1];
    self.fileArray=[[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard) name:UIApplicationDidEnterBackgroundNotification object:nil];
    

    if ([[Tools sharedManager] isOpenNumKeyboard]==NumKeyBoardOpenVerification) {
             [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verifySuccess ) name:@"KEYBOARD_PASSWARD_VERIFY" object:nil];

        keyVC=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"KeyViewController" ];
        keyVC.isFirst=NO;
        [self presentViewController:keyVC animated:YES completion:^{
            isPresent=YES;
        }];
    }
    
    
}

-(void)verifySuccess{
    [keyVC dismissViewControllerAnimated:YES completion:nil];
    isPresent=NO;

}
-(void)showKeyBoard
{
    NSLog(@"dafaffa");
   if ([[Tools sharedManager] isOpenNumKeyboard]!=NumKeyBoardOpenVerification)
       return;
       
    if (!isPresent) {
        
        keyVC.isFirst=NO;

        [self presentViewController:keyVC animated:YES completion:^{
            isPresent=YES;

        }];
    }
    
    

}
-(void)refreshData
{
    self.dataArray=[self SeachAttachFileInDocumentDirctory];
    
   // dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView transitionWithView:self.tableView
                          duration: 0.35f
                           options: UIViewAnimationOptionTransitionCrossDissolve
                        animations: ^(void)
         {
             [self.tableView reloadData];
         }
                        completion: ^(BOOL isFinished)
         {
             
         }];
        
}


- (NSMutableArray *)SeachAttachFileInDocumentDirctory{
    
    NSMutableArray *fileList=[[NSMutableArray alloc] init];
    NSString *appDocDir = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] relativePath];
    
    NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appDocDir error:NULL];
    for (NSString *aPath in contentOfFolder) {
        NSString * fullPath = [appDocDir stringByAppendingPathComponent:aPath];
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir)
        {
            [fileList addObject:aPath];
            [self.fileArray addObject:fullPath];
        }
    }
    return fileList ;
    
}
-(void)returnAction
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)editAction:(UIBarButtonItem *)item
{
    if ([item.title isEqualToString:@"编辑"]) {
        Editting=YES;
        item.title=@"取消";
    }else{
        Editting=NO;

        item.title=@"编辑";

    }
    [UIView transitionWithView:self.tableView
                      duration: 0.35f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void)
     {
         [self.tableView reloadData];
     }
                    completion: ^(BOOL isFinished)
     {  
         
     }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationTableViewCell" forIndexPath:indexPath];
    cell.L_title.text=[self.dataArray objectAtIndex:indexPath.row] ;
    [cell.file_cell_bkimg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"seg_button%d",arc4random()%4+1]]];
    
    if (Editting) {
        [cell.playImg setBackgroundImage:[UIImage imageNamed:@"play_delete"] forState:UIControlStateNormal];
    }else
    {
        [cell.playImg setBackgroundImage:[UIImage imageNamed:@"video_button_play"] forState:UIControlStateNormal];
    }
    [cell.playImg addTarget:self action:@selector(deleteVideoFromList:) forControlEvents:UIControlEventTouchUpInside];
    cell.contentView.layer.shadowColor=[UIColor groupTableViewBackgroundColor].CGColor;
    cell.contentView.layer.shadowOffset=CGSizeMake(3, 0);
    
    return cell;
}

-(void)deleteVideoFromList:(UIButton *)button
{
    LocationTableViewCell *cell;
    NSIndexPath *pathIndex;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
        cell=(LocationTableViewCell *)[[[button superview] superview] superview];
        pathIndex=[self.tableView indexPathForCell:cell];
    }else
    {
        cell=(LocationTableViewCell *)[[button superview] superview];
        pathIndex=[self.tableView indexPathForCell:cell];

    }

    //[self.dataArray objectAtIndex:path.row];
    
    if (Editting) {
        [JCAlertView showTwoButtonsWithTitle:@"提示" Message: [NSString stringWithFormat:@"确认删除文件:%@",[self.dataArray objectAtIndex:pathIndex.row]]
                                  ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:@"取消" Click:^{
                                  } ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"确认" Click:^{
                                      [[Tools sharedManager] deleteVideoWithFilePath:[self.fileArray objectAtIndex:pathIndex.row]];
                                      [self.dataArray removeObjectAtIndex:pathIndex.row];

                                      [self.tableView deleteRowsAtIndexPaths:@[pathIndex] withRowAnimation:UITableViewRowAnimationLeft];
                                  }];
    }else{
        
//        mpViewController *view=[[mpViewController alloc] init];
        
//        [self presentViewController:view animated:YES completion:^{
        
//        }];
       NSString *path=[self.fileArray objectAtIndex:pathIndex.row];
        
        
        
        NSLog(@"%d   %@",pathIndex.row,path);
//        
//        SPPlayerViewController *play=[[SPPlayerViewController alloc] init];
//
//        play.urlStr=path;  //@"http://baobab.cdn.wandoujia.com/14468618701471.mp4";
//        [play.videoController setContentURL:[NSURL URLWithString:path]];
//        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:play];
//        //  [self.navigationController pushViewController:play animated:YES];
//        [self presentViewController:nav animated:YES completion:^{
//            
//        }];
        
        
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
        
     //    disable buffering
        parameters[KxMovieParameterMinBufferedDuration] = @(0.0f);
        parameters[KxMovieParameterMaxBufferedDuration] = @(0.0f);
        KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:path
                                                                                   parameters:parameters];
        
        
//        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//            
//            [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
//             
//                                           withObject:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight]];
//            
//        }
      //  [self begainFullScreen];
      //  [self changedevice];
        [self presentViewController:vc animated:YES completion:nil];
    
        //[self.navigationController pushViewController:vc animated:YES];    

    }
}
- (void)changedevice
{
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView animateWithDuration:duration animations:^{
        // 修改状态栏的方向及view的方向进而强制旋转屏幕
        [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeRight ];
             //   self.navigationController.view.transform = _bottomView.landscapeModel ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformIdentity;
          self.navigationController.view.bounds = CGRectMake(self.navigationController.view.bounds.origin.x, self.navigationController.view.bounds.origin.y, self.view.frame.size.height, self.view.frame.size.width);
    }];
}

@end

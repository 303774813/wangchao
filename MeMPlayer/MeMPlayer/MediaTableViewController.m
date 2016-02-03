


//
//  MediaTableViewController.m
//  MeMPlayer
//
//  Created by mellow on 16/1/22.
//  Copyright © 2016年 mellow. All rights reserved.
//

#import "MediaTableViewController.h"
#import "MediaTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "LCLoadingHUD.h"
#import "ImageContentView.h"
#import "JCAlertView.h"
#import "SPPlayerViewController.h"
@interface MediaTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy)NSArray *dataArr;
@end

@implementation MediaTableViewController
-(void)dealloc
{
    _dataArr=nil;
    self.tableView.delegate=nil;
    self.tableView.dataSource=nil;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [button setBackgroundImage:[UIImage imageNamed:@"back_Main"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
    self.title=@"媒体库";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:button];

    self.view.backgroundColor=[UIColor greenColor];
    self.navigationController.navigationBarHidden=NO;
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"Defaut3x1"]];
    //[LCLoadingHUD showLoading:@"努力加载中..." inView:self.view];
    [LCLoadingHUD showLoading:@"努力加载中..."];
    [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(dismissKeyHUD) userInfo:nil repeats:NO];
    NSURL *URL = [NSURL URLWithString:@"https://api.bmob.cn/1/classes/PlayList"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [mutableRequest addValue:@"0ee0eb67154325f87f4265819a0b90e5" forHTTPHeaderField:@"X-Bmob-REST-API-Key"];
    [mutableRequest addValue:@"08cd68cc5df33c254063b510cfff3a15" forHTTPHeaderField:@"X-Bmob-Application-Id"];
    

    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:mutableRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self dismissKeyHUD];
                                          if (error||data==nil) {
                                              NSLog(@"error");
                                              self.dataArr=nil;
                                            [JCAlertView showOneButtonWithTitle:@"Message" Message:@"出错了!" ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:@"确定" Click:^{
                                                  ;
                                              }];
                                          }else
                                          {
                                              NSDictionary *dic=  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

                                              
                                              self.dataArr=[dic objectForKey:@"results"];
                                              
                                                  [self.tableView reloadData];
                                              
                                              NSLog(@"%@",self.dataArr);
                                          }
                                      });
                                      
                                  }];
    [task resume];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)dismissKeyHUD {
    
    [LCLoadingHUD hideInKeyWindow];
}
-(void)returnAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArr count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *MediaCellIdentifier = @"MediaTableViewCell";

    MediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MediaCellIdentifier forIndexPath:indexPath];
    cell.videoTitle.text=[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"title"];
    
     [ cell.videoBk setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://file.bmob.cn/%@",[[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"image"] objectForKey:@"url" ] ]]];
    
    return cell;
}
//添加每个cell出现时的3D动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(MediaTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
        CATransform3D rotation;//3D旋转
        
        rotation = CATransform3DMakeTranslation(0 ,50 ,20);
        //        rotation = CATransform3DMakeRotation( M_PI_4 , 0.0, 0.7, 0.4);
        //逆时针旋转
        
        rotation = CATransform3DScale(rotation, 0.9, .9, 1);
        
        rotation.m34 = 1.0/ -600;
        
        cell.layer.shadowColor = [[UIColor blackColor]CGColor];
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        
        cell.layer.transform = rotation;
        
        [UIView beginAnimations:@"rotation" context:NULL];
        //旋转时间
        [UIView setAnimationDuration:0.6];
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        [UIView commitAnimations];
    
    [cell cellOffset];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    
        NSArray<MediaTableViewCell *> *array = [self.tableView visibleCells];
        
        [array enumerateObjectsUsingBlock:^(MediaTableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            [obj cellOffset];
        }];
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPPlayerViewController *spVideo=[[SPPlayerViewController alloc] init];
    spVideo.titleV=[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"title"];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:spVideo];
    spVideo.urlStr=[[self.dataArr objectAtIndex:indexPath.row]objectForKey:@"nUrl"];
    [self presentViewController:nav animated:YES completion:^{
        ;
    }];
}




@end

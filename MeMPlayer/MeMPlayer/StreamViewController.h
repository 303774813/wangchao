//
//  StreamViewController.h
//  MeMPlayer
//
//  Created by mellow on 16/1/22.
//  Copyright © 2016年 mellow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreamViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *serverTextField;
@property (weak, nonatomic) IBOutlet UILabel *mesTF;
- (IBAction)clearHisrtoryList:(UIButton *)sender;
@end

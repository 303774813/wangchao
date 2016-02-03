//
//  SetTableViewCell.h
//  MeMPlayer
//
//  Created by mellow on 16/1/21.
//  Copyright © 2016年 mellow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *s_title;
- (IBAction)switchaValueChange:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UISwitch *switchV;

@end

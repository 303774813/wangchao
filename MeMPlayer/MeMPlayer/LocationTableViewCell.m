//
//  LocationTableViewCell.m
//  MeMPlayer
//
//  Created by mellow on 16/1/22.
//  Copyright © 2016年 mellow. All rights reserved.
//
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#import "LocationTableViewCell.h"

@implementation LocationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (CGFloat)cellOffset {
    CGRect centerToWindow = [self convertRect:self.bounds toView:self.window];
    CGFloat centerY = CGRectGetMidY(centerToWindow);
    CGPoint windowCenter = self.superview.center;
    CGFloat cellOffsetY = centerY - windowCenter.y;
    CGFloat offsetDig =  cellOffsetY / self.superview.frame.size.height *2;
    CGFloat offset =  -offsetDig * (kHeight/1.7 - 250)/2;
    CGAffineTransform transY = CGAffineTransformMakeTranslation(0,offset);
        self.file_cell_bkimg.transform = transY;
    return offset;
}
@end

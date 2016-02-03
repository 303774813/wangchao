//
//  MediaTableViewCell.m
//  MeMPlayer
//
//  Created by mellow on 16/1/22.
//  Copyright © 2016年 mellow. All rights reserved.
//
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#import "MediaTableViewCell.h"

@implementation MediaTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        self.clipsToBounds = YES;
        
        _picture = [[UIImageView alloc]initWithFrame:CGRectMake(0, -(kHeight/1.7 -250)/2, kWidth, kHeight/1.7)];
        
        _picture.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView  addSubview:_picture];
        
        _coverview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 250)];
        _coverview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.33];
        [self.contentView addSubview:_coverview];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 250 / 2 - 30, kWidth, 30)];
        
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_titleLabel];
        
        _littleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 250 / 2 + 30, kWidth, 30)];
        
        _littleLabel.font = [UIFont systemFontOfSize:14];
        
        _littleLabel.textAlignment = NSTextAlignmentCenter;
        
        _littleLabel.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_littleLabel];
        
        
        
    }
    return self;
 
    
    
}

- (CGFloat)cellOffset {
    
    CGRect centerToWindow = [self convertRect:self.bounds toView:self.window];
    CGFloat centerY = CGRectGetMidY(centerToWindow);
    CGPoint windowCenter = self.superview.center;
    
    CGFloat cellOffsetY = centerY - windowCenter.y;
    
    CGFloat offsetDig =  cellOffsetY / self.superview.frame.size.height *2;
    CGFloat offset =  -offsetDig * (kHeight/1.7 - 250)/2;
    
    CGAffineTransform transY = CGAffineTransformMakeTranslation(0,offset);
    
    //    self.titleLabel.transform = transY;
    //    self.littleLabel.transform = transY;
    
    self.videoBk.transform = transY;
    
    return offset;
}
- (CGFloat)cellOffnewset {
    
    CGRect centerToWindow = [self convertRect:self.bounds toView:self.window];
    CGFloat centerY = CGRectGetMidY(centerToWindow);
    CGPoint windowCenter = self.superview.center;
    
    CGFloat cellOffsetY = centerY - windowCenter.y;
    
    CGFloat offsetDig =  cellOffsetY / self.superview.frame.size.height *2;
    CGFloat offset =  -offsetDig * (kHeight/1.7 - 250)/2;
    
    CGAffineTransform transY = CGAffineTransformMakeTranslation(0,offset);
    

    self.videoBk.transform = transY;
    
    return offset;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

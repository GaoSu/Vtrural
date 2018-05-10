//
//  VLX_zuobianlanTableViewCell.m
//  Vlvxing
//
//  Created by grm on 2017/10/10.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_zuobianlanTableViewCell.h"

@implementation VLX_zuobianlanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//点中方法
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.contentView.backgroundColor = rgba(223, 223, 223, 1);
    
}
//高亮
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    self.contentView.backgroundColor = rgba(223, 223, 223, 1);

}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self ui];
    }
    return self;
}
-(void)ui{
    
    _zuobianlanname = [[UILabel alloc] initWithFrame:CGRectMake(5, 47, 62, 14)];
    _zuobianlanname.numberOfLines = 0;
    _zuobianlanname.font = [UIFont systemFontOfSize:14];
    _zuobianlanname.textColor = [UIColor lightGrayColor];
    _zuobianlanname.highlightedTextColor = rgba(234, 105,73, 1);
    [self.contentView addSubview:_zuobianlanname];
    
    _zuobianlanImgVw = [[UIImageView alloc]initWithFrame:CGRectMake(23, 16, 27, 23)];
    
    
    [self.contentView addSubview:_zuobianlanImgVw];
}



@end

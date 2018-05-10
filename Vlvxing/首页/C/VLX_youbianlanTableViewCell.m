//
//  VLX_youbianlanTableViewCell.m
//  Vlvxing
//
//  Created by grm on 2017/10/10.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_youbianlanTableViewCell.h"

@implementation VLX_youbianlanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    // Configure the view for the selected state
    self.contentView.backgroundColor = [UIColor whiteColor];
    
}
//高亮
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
}




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self ui];
    }
    return self;
}

-(void)ui
{
    
    //43.34.260.30 h 134
    //距右230.36,65,30
    //距右76, 36,36,36
    //230 87 35色值
    
    _youbianlanname = [[UILabel alloc] initWithFrame:CGRectMake(21.5, 17, 1600, 16)];
    _youbianlanname.numberOfLines = 0;
//    _youbianlanname.font = [UIFont systemFontOfSize:16];
//    _youbianlanname.highlightedTextColor = rgba(234, 105,73, 1);
    [self.contentView addSubview:_youbianlanname];
    

    
    //button
    _selectBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth -72, 18, 18, 18)];
    [_selectBt setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
    [_selectBt setImage:[UIImage imageNamed:@"选择后"] forState:UIControlStateSelected];
    [_selectBt setTitleEdgeInsets:UIEdgeInsetsMake(0, _selectBt.titleLabel.bounds.size.width, 0, _selectBt.titleLabel.bounds.size.width-20)];
    [_selectBt setImageEdgeInsets:UIEdgeInsetsMake(0, -_selectBt.imageView.bounds.size.width-35, 0, _selectBt.imageView.bounds.size.width+35)];
    
    
    
    
    _selectBt.selected = NO;

    self.contentView.userInteractionEnabled = YES;
    
    [self.contentView addSubview:_selectBt];
    
    
    
    
    
    
    
}






@end

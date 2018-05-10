
//
//  VLX_baoxiaoTableViewCell.m
//  Vlvxing
//
//  Created by grm on 2017/11/16.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_baoxiaoTableViewCell.h"

@implementation VLX_baoxiaoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

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
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self UI];
    }
    return self;
}
-(void)UI
{
    //    * nameLb;//名称
    //    * jiageLb;//价格
    //    * tipsLb;//小提示
    
    _nameLb2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 18, 70, 16)];
    _nameLb2.text = @"收件人";
    _nameLb2.font =[UIFont systemFontOfSize:14];
    
    
    
    _txfds2 = [[UITextField alloc]initWithFrame:CGRectMake(75, 18, 200, 21)];
    
    //圆木垒起的木屋,有一个木窗口,
    
    
    
    [self.contentView addSubview:_nameLb2];
    [self.contentView addSubview:_txfds2];
    
    
}


@end

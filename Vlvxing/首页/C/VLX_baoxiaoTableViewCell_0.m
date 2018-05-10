
//
//  VLX_baoxiaoTableViewCell_0.m
//  Vlvxing
//
//  Created by grm on 2017/11/16.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_baoxiaoTableViewCell_0.h"

@implementation VLX_baoxiaoTableViewCell_0

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
    
    _nameLb3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 18, 70, 16)];
    _nameLb3.text = @"快递费";
    _nameLb3.font =[UIFont systemFontOfSize:14];
    
    
    
    _jiageLb3 = [[UILabel alloc]initWithFrame:CGRectMake(75, 18, 100, 21)];
    _jiageLb3.text = @"¥:20";
    
    //兴安落叶松林,
    
    
    [self.contentView addSubview:_nameLb3];
    [self.contentView addSubview:_jiageLb3];
    
    
}


@end

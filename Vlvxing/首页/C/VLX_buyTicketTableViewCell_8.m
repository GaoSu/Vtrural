//
//  VLX_buyTicketTableViewCell_8.m
//  Vlvxing
//
//  Created by grm on 2017/11/15.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_buyTicketTableViewCell_8.h"

@implementation VLX_buyTicketTableViewCell_8

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
    
    _nameLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 18, 70, 16)];
    _nameLb.text = @"报销";
    _nameLb.font =[UIFont systemFontOfSize:14];
    

    
    _baoxiaoBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth, 18, 21, 21)];
    [_baoxiaoBt addTarget:self action:@selector(PresBtn) forControlEvents:UIControlEventTouchUpInside];
    [_baoxiaoBt setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
    [_baoxiaoBt setImage:[UIImage imageNamed:@"选择后"] forState:UIControlStateSelected];
    [_baoxiaoBt setTitleEdgeInsets:UIEdgeInsetsMake(0, _baoxiaoBt.titleLabel.bounds.size.width, 0, _baoxiaoBt.titleLabel.bounds.size.width-20)];
    [_baoxiaoBt setImageEdgeInsets:UIEdgeInsetsMake(0, -_baoxiaoBt.imageView.bounds.size.width-35, 0, _baoxiaoBt.imageView.bounds.size.width+35)];
    _baoxiaoBt.selected = NO;
    
    _txfds2 = [[UITextField alloc]initWithFrame:CGRectMake(75, 15, ScreenWidth-85, 21)];
//    _txfds2.text SizeToFitWidth = YES;
    _txfds2.adjustsFontSizeToFitWidth = YES;
    
    _jiageLb3 = [[UILabel alloc]initWithFrame:CGRectMake(75, 15, 100, 21)];
    _jiageLb3.text = @"¥20";

    
    
    [self.contentView addSubview:_nameLb];
    [self.contentView addSubview:_baoxiaoBt];
    
    [self.contentView addSubview:_txfds2];
    [self.contentView addSubview:_jiageLb3];
    
}

-(void)PresBtn
{
    if ([self.baoxiaoBt respondsToSelector:@selector(abcd:)]) {
        [self.delegaie abcd:self];
    }
}


@end

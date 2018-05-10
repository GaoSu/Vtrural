//
//  VLX_buyTicketTableViewCell_5.m
//  Vlvxing
//
//  Created by grm on 2017/10/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_buyTicketTableViewCell_5.h"

@implementation VLX_buyTicketTableViewCell_5

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
    
    _nameLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 18, 70, 16)];
    _nameLb.text = @"航意险";
    _nameLb.textColor = rgba(22, 134, 216, 1);
    _nameLb.font =[UIFont systemFontOfSize:14];
    
    
    _jiageLb = [[UILabel alloc]initWithFrame:CGRectMake(111, 12, 170, 17)];
    _jiageLb.text = @"¥50/份";
    _jiageLb.font =[UIFont systemFontOfSize:16];
    
    
    _tipsLb = [[UILabel alloc]initWithFrame:CGRectMake(111, 32, 170, 12)];
    _tipsLb.text = @"保额¥120万,出行更放心";
    _tipsLb.textColor = [UIColor lightGrayColor];
    _tipsLb.font =[UIFont systemFontOfSize:12];

    _selectBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-57, 18, 21, 21)];
    [_selectBt addTarget:self action:@selector(PresBtn) forControlEvents:UIControlEventTouchUpInside];
    [_selectBt setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
    [_selectBt setImage:[UIImage imageNamed:@"选择后"] forState:UIControlStateSelected];
    _selectBt.selected = YES;
    
    
    [self.contentView addSubview:_nameLb];
    [self.contentView addSubview:_jiageLb];
    [self.contentView addSubview:_tipsLb];
    [self.contentView addSubview:_selectBt];
    
    
}

-(void)PresBtn
{
    if ([self.delegaie respondsToSelector:@selector(abc:)]) {
        [self.delegaie abc:self];
    }
}


@end

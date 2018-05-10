//
//  VLX_buyTicketTableViewCell_7.m
//  Vlvxing
//
//  Created by grm on 2017/10/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_buyTicketTableViewCell_7.h"

@implementation VLX_buyTicketTableViewCell_7

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
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifie{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifie];
    if (self) {
        [self UI];
    }return self;
}

-(void)UI
{

    
    UILabel * lineLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5f)];
    lineLb.backgroundColor = [UIColor lightGrayColor];
    
    _zhifubaoImgvw = [[UIImageView alloc]initWithFrame:CGRectMake(27, 16, 24, 24)];
//    _zhifubaoImgvw.image =[ UIImage imageNamed:@"WeChat-pay"];
    
    _zhifubaoLb = [[UILabel alloc]initWithFrame:CGRectMake(71, 19, 70, 17)];
//    _zhifubaoLb.text = @"支付宝";
    
    _selectBt1 = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth, 16, 21, 21)];
    [_selectBt1 setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
    [_selectBt1 setImage:[UIImage imageNamed:@"选择后"] forState:UIControlStateSelected];
    [_selectBt1 setTitleEdgeInsets:UIEdgeInsetsMake(0, _selectBt1.titleLabel.bounds.size.width, 0, _selectBt1.titleLabel.bounds.size.width-20)];
    [_selectBt1 setImageEdgeInsets:UIEdgeInsetsMake(0, -_selectBt1.imageView.bounds.size.width-35, 0, _selectBt1.imageView.bounds.size.width+35)];
    self.contentView.userInteractionEnabled = YES;

    [self.contentView addSubview:lineLb];
    [self.contentView addSubview:_zhifubaoImgvw];
    [self.contentView addSubview:_zhifubaoLb];
    [self.contentView addSubview:_selectBt1];
    
    
}


@end

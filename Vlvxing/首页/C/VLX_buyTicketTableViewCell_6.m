//
//  VLX_buyTicketTableViewCell_6.m
//  Vlvxing
//
//  Created by grm on 2017/10/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_buyTicketTableViewCell_6.h"

@implementation VLX_buyTicketTableViewCell_6

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
    //daijinquanLb;//代金券
    //pushImgvw;//跳转箭头
    
    _daijinquanLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 18, 70, 16)];
    _daijinquanLb.text = @"代金券";
    _daijinquanLb.font =[UIFont systemFontOfSize:14];
    
    _pushImgvw = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-23, 18, 11, 17)];
    _pushImgvw.image = [UIImage imageNamed:@"jump"];
    
    [self.contentView addSubview:_daijinquanLb];
    [self.contentView addSubview:_pushImgvw];
    
}


@end

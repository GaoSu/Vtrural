//
//  VLX_buyTicketTableViewCell_4.m
//  Vlvxing
//
//  Created by grm on 2017/10/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_buyTicketTableViewCell_4.h"

@implementation VLX_buyTicketTableViewCell_4

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self UI];
    }
    return self;
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
-(void)UI
{
    _phoneLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 18, 70, 16)];
    _phoneLb.text = @"电话号码";
    _phoneLb.font =[UIFont systemFontOfSize:14];
    
    _phoneTxfd = [[UITextField alloc]initWithFrame:CGRectMake(111, 18, 170, 17)];
    _phoneTxfd.placeholder = @"用于接收预订信息";
    _phoneTxfd.font =[UIFont systemFontOfSize:15];
    
    [self.contentView addSubview:_phoneLb];
    [self.contentView addSubview:_phoneTxfd];


}

@end

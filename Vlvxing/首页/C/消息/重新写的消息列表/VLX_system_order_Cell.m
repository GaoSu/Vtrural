

//
//  VLX_system_order_Cell.m
//  Vlvxing
//
//  Created by grm on 2017/12/12.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_system_order_Cell.h"

@implementation VLX_system_order_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self UI];
    }
    return self;
}
-(void)UI{

//     topleftlabel;
//     rightlabel;
//     bottomLabel;
    _topleftlabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 12, 100, 17)];
    _topleftlabel.text = @"订单通知";
    _topleftlabel.textColor = [UIColor lightGrayColor];
    _topleftlabel.font = [UIFont systemFontOfSize:17];

    _rightlabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-120, 12, 100, 17)];
    _rightlabel.text = @"2017-11-11";
    _rightlabel.textColor = [UIColor lightGrayColor];
    _rightlabel.font = [UIFont systemFontOfSize:13];

    _bottomLabel =[[UILabel alloc]initWithFrame:CGRectMake(9, 40, ScreenWidth-20, 38)];
    _bottomLabel.text = @"2017-11-11";
    _bottomLabel.numberOfLines = 0;//
    _bottomLabel.textColor = [UIColor lightGrayColor];
    _bottomLabel.font = [UIFont systemFontOfSize:16];

    _orderid = [[UILabel alloc]init];

    [self.contentView addSubview:_topleftlabel];
    [self.contentView addSubview:_rightlabel];
    [self.contentView addSubview:_bottomLabel];
    [self.contentView addSubview:_orderid];
}
-(void)FillWithModel:(VLX_system_Order_Model *)model{

    self.rightlabel.text = model.msgtime;
    self.bottomLabel.text = model.msgcontent;
    self.orderid.text = [NSString stringWithFormat:@"%@",model.orderid];//model.orderid;

}





@end

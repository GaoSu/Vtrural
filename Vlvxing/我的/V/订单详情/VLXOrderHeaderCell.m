//
//  VLXOrderHeaderCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/5.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXOrderHeaderCell.h"
@interface VLXOrderHeaderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *countLab;



@end
@implementation VLXOrderHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _priceLab.textColor=orange_color;
    _countLab.textColor=blue_color;
    _line.backgroundColor=separatorColor1;
    self.contentView.backgroundColor=backgroun_view_color;
}
-(void)createUIWithModel:(VLXOrderDetailDataModel *)model
{
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.orderpic] placeholderImage:smallNoDataImage];
    _nameLab.text=[ZYYCustomTool checkNullWithNSString:model.ordername];
//    _priceLab.text=[NSString stringWithFormat:@"%@",model.orderprice];
    //
    if (model.ordertype.integerValue==1) {//订单类别   1 出行订单 2 用车订单
        //        _midlable.text=[NSString stringWithFormat:@"¥%@",model.orderallprice];
        //可变字体
        NSString *priceStr=[NSString stringWithFormat:@"¥%@",model.orderprice];
        NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:priceStr];
        NSRange range=[priceStr rangeOfString:[NSString stringWithFormat:@"%@",model.orderallprice]];
        [attStr addAttributes:@{NSForegroundColorAttributeName:orange_color, NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, 1)];//¥
        [attStr addAttributes:@{NSForegroundColorAttributeName:orange_color, NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} range:range];//价格
        _priceLab.attributedText=attStr;
        //
    }else if (model.ordertype.integerValue==2)
    {
        //        _midlable.text=[NSString stringWithFormat:@"¥%@/车",model.orderallprice];
        //可变字体
        NSString *priceStr=[NSString stringWithFormat:@"¥%@/车",model.orderprice];
        NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:priceStr];
        NSRange range=[priceStr rangeOfString:@"/车"];
        NSRange moneyRange=NSMakeRange(1, range.location);
        [attStr addAttributes:@{NSForegroundColorAttributeName:orange_color, NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, 1)];//¥
        [attStr addAttributes:@{NSForegroundColorAttributeName:orange_color, NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} range:moneyRange];//价格
        [attStr addAttributes:@{NSForegroundColorAttributeName:orange_color, NSFontAttributeName:[UIFont systemFontOfSize:16]} range:range];//单位
        _priceLab.attributedText=attStr;
        //
    }
    //
    _countLab.text=[NSString stringWithFormat:@"*%@",model.ordercount];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

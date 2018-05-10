//
//  VLXOrderDetailCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/5.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXOrderDetailCell.h"
@interface VLXOrderDetailCell ()
//
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lineArray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titleArray;
@property (weak, nonatomic) IBOutlet UILabel *payTitleLab;

//
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *IDCardLab;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *unPayLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLab;

@end
@implementation VLXOrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //
    for (UIView *line in _lineArray) {
        line.backgroundColor=separatorColor1;
    }
    for (UILabel *titleLab in _titleArray) {
        titleLab.textColor=[UIColor hexStringToColor:@"#313131"];
    }
    _textView.textColor=[UIColor hexStringToColor:@"#666666"];

    _textView.layer.cornerRadius=2;
    _textView.layer.masksToBounds=YES;
    _textView.layer.borderWidth=0.5;
    _textView.layer.borderColor=[UIColor hexStringToColor:@"#999999"].CGColor;
    //
    self.contentView.backgroundColor=backgroun_view_color;
}
-(void)createUIWithModel:(VLXOrderDetailDataModel *)model
{
    _nameLab.text=[ZYYCustomTool checkNullWithNSString:model.orderusername];
    _phoneLab.text=[ZYYCustomTool checkNullWithNSString:model.orderuserphone];
    _addressLab.text=[ZYYCustomTool checkNullWithNSString:model.orderuseraddress];
    _IDCardLab.text=[ZYYCustomTool checkNullWithNSString:model.orderuserid];
    _textView.text=[ZYYCustomTool checkNullWithNSString:model.orderusermessage];
    
    //可变字体
    NSString *priceStr=[NSString stringWithFormat:@"¥%@",model.orderallprice];
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange range=[priceStr rangeOfString:[NSString stringWithFormat:@"%@",model.orderallprice]];
    [attStr addAttributes:@{NSForegroundColorAttributeName:orange_color, NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} range:NSMakeRange(0, 1)];//¥
    [attStr addAttributes:@{NSForegroundColorAttributeName:orange_color, NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} range:range];//价格
    _unPayLab.attributedText=attStr;
    //
//    _unPayLab.text=[NSString stringWithFormat:@"¥%@",model.orderallprice];
    
    _orderNumLab.text=[ZYYCustomTool checkNullWithNSString:model.systemtradeno];
    _orderDateLab.text=[[NSString stringWithFormat:@"%@",model.ordercreatetime] RwnTimeExchange5];
    if ([model.orderstatus integerValue]==1)////0 待支付 1 已支付，2已评价,3已取消
    {
        _payTitleLab.text=@"已支付金额";
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

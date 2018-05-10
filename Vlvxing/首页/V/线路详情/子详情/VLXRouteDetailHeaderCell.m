//
//  VLXRouteDetailHeaderCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXRouteDetailHeaderCell.h"
@interface VLXRouteDetailHeaderCell ()
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIView *line;

@end
@implementation VLXRouteDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _desLab.textColor=[UIColor hexStringToColor:@"#313131"];
//    _desLab.text=@"北京，双飞5日游，北京一地自助游,纯玩品质0购物，精华景点一价全";

    _line.backgroundColor=backgroun_view_color;

}
-(void)creaetUIWithModel:(VLXHomeDetailDataModel *)model
{
    if ([model.productname containsString:@"\n"]) {
        _desLab.text=[ZYYCustomTool checkNullWithNSString:model.productname];
    }else{
      NSString *decStr = [model.context stringByReplacingOccurrencesOfString:@"\n" withString:@""];
       _desLab.text=[ZYYCustomTool checkNullWithNSString:decStr];
    }
    
   
    //可变字体
    NSString *priceStr=[NSString stringWithFormat:@"¥%@起/人",model.price];
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange range=[priceStr rangeOfString:@"起/人"];
    NSRange moneyRange=NSMakeRange(1, range.location);
    [attStr addAttributes:@{NSForegroundColorAttributeName:orange_color, NSFontAttributeName:[UIFont boldSystemFontOfSize:13]} range:NSMakeRange(0, 1)];//¥
    [attStr addAttributes:@{NSForegroundColorAttributeName:orange_color, NSFontAttributeName:[UIFont boldSystemFontOfSize:24]} range:moneyRange];//价格
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor hexStringToColor:@"#999999"], NSFontAttributeName:[UIFont systemFontOfSize:13]} range:range];//单位
    _priceLab.attributedText=attStr;
    //
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

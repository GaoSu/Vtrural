//
//  VLXFarmCourtryCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXFarmCourtryCell.h"
@interface VLXFarmCourtryCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UILabel *distanceLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@end
@implementation VLXFarmCourtryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)createUIWithModel:(VLXHomeRecommandDataModel *)model
{
    
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.layer.masksToBounds = YES;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[ZYYCustomTool checkNullWithNSString:model.productbigpic]] placeholderImage:ADNoDataImage];
    _desLab.text=[ZYYCustomTool checkNullWithNSString:model.context];
    
    //
    //计算农家院离当前位置的距离
//    CLLocationCoordinate2D currentCoor=CLLocationCoordinate2DMake([[NSString getLatitude] floatValue], [[NSString getLongtitude] floatValue]);
//    CLLocationCoordinate2D shopCoor=CLLocationCoordinate2DMake([model.pathlat floatValue], [model.pathlng floatValue]);
//    CGFloat meter= [VLXMapTool calculateMeter:currentCoor toShop:shopCoor];
//    _distanceLab.text=[NSString stringWithFormat:@"%.1fkm",meter/1000];
//    float kMeter=model.distance.floatValue/1000;
    _distanceLab.text=[NSString stringWithFormat:@"%@km",[ZYYCustomTool checkNullWithNSString:[NSString stringWithFormat:@"%.2f",model.distance.floatValue/1000]]];
    //可变字体
    NSString *priceStr=[NSString stringWithFormat:@"¥%@起",model.price];
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange range=[priceStr rangeOfString:@"起"];
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

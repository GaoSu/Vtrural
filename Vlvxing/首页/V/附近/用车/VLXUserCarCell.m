//
//  VLXUserCarCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXUserCarCell.h"
@interface VLXUserCarCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@end
@implementation VLXUserCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    _priceLab.textColor=orange_color;
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height-0.5, kScreenWidth, 0.5)];
    line.backgroundColor=separatorColor1;
    [self.contentView addSubview:line];
    
}
-(void)createUIWithModel:(VLXHomeRecommandDataModel *)model
{
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[ZYYCustomTool checkNullWithNSString:model.productsmallpic]] placeholderImage:ADNoDataImage];
    _titleLab.text=[ZYYCustomTool checkNullWithNSString:model.context];
    //可变字体
    NSString *priceStr=[NSString stringWithFormat:@"¥%@/车",model.price];
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange range=[priceStr rangeOfString:@"/车"];
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

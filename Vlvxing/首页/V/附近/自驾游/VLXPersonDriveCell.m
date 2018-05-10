//
//  VLXPersonDriveCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXPersonDriveCell.h"
@interface VLXPersonDriveCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@end
@implementation VLXPersonDriveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}
-(void)createUIWithModel:(VLXHomeRecommandDataModel *)dataModel
{
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[ZYYCustomTool checkNullWithNSString:dataModel.productbigpic]] placeholderImage:ADNoDataImage];
    _titleLab.text=[ZYYCustomTool checkNullWithNSString:dataModel.context];
    //可变字体
//    NSString *priceStr=@"¥138起/人";
    NSString *priceStr=[NSString stringWithFormat:@"¥%@起/人",dataModel.price];
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange range=[priceStr rangeOfString:@"起/人"];
    NSRange moneyRange=NSMakeRange(1, range.location);
    [attStr addAttributes:@{NSForegroundColorAttributeName:orange_color, NSFontAttributeName:[UIFont boldSystemFontOfSize:13]} range:NSMakeRange(0, 1)];//¥
    [attStr addAttributes:@{NSForegroundColorAttributeName:orange_color, NSFontAttributeName:[UIFont boldSystemFontOfSize:24]} range:moneyRange];//价格
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor hexStringToColor:@"#999999"], NSFontAttributeName:[UIFont systemFontOfSize:13]} range:range];//单位
    _priceLab.attributedText=attStr;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  VLXDomesticSpotCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXDomesticSpotCell.h"
@interface VLXDomesticSpotCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;


@end
@implementation VLXDomesticSpotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(_titleLab.frame.origin.x, self.frame.size.height-0.5, kScreenWidth-CGRectGetMinX(_titleLab.frame), 0.5)];
    line.backgroundColor=separatorColor1;
//    [self.contentView addSubview:line];
}
#pragma mark---数据
-(void)createUIWithModel:(VLXHomeRecommandDataModel *)model
{
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[ZYYCustomTool checkNullWithNSString:model.productsmallpic]] placeholderImage:ADNoDataImage];
//    CGFloat height = [model.context sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(ScreenWidth-114, MAXFLOAT)].height+10;
//    if (height > 55) {
//        self.titlableHeight.constant = 55;
//    }else{
//        self.titlableHeight.constant = height;
//    }
    _titleLab.text=[ZYYCustomTool checkNullWithNSString:model.context];
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
#pragma mark
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

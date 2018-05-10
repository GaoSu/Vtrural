//
//  VLXHomeRecommandCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/19.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXHomeRecommandCell.h"

@interface VLXHomeRecommandCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;// 景点名称
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidth;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;//价钱
@property (weak, nonatomic) IBOutlet UILabel *desLab;//描述
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (nonatomic,strong)UIView *line;
@end
@implementation VLXHomeRecommandCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.layer.masksToBounds = YES;
    
    NSString *title=[NSString stringWithFormat:@"   %@",@"加勒比海盗"];
    _titleLab.text=title;
    _titleWidth.constant=[title sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, 27)].width+40;//得到字体长度后 加30长度

    _titleLab.layer.cornerRadius=27/2;
    _titleLab.layer.masksToBounds=YES;
//    _titleLab.backgroundColor=[UIColor hexStringToColor:@"#000000"];
//    _titleLab.alpha=0.3;
    _titleLab.backgroundColor = [UIColor hexStringToColor:@"#edb949"];
//    _titleLab.alpha = 0.5;
    //底部的线 默认是隐藏的
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 137+44, kScreenWidth, 8)];
    line.backgroundColor=backgroun_view_color;
    [self.contentView addSubview:line];
    _line=line;
    _line.hidden=YES;
    //价格标签 默认是隐藏的
    _priceLab.layer.cornerRadius=2;
    _priceLab.layer.masksToBounds=YES;
    _priceLab.backgroundColor=orange_color;
//    _priceLab.text=@"¥200";
    _priceLab.hidden=YES;

}
#pragma mark---数据
-(void)createUIWithModel:(VLXHomeRecommandDataModel *)dataModel
{
    _titleLab.text=[ZYYCustomTool checkNullWithNSString:dataModel.productname];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[ZYYCustomTool checkNullWithNSString:dataModel.advertisebigpic]] placeholderImage:ADNoDataImage];

    _desLab.text=[ZYYCustomTool checkNullWithNSString:dataModel.context];
    
    //可变字体
    NSString *priceStr=[NSString stringWithFormat:@"￥%.2f",dataModel.price.floatValue];
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange range=[priceStr rangeOfString:@"￥"];
    NSRange moneyRange=NSMakeRange(1, range.location);
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:13]} range:NSMakeRange(0, 1)];//¥
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:24]} range:moneyRange];//价格

    _priceLab.attributedText=attStr;
    //
}
#pragma mark
-(void)setIsHasMargin:(BOOL)isHasMargin
{
    _isHasMargin=isHasMargin;
    if (isHasMargin) {
        _line.hidden=NO;
        _priceLab.hidden=NO;
        //设置描述样式
        _desLab.textColor=[UIColor hexStringToColor:@"#111111"];
        _desLab.font=[UIFont systemFontOfSize:14];//19
    }else
    {
        _line.hidden=YES;
        _priceLab.hidden=YES;
        //设置描述样式
        _desLab.textColor=[UIColor hexStringToColor:@"#666666"];
        _desLab.font=[UIFont systemFontOfSize:14];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  VLXOrderCarTableViewCell.m
//  Vlvxing
//
//  Created by Michael on 17/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXOrderCarTableViewCell.h"

@implementation VLXOrderCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView *)tableview
{
    VLXOrderCarTableViewCell * cell=[tableview dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell=[[VLXOrderCarTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    }
    return cell;
}
-(void)createUIWithModel:(VLXMyOrderDataModel *)model
{
    [_leftimageview sd_setImageWithURL:[NSURL URLWithString:model.orderpic] placeholderImage:smallNoDataImage];
    _toplalbel.text=[ZYYCustomTool checkNullWithNSString:model.ordername];
    if (model.ordertype.integerValue==1) {//订单类别   1 出行订单 2 用车订单
//        _midlable.text=[NSString stringWithFormat:@"¥%@",model.orderallprice];
        //可变字体
        NSString *priceStr=[NSString stringWithFormat:@"¥%.2f",[model.orderallprice doubleValue]];
        NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:priceStr];
        NSRange range=[priceStr rangeOfString:[NSString stringWithFormat:@"%@",model.orderallprice]];
        [attStr addAttributes:@{NSForegroundColorAttributeName:orange_color, NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, 1)];//¥
        [attStr addAttributes:@{NSForegroundColorAttributeName:orange_color, NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} range:range];//价格
        _midlable.attributedText=attStr;
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
        _midlable.attributedText=attStr;
        //
    }
    //订单状态   0 待支付 1 已支付，2已评价,3已取消
    [self changeBtnWithType:model.orderstatus.integerValue];

}
-(void)changeBtnWithType:(NSInteger)type
{
    //订单状态   0 待支付 1 已支付，2已评价,3已取消
    if (type==0) {
        [_rightBtn setBackgroundColor:orange_color];
        [_rightBtn setTitle:@"待付款" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if (type==1)
    {
        [_rightBtn setBackgroundColor:[UIColor hexStringToColor:@"#999999"]];
        [_rightBtn setTitle:@"已支付" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if (type==2)
    {
        [_rightBtn setBackgroundColor:[UIColor hexStringToColor:@"#999999"]];
        [_rightBtn setTitle:@"已评价" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if (type==3)
    {
        [_rightBtn setBackgroundColor:[UIColor hexStringToColor:@"#dddddd"]];
        [_rightBtn setTitle:@"已取消" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftimageview];
        [self.contentView addSubview:self.toplalbel];
        [self.contentView addSubview:self.midlable];
        [self.contentView addSubview:self.rightBtn];
        [self.contentView addSubview:self.footerview];
    }
    return self;
}
-(UIImageView * )leftimageview
{
    if (!_leftimageview) {
        _leftimageview=[UIImageView new];
//        _leftimageview.image=[UIImage imageNamed:@"bieke"];
        [self.contentView addSubview:_leftimageview];
        [_leftimageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScaleWidth(12));
            make.top.mas_equalTo(ScaleHeight(15));
            make.width.mas_equalTo(96);
            make.height.mas_equalTo(72);
        }];
    }
    return _leftimageview;
}
-(UILabel * )toplalbel
{
    if (!_toplalbel) {
        _toplalbel=[UILabel new];
//        _toplalbel.text=@"阿尔法罗密欧四叶草🍀";
        _toplalbel.textColor=[UIColor hexStringToColor:@"313131"];
        _toplalbel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        [self.contentView addSubview:_toplalbel];
        [_toplalbel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftimageview.mas_right).offset(ScaleWidth(10));
            make.top.mas_equalTo(ScaleHeight(15));
            make.width.mas_equalTo(ScreenWidth-ScaleWidth(22+96+11+12));
            make.height.mas_equalTo(18);

        }];

    }

    return _toplalbel;
}

-(UILabel * )midlable
{
    if (!_midlable) {
        _midlable=[UILabel new];
//        _midlable.text=@"￥750/月";
        _midlable.font=[UIFont  fontWithName:@"PingFang-SC-Medium" size:12];
        _midlable.textColor=orange_color;
        [self.contentView addSubview:_midlable];
        [_midlable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftimageview.mas_right).offset(ScaleWidth(10));
            make.top.mas_equalTo(self.toplalbel.mas_bottom).offset(15);
            make.width.mas_equalTo(ScreenWidth-ScaleWidth(22+96+11+12));
            make.height.mas_equalTo(13);
        }];
    }
    return _midlable;
}

-(UIButton*)rightBtn
{
    if (!_rightBtn) {
        _rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        [_rightBtn setBackgroundColor:orange_color];
//        [_rightBtn setTitle:@"待付款" forState:UIControlStateNormal];
//        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(Btnclick) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.layer.masksToBounds=YES;
        _rightBtn.layer.cornerRadius=4;
        [self.contentView addSubview:_rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ScaleWidth(-11.5));
            make.top.mas_equalTo(self.toplalbel.mas_bottom).offset(24);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(27.5);
        }];
    }


    return _rightBtn;
}


-(UIView * )footerview
{
    if (!_footerview) {
        _footerview=[UIView new];
        _footerview.backgroundColor=[UIColor hexStringToColor:@"dddddd"];
        [self.contentView addSubview:_footerview];
        [_footerview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftimageview.mas_right).offset(ScaleWidth(10));
            make.bottom.mas_equalTo(-1);
            make.width.mas_equalTo(ScaleWidth(256));
            make.height.mas_equalTo(1);

        }];
    }


    return _footerview;
}

-(void)Btnclick
{

    MyLog(@"rightclick");

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

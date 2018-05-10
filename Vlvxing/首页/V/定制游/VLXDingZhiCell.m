//
//  VLXDingZhiCell.m
//  Vlvxing
//
//  Created by Michael on 17/5/26.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXDingZhiCell.h"

@implementation VLXDingZhiCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
+(instancetype)cellWithTableView:(UITableView *)tableview
{
    VLXDingZhiCell * cell=[tableview dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell=[[VLXDingZhiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self leftlabel];
        [self midlabel];
        [self footLine];
    }
    return self;
}

-(UILabel * )leftlabel
{
    if (!_leftlabel) {

        _leftlabel=[UILabel new];
        _leftlabel.text=@"漓江塔";
        _leftlabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _leftlabel.textColor=[UIColor hexStringToColor:@"313131"];
        [self.contentView addSubview:_leftlabel];
        [_leftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScaleWidth(14.5));
            make.top.mas_equalTo(ScaleHeight(15));
            make.height.mas_equalTo(14);
        }];
    }

    return _leftlabel;
}
-(UILabel * )midlabel
{
    if (!_midlabel) {
        _midlabel=[UILabel new];
        _midlabel.textColor=[UIColor hexStringToColor:@"666666"];
        _midlabel.text=@"South Koreaapan";
        _midlabel.font=[UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        [self.contentView addSubview:_midlabel];
        [_midlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftlabel.mas_right).offset(ScaleWidth(9.5));
            make.top.mas_equalTo(ScaleHeight(15.5));

            make.height.mas_equalTo(14);
        }];
    }

    return _midlabel;
}
-(UIView *)footLine{
    if (!_footLine) {
        _footLine = [[UIView alloc]init];
        _footLine.backgroundColor =[UIColor hexStringToColor:@"e5e5e5"];
        [self.contentView addSubview:_footLine];
        [_footLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH - 15);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _footLine;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

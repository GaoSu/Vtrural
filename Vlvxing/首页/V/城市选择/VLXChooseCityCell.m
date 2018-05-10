//
//  VLXChooseCityCell.m
//  Vlvxing
//
//  Created by Michael on 17/5/27.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXChooseCityCell.h"

@implementation VLXChooseCityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView *)tableview
{
    VLXChooseCityCell * cell=[tableview dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell=[[VLXChooseCityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self leftlabel];
        [self footLine];
    }
    return self;
}

-(UILabel * )leftlabel
{
    if (!_leftlabel) {

        _leftlabel=[UILabel new];
        _leftlabel.text=@"漓江塔";
        _leftlabel.font=[UIFont systemFontOfSize:14];
        _leftlabel.textColor=[UIColor hexStringToColor:@"313131"];
        [self.contentView addSubview:_leftlabel];
        [_leftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScaleWidth(12));
            make.top.mas_equalTo(ScaleHeight(15));
            make.height.mas_equalTo(14);
        }];
    }

    return _leftlabel;
}

-(UIView *)footLine{
    if (!_footLine) {
        _footLine = [[UIView alloc]init];
        _footLine.backgroundColor =[UIColor hexStringToColor:@"dddddd"];
        [self.contentView addSubview:_footLine];
        [_footLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(ScaleWidth(-33));
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

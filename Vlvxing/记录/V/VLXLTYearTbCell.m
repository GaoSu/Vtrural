//
//  VLXLTYearTbCell.m
//  Vlvxing
//
//  Created by Michael on 17/5/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXLTYearTbCell.h"

@implementation VLXLTYearTbCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView *)tableView{

    VLXLTYearTbCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell==nil) {

        cell=[[VLXLTYearTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];

    }
    return cell;

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.yaerlabel];
        [self.contentView addSubview:self.point];

    }
    return self;
}

-(UIView * )line

{
    if (!_line) {
        _line=[UIView new];
        _line.backgroundColor=[UIColor hexStringToColor:@"dddddd"];
        [self.contentView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(3);
            make.left.mas_equalTo(ScaleWidth(6));
            make.width.mas_equalTo(62);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _line;
}

-(UIView * )point
{
    if (!_point) {
        _point=[UIView new];
        _point.backgroundColor=orange_color;
        [self.contentView addSubview:_point];
        _point.layer.masksToBounds=YES;
        _point.layer.cornerRadius=3;
        [_point mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(ScaleWidth(6));
            make.width.mas_equalTo(6);
            make.height.mas_equalTo(6);

        }];
    }

    return _point;
}

-(UILabel * )yaerlabel
{
    if (!_yaerlabel) {
        _yaerlabel=[UILabel new];
        _yaerlabel.text=@"2017";
        _yaerlabel.textColor=[UIColor whiteColor];
        _yaerlabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        _yaerlabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:_yaerlabel];
        [_yaerlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(ScaleWidth(-7.5));
//            make.width.mas_equalTo(36.6);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(16);
        }];
    }

    return _yaerlabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

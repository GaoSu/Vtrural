//
//  VLXDingZhiTableViewCell.m
//  Vlvxing
//
//  Created by Michael on 17/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXDingZhiTableViewCell.h"

@implementation VLXDingZhiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+(instancetype)cellWithTableView:(UITableView *)tableview
{
    VLXDingZhiTableViewCell * cell=[tableview dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell=[[VLXDingZhiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];

    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self.contentView addSubview:self.leftImage];
        [self.contentView addSubview:self.htoplabel];
        [self.contentView addSubview:self.hmidlabel];
        [self.contentView addSubview:self.hbottomLabel];
        [self.contentView addSubview:self.rtoplabel];
        [self.contentView addSubview:self.rmidlabel];
        [self.contentView addSubview:self.rbottomlabel];
        [self.contentView addSubview:self.footLine];

    }

    return self;
}


-(UIImageView * )leftImage
{
    if (!_leftImage) {
        _leftImage=[UIImageView new];
        _leftImage.image=[UIImage imageNamed:@"dingzhi-line"];
        [self.contentView addSubview:_leftImage];
        [_leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScaleWidth(12));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(28);
            make.height.mas_equalTo(28);
        }];
    }

    return _leftImage;
}

-(UILabel *)htoplabel
{
    if (!_htoplabel) {
        _htoplabel=[UILabel new];
        _htoplabel.textColor=[UIColor hexStringToColor:@"666666"];
        _htoplabel.text=@"目的地";
        _htoplabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        [self.contentView addSubview:_htoplabel];
        [_htoplabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftImage.mas_right).mas_offset(ScaleWidth(15));
            make.top.mas_equalTo(ScaleHeight(15));
            make.width.mas_equalTo(58);
            make.height.mas_equalTo(14);
        }];
    }


    return _htoplabel;
}
-(UILabel *)hmidlabel
{
    if (!_hmidlabel) {
        _hmidlabel=[UILabel new];
        _hmidlabel.textColor=[UIColor hexStringToColor:@"666666"];
        _hmidlabel.text=@"出发地";
        _hmidlabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        [self.contentView addSubview:_hmidlabel];
        [_hmidlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftImage.mas_right).mas_offset(ScaleWidth(15));
            make.top.mas_equalTo(self.htoplabel.mas_bottom).offset(ScaleHeight(15.5));
            make.width.mas_equalTo(58);
            make.height.mas_equalTo(14);
        }];

    }

    return _hmidlabel;
}


-(UILabel * )hbottomLabel
{
    if (!_hbottomLabel) {
        _hbottomLabel=[UILabel new];
        _hbottomLabel.textColor=[UIColor hexStringToColor:@"666666"];
        _hbottomLabel.text=@"出行时间";
        _hbottomLabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        [self.contentView addSubview:_hbottomLabel];
        [_hbottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftImage.mas_right).mas_offset(ScaleWidth(15));
            make.top.mas_equalTo(self.hmidlabel.mas_bottom).offset(ScaleHeight(15.5));
            make.width.mas_equalTo(58);
            make.height.mas_equalTo(14);
        }];
    }
    return _hbottomLabel;
}


-(UILabel * )rbottomlabel
{
    if (!_rbottomlabel) {
        _rbottomlabel=[UILabel new];
        _rbottomlabel.textColor=[UIColor hexStringToColor:@"111111"];
//        _rbottomlabel.text=@"2017-05-10";
        _rbottomlabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        [self.contentView addSubview:_rbottomlabel];
        [_rbottomlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.hbottomLabel.mas_right).mas_offset(ScaleWidth(17));
            make.top.mas_equalTo(self.hmidlabel.mas_bottom).offset(ScaleHeight(15.5));
            make.width.mas_equalTo(ScreenWidth/2);
            make.height.mas_equalTo(16);
        }];

    }

    return _rbottomlabel;
}


-(UILabel * )rmidlabel
{
    if (!_rmidlabel) {
        _rmidlabel=[UILabel new];
        _rmidlabel.textColor=[UIColor hexStringToColor:@"111111"];
//        _rmidlabel.text=@"石家庄";
        _rmidlabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        [self.contentView addSubview:_rmidlabel];
        [_rmidlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.hbottomLabel.mas_right).mas_offset(ScaleWidth(17));
            make.top.mas_equalTo(self.htoplabel.mas_bottom).offset(ScaleHeight(15.5));
            make.width.mas_equalTo(ScreenWidth/2);
            make.height.mas_equalTo(16);
        }];
    }
    return _rmidlabel;
}

-(UILabel * )rtoplabel
{
    if (!_rtoplabel) {
        _rtoplabel=[UILabel new];
        _rtoplabel.textColor=[UIColor hexStringToColor:@"111111"];
//        _rtoplabel.text=@"乌兹别克斯坦🇺🇿";
        _rtoplabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        [self.contentView addSubview:_rtoplabel];
        [_rtoplabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.hbottomLabel.mas_right).mas_offset(ScaleWidth(17));
            make.top.mas_equalTo(ScaleHeight(15.5));
            make.width.mas_equalTo(ScreenWidth/2);
            make.height.mas_equalTo(16);
        }];

    }

    return _rtoplabel;
}

-(UIView *)footLine{
    if (!_footLine) {
        _footLine = [[UIView alloc]init];
        _footLine.backgroundColor =[UIColor hexStringToColor:@"e5e5e5"];
        [self.contentView addSubview:_footLine];
        [_footLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
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

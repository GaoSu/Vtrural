
//
//  VLXDingZhiAlert.m
//  Vlvxing
//
//  Created by Michael on 17/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXDingZhiAlert.h"

@implementation VLXDingZhiAlert


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        [self addSubview:self.alertview];
        [self.alertview addSubview:self.orangeview];
        [self.orangeview addSubview:self.tishilabel];
        [self.alertview addSubview:self.midlabel];
        [self.alertview addSubview:self.line];
        [self.alertview addSubview:self.leftlabel];
        [self.alertview addSubview:self.midview];
        [self.alertview addSubview:self.rightlabel];
        [self.alertview addSubview:self.leftBtn];
        [self.alertview addSubview:self.rightBtn];

    }

    return self;
}

#pragma mark 全部懒加载
-(UIView * )alertview
{

    if (!_alertview) {
        _alertview=[UIView new];
        _alertview.backgroundColor=[UIColor whiteColor];
        [self addSubview:_alertview];
        _alertview.layer.masksToBounds=YES;
        _alertview.layer.cornerRadius=7;
        [_alertview mas_makeConstraints:^(MASConstraintMaker *make) {

            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(ScaleWidth(320));
            make.height.mas_equalTo(149);
        }];
    }

    return _alertview;
}

-(UIView * )orangeview
{
    if (!_orangeview) {
        _orangeview=[UIView new];
        _orangeview.backgroundColor=[UIColor hexStringToColor:@"ea5413"];
        [self.alertview addSubview:_orangeview];
        [_orangeview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(ScaleWidth(320));
            make.height.mas_equalTo(44);
        }];

    }
    return _orangeview;
}


-(UILabel * )tishilabel
{
    if (!_tishilabel) {
        _tishilabel=[UILabel new];
        _tishilabel.text=@"提示";
        _tishilabel.textColor=[UIColor hexStringToColor:@"ffffff"];
        _tishilabel.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
        [self.orangeview addSubview:_tishilabel];
        [_tishilabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.orangeview.mas_centerX);
          make.centerY.mas_equalTo(self.orangeview.mas_centerY);
//            make.width.mas_equalTo(33);
            make.height.mas_equalTo(16);
        }];
    }
    return _tishilabel;
}

-(UILabel * )midlabel
{
    if (!_midlabel) {
        _midlabel=[UILabel new];
        _midlabel.text=@"确定删除选中路线?";
        _midlabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        _midlabel.textColor=[UIColor  hexStringToColor:@"313131"];
        _midlabel.textAlignment=NSTextAlignmentCenter;
        [self.alertview addSubview:_midlabel];
        [_midlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(self.orangeview.mas_bottom).offset(22.5);
            make.width.mas_equalTo(ScaleWidth(320));
            make.height.mas_equalTo(16);

        }];
    }
    return _midlabel;
}

-(UIView * )line
{
    if (!_line) {
        _line=[UIView new];
        _line.backgroundColor=[UIColor hexStringToColor:@"999999"];
        [self.alertview addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {


            make.left.mas_equalTo(0);
            make.top.mas_equalTo(self.midlabel.mas_bottom).mas_offset(22.5);
            make.width.mas_equalTo(ScaleWidth(320));
            make.height.mas_equalTo(0.5);


        }];
    }

    return _line;
}

-(UILabel *)leftlabel
{
    if (!_leftlabel) {
        _leftlabel=[UILabel new];
        _leftlabel.text=@"确定";
        _leftlabel.textColor=[UIColor hexStringToColor:@"666666"];
        _leftlabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        [self.alertview addSubview:_leftlabel];
        [_leftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScaleWidth(64.5));
            make.top.mas_equalTo(self.line.mas_bottom).offset(10);
            make.width.mas_equalTo(33);
            make.height.mas_equalTo(16);
        }];


    }


    return _leftlabel;
}

-(UIView * )midview
{
    if (!_midview) {
        _midview=[UIView new];
        _midview.backgroundColor=[UIColor hexStringToColor:@"999999"];
        [self.alertview addSubview:_midview];
        [_midview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.alertview.mas_centerX);
            make.top.mas_equalTo(self.line.mas_bottom).offset(11);
            make.width.mas_equalTo(0.5);
            make.height.mas_equalTo(13);
        }];
    }

    return _midview;
}

-(UILabel * )rightlabel
{
    if (!_rightlabel) {
        _rightlabel=[UILabel new];
        _rightlabel.text=@"取消";
        _rightlabel.textColor=[UIColor hexStringToColor:@"666666"];
        _rightlabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        [self.alertview addSubview:_rightlabel];
        [_rightlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.midview.mas_right).offset(ScaleWidth(64.5));
            make.top.mas_equalTo(self.line.mas_bottom).offset(10);
            make.width.mas_equalTo(33);
            make.height.mas_equalTo(16);

        }];
    }

    return _rightlabel;
}

-(UIButton * )leftBtn
{
    if (!_leftBtn) {
        _leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
        [self.alertview addSubview:_leftBtn];
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(self.line.mas_bottom).offset(0);
            make.width.mas_equalTo(ScaleWidth(320)/2);
            make.height.mas_equalTo(44.5);

        }];
    }


    return _leftBtn;
}
-(UIButton * )rightBtn
{
    if (!_rightBtn) {
        _rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];

        [_rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
        [self.alertview addSubview:_rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScaleWidth(320)/2);
            make.top.mas_equalTo(self.line.mas_bottom).offset(0);
            make.width.mas_equalTo(ScaleWidth(320)/2);
            make.height.mas_equalTo(44.5);

        }];

    }

    return _rightBtn;
}
-(void)leftClick
{
    if ([self.delegate respondsToSelector:@selector(BringBackValue:)]) {
        [self.delegate BringBackValue:0];
    }
    MyLog(@"点击左边");

}
-(void)rightClick
{
    MyLog(@"点击右边");
    if ([self.delegate respondsToSelector:@selector(BringBackValue:)]) {
        [self.delegate BringBackValue:1];
    }

}



@end

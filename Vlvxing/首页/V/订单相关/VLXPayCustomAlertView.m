//
//  VLXPayCustomAlertView.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/9.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXPayCustomAlertView.h"
@interface VLXPayCustomAlertView ()
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,assign)float payMoney;
@property (nonatomic,assign)NSInteger payType;//0微信 1支付宝
@end
@implementation VLXPayCustomAlertView
-(instancetype)initWithFrame:(CGRect)frame andPayMoney:(float)payMoney
{
    if (self=[super initWithFrame:frame]) {
        _payMoney=payMoney;
        self.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.3];
        //初始化
        _payType=0;//默认微信
        //
        [self createUI];
        //添加背景点击手势
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCloseBtn)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(void)createUI
{
    _bgView=[[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-320)/2, (kScreenHeight-225)/2, 320, 225)];
    _bgView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_bgView];
    _bgView.layer.cornerRadius=8;
    _bgView.layer.masksToBounds=YES;
    //标题
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _bgView.frame.size.width, 55.5)];
    titleLab.text=[NSString stringWithFormat:@"支付¥%.2f",_payMoney];
    titleLab.textColor=orange_color;
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.font=[UIFont systemFontOfSize:16];
    [_bgView addSubview:titleLab];
    //线
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLab.frame), _bgView.frame.size.width, 0.5)];
    line.backgroundColor=separatorColor1;
    [_bgView addSubview:line];
    //
    CGFloat height=107/2;
    NSArray *titleArray=@[@"微信支付",@"支付宝支付"];
    NSArray *imageArray=@[@"WeChat-pay",@"alipay"];
    for (int i=0; i<titleArray.count; i++) {
        UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, i*height+CGRectGetMaxY(line.frame), _bgView.frame.size.width, height)];
        [_bgView addSubview:bgView];
        bgView.tag=200+i;
        UIImageView *iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(18, (height-22)/2, 22, 22)];
        [iconImageView setImage:[UIImage imageNamed:imageArray[i]]];
        [bgView addSubview:iconImageView];
        UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+15, 0, 150, bgView.frame.size.height)];
        titleLab.text=titleArray[i];
        titleLab.textColor=[UIColor hexStringToColor:@"#313131"];
        titleLab.font=[UIFont systemFontOfSize:16];
        [bgView addSubview:titleLab];
        UIImageView *chooseImage=[[UIImageView alloc] initWithFrame:CGRectMake(_bgView.frame.size.width-20-15, (bgView.frame.size.height-10)/2, 15, 10)];
        [chooseImage setImage:[UIImage imageNamed:@"pitch-on"]];
        chooseImage.tag=100+i;
        [bgView addSubview:chooseImage];
        if (i==0) {
            chooseImage.hidden=NO;
        }else{
            chooseImage.hidden=YES;
        }
        //添加手势
        bgView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToChoosePay:)];
        [bgView addGestureRecognizer:tap];
    }
    //确定
    UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame=CGRectMake(20, _bgView.frame.size.height-18-44, _bgView.frame.size.width-20*2, 44);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    sureBtn.backgroundColor=orange_color;
    [sureBtn addTarget:self action:@selector(btnClickedToSure:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:sureBtn];
    
}
#pragma mark---事件
-(void)tapToChoosePay:(UITapGestureRecognizer *)tap
{
    NSLog(@"%ld",tap.view.tag);
    UIImageView *imageView1=[self viewWithTag:100];
    UIImageView *imageView2=[self viewWithTag:101];
    if (tap.view.tag==200) {
        imageView1.hidden=NO;
        imageView2.hidden=YES;
    }else if (tap.view.tag==201)
    {
        imageView1.hidden=YES;
        imageView2.hidden=NO;
    }
    //
    _payType=tap.view.tag-200;
}
-(void)btnClickedToSure:(UIButton *)sender
{
    [self removeFromSuperview];
    NSLog(@"sure");
    if (_payTypeBlock) {
        _payTypeBlock(_payType);
    }
}
#pragma mark
#pragma mark--关闭
-(void)clickCloseBtn
{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

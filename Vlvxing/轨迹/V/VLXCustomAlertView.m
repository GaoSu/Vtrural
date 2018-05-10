//
//  VLXCustomAlertView.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/6.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXCustomAlertView.h"
@interface VLXCustomAlertView ()
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *content1;
@property (nonatomic,copy)NSString *content2;
@end
@implementation VLXCustomAlertView
-(instancetype)initWithTitle:(NSString *)title andContent1:(NSString *)content1 andContent2:(NSString *)content2
{
    if(self=[super init])
    {
        _title=title;
        _content1=content1;
        _content2=content2;
        self.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.3];
        [self addWiteView];
        //添加背景点击手势
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCloseBtn)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
#pragma 添加踢实况
-(void)addWiteView
{
    UIView*whiteView=[[UIView alloc]initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH-60, 150)];
    whiteView.backgroundColor=[UIColor whiteColor];
    whiteView.center=self.center;
    whiteView.layer.cornerRadius=6;
    whiteView.layer.masksToBounds=YES;
    [self addSubview:whiteView];
    
    UILabel*titleLable=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, whiteView.width-40, 48)];
    titleLable.textColor=orange_color;
    titleLable.font=[UIFont systemFontOfSize:16];
//    titleLable.text=@"选择性别";
    titleLable.text=[ZYYCustomTool checkNullWithNSString:_title];
    titleLable.textAlignment=NSTextAlignmentCenter;
    [whiteView addSubview:titleLable];
    
    UIButton*closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(whiteView.width-15-15, 15, 15, 15)];
    [closeBtn setImage:[UIImage imageNamed:@"wd_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:closeBtn];
    
    UIView*lineOne=[[UIView alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(titleLable.frame), whiteView.width-20, 1)];
    lineOne.backgroundColor=[UIColor hexStringToColor:@"eeeeee"];
    [whiteView addSubview:lineOne];
    
    UIButton*paizhaoBtn=[[UIButton alloc]initWithFrame:CGRectMake(24,CGRectGetMaxY(lineOne.frame), whiteView.width-48,48)];
    paizhaoBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    paizhaoBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    
//    [paizhaoBtn setTitle:@"男" forState:UIControlStateNormal];
    [paizhaoBtn setTitle:[ZYYCustomTool checkNullWithNSString:_content1] forState:UIControlStateNormal];
    [paizhaoBtn setTitleColor:[UIColor hexStringToColor:@"000001"] forState:UIControlStateNormal];
    [paizhaoBtn addTarget:self action:@selector(clickBenDiBtn) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:paizhaoBtn];
    
    UIView*lineTwo=[[UIView alloc]initWithFrame:CGRectMake(31.7,CGRectGetMaxY(paizhaoBtn.frame), whiteView.width-63.4, 0.5)];
    lineTwo.backgroundColor=[UIColor hexStringToColor:@"eeeeee"];
    [whiteView addSubview:lineTwo];
    
    UIButton*bendiBtn=[[UIButton alloc]initWithFrame:CGRectMake(24,CGRectGetMaxY(lineTwo.frame), whiteView.width-48, 48)];
    bendiBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    bendiBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
//    [bendiBtn setTitle:@"女" forState:UIControlStateNormal];
    [bendiBtn setTitle:[ZYYCustomTool checkNullWithNSString:_content2] forState:UIControlStateNormal];
    [bendiBtn setTitleColor:[UIColor hexStringToColor:@"000001"] forState:UIControlStateNormal];
    [bendiBtn addTarget:self action:@selector(clickPaiZhaoBtn) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:bendiBtn];
    
}
#pragma mark--关闭
-(void)clickCloseBtn
{
    [self removeFromSuperview];
}
#pragma mark--拍照上传按钮
-(void)clickPaiZhaoBtn
{
    [self removeFromSuperview];
    if (_alertBlock) {
        _alertBlock(2);
    }
//    if(self.delegate && [self.delegate respondsToSelector:@selector(bringBackMessage:)])
//    {
//        [self.delegate bringBackMessage:2];
//    }
}
#pragma mark--本地上传按钮
-(void)clickBenDiBtn
{
    [self removeFromSuperview];
    if (_alertBlock) {
        _alertBlock(1);
    }
//    if(self.delegate && [self.delegate respondsToSelector:@selector(bringBackMessage:)])
//    {
//        [self.delegate bringBackMessage:1];
//    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  XWPicChooseAlterView.m
//  XWQY
//
//  Created by 撼动科技006 on 17/3/14.
//  Copyright © 2017年 XWQY. All rights reserved.
//

#import "XWPicChooseAlterView.h"

@implementation XWPicChooseAlterView

-(instancetype)init
{
    if(self=[super init])
    {
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
    titleLable.text=@"设置头像";
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
    
    [paizhaoBtn setTitle:@"选择本地图片" forState:UIControlStateNormal];
    [paizhaoBtn setTitleColor:[UIColor hexStringToColor:@"000001"] forState:UIControlStateNormal];
    [paizhaoBtn addTarget:self action:@selector(clickBenDiBtn) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:paizhaoBtn];
    
    UIView*lineTwo=[[UIView alloc]initWithFrame:CGRectMake(31.7,CGRectGetMaxY(paizhaoBtn.frame), whiteView.width-63.4, 0.5)];
    lineTwo.backgroundColor=[UIColor hexStringToColor:@"eeeeee"];
    [whiteView addSubview:lineTwo];
    
    UIButton*bendiBtn=[[UIButton alloc]initWithFrame:CGRectMake(24,CGRectGetMaxY(lineTwo.frame), whiteView.width-48, 48)];
    bendiBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    bendiBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [bendiBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [bendiBtn setTitleColor:[UIColor hexStringToColor:@"0000001"] forState:UIControlStateNormal];
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
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickBtnNumber:)])
    {
        [self.delegate clickBtnNumber:0];
    }
}
#pragma mark--本地上传按钮
-(void)clickBenDiBtn
{
      [self removeFromSuperview];
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickBtnNumber:)])
    {
        [self.delegate clickBtnNumber:1];
    }
}
@end

//
//  VLXCustomNavTitleView.m
//  Vlvxing
//
//  Created by Michael on 17/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXCustomNavTitleView.h"

@implementation VLXCustomNavTitleView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        //出行view
        self.chuxingView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScaleWidth(96), 28)];
        self.chuxingView.backgroundColor=orange_color;
        self.chuxingView.layer.masksToBounds=YES;
        self.chuxingView.layer.cornerRadius=14;
        [self addSubview:self.chuxingView];

        self.chuxinglabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScaleWidth(96), 28)];
        self.chuxinglabel.text=@"出行订单";
        self.chuxinglabel.textColor=[UIColor whiteColor];
        self.chuxinglabel.textAlignment = NSTextAlignmentCenter;
        self.chuxinglabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        [self.chuxingView addSubview:self.chuxinglabel];

        //用车订单
        self.yongcheView =[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.chuxingView.frame)+ScaleWidth(30), 0, ScaleWidth(96), 28)];
        self.yongcheView.backgroundColor=[UIColor whiteColor];
        self.yongcheView.layer.masksToBounds=YES;
        self.yongcheView.layer.cornerRadius=14;
        [self addSubview:self.yongcheView];

        self.yongchelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScaleWidth(96), 28)];
        self.yongchelabel.text=@"用车订单";
        self.yongchelabel.textColor=[UIColor hexStringToColor:@"313131"];
        self.yongchelabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        self.yongchelabel.textAlignment = NSTextAlignmentCenter;
        [self.yongcheView addSubview:self.yongchelabel];


//添加点击事件
        UITapGestureRecognizer * chuxingtap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftclick)];
        self.chuxingView.userInteractionEnabled=YES;
        [self.chuxingView addGestureRecognizer:chuxingtap];

        UITapGestureRecognizer * yongcheTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightclick)];
        self.yongcheView.userInteractionEnabled=YES;
        [self.yongcheView addGestureRecognizer:yongcheTap];

    }

    return self;
}
-(void)leftclick
{

    MyLog(@"点击了左边");
    self.yongcheView.backgroundColor=[UIColor whiteColor];
    self.yongchelabel.textColor=[UIColor hexStringToColor:@"313131"];
    self.chuxingView.backgroundColor=orange_color;
    self.chuxinglabel.textColor=[UIColor whiteColor];
    if (self.MyBlock) {
        //左边的数值传0
        self.MyBlock(0);
    }

}
-(void)rightclick
{
    MyLog(@"点击了右边");
    //右边的数值传1
    self.chuxingView.backgroundColor=[UIColor whiteColor];
    self.chuxinglabel.textColor=[UIColor hexStringToColor:@"313131"];
    self.yongcheView.backgroundColor=orange_color;
    self.yongchelabel.textColor=[UIColor whiteColor];
    if (self.MyBlock) {
        //左边的数值传0
        self.MyBlock(1);
    }

}

-(void)retuenType:(typeBlock)block
{
    self.MyBlock=block;
}

@end

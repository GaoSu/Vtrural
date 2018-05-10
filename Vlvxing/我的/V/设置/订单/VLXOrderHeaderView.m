
//
//  VLXOrderHeaderView.m
//  Vlvxing
//
//  Created by Michael on 17/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXOrderHeaderView.h"

@implementation VLXOrderHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {

        NSArray * nameArray=@[@"全部",@"待付款",@"待评价"];
        for (int i=0; i<3; i++) {
            UIView * view=[[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/3*i, 0, ScreenWidth/3, 44)];
            view.tag=600+i;
            view.userInteractionEnabled=YES;
            UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTyte:)];
            [view addGestureRecognizer:tap];
            [self addSubview:view];
            UILabel * label=[UILabel new];
            label.text=nameArray[i];
            label.textColor=[UIColor hexStringToColor:@"444444"];
            label.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:16];
            [view addSubview:label];
            label.textAlignment=NSTextAlignmentCenter;
            [label mas_makeConstraints:^(MASConstraintMaker *make) {

                make.centerY.mas_equalTo(view.mas_centerY);
                make.left.mas_equalTo(0);
                make.width.mas_equalTo(ScreenWidth/3);
                make.height.mas_equalTo(16);
                
            }];
            UIView * footerview=[[UIView alloc]initWithFrame:CGRectMake(0, 42, ScreenWidth/3, 2)];
            footerview.backgroundColor=orange_color;
            footerview.tag=200+i;
            [view addSubview:footerview];
            if (i>0) {
                footerview.hidden=YES;
            }
        }
    }
       return self;
}
-(void)clickTyte:(UITapGestureRecognizer * )tap
{
    UIView * view1=[self viewWithTag:200];
    UIView * view2=[self viewWithTag:201];
    UIView * view3=[self viewWithTag:202];

    if (tap.view.tag==600) {
        view1.hidden=NO;
        view2.hidden=YES;
        view3.hidden=YES;
        if (self.myblock) {
            self.myblock(0);
        }

    }else if(tap.view.tag==601)
    {
        view1.hidden=YES;
        view2.hidden=NO;
        view3.hidden=YES;
        if (self.myblock) {
            self.myblock(1);
        }
    }else
    {
        view1.hidden=YES;
        view2.hidden=YES;
        view3.hidden=NO;
        if (self.myblock) {
            self.myblock(2);
        }
    }
}
-(void)returnBlock:(fukuanblock)block
{
    self.myblock=block;
}
@end

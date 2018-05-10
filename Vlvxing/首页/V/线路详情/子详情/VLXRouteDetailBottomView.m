//
//  VLXRouteDetailBottomView.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXRouteDetailBottomView.h"

@implementation VLXRouteDetailBottomView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame: frame]) {
        self.backgroundColor=[UIColor whiteColor];

        [self createUI];
    }
    return self;
}
#pragma mark---数据
-(void)changeCollectStatus:(BOOL)status
{
    UILabel *titleLab=[self viewWithTag:501];
    if (status) {
        titleLab.text=@"已收藏";
    }else
    {
        titleLab.text=@"收藏";
    }
}
#pragma mark
#pragma mark---视图
-(void)createUI
{

    CGFloat bgWidth=ScaleWidth(62);
    NSArray *imageArray=@[@"consult-blue",@"collect-blue"];
    NSArray *titleArray=@[@"咨询",@"收藏"];
    for (int i=0; i<2; i++) {
        UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(i*bgWidth, 0, bgWidth, self.frame.size.height)];
        [self addSubview:bgView];
        UIImage *image=[UIImage imageNamed:imageArray[i]];
        UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake((bgWidth-image.size.width)/2, 7, image.size.width, image.size.height)];
        [iconImage setImage:image];
        [bgView addSubview:iconImage];
        UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImage.frame)+7, bgWidth, 11)];
        titleLab.text=titleArray[i];
        titleLab.textColor=blue_color;
        titleLab.tag=500+i;
        titleLab.font=[UIFont systemFontOfSize:11];
        titleLab.textAlignment=NSTextAlignmentCenter;
        [bgView addSubview:titleLab];
        //添加手势
        bgView.userInteractionEnabled=YES;
        bgView.tag=100+i;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToEvent:)];
        [bgView addGestureRecognizer:tap];
    }
    
    
    //分割线
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(bgWidth, 0, 0.5, self.frame.size.height)];
    line.backgroundColor=separatorColor1;
    [self addSubview:line];
    //
    UIButton *buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame=CGRectMake(bgWidth*2, 0, kScreenWidth-bgWidth*2, self.frame.size.height);
    [buyBtn setTitle:@"购买" forState:UIControlStateNormal];
    buyBtn.titleLabel.font=[UIFont systemFontOfSize:19];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.backgroundColor=orange_color;
    [buyBtn addTarget:self action:@selector(btnClickedToEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buyBtn];
    
}
#pragma mark
#pragma mark---事件
-(void)tapToEvent:(UITapGestureRecognizer *)tap
{
    NSLog(@"%ld",tap.view.tag);
    if (_bottomBlock) {
        _bottomBlock(tap.view.tag-100);
    }
}
-(void)btnClickedToEvent:(UIButton *)sender
{
    NSLog(@"btnClickedToEvent");
    if (_bottomBlock) {
        _bottomBlock(2);
    }
}


@end

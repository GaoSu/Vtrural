//
//  VLXUserCarHeaderView.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXUserCarHeaderView.h"
@interface VLXUserCarHeaderView ()
@property (nonatomic,assign)BOOL leftSelected;
@property (nonatomic,assign)BOOL rightSelected;
@end
@implementation VLXUserCarHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.frame=CGRectMake(0, 0, kScreenWidth, 44+8);
        self.backgroundColor=backgroun_view_color;
        _leftSelected=NO;
        _rightSelected=NO;
        [self createUI];
    }
    return self;
}
#pragma mark---数据
#pragma mark
#pragma mark---视图
-(void)createUI
{
    CGFloat width=kScreenWidth/2;
    NSArray *titleArray=@[@"综合排序",@"筛选"];
    for (int i=0; i<2; i++) {
        UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(width*i, 0, width, 44)];
        bgView.backgroundColor=[UIColor whiteColor];
        [self addSubview:bgView];
        //
        CGFloat contentWidth=60+5+10;
        UIButton *titleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame=CGRectMake((width-contentWidth)/2, (44-14)/2, 60, 14);
        [titleBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        titleBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [titleBtn setTitleColor:[UIColor hexStringToColor:@"#313131"] forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(btnClickedToEvent:) forControlEvents:UIControlEventTouchUpInside];
        titleBtn.tag=400+i;
        [bgView addSubview:titleBtn];
        //
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleBtn.frame)+5, 3+titleBtn.frame.origin.y, 10, 6)];
        [imageView setImage:[UIImage imageNamed:@"pull-down"]];
        imageView.tag=500+i;
        [bgView addSubview:imageView];
        
    }
}

#pragma mark
#pragma mark---事件
-(void)btnClickedToEvent:(UIButton *)sender
{
    NSLog(@"%ld",sender.tag);
    UIImageView *leftImageView=[self viewWithTag:500];
    UIImageView *rightImageView=[self viewWithTag:501];
    if (sender.tag-400==0) {//综合排序
        _leftSelected=!_leftSelected;
        if (_leftSelected) {
            [leftImageView setImage:[UIImage imageNamed:@"pull-down-red"]];
            
        }else{
            [leftImageView setImage:[UIImage imageNamed:@"pull-down"]];
        }
        //回调
        if (_carHeaderBlock) {
            _carHeaderBlock(1,!_leftSelected);
        }
        //
        _rightSelected=NO;
        [rightImageView setImage:[UIImage imageNamed:@"pull-down"]];//将右边设为默认
    }else if(sender.tag-400==1)//筛选
    {
        _rightSelected=!_rightSelected;
        if (_rightSelected) {
            [rightImageView setImage:[UIImage imageNamed:@"pull-down-red"]];
            
        }else{
            [rightImageView setImage:[UIImage imageNamed:@"pull-down"]];
        }
        //回调
        if (_carHeaderBlock) {
            _carHeaderBlock(2,!_rightSelected);
        }
        //
        _leftSelected=NO;
        [leftImageView setImage:[UIImage imageNamed:@"pull-down"]];//将左边设为默认
    }
}
//左边恢复默认
-(void)leftChangeToNormal
{
    UIImageView *leftImageView=[self viewWithTag:500];
    //
    _leftSelected=NO;
    [leftImageView setImage:[UIImage imageNamed:@"pull-down"]];//将左边设为默认
}
//右边恢复默认
-(void)rightChangeToNormal
{
    UIImageView *rightImageView=[self viewWithTag:501];
    //
    _rightSelected=NO;
    [rightImageView setImage:[UIImage imageNamed:@"pull-down"]];//将右边设为默认
}
//
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

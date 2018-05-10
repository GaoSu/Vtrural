//
//  VLXUnLoginHeaderView.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/18.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXUnLoginHeaderView.h"

@implementation VLXUnLoginHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:CGRectMake(0, 0, kScreenWidth, 195)]) {
        [self createUI];
    }
    return self;
}
#pragma mark---数据
#pragma mark
#pragma mark---视图
-(void)createUI
{
    self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"denglu-bg"]];
    UIButton *rigthBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rigthBtn.frame=CGRectMake(kScreenWidth-20-12, 32, 20, 20);
    [rigthBtn setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
    [rigthBtn setImage:[UIImage imageNamed:@"set"] forState:UIControlStateHighlighted];
    [rigthBtn addTarget:self action:@selector(rigthBtnClickedToEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rigthBtn];
    
    
    UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-75)/2, 43, 75, 75)];
    [iconImage setImage:[UIImage imageNamed:@"touxiang-moren"]];
    [self addSubview:iconImage];
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImage.frame)+14, kScreenWidth, 17.5)];
    titleLab.text=@"登录/注册";
    titleLab.font=[UIFont systemFontOfSize:19];
    titleLab.textColor=[UIColor hexStringToColor:@"#ffffff"];
    titleLab.textAlignment=NSTextAlignmentCenter;
    [self addSubview:titleLab];
    //添加手势
    iconImage.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToLogin:)];
    [iconImage addGestureRecognizer:tap];
    //
    UIView *marginView=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-8, kScreenWidth, 8)];
    marginView.backgroundColor=[UIColor hexStringToColor:@"#f3f3f4"];
    [self addSubview:marginView];
}
#pragma mark
#pragma mark---事件
-(void)rigthBtnClickedToEvent:(UIButton *)sender
{
    NSLog(@"rigthBtnClickedToEvent");
    if (_loginBlock) {
        _loginBlock(2);
    }
}
-(void)tapToLogin:(UITapGestureRecognizer *)tap
{
    NSLog(@"tapToLogin");
    if (_loginBlock) {
        _loginBlock(1);
    }
}
#pragma mark
#pragma mark---delegate
#pragma mark
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

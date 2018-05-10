//
//  VLXCourseAlertView.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/9.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXCourseAlertView.h"
@interface VLXCourseAlertView ()
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,assign)NSInteger type;
@end
@implementation VLXCourseAlertView
-(instancetype)initWithFrame:(CGRect)frame andType:(NSInteger)type
{
    if (self=[super initWithFrame:frame]) {
        _type=type;
        self.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.3];
        [self createUI];
        //添加背景点击手势
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCloseBtn)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
#pragma mark---数据
#pragma mark
#pragma mark---视图
-(void)createUI
{
    CGFloat bgWidth=ScaleWidth(320);
    CGFloat bgHeight=ScaleHeight(150);
    _bgView=[[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-bgWidth)/2, (kScreenHeight-bgHeight)/2, bgWidth, bgHeight)];
    _bgView.backgroundColor=[UIColor whiteColor];
    _bgView.layer.cornerRadius=8;
    _bgView.layer.masksToBounds=YES;
    [self addSubview:_bgView];
    UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _bgView.frame.size.width, ScaleHeight(44))];
    titleView.backgroundColor=orange_color;
    [_bgView addSubview:titleView];
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _bgView.frame.size.width, ScaleHeight(44))];
    titleLab.textColor=[UIColor whiteColor];
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.text=@"提示";
    titleLab.font=[UIFont systemFontOfSize:16];
    [titleView addSubview:titleLab];
    UILabel *contentLab=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), _bgView.frame.size.width, ScaleHeight(60))];
//    contentLab.text=@"确认结束运动?";
    if (_type==1) {
        contentLab.text=@"确认结束运动?";
    }else if (_type==2)
    {
        contentLab.text=@"确认删除?";
    }
    contentLab.font=[UIFont systemFontOfSize:16];
    contentLab.textColor=[UIColor hexStringToColor:@"#313131"];
    contentLab.textAlignment=NSTextAlignmentCenter;
    [_bgView addSubview:contentLab];
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(contentLab.frame), _bgView.frame.size.width, 0.5)];
    line.backgroundColor=separatorColor1;
    [_bgView addSubview:line];
    //
    NSArray *btnArray=@[@"取消",@"确认"];
    CGFloat width=_bgView.frame.size.width/2;
    for (int i=0; i<btnArray.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(width*i, CGRectGetMaxY(contentLab.frame), width, ScaleHeight(44));
        [btn setTitle:btnArray[i] forState:UIControlStateNormal];
        if (i==0) {
            [btn setTitleColor:[UIColor hexStringToColor:@"#666666"] forState:UIControlStateNormal];
        }else
        {
            [btn setTitleColor:orange_color forState:UIControlStateNormal];
        }
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
        btn.tag=100+i;
        [btn addTarget:self action:@selector(btnClickedToEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:btn];
    }
    
    
    
    
    
    
    
}
#pragma mark
#pragma mark---事件
-(void)clickCloseBtn
{
    [self removeFromSuperview];
}
-(void)btnClickedToEvent:(UIButton *)sender
{
    [self removeFromSuperview];
    NSLog(@"%ld",sender.tag);
    if (_courseBlock) {
        _courseBlock(sender.tag);
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

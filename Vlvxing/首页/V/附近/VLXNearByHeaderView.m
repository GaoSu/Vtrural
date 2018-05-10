//
//  VLXNearByHeaderView.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXNearByHeaderView.h"

@interface VLXNearByHeaderView ()
@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong)UIView *lineView;
@end
@implementation VLXNearByHeaderView
-(instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=backgroun_view_color;
        self.frame=CGRectMake(0, 0, kScreenWidth, 44+8);
        _titleArray=titleArray;
        [self createUI];
    }
    return self;
}
#pragma mark---数据
#pragma mark
#pragma mark---视图
-(void)createUI
{
    CGFloat width=kScreenWidth/_titleArray.count;
    for (int i=0; i<_titleArray.count; i++) {
        UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(i*width, 0, width, 44)];
        bgView.backgroundColor=[UIColor whiteColor];
        bgView.tag=700+i;
        [self addSubview:bgView];
        UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
        titleLab.text=[ZYYCustomTool checkNullWithNSString:_titleArray[i]];
        titleLab.tag=800+i;
        if (i==0) {
            titleLab.textColor=orange_color;
            
        }else
        {
            titleLab.textColor=[UIColor hexStringToColor:@"#313131"];
        }
        titleLab.textAlignment=NSTextAlignmentCenter;
        titleLab.font=[UIFont systemFontOfSize:16];
        [bgView addSubview:titleLab];
        //添加手势
        bgView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToEvent:)];
        [bgView addGestureRecognizer:tap];
    }
    //底部红线
    _lineView=[[UIView alloc] initWithFrame:CGRectMake(0, 44-2, width, 2)];
    _lineView.backgroundColor=orange_color;
    [self addSubview:_lineView];
}
#pragma mark
#pragma mark---事件
-(void)tapToEvent:(UITapGestureRecognizer *)tap
{
    CGFloat width=kScreenWidth/_titleArray.count;
    NSLog(@"%ld",tap.view.tag);
    UILabel *currentLab=[self viewWithTag:tap.view.tag+100];
    currentLab.textColor=orange_color;
    for (int i=0; i<_titleArray.count; i++) {
        UILabel *lab=[self viewWithTag:800+i];
        if (tap.view.tag==i+700) {
            
        }else
        {
            lab.textColor=[UIColor hexStringToColor:@"313131"];
        }
    }
    [UIView animateWithDuration:0.28 animations:^{
        _lineView.frame=CGRectMake((tap.view.tag-700)*width, _lineView.frame.origin.y, _lineView.frame.size.width, _lineView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    if (_nearBlock) {
        _nearBlock(tap.view.tag-700);
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

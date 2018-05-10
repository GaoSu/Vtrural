//
//  VLXHomeSelectHeaderView.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/19.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXHomeSelectHeaderView.h"
@interface VLXHomeSelectHeaderView ()

@property (nonatomic,strong)UIView *lineView;

@end
@implementation VLXHomeSelectHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        self.frame=CGRectMake(0, 0, kScreenWidth, 48.5);
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    
    //
    CGFloat bgWidth=68+22*2;
    CGFloat titleWidth=68;
    //
    CGFloat margin=(kScreenWidth-bgWidth*2)/2;
    //
    UIView *centerView=[[UIView alloc] initWithFrame:CGRectMake(margin, 0, kScreenWidth-margin*2, self.frame.size.height)];

    [self addSubview:centerView];
    
    NSArray *titleArray=@[@"当季游玩",@"热门推荐"];
    for (int i=0; i<2; i++) {
        UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(i*bgWidth, 0, bgWidth, CGRectGetHeight(centerView.frame))];
        [centerView addSubview:bgView];
        UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake((bgWidth-titleWidth)/2, 11.5, titleWidth, 15.5)];
        titleLab.text=titleArray[i];
        titleLab.font=[UIFont systemFontOfSize:16];
        titleLab.textAlignment=NSTextAlignmentCenter;
        titleLab.tag=200+i;
        if (i==0) {
//            titleLab.tag=201;
            titleLab.textColor=orange_color;
            //底部红线
            _lineView=[[UIView alloc] initWithFrame:CGRectMake((bgWidth-32)/2, CGRectGetMaxY(titleLab.frame)+7.5, 32, 2)];
            _lineView.backgroundColor=orange_color;
            [centerView addSubview:_lineView];
        }else
        {
//            titleLab.tag=200;
            titleLab.textColor=[UIColor hexStringToColor:@"#2c2c2c"] ;
        }
        [bgView addSubview:titleLab];
        //添加手势
        bgView.userInteractionEnabled=YES;
        bgView.tag=100+i;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToEvent:)];
        [bgView addGestureRecognizer:tap];
        
        
    }
    

    
    



}
#pragma mark---事件
-(void)tapToEvent:(UITapGestureRecognizer *)tap
{

    
    UILabel *titleLab1=[self viewWithTag:200];
    UILabel *titleLab2=[self viewWithTag:201];
    CGFloat bgWidth=68+22*2;
    if (tap.view.tag==100) {
        titleLab1.textColor=orange_color;
        titleLab2.textColor=[UIColor hexStringToColor:@"#2c2c2c"];

        //设置动画
        [UIView animateWithDuration:0.28 animations:^{
            _lineView.frame=CGRectMake((bgWidth-32)/2, _lineView.frame.origin.y, 32, 2);
        } completion:^(BOOL finished) {
            
        }];
    }else if(tap.view.tag==101)
    {
        titleLab1.textColor=[UIColor hexStringToColor:@"#2c2c2c"];
        titleLab2.textColor=orange_color;
        //设置动画
        [UIView animateWithDuration:0.28 animations:^{
            _lineView.frame=CGRectMake(bgWidth+(bgWidth-32)/2, _lineView.frame.origin.y, 32, 2);
        } completion:^(BOOL finished) {
            
        }];
    }
    //回调
    if (_headerBlock) {
        _headerBlock(tap.view.tag-100);
    }
}

#pragma mark
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  VLXRouteSelectView.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXRouteSelectView.h"
@interface VLXRouteSelectView ()
@property (nonatomic,strong)UIView *titleView;
@end
@implementation VLXRouteSelectView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    _titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    
    [self addSubview:_titleView];
    CGFloat btnWidth=kScreenWidth/3;
    NSArray *titleArray=@[@"产品特色",@"费用说明",@"预定须知"];
    for (int i=0; i<3; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(i*btnWidth, 0, btnWidth, CGRectGetHeight(_titleView.frame));
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:16];
        if (i==0) {
            [btn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor=blue_color;
        }else
        {
            [btn  setTitleColor:[UIColor hexStringToColor:@"#666666"] forState:UIControlStateNormal];
            btn.backgroundColor=[UIColor whiteColor];
        }
        [_titleView addSubview:btn];
        btn.tag=100+i;
        [btn addTarget:self action:@selector(btnClickedToEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
}
#pragma mark---事件
-(void)btnClickedToEvent:(UIButton *)sender
{
    NSLog(@"%ld",sender.tag);
    for (int i=0; i<3; i++) {
        UIButton *btn=[self viewWithTag:i+100];
        if (sender.tag==100+i) {
            [btn setBackgroundColor:blue_color];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else
        {
            [btn  setTitleColor:[UIColor hexStringToColor:@"#666666"] forState:UIControlStateNormal];
            btn.backgroundColor=[UIColor whiteColor];
        }
    }
    if (_selectBlock) {
        _selectBlock(sender.tag-100);
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

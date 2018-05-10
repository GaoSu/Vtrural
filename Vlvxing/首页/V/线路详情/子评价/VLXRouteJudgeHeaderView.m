//
//  VLXRouteJudgeHeaderView.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXRouteJudgeHeaderView.h"

@implementation VLXRouteJudgeHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=backgroun_view_color;
        self.frame=CGRectMake(0, 0, kScreenWidth, 48+8);
        [self createUI];
    }
    return self;
}
#pragma mark---数据
-(void)createUIWithModel:(VLXHomeJudgeModel *)model
{
    NSArray *titleArray=@[@"全部",@"好评",@"中评",@"差评"];
    NSArray *numberArray=@[[NSString stringWithFormat:@"%@",model.data.allCounts],[NSString stringWithFormat:@"%@",model.data.goodCounts],[NSString stringWithFormat:@"%@",model.data.averageCounts],[NSString stringWithFormat:@"%@",model.data.badCounts]];
    for (int i=0; i<4; i++) {
        UIButton *btn=[self viewWithTag:100+i];
        [btn setTitle:[NSString stringWithFormat:@"%@ (%@)",titleArray[i],numberArray[i]] forState:UIControlStateNormal];
    }
}
#pragma mark
#pragma mark---视图
-(void)createUI
{
    
    UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 48)];
    bgView.backgroundColor=[UIColor whiteColor];
    [self addSubview:bgView];
    
    CGFloat width=ScaleWidth(80);
    CGFloat margin=(kScreenWidth-width*4)/5;
    NSArray *titleArray=@[@"全部",@"好评",@"中评",@"差评"];
    NSArray *numberArray=@[@"",@"",@"",@""];
    for (int i=0; i<4; i++) {
        UIView *btnView=[[UIView alloc] initWithFrame:CGRectMake(margin+(margin+width)*i, (48-28)/2, width, 28)];
        btnView.backgroundColor=[UIColor whiteColor];
        [bgView addSubview:btnView];
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(0, 0, btnView.frame.size.width, btnView.frame.size.height);
        [btn setTitle:[NSString stringWithFormat:@"%@ (%@)",titleArray[i],numberArray[i]] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        if (i==0) {
            btn.backgroundColor=red_color;
            btn.layer.borderWidth=1;
            btn.layer.borderColor=orange_color.CGColor;
            [btn setTitleColor:orange_color forState:UIControlStateNormal];
        }
        else
        {
            btn.backgroundColor=[UIColor whiteColor];
            btn.layer.borderWidth=1;
            btn.layer.borderColor=[UIColor colorWithHexString:@"#dddddd"].CGColor;
            [btn setTitleColor:[UIColor hexStringToColor:@"#666666"] forState:UIControlStateNormal];
        }
        [btnView addSubview:btn];
        //
        btn.tag=100+i;
        [btn addTarget:self action:@selector(btnClickedToEvent:) forControlEvents:UIControlEventTouchUpInside];
        //

    }

}
#pragma mark
#pragma mark---事件
-(void)btnClickedToEvent:(UIButton *)sender
{
    //
    for (int i=0; i<4; i++) {
        UIButton *btn=[self viewWithTag:100+i];
        if (sender.tag==100+i) {
            btn.backgroundColor=red_color;
            btn.layer.borderWidth=1;
            btn.layer.borderColor=orange_color.CGColor;
            [btn setTitleColor:orange_color forState:UIControlStateNormal];
        }else
        {
            btn.backgroundColor=[UIColor whiteColor];
            btn.layer.borderWidth=1;
            btn.layer.borderColor=[UIColor colorWithHexString:@"#dddddd"].CGColor;
            [btn setTitleColor:[UIColor hexStringToColor:@"#666666"] forState:UIControlStateNormal];
        }
    }
    //回调
    if (_judgeBlock) {
        _judgeBlock(sender.tag-100);
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

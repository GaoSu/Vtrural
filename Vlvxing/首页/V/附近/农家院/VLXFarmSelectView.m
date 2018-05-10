//
//  VLXFarmSelectView.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXFarmSelectView.h"
#define rowHeight 96/2
@interface VLXFarmSelectView ()
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)NSArray *titleArray;
@end
@implementation VLXFarmSelectView
-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSArray *)titleArray
{
    if (self=[super initWithFrame:frame]) {

        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        _titleArray=titleArray;
        [self createUI];
    }
    return self;
}
#pragma mark---数据
-(void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex=currentIndex;
    for (int i=0; i<_titleArray.count; i++) {
        UIImageView *imageView=[self viewWithTag:300+i];
        if (currentIndex==i) {
            imageView.hidden=NO;
        }else
        {
            imageView.hidden=YES;
        }
    }
}
#pragma mark
#pragma mark---视图
-(void)createUI
{
    _bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, rowHeight*_titleArray.count)];
    _bgView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_bgView];
    for (int i=0; i<_titleArray.count; i++) {
        UIButton *titleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame=CGRectMake(11.5, rowHeight*i, kScreenWidth-11.5, rowHeight);
        
        [titleBtn setTitle:[ZYYCustomTool checkNullWithNSString:_titleArray[i]] forState:UIControlStateNormal];
        titleBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [titleBtn setTitleColor:[UIColor hexStringToColor:@"#111111"] forState:UIControlStateNormal];
        titleBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        titleBtn.tag=200+i;
        [titleBtn addTarget:self action:@selector(btnClickedToEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:titleBtn];
        //
        UIImageView *chooseImage=[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-12.5-15, (rowHeight-10)/2+rowHeight*i, 15, 10)];
        [chooseImage setImage:[UIImage imageNamed:@"pitch-on"]];
        [_bgView addSubview:chooseImage];
        chooseImage.tag=300+i;
        chooseImage.hidden=YES;
        if (i==0) {
            chooseImage.hidden=NO;
        }
    }
}
#pragma mark
#pragma mark---事件
-(void)btnClickedToEvent:(UIButton *)sender
{
    NSLog(@"%ld",sender.tag);
    for (int i=0; i<_titleArray.count; i++) {
        UIImageView *imageView=[self viewWithTag:300+i];
        if (sender.tag-200==i) {
            imageView.hidden=NO;
        }else
        {
            imageView.hidden=YES;
        }
    }
    //回调
    if (_selectBlock) {
        _selectBlock(sender.tag-200);
    }
    //
    self.hidden=YES;

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.hidden=YES;
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

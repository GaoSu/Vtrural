//
//  VLXJudgeHeaderView.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/8.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXJudgeHeaderView.h"
@interface VLXJudgeHeaderView ()
@property(nonatomic,strong) UILabel *promptTitle;
@end
@implementation VLXJudgeHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.frame=CGRectMake(0, 0, kScreenWidth, 219);
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    CGFloat width=kScreenWidth/3;
    NSArray *titleArray=@[@"好评",@"中评",@"差评"];
    for (int i=0; i<3; i++) {
        UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(i*width, 0, width, 74)];
        [self addSubview:bgView];
        UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(35, (bgView.frame.size.height-16)/2, 35, 16)];
        titleLab.text=titleArray[i];
        titleLab.font=[UIFont systemFontOfSize:16];
        titleLab.textColor=[UIColor hexStringToColor:@"#313131"];
        [bgView addSubview:titleLab];
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(CGRectGetMaxX(titleLab.frame)+2, (bgView.frame.size.height-20)/2, 20, 20);
        btn.tag=100+i;
        if (i==0) {
            [btn setImage:[UIImage imageNamed:@"pitch-on2"] forState:UIControlStateNormal];
        }else
        {
            [btn setImage:[UIImage imageNamed:@"default-red"] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(btnClickedToEvent:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
    }
    //
    _textView=[[UITextView alloc] initWithFrame:CGRectMake(12, 74, kScreenWidth-12*2, 120)];
    _textView.layer.cornerRadius=5;
    _textView.layer.masksToBounds=YES;
    _textView.layer.borderColor=[UIColor hexStringToColor:@"#999999"].CGColor;
    _textView.layer.borderWidth=0.5;
    _textView.delegate=self;
    [self addSubview:_textView];
    //
    //创建Label 加提示语
    self.promptTitle = [[UILabel alloc]initWithFrame:CGRectMake(5,5,200,20)];
    self.promptTitle.text = @"10~500字的评价";
    self.promptTitle.font = [UIFont systemFontOfSize:14.0];
    self.promptTitle.textColor=[UIColor hexStringToColor:@"#666666"];
    [self.textView addSubview:self.promptTitle];
}
-(void)btnClickedToEvent:(UIButton *)sender
{
    NSLog(@"%ld",sender.tag);
    for (int i=0; i<3; i++) {
        UIButton *btn=[self viewWithTag:100+i];
        if (sender.tag==100+i) {
            [btn setImage:[UIImage imageNamed:@"pitch-on2"] forState:UIControlStateNormal];
        }else
        {
            [btn setImage:[UIImage imageNamed:@"default-red"] forState:UIControlStateNormal];
        }
    }
    if (_judgeBlock) {
        _judgeBlock(sender.tag-100+1);
    }
}
#pragma mark---textView delegate
//判断是否超出最大限额 500
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"%@",text);
    if ([text isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
        return YES;
    }
    else {
        if (textView.text.length - range.length + text.length > 500) {
            [SVProgressHUD showInfoWithStatus:@"最多可评价500字!"];
            return NO;
        }
        else {
            return YES;
        }
    }
}
-(void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length>0)
    {
        _promptTitle.hidden = YES;
    }
    else
    {
        _promptTitle.hidden =NO;
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

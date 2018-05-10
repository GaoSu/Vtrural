//
//  TimePickerView.m
//  zichanguanli
//
//  Created by RWN on 17/3/6.
//  Copyright © 2017年 handongkeji. All rights reserved.
//

#import "TimePickerView.h"

@interface TimePickerView ()

@property(nonatomic,strong) UIButton *MBbutton;
@property(nonatomic,strong) UIDatePicker *datepicker;
@property(nonatomic,strong) UILabel *picerTItle;


@end


@implementation TimePickerView


-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        
        self.frame=CGRectMake(0, 0, ScreenSize.width, ScreenSize.height);
        [self setupUI];
        
    }
    return self;
}

-(void)setupUI{

    //添加蒙版
    UIButton *MBbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height)];
    MBbutton.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self addSubview:MBbutton];
    [MBbutton addTarget:self action:@selector(topMBbutton) forControlEvents:UIControlEventTouchUpInside];
    
    
    //创建一个view(承载时间选择器)
    CGFloat DatePickerviewW=ScreenSize.width;
    CGFloat DatePickerviewH=260;
    CGFloat DatePickerviewX=0;
    CGFloat DatePickerviewY=(ScreenSize.height-DatePickerviewH);
    UIView *DatePickerview=[[UIView alloc]initWithFrame:CGRectMake(DatePickerviewX, DatePickerviewY, DatePickerviewW, DatePickerviewH)];
    DatePickerview.backgroundColor=[UIColor whiteColor];
    DatePickerview.layer.cornerRadius = 7;
    [MBbutton addSubview:DatePickerview];
    self.MBbutton=MBbutton;

    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:DatePickerview.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = DatePickerview.bounds;
    maskLayer.path = maskPath.CGPath;
    DatePickerview.layer.mask = maskLayer;
    
    //添加顶部的View
    UIView *TopView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenSize.width, 44)];
    TopView.backgroundColor=[UIColor hexStringToColor:@"f5f5f5"];
    [DatePickerview addSubview:TopView];
    
    //添加确定取消按钮
    //1 取消
    CGFloat picerCencelY=15;
    CGFloat picerCencelW=50;
    CGFloat picerCencelH=17;
    CGFloat picerCencelX=15;
    UIButton *picerCencel=[[UIButton alloc]initWithFrame:CGRectMake(picerCencelX, picerCencelY, picerCencelW, picerCencelH)];
    [picerCencel setTitle:@"取消" forState:UIControlStateNormal];
    [picerCencel setTitleColor:[UIColor hexStringToColor:@"#509EEE"] forState:UIControlStateNormal];
    picerCencel.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:17];
    picerCencel.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [DatePickerview addSubview:picerCencel];
    [picerCencel addTarget:self action:@selector(topNO:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *RWNTitle=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(picerCencel.frame), 0, kScreenWidth-130, 45)];
    RWNTitle.textColor=[UIColor hexStringToColor:@"#999999"];
    RWNTitle.textAlignment=NSTextAlignmentCenter;
    RWNTitle.font=[UIFont fontWithName:@"PingFangSC-Regular" size:17];
    RWNTitle.text=self.title;
    [DatePickerview addSubview:RWNTitle];
    self.picerTItle=RWNTitle;
    
    //1 确定
    CGFloat picerYesY=15;
    CGFloat picerYesW=50;
    CGFloat picerYesH=17;
    CGFloat picerYesX=ScreenSize.width-15-picerYesW;
    UIButton *picerYes=[[UIButton alloc]initWithFrame:CGRectMake(picerYesX, picerYesY, picerYesW, picerYesH)];
    [picerYes setTitle:@"确定" forState:UIControlStateNormal];
    [picerYes setTitleColor:[UIColor hexStringToColor:@"#509EEE"] forState:UIControlStateNormal];
    picerYes.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:17];
    picerYes.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [DatePickerview addSubview:picerYes];
    [picerYes addTarget:self action:@selector(tapSure:) forControlEvents:UIControlEventTouchUpInside];

    //添加时间选择器
    CGFloat datepickerW=DatePickerviewW;
    CGFloat datepickerH=260-44;
    CGFloat datepickerX=0;
    CGFloat datepickerY=44;
    UIDatePicker * datepicker =[[UIDatePicker alloc]init];
    datepicker.frame=CGRectMake(datepickerX, datepickerY, datepickerW, datepickerH);
    //时间选择器模式
    datepicker.datePickerMode=UIDatePickerModeDate;
    datepicker.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.07];
    //初始化时间格式
    NSDateFormatter * dateform=[[NSDateFormatter alloc]init];
    
    NSString * str =@"1970-01-02";
    //时间格式
    [dateform setDateFormat:@"yyyy-MM-dd"];
    //时间从那一天开始
//    NSDate * date =[dateform dateFromString:str];
    //获取现在的时间
    NSDate * date1= [NSDate date];
    //时间选择器的最小时间
    datepicker.minimumDate=date1;
    //时间选择器的最大时间
//    datepicker.maximumDate=date1;
    datepicker.date=date1;
    [DatePickerview addSubview:datepicker];
    self.datepicker=datepicker;

}


//点击蒙版
-(void)topMBbutton
{
    [self.MBbutton removeFromSuperview];
    [self removeFromSuperview];
}

//点击取消
- (void)topNO:(UIButton *)sender {
    
    [self.MBbutton removeFromSuperview];
    [self removeFromSuperview];
}


-(void)setTitle:(NSString *)title{

    _title=title;
    self.picerTItle.text=title;

}


#pragma mark DatePicker选定值处理
- (void)tapSure:(UIButton *)sender {
    NSDate *selectedDate = self.datepicker.date;
    NSString *timeSp = [NSString stringWithFormat:@"%lld", (long long)[selectedDate timeIntervalSince1970] *1000];    
    NSString *time = [timeSp RwnTimeExchange];
    
    
    if (self.clickTime) {
        self.clickTime(time);
    }
    
    [self.MBbutton removeFromSuperview];
    [self removeFromSuperview];
//    [self saveUserInfoKey:@"userBirthday" value:[NSString stringWithFormat:@"%@",timeSp]];
//
//    [self.tab reloadData];
}


@end

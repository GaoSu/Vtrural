//
//  VLXSelectDateView.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/31.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXSelectDateView.h"
@interface VLXSelectDateView ()
@property (nonatomic,copy)NSString *dateStr;//年月日
@end
@implementation VLXSelectDateView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [self createUI];
    }
    return self;
}
#pragma mark---数据
#pragma mark
#pragma mark---视图
-(void)createUI
{
    //日历
    _calendar=[[FSCalendar alloc] initWithFrame:CGRectMake(0, self.frame.size.height-300, kScreenWidth, 300)];
    _calendar.backgroundColor=[UIColor whiteColor];
    _calendar.dataSource=self;
    _calendar.delegate=self;
    _calendar.appearance.headerTitleColor=orange_color;//设置月份颜色
    _calendar.appearance.headerDateFormat=@"yyyy-MM";
    _calendar.appearance.weekdayTextColor=orange_color;//设置星期颜色
    _calendar.appearance.todayColor=orange_color;//设置当日颜色
    _calendar.appearance.selectionColor=[UIColor orangeColor];
    _calendar.scrollDirection=UICollectionViewScrollDirectionVertical;
    [self addSubview:_calendar];
}
#pragma mark
#pragma mark---事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
#pragma mark
#pragma mark---FSCalendar delegate
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date//点击事件
{


    _dateStr=[calendar stringFromDate:date format:@"yyyy-MM-dd"];
    NSLog(@"%@",_dateStr);
    if (self.dateBlock) {
        _dateBlock(_dateStr);
    }
    [self removeFromSuperview];
    
}
-(BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date//是否允许选中
{

    NSInteger flag=[NSDate compareOneDay:date withAnotherDay:[NSDate date]];
    if (flag==-1||flag==0) {
        [SVProgressHUD showErrorWithStatus:@"请选择今天之后的日期!"];
        return NO;
    }
    return YES;
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

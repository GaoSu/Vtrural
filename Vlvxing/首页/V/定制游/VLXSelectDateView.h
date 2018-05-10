//
//  VLXSelectDateView.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/31.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^dateBlock)(NSString *dateStr);
@interface VLXSelectDateView : UIView<FSCalendarDelegate,FSCalendarDataSource>
@property (nonatomic,strong)FSCalendar *calendar;//日历
@property (nonatomic,copy)dateBlock dateBlock;
@end

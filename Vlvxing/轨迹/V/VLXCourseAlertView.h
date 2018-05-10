//
//  VLXCourseAlertView.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/9.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^courseBlock)(NSInteger  tag);
@interface VLXCourseAlertView : UIView
-(instancetype)initWithFrame:(CGRect)frame andType:(NSInteger)type;//1 是否保存当前v点样式
@property (nonatomic,copy)courseBlock courseBlock;
@end

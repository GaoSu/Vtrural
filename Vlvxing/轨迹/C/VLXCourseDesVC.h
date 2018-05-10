//
//  VLXCourseDesVC.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/9.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^desBlock)(NSString *titleStr,NSString *desStr);
@interface VLXCourseDesVC : BaseViewController
@property (nonatomic,copy)desBlock desBlock;
@end

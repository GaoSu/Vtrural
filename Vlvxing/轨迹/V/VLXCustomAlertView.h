//
//  VLXCustomAlertView.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/6.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^alertBlock)(NSInteger index);
@interface VLXCustomAlertView : UIView
-(instancetype)initWithTitle:(NSString *)title andContent1:(NSString *)content1 andContent2:(NSString *)content2;
@property (nonatomic,copy)alertBlock alertBlock;
@end

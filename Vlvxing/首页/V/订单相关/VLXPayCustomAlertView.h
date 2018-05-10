//
//  VLXPayCustomAlertView.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/9.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^payTypeBlock)(NSInteger tag);
@interface VLXPayCustomAlertView : UIView
-(instancetype)initWithFrame:(CGRect)frame andPayMoney:(float)payMoney;
@property (nonatomic,copy)payTypeBlock payTypeBlock;
@end

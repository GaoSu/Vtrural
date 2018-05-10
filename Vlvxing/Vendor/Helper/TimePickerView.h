//
//  TimePickerView.h
//  zichanguanli
//
//  Created by RWN on 17/3/6.
//  Copyright © 2017年 handongkeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimePickerView : UIView

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)void(^clickTime)(NSString *seletedTime);

@end

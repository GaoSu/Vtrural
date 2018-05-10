//
//  VLXRouteSelectView.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^selectBlock)(NSInteger  index);
@interface VLXRouteSelectView : UIView
@property (nonatomic,copy)selectBlock selectBlock;
@end

//
//  VLXRouteDetailBottomView.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^bottomBlock)(NSInteger index);
@interface VLXRouteDetailBottomView : UIView
@property (nonatomic,copy)bottomBlock bottomBlock;
-(void)changeCollectStatus:(BOOL)status;//改变收藏状态
@end

//
//  VLXFarmHeaderView.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^farmHeaderBlock)(NSInteger index,BOOL isSelected);
@interface VLXFarmHeaderView : UIView
@property (nonatomic,copy)farmHeaderBlock farmHeaderBlock;//1   2
-(void)leftChangeToNormal;//左边恢复默认
-(void)rightChangeToNormal;//右边恢复默认
@end

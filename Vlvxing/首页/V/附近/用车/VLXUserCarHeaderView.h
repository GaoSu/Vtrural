//
//  VLXUserCarHeaderView.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^carHeaderBlock)(NSInteger index,BOOL isSelected);
@interface VLXUserCarHeaderView : UIView
-(void)leftChangeToNormal;//左边恢复默认
-(void)rightChangeToNormal;//右边恢复默认
@property (nonatomic,copy)carHeaderBlock carHeaderBlock;
@end

//
//  VLXNearByHeaderView.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^nearBlock)(NSInteger index);
@interface VLXNearByHeaderView : UIView
-(instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray;
@property (nonatomic,copy)nearBlock nearBlock;
@end

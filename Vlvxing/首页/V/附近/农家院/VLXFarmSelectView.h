//
//  VLXFarmSelectView.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^selectBlock)(NSInteger index);
@interface VLXFarmSelectView : UIView
@property (nonatomic,copy)selectBlock selectBlock;
-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSArray *)titleArray;
@property (nonatomic,assign)NSInteger currentIndex;//当前选中序号
@end

//
//  VLXMenuPopView.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/15.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^menuBlock)(NSInteger index);
@interface VLXMenuPopView : UIView
-(instancetype)initWithFrame:(CGRect)frame andType:(NSInteger)type;//1.分享 删除 2分享 编辑 删除 3 删除
@property (nonatomic,copy)menuBlock menuBlock;
@end

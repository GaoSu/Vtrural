//
//  VLXOrderFooterView.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/5.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^btnBlock)(NSInteger tag);
@interface VLXOrderFooterView : UIView
-(instancetype)initWithFrame:(CGRect)frame andType:(NSInteger )type andPrice:(NSString *)price;//0 待支付 1 已支付，2已评价,3已取消
@property (nonatomic,copy)btnBlock btnBlock;
@end

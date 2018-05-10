//
//  VLXHomeSelectHeaderView.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/19.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^headerBlock)(NSInteger index);
@interface VLXHomeSelectHeaderView : UIView
@property (nonatomic,copy)headerBlock headerBlock;
@end

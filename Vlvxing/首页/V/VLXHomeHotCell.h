//
//  VLXHomeHotCell.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/19.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLXHomeHotModel.h"
typedef void(^homeHotBlock)(NSInteger index);
@interface VLXHomeHotCell : UITableViewCell
@property (nonatomic,copy)homeHotBlock homeHotBlock;
-(void)createUIWithModel:(VLXHomeHotModel *)model;
@end

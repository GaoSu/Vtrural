//
//  VLXHomeHeaderCell.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/19.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLXVHeadModel.h"

typedef void(^topBlock)(NSInteger index);
typedef void(^centerBlock)();
typedef void(^bottomBlock)(NSInteger index);

@interface VLXHomeHeaderCell : UITableViewCell
@property (nonatomic,copy)topBlock topBlock;//附近 国内 境外 发现景点 更多
@property (nonatomic,copy)centerBlock centerBlock;//v头条
@property (nonatomic,copy)bottomBlock bottomBlock;//火车票 机票 定制票 用车
-(void)createUIWithData:(VLXVHeadModel *)vModel;
@end

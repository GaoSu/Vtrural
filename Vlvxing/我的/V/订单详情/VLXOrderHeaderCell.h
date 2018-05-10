//
//  VLXOrderHeaderCell.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/5.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "VLXMyOrderModel.h"
#import "VLXOrderDetailModel.h"
@interface VLXOrderHeaderCell : UITableViewCell
-(void)createUIWithModel:(VLXOrderDetailDataModel *)model;
@end

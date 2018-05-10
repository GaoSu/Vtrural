//
//  VLXRecordMarkCell.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/3.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLXRecordDetailModel.h"
typedef void(^cellBlock)();
@interface VLXRecordMarkCell : UITableViewCell
-(void)createUIWithModel:(VLXRecordDetailInfoModel *)model;
@property (nonatomic,copy)cellBlock cellBlock;
@end

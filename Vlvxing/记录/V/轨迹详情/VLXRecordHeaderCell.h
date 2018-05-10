//
//  VLXRecordHeaderCell.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/3.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLXRecordDetailModel.h"
typedef void(^addressBlock)();
@interface VLXRecordHeaderCell : UITableViewCell
-(void)createUIWithModel:(VLXRecordDetailDataModel *)model;
@property (nonatomic,copy)addressBlock addressBlock;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHeight;

@end

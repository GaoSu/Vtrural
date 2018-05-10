//
//  VLXDomesticHotCell.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLXHotDemesticModel.h"
typedef void(^hotBlock)(NSInteger index,BOOL isMore);//index 序号 isMore 是否最后一个  表示更多
@interface VLXDomesticHotCell : UITableViewCell
-(void)createUIWithData:(NSArray *)dataArray andType:(NSInteger)type;//1.国内  2.境外游
@property (nonatomic,copy)hotBlock hotBlock;
@end

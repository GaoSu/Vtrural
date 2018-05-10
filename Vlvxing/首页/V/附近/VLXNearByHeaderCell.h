//
//  VLXNearByHeaderCell.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^headBlock)(NSInteger index);
@interface VLXNearByHeaderCell : UITableViewCell
@property (nonatomic,copy)headBlock headBlock;
@end

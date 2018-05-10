//
//  VLX_riliCollectionViewCell.h
//  Vlvxing
//
//  Created by grm on 2017/10/12.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VLX_riliCollectionViewCell : UICollectionViewCell




@property (nonatomic,strong)NSString * dateStr;//日期
@property (nonatomic,strong)NSString * xingqiStr;//星期
@property (nonatomic,strong)NSString * jiageStr;//价格

@property (nonatomic,strong)UILabel * dateLb;
@property (nonatomic,strong)UILabel * xingqiLb;
@property (nonatomic,strong)UILabel * jiageLb;

@end

//
//  VLX_riliCollectionViewCell.m
//  Vlvxing
//
//  Created by grm on 2017/10/12.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_riliCollectionViewCell.h"

@implementation VLX_riliCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self ui];
    }
    return self;
}

-(void)ui
{
    _dateLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, ScreenWidth/5, 12)];
    _dateLb.text = @"12-31";
    _dateLb.textAlignment = NSTextAlignmentCenter;
    _dateLb.textColor = [UIColor whiteColor];
    _dateLb.font = [UIFont systemFontOfSize:12];
    
    
    _xingqiLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth/5, 12)];
    _xingqiLb.text = @"周一";
    _xingqiLb.textAlignment = NSTextAlignmentCenter;
    _xingqiLb.textColor = [UIColor whiteColor];
    _xingqiLb.font = [UIFont systemFontOfSize:12];
    
    _jiageLb = [[UILabel alloc]initWithFrame:CGRectMake(12, 54, 50, 12)];
    _jiageLb.text = @"¥998";
    _jiageLb.textColor = [UIColor whiteColor];
    _jiageLb.font = [UIFont systemFontOfSize:12];
    
    
    [self.contentView addSubview:_dateLb];
    [self.contentView addSubview:_xingqiLb];
    //    [self.contentView addSubview:_jiageLb];

}

@end

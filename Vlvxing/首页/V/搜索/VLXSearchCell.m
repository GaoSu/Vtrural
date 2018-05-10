//
//  VLXSearchCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXSearchCell.h"

@implementation VLXSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLab.layer.cornerRadius=4;
    _titleLab.layer.masksToBounds=YES;
    _titleLab.textColor=[UIColor hexStringToColor:@"#313131"];
    _titleLab.layer.borderWidth=0.5;
    _titleLab.layer.borderColor=[UIColor hexStringToColor:@"#999999"].CGColor;
}

@end

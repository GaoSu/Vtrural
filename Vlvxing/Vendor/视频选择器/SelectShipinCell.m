//
//  SelectShipinCell.m
//  yinxin
//
//  Created by handong001 on 16/11/4.
//  Copyright © 2016年 RWN. All rights reserved.
//

#import "SelectShipinCell.h"

@implementation SelectShipinCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.mainContentImg.userInteractionEnabled=YES;
    self.shipinIcon.userInteractionEnabled=YES;
    
    
    
}

-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if (isSelect) {
        _isSelectImg.hidden = NO;
    }else{
        _isSelectImg.hidden = YES;
    }
}

@end

//
//  RightButton.m
//  ShiTingBang
//
//  Created by Michael on 16/10/27.
//  Copyright © 2016年 shitingbang. All rights reserved.
//

#import "RightButton.h"

@implementation RightButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(tapRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)tapRightBtn:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickRightButton:)]) {
        [self.delegate clickRightButton:button];
    }
}

@end

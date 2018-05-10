//
//  LeftButton.m
//  ShiTingBang
//
//  Created by Michael on 16/10/27.
//  Copyright © 2016年 shitingbang. All rights reserved.
//

#import "LeftButton.h"

@implementation LeftButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = (CGRect){{0,0},{17,18}};
        [self setImage:[UIImage imageNamed:@"icon_fanhui"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(tapLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)tapLeftBtn:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickLeftButton:)]) {
        [self.delegate clickLeftButton:button];
    }
}

@end

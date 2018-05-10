//
//  LeftButtonItem.m
//  ShiTingBang
//
//  Created by Michael on 16/10/26.
//  Copyright © 2016年 shitingbang. All rights reserved.
//

#import "LeftButtonItem.h"

@implementation LeftButtonItem

- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(nullable id)target action:(nullable SEL)action
{
    self = [super initWithBarButtonSystemItem:systemItem target:target action:action];
    if (self) {
        self.width = -5;
    }
    return self;
}

@end

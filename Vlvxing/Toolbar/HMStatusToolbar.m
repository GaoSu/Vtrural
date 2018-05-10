//
//  HMStatusToolbar.m
//  XingJu
//
//  Created by apple on 14-7-14.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMStatusToolbar.h"

@interface HMStatusToolbar()
@property (nonatomic, strong) NSMutableArray *dividers;
@end

@implementation HMStatusToolbar
- (NSMutableArray *)dividers
{
    if (_dividers == nil) {
        self.dividers = [NSMutableArray array];
    }
    return _dividers;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDivider];
//        [self setupDivider];
    }
    return self;
}

/**
 *  分割线
 */
- (void)setupDivider
{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageWithName:@"timeline_card_bottom_line"];
    divider.contentMode = UIViewContentModeCenter;
    [self addSubview:divider];
    
    [self.dividers addObject:divider];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    NSUInteger dividerCount = self.dividers.count;
    CGFloat dividerFirstX = self.width / (dividerCount + 1);
    CGFloat dividerH = self.height;
    
    // 设置分割线的frame
    for (int i = 0; i<dividerCount; i++) {
        UIImageView *divider = self.dividers[i];
        divider.width = 4;
        divider.height = dividerH;
        divider.centerX = (i + 1) * dividerFirstX;
        divider.centerY = dividerH * 0.5;
    }
}

- (void)drawRect:(CGRect)rect
{
    [[UIImage resizedImage:@"common_card_bottom_background"] drawInRect:rect];
}
@end

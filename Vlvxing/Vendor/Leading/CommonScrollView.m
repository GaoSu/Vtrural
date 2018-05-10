//
//  CommonScrollView.m
//  lvxingyongche
//
//  Created by 朱文成 on 16/1/10.
//  Copyright © 2016年 handong001. All rights reserved.
//

#import "CommonScrollView.h"

@implementation CommonScrollView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews
{
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.bounces =YES;
    self.pagingEnabled = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

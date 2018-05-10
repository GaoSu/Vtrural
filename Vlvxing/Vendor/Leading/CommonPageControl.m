//
//  LeadViewController.h
//  lvxingyongche
//
//  Created by Michael on 16/1/8.
//  Copyright © 2016年 handong001. All rights reserved.
//

#import "CommonPageControl.h"

@implementation CommonPageControl

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
    self.currentPage= 0 ;
    [self setGapWidth:12];
    [self setDiameter:18];
//    self.coreNormalColor=[UIColor hd_colorWithHexString:@"bab0a2"  alpha:0.7];
//    self.coreNormalColor=[UIColor hd_colorWithHexString:@"ffffff" ];
    self.coreNormalColor = [UIColor hexStringToColor:@"bab0a2" andAlph:0.7];
    self.coreSelectedColor = [UIColor hexStringToColor:@"ffffff"];
    [self setPageControlStyle:PageControlStyleDefault];
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    self.backgroundColor=[UIColor clearColor];
    self.backgroundColor=[UIColor clearColor];
    self.hidesForSinglePage = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

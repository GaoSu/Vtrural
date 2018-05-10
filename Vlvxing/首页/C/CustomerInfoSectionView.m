//
//  CustomerInfoSectionView.m
//  Vlvxing
//
//  Created by grm on 2017/11/15.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "CustomerInfoSectionView.h"

@implementation CustomerInfoSectionView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self UI];
    }
    return self;
}

-(void)UI{
    
}

-(void)toggleOpen:(id)sender {
    
    [self toggleOpenWithUserAction:YES];
}



@end

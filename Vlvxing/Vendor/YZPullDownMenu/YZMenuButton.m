//
//  YZMenuButton.m
//  PullDownMenu
//
//  Created by yz on 16/8/12.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "YZMenuButton.h"

@implementation YZMenuButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView.mj_x < self.titleLabel.mj_x) {
        
        self.titleLabel.mj_x = self.imageView.mj_x;
        
        if (MinPhone) {
            
          self.imageView.mj_x = self.titleLabel.mj_x+ self.titleLabel.mj_w + 5;
        }else{
            
        self.imageView.mj_x = self.titleLabel.mj_x+ self.titleLabel.mj_w + 10;
        }
        
    }
    
    
    
}

@end

//
//  LeftButton.h
//  ShiTingBang
//
//  Created by Michael on 16/10/27.
//  Copyright © 2016年 shitingbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol clickLeftButtonDelegate <NSObject>

@optional

- (void)clickLeftButton:(UIButton *)button;

@end

@interface LeftButton : UIButton

@property (weak, nonatomic) id<clickLeftButtonDelegate> delegate;

@end

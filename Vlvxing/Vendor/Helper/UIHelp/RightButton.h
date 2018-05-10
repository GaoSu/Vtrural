//
//  RightButton.h
//  ShiTingBang
//
//  Created by Michael on 16/10/27.
//  Copyright © 2016年 shitingbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol clickRightButtonDelegate <NSObject>

@optional

- (void)clickRightButton:(UIButton *)button;

@end

@interface RightButton : UIButton

@property (weak, nonatomic) id<clickRightButtonDelegate> delegate;

@end

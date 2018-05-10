//
//  VLXCustomNavTitleView.h
//  Vlvxing
//
//  Created by Michael on 17/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^typeBlock)(NSInteger type);

@interface VLXCustomNavTitleView : UIView
@property(nonatomic,strong)UIView * chuxingView;
@property(nonatomic,strong)UIView * yongcheView;
@property(nonatomic,strong) UILabel * chuxinglabel;
@property(nonatomic,strong)UILabel * yongchelabel;
@property(nonatomic,copy)typeBlock MyBlock;
-(void)retuenType:(typeBlock)block;
@end

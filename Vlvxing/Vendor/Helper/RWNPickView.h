//
//  RWNPickView.h
//  zichanguanli
//
//  Created by RWN on 17/3/7.
//  Copyright © 2017年 handongkeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RWNPickView;
@protocol RWNPickViewDelegate <NSObject>

@optional;
-(void)RWNPickViewDidClickSureBtn:(UIButton *)sureBtn andSelectedStr:(NSString *)selectedStr andRWNPickView:(RWNPickView *)pickView;

@end

@interface RWNPickView : UIView

@property(nonatomic,weak)id<RWNPickViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame  CreateProjectTypeViewWithDataSourceArray:(NSMutableArray *)dataArray selectedArray:(NSMutableArray *)selectedArray title:(NSString *)title andTag:(NSInteger)Tag;


@end

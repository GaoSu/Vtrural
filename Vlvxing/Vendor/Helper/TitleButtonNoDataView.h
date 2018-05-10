//
//  TitleButtonNoDataView.h
//  pinche
//
//  Created by handong on 16/12/8.
//  Copyright © 2016年 撼动科技006. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TitleButtonNoDataView;
@protocol TitleButtonNoDataViewDelegate <NSObject>

- (void)titleButtonNoDataView:(TitleButtonNoDataView *)view didClickButton:(UIButton *)button;

@end

@interface TitleButtonNoDataView : UIView
@property (nonatomic,copy) NSString *titleText;
@property (nonatomic,assign) BOOL noDataButtonIsHidden;
@property (weak, nonatomic) id<TitleButtonNoDataViewDelegate> delegate;
@end

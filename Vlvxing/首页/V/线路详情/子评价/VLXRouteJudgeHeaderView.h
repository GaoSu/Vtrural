//
//  VLXRouteJudgeHeaderView.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLXHomeJudgeModel.h"
typedef void(^judgeBlock)(NSInteger index);
@interface VLXRouteJudgeHeaderView : UIView
@property (nonatomic,copy)judgeBlock judgeBlock;
-(void)createUIWithModel:(VLXHomeJudgeModel *)model;
@end

//
//  VLXJudgeHeaderView.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/8.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^judgeBlock)(NSInteger index);
@interface VLXJudgeHeaderView : UIView<UITextViewDelegate>
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,copy)judgeBlock judgeBlock;
@end

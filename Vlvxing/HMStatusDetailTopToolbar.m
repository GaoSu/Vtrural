//
//  HMStatusDetailTopToolbar.m
//  XingJu
//
//  Created by apple on 14-7-22.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMStatusDetailTopToolbar.h"
#import "HMStatus.h"
#import "HMDynamic.h"

@interface HMStatusDetailTopToolbar()
/** 三角形 */
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;

//底部滚动条
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine;


@property (nonatomic, weak) UIButton *selectedButton;
- (IBAction)buttonClick:(UIButton *)button;

@end

@implementation HMStatusDetailTopToolbar

+ (instancetype)toolbar
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HMStatusDetailTopToolbar" owner:nil options:nil] lastObject];
}

- (void)drawRect:(CGRect)rect
{
    rect.origin.y = 10;
    [[UIImage resizedImage:@"statusdetail_comment_top_background"] drawInRect:rect];
}

/**
 *  从xib中加载完毕后就会调用
 */
- (void)awakeFromNib
{
    // 1.设置按钮tag
    self.commentButton.tag = HMStatusDetailTopToolbarButtonTypeComment;
    self.attitudeButton.tag = HMStatusDetailTopToolbarButtonTypeLike;
    
    // 设置背景色
    self.backgroundColor = HMGlobalBg;
}

- (void)setDelegate:(id<HMStatusDetailTopToolbarDelegate>)delegate
{
    _delegate = delegate;
    
    // 默认点击了评论按钮
//    [self buttonClick:self.commentButton];
}

/**
 *  监听按钮点击
 */
- (IBAction)buttonClick:(UIButton *)button {
    // 1.控制按钮状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    if (button == self.commentButton) {
        
        // 2.控制箭头的位置
        [UIView animateWithDuration:0.25 animations:^{
            //        self.arrowView.centerX = button.centerX;
            self.bottomLine.constant = 0;
        }];

        
    }else if (button == self.attitudeButton){
        // 2.控制箭头的位置
        [UIView animateWithDuration:0.25 animations:^{
            //        self.arrowView.centerX = button.centerX;
            self.bottomLine.constant = 35 + 83 + 50;
        }];

    }
    
    
    // 3.通知代理
    if ([self.delegate respondsToSelector:@selector(topToolbar:didSelectedButton:)]) {
        [self.delegate topToolbar:self didSelectedButton:button.tag];
    }
}

- (void)setStatus:(HMStatus *)status
{
    _status = status;
    
    [self setupBtnTitle:self.retweetedButton count:status.dynamic.collectionCount defaultTitle:@"收藏"];
    [self setupBtnTitle:self.commentButton count:status.dynamic.commentCount defaultTitle:@"评论"];
    [self setupBtnTitle:self.attitudeButton count:status.dynamic.likeCount defaultTitle:@"赞"];
}

/**
 *  设置按钮的文字
 *
 *  @param button       需要设置文字的按钮
 *  @param count        按钮显示的数字
 *  @param defaultTitle 数字为0时显示的默认文字
 */
- (void)setupBtnTitle:(UIButton *)button count:(NSInteger)count defaultTitle:(NSString *)defaultTitle
{
    if (count >= 10000) { // [10000, 无限大)
        defaultTitle = [NSString stringWithFormat:@"%.1f万 %@", count / 10000.0, defaultTitle];
        // 用空串替换掉所有的.0
        defaultTitle = [defaultTitle stringByReplacingOccurrencesOfString:@".0" withString:@""];
    } else if (count > 0) { // (0, 10000)
        defaultTitle = [NSString stringWithFormat:@"%d %@", count, defaultTitle];
    } else {
        defaultTitle = [NSString stringWithFormat:@"0 %@", defaultTitle];
    }
    [button setTitle:defaultTitle forState:UIControlStateNormal];
}
@end

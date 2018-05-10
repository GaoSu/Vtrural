//
//  HMStatusRetweetedFrame.m
//  XingJu
//
//  Created by apple on 14-7-14.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMStatusRetweetedFrame.h"
#import "HMStatus.h"
#import "HMUser.h"
#import "HMStatusPhotosView.h"

@implementation HMStatusRetweetedFrame

- (void)setRetweetedStatus:(HMStatus *)retweetedStatus
{
    _retweetedStatus = retweetedStatus;
    
    // 1.正文
    CGFloat h = 0;
    CGFloat textX = HMStatusCellInset;
    CGFloat textY = HMStatusCellInset * 0.5;
    CGFloat maxW = ScreenWidth - 2 * textX;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    CGSize textSize = [retweetedStatus.attributedText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.textFrame = (CGRect){{textX, textY}, textSize};
    h = CGRectGetMaxY(self.textFrame) + HMStatusCellInset;
    
    // 2.配图相册
//    if (retweetedStatus.pic_urls.count) {
//        CGFloat photosX = textX;
//        CGFloat photosY = CGRectGetMaxY(self.textFrame) + HMStatusCellInset * 0.5;
//        CGSize photosSize = [HMStatusPhotosView sizeWithPhotosCount:retweetedStatus.pic_urls.count];
//        self.photosFrame = (CGRect){{photosX, photosY}, photosSize};
//        h = CGRectGetMaxY(self.photosFrame) + HMStatusCellInset;
//    }
    
    // 3.工具条
    if (retweetedStatus.isDetail) { // 展示在详情里面， 需要显示toolbar
        CGFloat toolbarY = 0;
        CGFloat toolbarW = 200;
        CGFloat toolbarX = ScreenWidth - toolbarW;
        CGFloat toolbarH = 20;
        if (retweetedStatus.pic_urls.count) {
            toolbarY = CGRectGetMaxY(self.photosFrame) + HMStatusCellInset;
        } else {
            toolbarY = CGRectGetMaxY(self.textFrame) + HMStatusCellInset;
        }
        self.toolbarFrame = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
        NSLog(@"toolbarFrame高度就是cell的高度👌-2:%f",CGRectGetMaxY(self.toolbarFrame));

        h = CGRectGetMaxY(self.toolbarFrame) + HMStatusCellInset;
    }
    
    // 自己
    CGFloat x = 0;
    CGFloat y = 0; // 高度 = 原创微博最大的Y值
    CGFloat w = ScreenWidth;
    self.frame = CGRectMake(x, y, w, h);
}

@end

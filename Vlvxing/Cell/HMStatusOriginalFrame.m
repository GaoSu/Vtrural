//
//  HMStatusOriginalFrame.m
//  XingJu
//
//  Created by apple on 14-7-14.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMStatusOriginalFrame.h"
#import "HMStatus.h"
#import "HMUser.h"
#import "HMStatusPhotosView.h"
#import "HMVideo.h"

#import "HMDynamic.h"

@implementation HMStatusOriginalFrame

- (void)setStatus:(HMStatus *)status
{
    _status = status;
    
    //取出用户模型
    HMUser *user = status.user;
    
    //取出动态数据
    HMDynamic *dynamic = status.dynamic;
    
    // 1.头像
    CGFloat iconX = HMStatusCellInset;
    CGFloat iconY = HMStatusCellInset;
    CGFloat iconW = 50;
    CGFloat iconH = 50;
    self.iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    // 2.昵称
    CGFloat nameX = CGRectGetMaxX(self.iconFrame) + HMStatusCellInset;
    CGFloat nameY = iconY;
    CGSize nameSize = [user.userName sizeWithFont:HMStatusOrginalNameFont];
    self.nameFrame = (CGRect){{nameX, nameY}, nameSize};
    

    // 3.正文
    CGFloat textX = iconX;
    CGFloat textY = CGRectGetMaxY(self.iconFrame) + HMStatusCellInset * 0.5;
    CGFloat maxW = ScreenWidth - 2 * textX;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    CGSize textSize = [dynamic.attributedText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    NSLog(@"dynamic.attributedText%@",dynamic.attributedText);//(null)症结所在

    self.textFrame = (CGRect){{textX, textY}, textSize};

//    NSLog(@"~~3.正文的frame:%@",NSStringFromCGRect(self.textFrame));
    CGFloat photosY = 0;
    if (dynamic.video.videoId) {//有视频
        
        CGFloat videoX = textX;
        CGFloat videoY = CGRectGetMaxY(self.textFrame) + HMStatusCellInset * 0.5;
        CGFloat videoW = ScreenWidth - 2 * HMStatusCellInset;
        CGFloat videoH = 200;
        self.videoViewFrame = CGRectMake(videoX, videoY, videoW, videoH);
         //视频
        //视频上默认的图片
        self.videoImageFrame = self.videoViewFrame;
        
        //播放按钮
        CGFloat playBtnW = 50;
        CGFloat playBtnH = 50;
        CGFloat playBtnX = (videoW - playBtnW) * 0.5;
        CGFloat playBtnY = (videoH - playBtnH) * 0.5;
        
        self.playBtnFrame = CGRectMake(playBtnX, playBtnY, playBtnW, playBtnH);
        photosY = CGRectGetMaxY(self.videoViewFrame) + HMStatusCellInset * 0.5;

    }else{
        photosY = CGRectGetMaxY(self.textFrame) + HMStatusCellInset * 0.5;
    }
   
    // 4.配图相册
    CGFloat h = 0;
    if (dynamic.images.count) {//有配图
        CGFloat photosX = textX;
        HMStatusPhotosView *photosView = [[HMStatusPhotosView alloc] init];
        CGSize photosSize = [photosView sizeWithPhotosCount:dynamic.images.count dynamic:dynamic];
        
        self.photosFrame = (CGRect){{photosX, photosY}, photosSize};
        
        h = CGRectGetMaxY(self.photosFrame) + HMStatusCellInset;
    } else {
        if (dynamic.video.videoId) {
            h = CGRectGetMaxY(self.videoViewFrame) + HMStatusCellInset;
        }else{
            h = CGRectGetMaxY(self.textFrame) + HMStatusCellInset;
        }
    }
    
    // 自己
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = ScreenWidth;
    self.frame = CGRectMake(x, y, w, h);
}

@end

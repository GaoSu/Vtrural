//
//  HMEmotionAttachment.m
//  XingJu
//
//  Created by apple on 14-7-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMEmotionAttachment.h"
#import "HMEmotion.h"

@implementation HMEmotionAttachment

- (void)setEmotion:(HMEmotion *)emotion
{
    _emotion = emotion;
    
    self.image = [UIImage imageWithName:[NSString stringWithFormat:@"%@/%@", emotion.directory, emotion.png]];
}

@end

//
//  HMDynamic.h
//  XingJu
//
//  Created by 中通华 on 16/11/14.
//  Copyright © 2016年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HMVideo,HMUser;

@interface HMDynamic : NSObject<NSCoding>

//星聚
/** 收藏数 */
@property (nonatomic,assign) NSInteger collectionCount;
/** 收藏状态 */
@property (nonatomic,assign) BOOL collectionState;
/** 评论总数 */
@property (nonatomic,assign) NSInteger commentCount;

/** 文字内容 */
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSAttributedString *attributedText;

/** 时间 */
@property (nonatomic,assign) NSInteger date;

/** 动态ID */
@property (nonatomic,copy) NSString *dynamicId;
/** 转发数量 */
@property (nonatomic,assign) NSInteger forwardCount;

/** 图片 */
@property (nonatomic,strong) NSArray *images;
/** 点赞数 */
@property (nonatomic,assign) NSInteger likeCount;
/** 点赞状态 */
@property (nonatomic,assign) BOOL likeState;
/** 分享的URL	string */
@property (nonatomic,copy) NSString *shareUrl;
/** 视频信息 */
@property (nonatomic,strong) HMVideo *video;


/** 当前页面 */
@property (nonatomic,assign) NSInteger currentPage;




@end

//
//  VLX_status.h
//  Vlvxing
//
//  Created by grm on 2018/1/24.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VLX_User;
@interface VLX_status : NSObject<NSCoding>
/** 用户信息 */
@property (nonatomic,strong) VLX_User * member;

/** 评论总数 */
@property (nonatomic,assign) NSInteger commentcount;

/** 文字内容 */
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSAttributedString *attributedText;

/** 时间 */
@property (nonatomic,assign) NSInteger createTime;

/** 动态ID */
@property (nonatomic,copy) NSString *dynamicId;
/** 转发数量 */
@property (nonatomic,assign) NSInteger forwardCount;

/** 当前页面 */
@property (nonatomic,assign) NSInteger currentPage;

/** 图片数组 */
@property (nonatomic,strong) NSArray *prictures;
/** 点赞数 */
@property (nonatomic,assign) NSInteger likeCount;
// 点赞状态 ///是否点赞
@property (nonatomic,assign) BOOL isFavor;

/** //视频截图 */
@property (nonatomic,copy) NSString *imgUrl;
/** 视频id */
@property (nonatomic,copy) NSString *videoId;
/** 视频vuid */
@property (nonatomic,copy) NSString *vuid;



@end

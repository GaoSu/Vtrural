//
//  VLX_newCommnuityModel.h
//  Vlvxing
//
//  Created by grm on 2018/1/25.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLX_newCommnuityModel : NSObject

@property(nonatomic,strong)NSString * content;//内容
@property(nonatomic,strong)NSNumber * createTime;//时间
@property(nonatomic,strong)NSNumber * dynamicId;//帖子id
@property(nonatomic,strong)NSString * areaname;//地点
//@property(nonatomic,strong)NSNumber * areaid;//地点id
//差个查看数量
@property(nonatomic,strong)NSNumber * commentCount;////评论数
@property(nonatomic,strong)NSNumber * favor;//点赞数
@property(nonatomic,strong)NSNumber * allpageview;//查看次数,每次刷新,后台都会加一
@property(nonatomic,strong)NSNumber * isFavor;//是否点赞
@property(nonatomic,strong)NSDictionary * member;//用户信息
@property(nonatomic,strong)NSNumber * memberId;//用户id
@property(nonatomic,strong)NSArray * pictures;//图片数组
@property(nonatomic,strong)NSString * thumbnail;//缩略图
@property(nonatomic,strong)NSString * videoUrl;//视频地址
@property(nonatomic,strong)NSNumber * userid;
@property(nonatomic,strong)NSString * usernick;
@property(nonatomic,strong)NSString * userpic;


@property (nonatomic, assign) CGFloat CellHeight;


+ (instancetype)infoListWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end

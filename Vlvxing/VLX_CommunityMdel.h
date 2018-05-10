//
//  VLX_CommunityMdel.h
//  Vlvxing
//
//  Created by grm on 2017/12/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface VLX_CommunityMdel : NSObject


@property(nonatomic,strong)VLX_CommunityMdel * CommuModel;
//@property(nonatomic,strong)NSNumber * collectionCount;//收藏数量//可能用不上/
//@property(nonatomic,)
@property(nonatomic,strong)NSNumber * commentCount;//评论数量
@property(nonatomic,strong)NSString * content;//主题
@property(nonatomic,strong)NSNumber * createTime;//时间戳,秒
@property(nonatomic,strong)NSArray * pictures;//图片数组
@property(nonatomic,strong)NSNumber * favor;//点赞数量
@property(nonatomic,assign)NSNumber * isFavor;//是否点赞 false否,ture是

//@property (nonatomic,strong)NSString * videoUrl;//视频地址
//@property (nonatomic,strong)NSString * thumbnail;//视频缩略图


@property (nonatomic,strong)NSDictionary * member;//用户所有信息
@property(nonatomic,strong)NSString * userpic;//头像url
@property(nonatomic,strong)NSString * usernick;//用户名
@property(nonatomic,assign)NSNumber * userid;//用户id

@property(nonatomic,assign)NSNumber * dynamicId;//yonghu id

+ (instancetype)infoListWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end

//
//  VLX_detailhuifuModel.h
//  Vlvxing
//
//  Created by grm on 2018/1/29.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface VLX_detailhuifuModel : NSObject

@property(nonatomic,strong)NSString * content;//每条评论内容
@property(nonatomic,strong)NSNumber * createTime;//每条评论时间
@property(nonatomic,strong)NSNumber * discussId;//每条评论的id
//@property(nonatomic,strong)NSNumber * PLid;//每条评论的id(关键字id)
@property(nonatomic,strong)NSDictionary * member;//每条评论用户信息
//@property(nonatomic,strong)NSNumber * yuanshi_H;////图片原始高.像素
//@property(nonatomic,strong)NSNumber * yuanshi_W;////图片原始宽.像素
@property(nonatomic,strong)NSDictionary * weiboComment;//评论的评论信息
@property(nonatomic,strong)NSArray * pictures;//每条评论的图片数组

@property (nonatomic, assign) CGFloat CellHeight_2;//行高

+ (instancetype)infoListWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
-(void)setValue:(id)value forKey:(NSString *)key;

@end

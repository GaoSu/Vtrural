//
//  VLX_plwdModel.h
//  Vlvxing
//
//  Created by grm on 2018/3/12.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLX_plwdModel : NSObject

@property(nonatomic,strong)NSString * usernick;//
@property(nonatomic,strong)NSString * userpic;//
@property(nonatomic,strong)NSNumber * userid;//userid
/**时间**/
@property(nonatomic,strong)NSString *createTime;
+ (instancetype)infoListWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;


@end

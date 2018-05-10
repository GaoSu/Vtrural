//
//  VLX_Dynamic+UserMdel.h
//  Vlvxing
//
//  Created by grm on 2018/1/17.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLX_Dynamic_UserMdel : NSObject
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;


//dynamic
@property(nonatomic,strong)NSDictionary * dynamic;
//user
@property(nonatomic,strong)NSDictionary * user;
+ (instancetype)infoListWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end

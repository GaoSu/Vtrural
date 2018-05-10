//
//  VLX_User.h
//  Vlvxing
//
//  Created by grm on 2018/1/24.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLX_User : NSObject<NSCoding>


//星聚
/** 用户头像地址 */
@property (nonatomic,copy) NSString *userpic;
/** 用户Id */
@property (nonatomic,copy) NSString *userid;
/** 用户名称 */
@property (nonatomic,copy) NSString *usernick;
/** 身份标识 */
//@property (nonatomic,strong) NSArray *userIdentity;

@end

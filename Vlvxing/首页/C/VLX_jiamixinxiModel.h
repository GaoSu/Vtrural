//
//  VLX_jiamixinxiModel.h
//  Vlvxing
//
//  Created by grm on 2017/11/20.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLX_jiamixinxiModel : NSObject

@property (nonatomic,strong)NSString * name;//姓名
@property (nonatomic,strong)NSString * cardno;//身份证号

+(VLX_jiamixinxiModel *)infoListWithDict:(NSDictionary *)dict;

-(instancetype)initWithDict:(NSDictionary *)dict;


@end

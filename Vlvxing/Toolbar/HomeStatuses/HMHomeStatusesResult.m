//
//  HMHomeStatusesResult.m
//  XingJu
//
//  Created by apple on 14-7-11.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMHomeStatusesResult.h"
#import "MJExtension.h"
#import "HMStatus.h"

@implementation HMHomeStatusesResult
- (NSDictionary *)objectClassInArray
{
    return @{@"statuses" : [HMStatus class]};
}
@end

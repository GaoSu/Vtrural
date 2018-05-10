//
//  historyManager.h
//  searchOLD
//
//  Created by grm on 2017/11/6.
//  Copyright © 2017年 grm. All rights reserved.
//

#import <Foundation/Foundation.h> /////////搜索历史model

@interface historyManager : NSObject
//缓存搜索的数组
+(void)SearchText :(NSString *)seaTxt;
//清除缓存数组
+(void)removeAllArray;
@end

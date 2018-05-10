//
//  VLXDingZhiModel.h
//  Vlvxing
//
//  Created by Michael on 17/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "JSONModel.h"

@interface VLXDingZhiModel : JSONModel//用于控制界面(我的定制)
@property(nonatomic,copy)NSString * imagename;
@property(nonatomic,copy)NSString * mudidi;
@property(nonatomic,copy)NSString * chufadi;
@property(nonatomic,copy)NSString * timestring;
@property(nonatomic,assign)BOOL selected;
@end

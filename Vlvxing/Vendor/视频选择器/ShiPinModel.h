//
//  ShiPinModel.h
//  yinxin
//
//  Created by hdkj005 on 16/11/7.
//  Copyright © 2016年 RWN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@interface ShiPinModel : NSObject

//视频压缩后的路径
@property(nonatomic,copy)NSString *filePath;
//视频本地的路径
@property(nonatomic,copy)NSString *fileUrl;
//视频名称
@property(nonatomic,copy)NSString *fileName;
//视频缩略图
@property(nonatomic,strong)UIImage *pic;
//用户写的名称
@property(nonatomic,copy)NSString *title;
//视频的资源
@property(nonatomic,copy)PHAsset *asset;
//是否被选择了
@property(nonatomic,assign)BOOL isSelected;


@end

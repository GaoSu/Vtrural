//
//  HMStatusPhotosView.m
//  XingJu
//
//  Created by apple on 14-7-15.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMStatusPhotosView.h"
#import "HMStatusPhotoView.h"
#import "UIImageView+WebCache.h"
#import "HMPhoto.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "HMDynamic.h"
#import "HMVideo.h"
#import "UIView+Extension.h"

#define HMStatusPhotosMaxCount 9
#define HMStatusPhotosMaxCols(photosCount) ((photosCount==4)?2:3)
#define HMStatusPhotoW 115
#define HMStatusPhotoH HMStatusPhotoW
#define HMStatusPhotoMargin 10

@interface HMStatusPhotosView()

/** 动态模型 */
@property (nonatomic,strong) HMDynamic *dynamic;



@end

@implementation HMStatusPhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 预先创建9个图片控件
        for (int i = 0; i<HMStatusPhotosMaxCount; i++) {
            HMStatusPhotoView *photoView = [[HMStatusPhotoView alloc] init];
            photoView.tag = i;
            [self addSubview:photoView];
            
            // 添加手势监听器（一个手势监听器 只能 监听对应的一个view）
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
            [recognizer addTarget:self action:@selector(tapPhoto:)];
            [photoView addGestureRecognizer:recognizer];
            
//            self.backgroundColor = [UIColor redColor];
        }
    }
    return self;
}

/**
 *  监听图片的点击
 */
- (void)tapPhoto:(UITapGestureRecognizer *)recognizer
{
    // 1.创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    // 2.设置图片浏览器显示的所有图片
    NSMutableArray *photos = [NSMutableArray array];
    NSInteger count = self.images.count;
 
    for (int i = 0; i<count; i++) {
        HMPhoto *pic = self.images[i];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        // 设置图片的路径
        photo.url = [NSURL URLWithString:pic.url];
        // 设置来源于哪一个UIImageView
        photo.srcImageView = self.subviews[i];
        [photos addObject:photo];
    }
    browser.photos = photos;
    
    // 3.设置默认显示的图片索引
    browser.currentPhotoIndex = recognizer.view.tag;
    
    // 3.显示浏览器
    [browser show];
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    
    for (int i = 0; i<HMStatusPhotosMaxCount; i++) {
        HMStatusPhotoView *photoView = self.subviews[i];
        
//        NSLog(@"%zd",self.dynamic.video.videoId.length);
        
        if (self.dynamic.video.videoId.length) {//有视频
            NSInteger count = images.count > 3 ? 3 : images.count;
            if (i < count) { // 显示图片
                
                photoView.photo = images[i];
                photoView.hidden = NO;
                
            } else { // 隐藏
                photoView.hidden = YES;
            }
        }else{
//
            if (i < images.count) { // 显示图片
                photoView.photo = images[i];
                photoView.hidden = NO;
    
            } else { // 隐藏
                photoView.hidden = YES;
            }
        }
        
        
        
    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.images.count;
    int maxCols = HMStatusPhotosMaxCols(count);
    for (int i = 0; i<count; i++) {
        HMStatusPhotoView *photoView = self.subviews[i];
        photoView.width = HMStatusPhotoW;
        photoView.height = HMStatusPhotoH;
        photoView.x = (i % maxCols) * (HMStatusPhotoW + HMStatusPhotoMargin);
        photoView.y = (i / maxCols) * (HMStatusPhotoH + HMStatusPhotoMargin);
    }
}

- (CGSize)sizeWithPhotosCount:(NSUInteger)photosCount dynamic:(HMDynamic *)dynamic
{
    self.dynamic = dynamic;
    
//    NSLog(@"%zd",dynamic.video.videoId.length);
    
    CGFloat photosW = 0;
    CGFloat photosH = 0;
    if (dynamic.video.videoId.length) {//有视频
        
        NSInteger count = photosCount > 3 ? 3 : photosCount;
        NSInteger maxCols = HMStatusPhotosMaxCols(count);
        
        // 总列数
        NSInteger totalCols = count >= maxCols ?  maxCols : count;
        
        // 总行数
        NSInteger totalRows = (count + maxCols - 1) / maxCols;
        
        // 计算尺寸
        photosW = totalCols * HMStatusPhotoW + (totalCols - 1) *HMStatusPhotoMargin;
        photosH = totalRows * HMStatusPhotoH + (totalRows - 1) * HMStatusPhotoMargin;

    }else{
        NSInteger maxCols = HMStatusPhotosMaxCols(photosCount);
        
        // 总列数
        NSInteger totalCols = photosCount >= maxCols ?  maxCols : photosCount;
        
        // 总行数
        NSInteger totalRows = (photosCount + maxCols - 1) / maxCols;
        
        // 计算尺寸
         photosW = totalCols * HMStatusPhotoW + (totalCols - 1) * HMStatusPhotoMargin;
         photosH = totalRows * HMStatusPhotoH + (totalRows - 1) * HMStatusPhotoMargin;
    }
    
    return CGSizeMake(photosW, photosH);
}
@end

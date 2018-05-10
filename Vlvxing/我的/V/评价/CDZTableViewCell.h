//
//  CDZTableViewCell.h
//  CDZCollectionInTableViewDemo
//
//  Created by Nemocdz on 2017/1/21.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDZCollectionViewItem.h"
typedef void(^addBlock)();//表示添加图片
typedef void(^deleteBlock)(NSArray<CDZCollectionViewItem *> *);//表示删除图片
@protocol CDZTableViewCellDelegate<NSObject>

@optional
- (void)shouldReload;
@end

@interface CDZTableViewCell : UITableViewCell
@property (nonatomic,assign) id<CDZTableViewCellDelegate> delegate;
@property (nonatomic,copy)addBlock addBlock;
@property (nonatomic,copy)deleteBlock deleteBlock;
-(void)createUIWithImagesArray:(NSMutableArray<CDZCollectionViewItem *> *)imagesArray;
@end

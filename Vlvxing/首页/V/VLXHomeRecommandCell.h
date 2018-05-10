//
//  VLXHomeRecommandCell.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/19.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLXHomeRecommandModel.h"
@interface VLXHomeRecommandCell : UITableViewCell
@property (nonatomic,assign)BOOL isHasMargin;//是否有间距 0 表示没有间距的样式(首页) 1表示有间距的样式(附近)
-(void)createUIWithModel:(VLXHomeRecommandDataModel *)dataModel;
@end

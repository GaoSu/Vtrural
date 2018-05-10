//
//  VLXRouteJudgeCell.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/24.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLXHomeJudgeModel.h"

@interface VLXRouteJudgeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
-(void)createUIWithModel:(VLXHomeJudgeEvaluateModel *)model;
//-(void)createUIWithData:(NSArray *)dataArray;

@end

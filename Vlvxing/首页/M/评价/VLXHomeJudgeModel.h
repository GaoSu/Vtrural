//
//  VLXHomeJudgeModel.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/31.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "JSONModel.h"
@class VLXHomeJudgeDataModel;
@protocol VLXHomeJudgeEvaluateModel

@end
@interface VLXHomeJudgeModel : JSONModel
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic,strong)VLXHomeJudgeDataModel *data;
@end
@interface VLXHomeJudgeDataModel : JSONModel
@property (nonatomic, strong) NSNumber *averageCounts;
@property (nonatomic, strong) NSNumber *goodCounts;
@property (nonatomic, strong) NSNumber *badCounts;
@property (nonatomic, strong) NSNumber *allCounts;
@property (nonatomic,strong)NSArray<VLXHomeJudgeEvaluateModel> *evaluates;
@end

@interface VLXHomeJudgeEvaluateModel : JSONModel
@property (nonatomic, copy) NSString *evaluatepic;
@property (nonatomic, strong) NSNumber *userid;
@property (nonatomic, strong) NSNumber *evaluatelevel;
@property (nonatomic, copy) NSString *evaluatecontent;
@property (nonatomic, strong) NSNumber *evaluateid;
@property (nonatomic, strong) NSNumber *isdelete;
@property (nonatomic, strong) NSNumber *createtime;
@property (nonatomic, strong) NSNumber *productid;
@property (nonatomic,copy)NSString *usernick;
@property (nonatomic,copy)NSString *userpic;
@end

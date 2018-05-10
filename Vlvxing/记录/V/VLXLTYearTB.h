//
//  VLXLTYearTB.h
//  Vlvxing
//
//  Created by Michael on 17/5/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^yearBlock)();
@protocol VLXLTYearTBDelegate <NSObject>

-(void)tbSelcteyear:(NSInteger)year;

@end


@interface VLXLTYearTB : UIView
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,assign)id<VLXLTYearTBDelegate>delegate;
@property (nonatomic,copy)yearBlock yearBlock;
@end

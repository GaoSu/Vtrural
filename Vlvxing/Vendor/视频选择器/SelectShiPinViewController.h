//
//  SelectShiPinViewController.h
//  yinxin
//
//  Created by handong001 on 16/11/4.
//  Copyright © 2016年 RWN. All rights reserved.
//

#import "BaseViewController.h"

@protocol SelectShiPinViewControllerDelegate <NSObject>

@optional
-(void)selectedVideoArray:(NSMutableArray *)array;


@end


@interface SelectShiPinViewController : UIViewController


@property(nonatomic,weak)id<SelectShiPinViewControllerDelegate>delegate;
@property(nonatomic,copy) NSString *folderId;



@property(nonatomic,strong) NSMutableArray *modelArray;

@end

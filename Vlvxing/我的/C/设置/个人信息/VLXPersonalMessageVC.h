//
//  VLXPersonalMessageVC.h
//  Vlvxing
//
//  Created by Michael on 17/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"

@protocol VLXPersonalMessageVCDelegate <NSObject>

-(void)refresh:(BOOL)refreshed;

@end


@interface VLXPersonalMessageVC : BaseViewController
@property(nonatomic,strong)NSDictionary * dataDic;
@property(nonatomic,assign)id<VLXPersonalMessageVCDelegate>delegate;
@end

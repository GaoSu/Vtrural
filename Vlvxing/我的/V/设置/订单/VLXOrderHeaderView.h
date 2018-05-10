//
//  VLXOrderHeaderView.h
//  Vlvxing
//
//  Created by Michael on 17/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^fukuanblock)(NSInteger type);


@interface VLXOrderHeaderView : UIView
@property(nonatomic,copy)fukuanblock myblock;
-(void)returnBlock:(fukuanblock)block;
@end

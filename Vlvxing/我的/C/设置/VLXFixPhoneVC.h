//
//  VLXFixPhoneVC.h
//  Vlvxing
//
//  Created by Michael on 17/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^phoneBlock)(NSString * phone);

@interface VLXFixPhoneVC : BaseViewController
@property(nonatomic,strong)NSString * oldPhoneNumber;
@property(nonatomic,copy)phoneBlock block;
-(void)getPhoneBlock:(phoneBlock)phoneblock;
@end

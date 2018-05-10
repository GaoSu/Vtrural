//
//  VLXCustomTripModel.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/31.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXCustomTripModel.h"

@implementation VLXCustomTripModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"forUndefinedKey:%@",key);
}
-(BOOL)checkIsFull
{
    if ([NSString checkForNull:self.startCity]) {
        [SVProgressHUD showErrorWithStatus:@"请输入出发城市"];
        return NO;
    }else if ([NSString checkForNull:self.endCity])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入目的地"];
        return NO;
    }else if ([NSString checkForNull:self.date])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入出发日期"];
        return NO;
    }else if ([self.days integerValue]<=0)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择出行天数"];
        return NO;
    }else if ([self.peoples integerValue]<=0)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择出行人数"];
        return NO;
    }else if ([NSString checkForNull:self.name])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return NO;
    }
    else if ([NSString checkForNull:self.phone])
    {
        
        [SVProgressHUD showErrorWithStatus:@"请输入电话"];
        return NO;
    }
    else if ([NSString checkForNull:self.email])
    {
        
        [SVProgressHUD showErrorWithStatus:@"请输入邮箱"];
        return NO;
    }
    if (![self.phone isMobileNumber:self.phone]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的电话号码"];
        return NO;
    }
    if (![NSString validateEmail:self.email]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的邮箱地址"];
        return NO;
    }
    return YES;
}
@end
















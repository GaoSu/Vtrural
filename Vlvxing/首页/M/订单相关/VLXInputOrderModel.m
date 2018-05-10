//
//  VLXInputOrderModel.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/5.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXInputOrderModel.h"

@implementation VLXInputOrderModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"forUndefinedKey:%@",key);
}
-(BOOL)checkIsFull
{
    if ([NSString checkForNull:self.name])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return NO;
    }
    else if ([NSString checkForNull:self.phone])
    {
        
        [SVProgressHUD showErrorWithStatus:@"请输入电话"];
        return NO;
    }
    else if ([NSString checkForNull:self.address])
    {
        
        [SVProgressHUD showErrorWithStatus:@"请输入地址"];
        return NO;
    }
    else if ([NSString checkForNull:self.IDCard])
    {
        
        [SVProgressHUD showErrorWithStatus:@"请输入身份证号"];
        return NO;
    }
    if (![self.phone isMobileNumber:self.phone]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的电话号码"];
        return NO;
    }
    if (![NSString validateIdentityCard:self.IDCard]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的身份证号码"];
        return NO;
    }
    return YES;
}
-(BOOL)checkIsFull_2//
{
    if ([NSString checkForNull:self.name])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return NO;
    }
//    else if (![NSString checkForNullChinese:self.name]){
//        [SVProgressHUD showErrorWithStatus:@"请输入正确姓名"];
//        return NO;
//
//    }
    else if (![NSString validateIdentityCard:self.IDCard]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的身份证号码"];
        return NO;
    }

    return YES;
}

-(BOOL)checkIsFull_3//单独的正则验证手机号
{
    if (![self.phone isMobileNumber:self.phone])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确手机号码"];
        return NO;
    }
    return YES;
}

-(BOOL)checkIsFull_4//姓名,电话,地址
{
    if ([NSString checkForNull:self.name1])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return NO;
    }

    else if (![self.phone1 isMobileNumber:self.phone1]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确号码"];
        return NO;
    }
    else if ([NSString checkForNull:self.address1]) {
        [SVProgressHUD showErrorWithStatus:@"请输入地址"];
        return NO;
    }

    return YES;
}






@end

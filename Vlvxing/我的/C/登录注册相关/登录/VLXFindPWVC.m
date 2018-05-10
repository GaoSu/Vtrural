//
//  VLXFindPWVC.m
//  Vlvxing
//
//  Created by Michael on 17/5/19.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXFindPWVC.h"

@interface VLXFindPWVC ()
@property (nonatomic,strong)UIView *centerView;
@property (nonatomic,strong)UIButton *codeBtn;
@end

@implementation VLXFindPWVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}
-(void)createUI
{
    [self setNav];
    [self createCenter];
    [self createBottom];
}
- (void)setNav{

    self.title = self.titleString;
    self.view.backgroundColor=[UIColor whiteColor];
    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton:)];
}

-(void)createCenter
{
    NSArray *imagesArray=@[@"Phone-number",@"captcha",@"password"];
    NSArray *placeHolderArray=@[@"请输入手机号",@"请输入验证码",@"请输入新密码"];
    CGFloat rowHeight=52;
    _centerView=[[UIView alloc] initWithFrame:CGRectMake(0, 69-rowHeight, kScreenWidth, rowHeight*3)];
    //    _centerView.backgroundColor=[UIColor orangeColor];
    [self.view addSubview:_centerView];
    for (int i=0; i<3; i++) {
        UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, i*rowHeight, kScreenWidth, rowHeight)];
        [_centerView addSubview:bgView];
        NSLog(@"%@",NSStringFromCGRect(bgView.frame));
        if (i==0) {
            UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(15, (rowHeight-22)/2, 15, 22)];
            [iconImage setImage:[UIImage imageNamed:imagesArray[i]]];
            [bgView addSubview:iconImage];
            UITextField *txtField=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame)+16,( rowHeight-15.5)/2, 200, 15.5)];
            txtField.textColor=[UIColor hexStringToColor:@"#666666"];
            txtField.font=[UIFont systemFontOfSize:15];
            txtField.placeholder=placeHolderArray[i];
            txtField.tag=300+i;
            [bgView addSubview:txtField];
        }
        else if (i==1) {
            UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(15, (rowHeight-22)/2, 22, 18)];
            [iconImage setImage:[UIImage imageNamed:imagesArray[i]]];
            [bgView addSubview:iconImage];
            UITextField *txtField=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame)+9.5,( rowHeight-15.5)/2, 200, 15.5)];
            txtField.textColor=[UIColor hexStringToColor:@"#666666"];
            txtField.font=[UIFont systemFontOfSize:15];
            txtField.placeholder=placeHolderArray[i];
            txtField.tag=300+i;
            [bgView addSubview:txtField];
            UIView *margin=[[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-110, (rowHeight-24)/2, 1, 24)];
            margin.backgroundColor=separatorColor1;
            [bgView addSubview:margin];
            UIButton *codeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            codeBtn.frame=CGRectMake(CGRectGetMaxX(margin.frame), 0, kScreenWidth-CGRectGetMaxX(margin.frame), rowHeight);
            [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [codeBtn setTitleColor:[UIColor hexStringToColor:@"#ea5413"] forState:UIControlStateNormal];
            codeBtn.titleLabel.font=[UIFont systemFontOfSize:16];
            codeBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
            [codeBtn addTarget:self action:@selector(btnClickedToGetCode:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:codeBtn];
            _codeBtn=codeBtn;

        }else if (i==2)
        {
            UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(15, (rowHeight-22)/2, 17, 22)];
            [iconImage setImage:[UIImage imageNamed:imagesArray[i]]];
            [bgView addSubview:iconImage];
            UITextField *txtField=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame)+14,( rowHeight-15.5)/2, 200, 15.5)];
            txtField.textColor=[UIColor hexStringToColor:@"#666666"];
            txtField.font=[UIFont systemFontOfSize:15];
            txtField.placeholder=placeHolderArray[i];
            txtField.keyboardType=UIKeyboardTypeNumberPad;
            txtField.tag=300+i;
            [bgView addSubview:txtField];

        }

    }

}



-(void)createBottom
{
    UIButton *registerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame=CGRectMake(15, CGRectGetMaxY(_centerView.frame)+50, kScreenWidth-15*2, 44);
    [registerBtn setTitle:@"确定" forState:UIControlStateNormal];
    registerBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    registerBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [registerBtn setBackgroundColor:[UIColor hexStringToColor:@"#ea5413"]];
    registerBtn.layer.cornerRadius=4;
    registerBtn.layer.masksToBounds=YES;
    [registerBtn addTarget:self action:@selector(btnClickedToRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
}
#pragma mark---事件
-(void)tapLeftButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)btnClickedToRegister:(UIButton *)sender
{
    if ([self beforeRegister]) {
        UITextField * phonetextfield=[self.view viewWithTag:300];
        UITextField * psTextfield=[self.view viewWithTag:302];
        UITextField * yanzhenTextfield=[self.view viewWithTag:301];
        
        if (![NSString checkForNull:phonetextfield.text]) {
            if (![NSString checkForNull:yanzhenTextfield.text]) {
                if (![NSString checkForNull:psTextfield.text]) {
                    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
                    dic[@"phoneNum"]=phonetextfield.text;
                    dic[@"infoCode"]=yanzhenTextfield.text;
                    dic[@"password"]=psTextfield.text;
                    
                    NSString * url=[NSString stringWithFormat:@"%@/MbUserController/forgotPassword.json",ftpPath];
                    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
                        MyLog(@"%@",requestDic);
                        
                        if ([requestDic[@"status"] integerValue]==1) {
                            
                            [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                [self.navigationController popViewControllerAnimated:YES];
                                [NSString setDefaultToken:requestDic[@"data"][@"token"]];
                            });
                        }else
                        {
                            [SVProgressHUD showErrorWithStatus:msg];
                        }
                    } failure:^(NSString *errorInfo) {
                        [SVProgressHUD dismiss];
                        
                    }];
                    
                }else
                {
                    [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
                }
                
                
            }else
            {
                [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
            }
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        }
    }
//    UITextField * phonetextfield=[self.view viewWithTag:300];
//    UITextField * psTextfield=[self.view viewWithTag:302];
//    UITextField * yanzhenTextfield=[self.view viewWithTag:301];
//
//    if (![NSString checkForNull:phonetextfield.text]) {
//        if (![NSString checkForNull:yanzhenTextfield.text]) {
//            if (![NSString checkForNull:psTextfield.text]) {
//                NSMutableDictionary * dic=[NSMutableDictionary dictionary];
//                dic[@"phoneNum"]=phonetextfield.text;
//                dic[@"infoCode"]=yanzhenTextfield.text;
//                dic[@"password"]=psTextfield.text;
//
//                NSString * url=[NSString stringWithFormat:@"%@/MbUserController/forgotPassword.json",ftpPath];
//                [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
//                    MyLog(@"%@",requestDic);
//
//                    if ([requestDic[@"status"] integerValue]==1) {
//
//                        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                            [self.navigationController popViewControllerAnimated:YES];
//                            [NSString setDefaultToken:requestDic[@"data"][@"token"]];
//                        });
//                    }else
//                    {
//                        [SVProgressHUD showErrorWithStatus:msg];
//                    }
//                } failure:^(NSString *errorInfo) {
//                    [SVProgressHUD dismiss];
//
//                }];
//
//            }else
//            {
//                [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
//            }
//
//
//        }else
//        {
//            [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
//        }
//        
//    }else
//    {
//        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
//    }

    
}
-(BOOL)beforeGetCode//获取验证码的验证
{
    UITextField * phonetextfield=[self.view viewWithTag:300];

    
    if ([phonetextfield.text isMobileNumber:phonetextfield.text]==NO) {
        [SVProgressHUD showErrorWithStatus:@"请您输入正确的手机号码!"];
        return NO;
    }
    return YES;
}
- (void)startYZMTimer

{
    self.codeBtn.enabled = NO;
    __block int time = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        if (time <= 0) {
            dispatch_source_cancel(_timer);
            NSString *str = @"获取验证码";
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeBtn setTitle:str forState:UIControlStateNormal];
                [self.codeBtn setTitleColor:orange_color forState:UIControlStateNormal];
                self.codeBtn.enabled = YES;
            });
            
        }else{
            
            NSString *strTime = [NSString stringWithFormat:@"%d s后重发",time];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeBtn setTitle:strTime forState:UIControlStateDisabled];
                [self.codeBtn setTitleColor:gray_color forState:UIControlStateNormal];
                self.codeBtn.enabled = NO;
            });
            
            time --;
        }
    });
    
    dispatch_resume(_timer);
}
-(BOOL)beforeRegister//确定之前的验证
{
    UITextField * phonetextfield=[self.view viewWithTag:300];
    UITextField * newpwtextfield=[self.view viewWithTag:302];
    UITextField * codetextfield=[self.view viewWithTag:301];
    if ([phonetextfield.text isMobileNumber:phonetextfield.text]==NO) {
        [SVProgressHUD showErrorWithStatus:@"请您输入正确的手机号码!"];
        return NO;
    }else if ([NSString checkForNull:newpwtextfield.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入密码!"];
        return NO;
    }else if ([NSString checkForNull:codetextfield.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return NO;
    }
    return YES;
}
-(void)btnClickedToGetCode:(UIButton *)sender
{
    NSLog(@"获取验证码");
    if ([self beforeGetCode]) {
        UITextField * textfield=[self.view viewWithTag:300];
        
        if (![NSString checkForNull:textfield.text]) {
            
            [SVProgressHUD showWithStatus:@"验证码发送中..."];
            NSLog(@"获取验证码");
            NSMutableDictionary * dic=[NSMutableDictionary dictionary];
            
            dic[@"phoneNum"]=textfield.text;
            dic[@"forwhat"]=@"2";
            dic[@"userType"]=@"2";
            NSString * url=[NSString stringWithFormat:@"%@/mbUserPer/getCode.json",ftpPath];
            MyLog(@"%@",dic);
            [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
                if ([requestDic[@"status"]integerValue]) {
                    
                    //验证码发送成功
                    [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
                    [self startYZMTimer];
                }else
                {
                    [SVProgressHUD showErrorWithStatus:msg];
                }
                MyLog(@"%@",requestDic);
            } failure:^(NSString *errorInfo) {
                MyLog(@"%@",errorInfo);
                [SVProgressHUD dismiss];
                
            }];
            
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"请填写手机号"];
            
        }
    }
//    UITextField * textfield=[self.view viewWithTag:300];
//
//    if (![NSString checkForNull:textfield.text]) {
//
//        [SVProgressHUD showWithStatus:@"验证码发送中..."];
//        NSLog(@"获取验证码");
//        NSMutableDictionary * dic=[NSMutableDictionary dictionary];
//
//        dic[@"phoneNum"]=textfield.text;
//        dic[@"forwhat"]=@"2";
//        dic[@"userType"]=@"2";
//        NSString * url=[NSString stringWithFormat:@"%@/mbUserPer/getCode.json",ftpPath];
//        MyLog(@"%@",dic);
//        [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
//            if ([requestDic[@"status"]integerValue]) {
//
//                //验证码发送成功
//                [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
//            }else
//            {
//                [SVProgressHUD showErrorWithStatus:msg];
//            }
//            MyLog(@"%@",requestDic);
//        } failure:^(NSString *errorInfo) {
//            MyLog(@"%@",errorInfo);
//            [SVProgressHUD dismiss];
//
//        }];
//
//
//    }else
//    {
//        [SVProgressHUD showErrorWithStatus:@"请填写手机号"];
//        
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

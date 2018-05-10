//
//  VLXLoginVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/18.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXLoginVC.h"
#import "VLXRegisterVC.h"//  注册
#import "VLXFindPWVC.h"//找回密码
#import "VLXThirdRegistVC.h"//三方注册
#import <RongIMKit/RCIM.h>
@interface VLXLoginVC ()
@property (nonatomic,strong)UIView *putView;//手机号 密码
@property (nonatomic,strong)UIButton *registerBtn;
@property(nonatomic,strong) UIButton *weiXinBtn;

@end

@implementation VLXLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ( self.navigationController.childViewControllers.count > 1 ) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}
#pragma mark---数据
#pragma mark
#pragma mark---视图
-(void)createUI
{
    //标题
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"denlgu-bg2"]];
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 33.5, kScreenWidth, 17.5)];
    titleLab.text=@"登录";
    titleLab.font=[UIFont systemFontOfSize:19];
    titleLab.textColor=[UIColor whiteColor];
    titleLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(14.5, 34.5-(30-17.5)/2, 30, 30);
    [leftBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(btnClickedToClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    //
    [self createPutView];
    //
    [self createBottomView];
}
-(void)createPutView
{
    _putView=[[UIView alloc] initWithFrame:CGRectMake(15, ScaleHeight(114), kScreenWidth-15*2, ScaleHeight(122))];
    _putView.backgroundColor=[UIColor whiteColor];
    _putView.layer.cornerRadius=4;
    _putView.layer.masksToBounds=YES;
    [self.view addSubview:_putView];
    NSArray *imagesArray=@[@"Phone-number",@"password"];
    NSArray *placeHolderArray=@[@"请输入手机号",@"请输入新密码"];
    CGFloat rowHeight=ScaleHeight(122)/2;
    for (int i=0; i<2; i++) {
        UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, rowHeight*i, CGRectGetWidth(_putView.frame), rowHeight)];
        [_putView addSubview:bgView];
        if (i==0) {
            UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(15, (rowHeight-ScaleHeight(22))/2, 15, ScaleHeight(22))];
            [iconImage setImage:[UIImage imageNamed:imagesArray[i]]];
            [bgView addSubview:iconImage];
            UITextField *txtField=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame)+14,( rowHeight-15.5)/2, 200, 15.5)];
            txtField.textColor=[UIColor hexStringToColor:@"#666666"];
            txtField.font=[UIFont systemFontOfSize:15];
            txtField.tag=400+i;
            txtField.placeholder=placeHolderArray[i];
            txtField.keyboardType=UIKeyboardTypeNumberPad;
            
            [bgView addSubview:txtField];
        }
        else if (i==1) {
            UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(15, (rowHeight-ScaleHeight(22))/2, 17, ScaleHeight(22))];
            [iconImage setImage:[UIImage imageNamed:imagesArray[i]]];
            [bgView addSubview:iconImage];
            UITextField *txtField=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame)+14,( rowHeight-15.5)/2, 200, 15.5)];
            txtField.textColor=[UIColor hexStringToColor:@"#666666"];
            txtField.font=[UIFont systemFontOfSize:15];
            txtField.placeholder=placeHolderArray[i];
            txtField.tag=400+i;
            txtField.secureTextEntry=YES;
            txtField.clearButtonMode=UITextFieldViewModeWhileEditing;
            [bgView addSubview:txtField];
        }
//        UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, rowHeight*i, CGRectGetWidth(_putView.frame), rowHeight)];
//        [_putView addSubview:bgView];
//        if (i==0) {
//            UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(15, (rowHeight-ScaleHeight(22))/2, 15, ScaleHeight(22))];
//            [iconImage setImage:[UIImage imageNamed:imagesArray[i]]];
//            [bgView addSubview:iconImage];
//            UITextField *txtField=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame)+ScaleHeight(15.5),( rowHeight-ScaleHeight(15.5))/2, 200, ScaleHeight(15.5))];
//            txtField.textColor=[UIColor hexStringToColor:@"#666666"];
//            txtField.font=[UIFont systemFontOfSize:15];
//            txtField.tag=400+i;
//            txtField.placeholder=placeHolderArray[i];
//            txtField.keyboardType=UIKeyboardTypeNumberPad;
//
//            [bgView addSubview:txtField];
//        }
//        else if (i==1) {
//            UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(15, (rowHeight-ScaleHeight(22))/2, 17, ScaleHeight(22))];
//            [iconImage setImage:[UIImage imageNamed:imagesArray[i]]];
//            [bgView addSubview:iconImage];
//            UITextField *txtField=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame)+14,( rowHeight-ScaleHeight(15.5))/2, 200, ScaleHeight(15.5))];
//            txtField.textColor=[UIColor hexStringToColor:@"#666666"];
//            txtField.font=[UIFont systemFontOfSize:15];
//            txtField.placeholder=placeHolderArray[i];
//            txtField.tag=400+i;
//            txtField.secureTextEntry=YES;
//            txtField.clearButtonMode=UITextFieldViewModeWhileEditing;
//            [bgView addSubview:txtField];
//        }
    }
    UIView *margin=[[UIView alloc] initWithFrame:CGRectMake(15, rowHeight, CGRectGetWidth(_putView.frame)-15*2, 0.5)];
    margin.backgroundColor=separatorColor1;
    [_putView addSubview:margin];
    //忘记密码
    UIButton *forgetBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame=CGRectMake(_putView.frame.origin.x, CGRectGetMaxY(_putView.frame)+15, CGRectGetWidth(_putView.frame), 16);
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(btnClickedToForget:) forControlEvents:UIControlEventTouchUpInside];
    
    forgetBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    forgetBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [self.view addSubview:forgetBtn];
    //登录
    UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame=CGRectMake(_putView.frame.origin.x, CGRectGetMaxY(forgetBtn.frame)+15, CGRectGetWidth(_putView.frame), ScaleHeight(44));
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:[UIColor hexStringToColor:@"#ea5413"]];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font=[UIFont systemFontOfSize:19];
    loginBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    loginBtn.layer.cornerRadius=4;
    loginBtn.layer.masksToBounds=YES;
    [loginBtn addTarget:self action:@selector(btnClickedToLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    //注册新用户
    UIButton *registerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame=CGRectMake(loginBtn.frame.origin.x, CGRectGetMaxY(loginBtn.frame)+15, CGRectGetWidth(loginBtn.frame), ScaleHeight(44));
    [registerBtn setBackgroundColor:[UIColor hexStringToColor:@"#00baff"]];
    [registerBtn setTitle:@"注册新用户" forState:UIControlStateNormal];
    registerBtn.titleLabel.font=[UIFont systemFontOfSize:19];
    registerBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    registerBtn.layer.cornerRadius=4;
    registerBtn.layer.masksToBounds=YES;
    [registerBtn addTarget:self action:@selector(btnClickedToRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    _registerBtn=registerBtn;
}
-(void)createBottomView
{
    NSString *title=@"第三方账号登录";
    CGFloat titleWidth=[title sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 13.5) ].width;
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-95)/2, CGRectGetMaxY(_registerBtn.frame)+72, titleWidth, 13.5)];
    titleLab.text=title;
    titleLab.textColor=[UIColor whiteColor];
    titleLab.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:titleLab];
    //线
    UIView *leftLine=[[UIView alloc] initWithFrame:CGRectMake(0, titleLab.frame.origin.y+CGRectGetHeight(titleLab.frame)/2, titleLab.frame.origin.x-15, 0.5)];
    leftLine.backgroundColor=separatorColor1;
    [self.view addSubview:leftLine];
    UIView *rightLine=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLab.frame)+15, leftLine.frame.origin.y, CGRectGetWidth(leftLine.frame), 0.5)];
    rightLine.backgroundColor=separatorColor1;
    [self.view addSubview:rightLine];
    //
    //三方登录
    
    UIView *bgView=[[UIView alloc] init];
    [self.view addSubview:bgView];
    NSArray *loginImageArray;
    CGFloat margin = 0.0;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]&& [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] ) {//有装QQ 和微信
        bgView.frame = CGRectMake(ScaleWidth(102), CGRectGetMaxY(titleLab.frame)+ScaleHeight(23.5), kScreenWidth-ScaleWidth(102)*2, ScaleHeight(35));
       loginImageArray =@[@"WeChat-baise",@"qq-baise",@"weibo-baise"];
        margin =(CGRectGetWidth(bgView.frame)-3*ScaleWidth(35))/2;
    }else if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]&& [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] ){////没有QQ 有微信
       bgView.frame = CGRectMake(ScaleWidth(130), CGRectGetMaxY(titleLab.frame)+ScaleHeight(23.5), kScreenWidth-ScaleWidth(102)*2, ScaleHeight(35));
       loginImageArray=@[@"WeChat-baise",@"weibo-baise"];
       margin =(CGRectGetWidth(bgView.frame)-2*ScaleWidth(35))/2;
    }
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]&& ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] ){//////有装QQ 没有微信
        bgView.frame = CGRectMake(ScaleWidth(130), CGRectGetMaxY(titleLab.frame)+ScaleHeight(23.5), kScreenWidth-ScaleWidth(102)*2, ScaleHeight(35));
        loginImageArray=@[@"qq-baise",@"weibo-baise"];
        margin =(CGRectGetWidth(bgView.frame)-2*ScaleWidth(35))/2;
    }
    else if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]&& ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] ){//////没有装QQ 也没有微信
        bgView.frame = CGRectMake(ScaleWidth(180), CGRectGetMaxY(titleLab.frame)+ScaleHeight(23.5), kScreenWidth-ScaleWidth(102)*2, ScaleHeight(35));
        loginImageArray=@[@"weibo-baise"];
        margin =(CGRectGetWidth(bgView.frame)- ScaleWidth(35))/2;
    }
    
    
    for (int i =0; i<loginImageArray.count; i++) {
        UIButton *threeLoginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        threeLoginBtn.frame=CGRectMake(i*(ScaleHeight(35)+margin), 0, ScaleHeight(35), ScaleHeight(35));
        threeLoginBtn.tag=1000+i;
        [threeLoginBtn setImage:[UIImage imageNamed:loginImageArray[i]] forState:UIControlStateNormal];
        [threeLoginBtn addTarget:self action:@selector(btnClickedToThreeLogin:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            self.weiXinBtn = threeLoginBtn;
        }
        [bgView addSubview:threeLoginBtn];
    }
}
#pragma mark
#pragma mark---事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)btnClickedToThreeLogin:(UIButton *)sender//三方登录
{
    [self clickThird:sender];
//    switch (sender.tag-1000) {
//        case 0:
//        {
//            NSLog(@"微信登录");
//
//        }
//            break;
//        case 1:
//        {
//            NSLog(@"QQ登录");
//        }
//            break;
//        case 2:
//        {
//            NSLog(@"sina登录");
//        }
//            break;
//            
//        default:
//            break;
//    }
}

#pragma mark --三方登陆按钮事件--

- (void)clickThird:(UIButton *)button
{
    NSLog(@"按钮的tag值:%ld",(long)button.tag);
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]  &&![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) { //1//没微信,也没有qq
        if (button.tag == 1000) {
            
            //        [SVProgressHUD showWithStatus:@"正在加载"];
            //        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"Sinaweibo://"]]) {
            //新浪微博
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
                if (error) {
                    MyLog(@"%@",error);
                } else {
                    UMSocialUserInfoResponse *resp = result;
                    
                    //[SVProgressHUD dismiss];
                    if ([NSString checkForNull:resp.name] && [NSString checkForNull:resp.iconurl]) {
                        [SVProgressHUD showErrorWithStatus:@"授权失败，请重试"];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        [self thirdLoginWithOpenId:resp.uid OpenToken:resp.accessToken Type:@"3" name:resp.name userPic:resp.iconurl];
                    }
                    
                }
            }];
            //        }else
            //        {
            //            [SVProgressHUD showErrorWithStatus:@"请安装微博客户端"];
            //        }
            
            
            
        }else if (button.tag == 1001) {
            //qq
            //        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]] ){//这里的wbxxxxxxxxx是URL schemes
            
            NSLog(@"安装qq客户端0");
            //            [SVProgressHUD showWithStatus:@"正在加载"];
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
                if (error) {
                    MyLog(@"%@",error);
                } else {
                    UMSocialUserInfoResponse *resp = result;
                    if ([NSString checkForNull:resp.name] && [NSString checkForNull:resp.iconurl]) {
                        [SVProgressHUD showErrorWithStatus:@"授权失败，请重试"];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else{
                         [self thirdLoginWithOpenId:resp.uid OpenToken:resp.accessToken Type:@"2" name:resp.name userPic:resp.iconurl];
                    }
                   
                    
                }
            }];
            //        }else
            //        {
            //            [SVProgressHUD showErrorWithStatus:@"请安装QQ客户端"];
            //        }
        }
        
    }else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]  &&![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]){//2//有微信,无qq
      
        if (button.tag == 1001) {
            
            //        [SVProgressHUD showWithStatus:@"正在加载"];
            //        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"Sinaweibo://"]]) {
            //新浪微博
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
                if (error) {
                    MyLog(@"%@",error);
                } else {
                    UMSocialUserInfoResponse *resp = result;
                    if ([NSString checkForNull:resp.name] && [NSString checkForNull:resp.iconurl]) {
                        [SVProgressHUD showErrorWithStatus:@"授权失败，请重试"];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        [self thirdLoginWithOpenId:resp.uid OpenToken:resp.accessToken Type:@"3" name:resp.name userPic:resp.iconurl];
                    }
                    //                    [SVProgressHUD dismiss];
                    
                }
            }];
            //        }else
            //        {
            //            [SVProgressHUD showErrorWithStatus:@"请安装微博客户端"];
            //        }
            
            
            
        }else if (button.tag == 1000) {
            //qq
//                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]] ){//这里的wbxxxxxxxxx是URL schemes

            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
                if (error) {
                    MyLog(@"%@",error);
                } else {
                    UMSocialUserInfoResponse *resp = result;

                    if ([NSString checkForNull:resp.name] && [NSString checkForNull:resp.iconurl]) {
                        [SVProgressHUD showErrorWithStatus:@"授权失败，请重试"];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        [self thirdLoginWithOpenId:resp.uid OpenToken:resp.accessToken Type:@"1" name:resp.name userPic:resp.iconurl];
                    }
                    //                    [SVProgressHUD dismiss];


                }
            }];

//            NSLog(@"安装qq客户端1");
//            //            [SVProgressHUD showWithStatus:@"正在加载"];
//            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
//                if (error) {
//                    MyLog(@"%@",error);
//                }
//                else {
//                    UMSocialUserInfoResponse *resp = result;
//                    if ([NSString checkForNull:resp.name] && [NSString checkForNull:resp.iconurl]) {
//                        [SVProgressHUD showErrorWithStatus:@"授权失败，请重试"];
//                        [self dismissViewControllerAnimated:YES completion:nil];
//                    }else{
//                          [self thirdLoginWithOpenId:resp.uid OpenToken:resp.accessToken Type:@"2" name:resp.name userPic:resp.iconurl];
//                    }
//
//
//                }
//            }];
//           }else{
//               [SVProgressHUD showErrorWithStatus:@"请安装QQ客户端"];
//                }
        }else{
            //微信
            //        [SVProgressHUD showWithStatus:@"正在加载"];
            //        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            //微信
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
                if (error) {
                    MyLog(@"%@",error);
                } else {
                    UMSocialUserInfoResponse *resp = result;
                    
                    if ([NSString checkForNull:resp.name] && [NSString checkForNull:resp.iconurl]) {
                        [SVProgressHUD showErrorWithStatus:@"授权失败，请重试"];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else{
                         [self thirdLoginWithOpenId:resp.uid OpenToken:resp.accessToken Type:@"1" name:resp.name userPic:resp.iconurl];
                    }
                    //                    [SVProgressHUD dismiss];
                   
                    
                }
            }];
            
            //        }else
            //        {
            
            //            [SVProgressHUD showErrorWithStatus:@"请安装微信客户端"];
            //        }
            
            
        }
        
    }
    else if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]  &&[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]){//3//有qq,无微信



        if (button.tag == 1001) {

            //新浪微博
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
                if (error) {
                    MyLog(@"%@",error);
                } else {
                    UMSocialUserInfoResponse *resp = result;
                    if ([NSString checkForNull:resp.name] && [NSString checkForNull:resp.iconurl]) {
                        [SVProgressHUD showErrorWithStatus:@"授权失败，请重试"];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        [self thirdLoginWithOpenId:resp.uid OpenToken:resp.accessToken Type:@"3" name:resp.name userPic:resp.iconurl];
                    }
                }
            }];


        }else if (button.tag == 1000) {
            //qq
                        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
                            if (error) {
                                MyLog(@"%@",error);
                            }
                            else {
                                UMSocialUserInfoResponse *resp = result;
                                if ([NSString checkForNull:resp.name] && [NSString checkForNull:resp.iconurl]) {
                                    [SVProgressHUD showErrorWithStatus:@"授权失败，请重试"];
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                }else{
                                      [self thirdLoginWithOpenId:resp.uid OpenToken:resp.accessToken Type:@"2" name:resp.name userPic:resp.iconurl];
                                }
                            }
                        }];
        }
    }
     else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]  && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]){//4//有qq,有微信
         if (button.tag == 1002) {

             //新浪微博
             [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
                 if (error) {
                     MyLog(@"%@",error);
                 } else {
                     UMSocialUserInfoResponse *resp = result;
                     if ([NSString checkForNull:resp.name] && [NSString checkForNull:resp.iconurl]) {
                         [SVProgressHUD showErrorWithStatus:@"授权失败，请重试"];
                         [self dismissViewControllerAnimated:YES completion:nil];
                     }else{
                         [self thirdLoginWithOpenId:resp.uid OpenToken:resp.accessToken Type:@"3" name:resp.name userPic:resp.iconurl];
                     }
                 }
             }];


         }else if (button.tag == 1001) {
             //qq
             [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
                 if (error) {
                     MyLog(@"%@",error);
                 }
                 else {
                     UMSocialUserInfoResponse *resp = result;
                     if ([NSString checkForNull:resp.name] && [NSString checkForNull:resp.iconurl]) {
                         [SVProgressHUD showErrorWithStatus:@"授权失败，请重试"];
                         [self dismissViewControllerAnimated:YES completion:nil];
                     }else{
                         [self thirdLoginWithOpenId:resp.uid OpenToken:resp.accessToken Type:@"2" name:resp.name userPic:resp.iconurl];
                     }
                 }
             }];
         }
         else if (button.tag == 1000) {
             //qq
             [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
                 if (error) {
                     MyLog(@"%@",error);
                 } else {
                     UMSocialUserInfoResponse *resp = result;

                     if ([NSString checkForNull:resp.name] && [NSString checkForNull:resp.iconurl]) {
                         [SVProgressHUD showErrorWithStatus:@"授权失败，请重试"];
                         [self dismissViewControllerAnimated:YES completion:nil];
                     }else{
                         [self thirdLoginWithOpenId:resp.uid OpenToken:resp.accessToken Type:@"1" name:resp.name userPic:resp.iconurl];
                     }

                 }
             }];
         }


     }

}

- (void)thirdLoginWithOpenId:(NSString *)openId OpenToken:(NSString *)openToken Type:(NSString *)type name:(NSString *)nameStr userPic:(NSString *)pic{


    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/MbUserController/loginByOpenNew.json",ftpPath];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:type forKey:@"useropentype"];
    [dic setValue:openId forKey:@"useropenid"];
    [dic setValue:openToken forKey:@"useropentoken"];
    [dic setValue:@"2" forKey:@"apptype"];
    [dic setValue:nameStr forKey:@"usernick"];
    [dic setValue:pic forKey:@"picUrl"];
    MyLog(@"%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:urlStr withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        MyLog(@"%@",requestDic);
        if ([requestDic[@"status"] intValue] == 1) {

            [SVProgressHUD showSuccessWithStatus:@"登录成功"];

#pragma mark 三方登录成功保存userID  和token

            [NSString setDefaultUser:requestDic[@"message"]];
            [NSString setDefaultToken:requestDic[@"data"]];
            NSString * userID=requestDic[@"message"];//用户id,取的时候用"userid"
            NSString *alias = [NSString stringWithFormat:@"%@vlvxing",userID];
            MyLog(@"三方登录成功保存%@三方登录成功保存%@",alias ,requestDic[@"data"]);
            [NSString setAlias:alias];
            [UMessage setAlias:alias type:@"vlvxing_type" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                MyLog(@"%@",responseObject);
                MyLog(@"%@",error);

            }];
            [UMessage removeAllTags:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {

            }];
            [UMessage addTag:@"1" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {

            }];


            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

          [self dismissViewControllerAnimated:YES completion:nil];
            });

//
        }else if([requestDic[@"status"] intValue] == 2) {
            [SVProgressHUD dismiss];
            VLXThirdRegistVC *reg =[[VLXThirdRegistVC alloc] init];
            reg.type=type;
            reg.openId=openId;
            reg.openToken=openToken;
            [self.navigationController pushViewController:reg animated:YES];
            
        }else
        {

            [SVProgressHUD showErrorWithStatus:msg];
        }


    } failure:^(NSString *errorInfo) {
        [SVProgressHUD showErrorWithStatus:@"请求超时"];

    }];

    
}

-(BOOL)beforeRegister//登录之前的验证
{
    UITextField * phonetextfield=[self.view viewWithTag:400];
    UITextField * newpwtextfield=[self.view viewWithTag:401];
    if ([phonetextfield.text isMobileNumber:phonetextfield.text]==NO) {
        [SVProgressHUD showErrorWithStatus:@"请您输入正确的手机号码!"];
        return NO;
    }else if ([NSString checkForNull:newpwtextfield.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入密码!"];
        return NO;
    }
    return YES;
}
-(void)btnClickedToLogin:(UIButton *)sender//手机登录
{
    NSLog(@"登录");
    if ([self beforeRegister]) {
        [SVProgressHUD showWithStatus:@"登录中..."];
        UITextField * phonetextfield=[self.view viewWithTag:400];
        UITextField * newpwtextfield=[self.view viewWithTag:401];
        if (![NSString checkForNull:phonetextfield.text]) {
            
            if (![NSString checkForNull:newpwtextfield.text]) {
                NSMutableDictionary * dic=[NSMutableDictionary dictionary];
                dic[@"phoneNum"]=phonetextfield.text;
                dic[@"password"]=newpwtextfield.text;
                dic[@"appType"]=@"2";
                NSString * url=[NSString stringWithFormat:@"%@/MbUserController/login.json",ftpPath];
                
                [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
                    MyLog(@"登录👌:%@",requestDic);
                    if ([requestDic[@"status"] integerValue]==1) {
                        
                        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                        /////保存基本信息  token 和手机号
                        [NSString setDefaultToken:requestDic[@"data"][@"token"]];
                        [NSString setDefaultUser:phonetextfield.text];
                        
                        
                        NSString * urserID =[NSString stringWithFormat:@"%d",[requestDic[@"data"][@"userId"] intValue]];




                        
                        NSString *alias = [NSString stringWithFormat:@"%@vlvxing",urserID];
                        [NSString setAlias:alias];
                        [UMessage setAlias:alias type:@"vlvxing_type" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                            MyLog(@"%@",responseObject);
                            MyLog(@"%@",error);
                            
                        }];
                        [UMessage removeAllTags:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
                            
                        }];
                        [UMessage addTag:@"1" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
                            
                        }];
                        //                    }

                      
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self dismissViewControllerAnimated:YES completion:^{
                                
                                
                            }];
                        });
                        
                    }else
                    {
                        [SVProgressHUD showErrorWithStatus:msg];
                    }
                    MyLog(@"%@",requestDic);
                } failure:^(NSString *errorInfo) {
                    [SVProgressHUD dismiss];
                    
                }];
                
            }else
            {
                
                [SVProgressHUD showErrorWithStatus:@"请输入密码"];
            }
            
        }else
        {
            
            [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        }
    }
//    [SVProgressHUD showWithStatus:@"登录中..."];
//    UITextField * phonetextfield=[self.view viewWithTag:400];
//    UITextField * newpwtextfield=[self.view viewWithTag:401];
//    if (![NSString checkForNull:phonetextfield.text]) {
//
//        if (![NSString checkForNull:newpwtextfield.text]) {
//            NSMutableDictionary * dic=[NSMutableDictionary dictionary];
//            dic[@"phoneNum"]=phonetextfield.text;
//            dic[@"password"]=newpwtextfield.text;
//            dic[@"appType"]=@"2";
//            NSString * url=[NSString stringWithFormat:@"%@/MbUserController/login.json",ftpPath];
//
//            [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
//                MyLog(@"%@",requestDic);
//                if ([requestDic[@"status"] integerValue]==1) {
//                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
//                    /////保存基本信息  token 和手机号
//                    [NSString setDefaultToken:requestDic[@"data"][@"token"]];
//                     [NSString setDefaultUser:phonetextfield.text];
//
//
//                    NSString * urserID =requestDic[@"data"][@"userId"];
//
//
//                        
//                                        NSString *alias = [NSString stringWithFormat:@"%@vlvxing",urserID];
//                                        [NSString setAlias:alias];
//                                        [UMessage setAlias:alias type:@"vlvxing_type" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
//                                            MyLog(@"%@",responseObject);
//                                            MyLog(@"%@",error);
//                        
//                                        }];
//                                        [UMessage removeAllTags:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
//                        
//                                        }];
//                                        [UMessage addTag:@"1" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
//                        
//                                        }];
////                    }
//
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [self dismissViewControllerAnimated:YES completion:^{
//
//
//                        }];
//                    });
//
//                }else
//                {
//                    [SVProgressHUD showErrorWithStatus:msg];
//                }
//                MyLog(@"%@",requestDic);
//            } failure:^(NSString *errorInfo) {
//                [SVProgressHUD dismiss];
//
//            }];
//
//        }else
//        {
//
//            [SVProgressHUD showErrorWithStatus:@"请输入密码"];
//        }
//
//    }else
//    {
//
//        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
//    }

}
-(void)btnClickedToRegister:(UIButton *)sender//注册新用户
{
    NSLog(@"注册新用户");

    VLXRegisterVC *registerVC=[[VLXRegisterVC alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
-(void)btnClickedToForget:(UIButton *)sender//忘记密码
{
    NSLog(@"忘记密码");
    VLXFindPWVC * findVC=[[VLXFindPWVC alloc]init];
    findVC.titleString=@"忘记密码";
    [self.navigationController pushViewController:findVC animated:YES];
}
-(void)btnClickedToClose:(UIButton *)sender//关闭
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark
#pragma mark---delegate
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  VLXFixPhoneVC.m
//  Vlvxing
//
//  Created by Michael on 17/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXFixPhoneVC.h"

@interface VLXFixPhoneVC ()
@property (nonatomic,strong)UIView *centerView;
@end

@implementation VLXFixPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
}
-(void)createUI
{
    [self setNav];
    [self createCenter];
    [self createBottom];
}

#pragma mark block的方法
-(void)getPhoneBlock:(phoneBlock)phoneblock
{
    self.block=phoneblock;
}

- (void)setNav{

    self.title = @"修改手机号";
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
    NSArray *imagesArray=@[@"Phone-number",@"captcha"];
    NSArray *placeHolderArray=@[@"请输入手机号",@"请输入验证码"];
    CGFloat rowHeight=52;
    _centerView=[[UIView alloc] initWithFrame:CGRectMake(0, 69-rowHeight, kScreenWidth, rowHeight*2)];
    //    _centerView.backgroundColor=[UIColor orangeColor];
    [self.view addSubview:_centerView];
    for (int i=0; i<2; i++) {
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

        }else if (i==2)
        {
            //            UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(15, (rowHeight-22)/2, 17, 22)];
            //            [iconImage setImage:[UIImage imageNamed:imagesArray[i]]];
            //            [bgView addSubview:iconImage];
            //            UITextField *txtField=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame)+14,( rowHeight-15.5)/2, 200, 15.5)];
            //            txtField.textColor=[UIColor hexStringToColor:@"#666666"];
            //            txtField.font=[UIFont systemFontOfSize:15];
            //            txtField.placeholder=placeHolderArray[i];
            //            txtField.keyboardType=UIKeyboardTypeNumberPad;
            //            txtField.tag=300+i;
            //            [bgView addSubview:txtField];

        }

    }

}

-(void)btnClickedToGetCode:(UIButton * )btn
{

    MyLog(@"获取验证码");
    NSLog(@"获取验证码");
    UITextField * textfield=[self.view viewWithTag:300];
    

    if (![NSString checkForNull:textfield.text]) {
        if (![textfield.text isMobileNumber:textfield.text]) {
            [SVProgressHUD showErrorWithStatus:@"输入手机号格式不正确，请重新输入"];
            return;
        }

        [SVProgressHUD showWithStatus:@"验证码发送中..."];
        NSLog(@"获取验证码");
        NSMutableDictionary * dic=[NSMutableDictionary dictionary];

        dic[@"phoneNum"]=textfield.text;
        dic[@"forwhat"]=@"3";
        dic[@"userType"]=@"3";
        NSString * url=[NSString stringWithFormat:@"%@/mbUserPer/getCode.json",ftpPath];
        MyLog(@"%@",dic);
        [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
            if ([requestDic[@"status"]integerValue]) {

                //验证码发送成功
                [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
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

-(void)createBottom
{
    UIButton *registerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame=CGRectMake(15, CGRectGetMaxY(_centerView.frame)+40, kScreenWidth-15*2, 44);
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

-(void)btnClickedToRegister:(UIButton*)btn
{

    MyLog(@"点击确定");
  [SVProgressHUD showWithStatus:@"加载中..."];
  UITextField * YanZhengtextfield=[self.view viewWithTag:301];
  UITextField * Newtextfield=[self.view viewWithTag:300];

    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"userId"] = [NSString getDefaultUser];
    dic[@"infoCode"]=YanZhengtextfield.text;
    dic[@"newphoneNum"]=Newtextfield.text;
    NSString * url=[NSString stringWithFormat:@"%@/MbUserController/updateUserMobile.json",ftpPath];
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        if ([requestDic[@"status"] integerValue]==1) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            if (self.block) {
                self.block(Newtextfield.text);
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        MyLog(@"%@",requestDic);
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
    }];



}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

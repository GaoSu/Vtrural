//
//  VLXFeadBackVC.m
//  Vlvxing
//
//  Created by Michael on 17/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXFeadBackVC.h"

@interface VLXFeadBackVC ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView * textview;
@property(nonatomic,strong)UITextField * textfield;
@property(nonatomic,strong)UILabel * placeLabel;
@end

@implementation VLXFeadBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createBottom];
}

-(void)createUI
{
    [self setNav];
    UIView * topview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 172)];
    topview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topview];
    self.textview=[UITextView new];
    self.textview.layer.masksToBounds=YES;
    self.textview.layer.cornerRadius=5;
    self.textview.textColor=[UIColor hexStringToColor:@"999999" andAlph:1];
    self.textview.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    self.textview.delegate=self;
    self.textview.layer.borderColor=[UIColor hexStringToColor:@"999999"].CGColor;
    self.textview.layer.borderWidth=0.5;


    [topview addSubview:self.textview];

    [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(ScaleHeight(16));
        make.width.mas_equalTo(ScreenWidth-30);
        make.height.mas_equalTo(140);
    }];

    self.placeLabel=[UILabel new];
    self.placeLabel.text=@"您的意见是我们前进的动力..";
    self.placeLabel.textColor=[UIColor hexStringToColor:@"999999" andAlph:1];
    self.placeLabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [self.textview addSubview:self.placeLabel];
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(ScaleWidth(12.5));
        make.top.mas_equalTo(ScaleHeight(12.5));

        make.width.mas_equalTo(ScreenWidth/3*2);
        make.height.mas_equalTo(14);

    }];

    UIView * downview=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topview.frame)+ScaleHeight(16), ScreenWidth, 60)];
    downview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:downview];


    self.textfield=[UITextField new];
    self.textfield.placeholder=@"您的手机号码";
    self.textfield.textColor=[UIColor hexStringToColor:@"999999"];
    self.textfield.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    self.textfield.layer.masksToBounds=YES;
    self.textfield.layer.cornerRadius=5;
    self.textfield.layer.borderWidth=0.5;
    self.textfield.layer.borderColor=[UIColor hexStringToColor:@"999999"].CGColor;
    [downview addSubview:self.textfield];
    [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(downview.mas_centerX);
        make.centerY.mas_equalTo(downview.mas_centerY);
        make.width.mas_equalTo(ScreenWidth-30);
        make.height.mas_equalTo(40);
    }];
//textfield左边的展位图
    UIView * zhanwei=[[UIView alloc]initWithFrame:CGRectMake(13, 0, 13, 20)];
    zhanwei.backgroundColor=[UIColor whiteColor];
    self.textfield.leftView=zhanwei;
    self.textfield.leftViewMode=UITextFieldViewModeAlways;
}
//郭荣明9.30修改
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.textview resignFirstResponder];
    
    [self.textfield resignFirstResponder];
}

-(void)createBottom
{
    UIButton *registerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame=CGRectMake(15, 288.5, kScreenWidth-15*2, 44);
    [registerBtn setTitle:@"提交" forState:UIControlStateNormal];
    registerBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    registerBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [registerBtn setBackgroundColor:[UIColor hexStringToColor:@"#ea5413"]];
    registerBtn.layer.cornerRadius=4;
    registerBtn.layer.masksToBounds=YES;
    [registerBtn addTarget:self action:@selector(btnClickedToRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
}
- (void)setNav{
    self.title = @"意见反馈";
    self.view.backgroundColor=[UIColor hexStringToColor:@"f3f3f4"];
    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton)];
}


#pragma  mark 代理方法点击事件

-(void)tapLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnClickedToRegister
{
    if (self.textview.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请填写您的见解"];
    }else
    {

        if (self.textfield.text.length==0) {
            [SVProgressHUD showErrorWithStatus:@"请输入您的手机号"];
        }else
        {
            [SVProgressHUD showWithStatus:@"加载中..."];
            NSMutableDictionary * dic=[NSMutableDictionary dictionary];
            dic[@"phone"]=self.textfield.text;
            dic[@"content"]=self.textview.text;
            dic[@"token"]=[NSString getDefaultToken];

            NSString * url=[NSString stringWithFormat:@"%@/MbUserProposalController/auth/feedBack.json",ftpPath];
            [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
                if ([requestDic[@"status"] integerValue]==1) {

                    [SVProgressHUD showSuccessWithStatus:@"意见已经提交"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController
                         popViewControllerAnimated:YES];
                    });
                }else{
                    [SVProgressHUD showErrorWithStatus:msg];


                }


            } failure:^(NSString *errorInfo) {
                [SVProgressHUD dismiss];


            }];


        }
    }
    MyLog(@"提交了");
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length==0) {
        self.placeLabel.hidden=NO;
    }else
    {
        self.placeLabel.hidden=YES;
    }

}




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

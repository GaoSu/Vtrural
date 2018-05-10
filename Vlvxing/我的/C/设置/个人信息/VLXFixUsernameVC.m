//
//  VLXFixUsernameVC.m
//  Vlvxing
//
//  Created by Michael on 17/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXFixUsernameVC.h"

@interface VLXFixUsernameVC ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField  * textfield;
@end

@implementation VLXFixUsernameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
-(void)createUI
{
    [self setNav];
    UIView * bgview=[[UIView alloc]initWithFrame:CGRectMake(0, 6.5, ScreenWidth, 44)];
    bgview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgview];

    self.textfield =[[UITextField alloc]initWithFrame:CGRectMake(ScaleWidth(12), 14.5, ScreenWidth/4*3, 16)];
    self.textfield.placeholder=@"请输入用户名";
    self.textfield.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    self.textfield.returnKeyType=UIReturnKeyNext;
    self.textfield.delegate=self;
    [bgview addSubview:self.textfield];

}
//点击空白处回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.textfield resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    MyLog(@"点击了返回按钮");
    if (self.backblock) {
        self.backblock(self.textfield.text);
    }
    [self.navigationController popViewControllerAnimated:YES];

    return YES;
}
- (void)setNav{
    self.title = @"用户名";
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

    //右边按钮
    UIButton * rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(0, 0, 30, 20);
    [rightBtn setTitleColor:[UIColor hexStringToColor:@"ea5413"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [rightBtn addTarget:self action:@selector(rightBarClick) forControlEvents:UIControlEventTouchUpInside];


    UIBarButtonItem * rightBar=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightBar;

}



#pragma  mark 代理方法点击事件

-(void)tapLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBarClick
{
    MyLog(@"点击右边的按钮");
    if (self.backblock) {
        self.backblock(self.textfield.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
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

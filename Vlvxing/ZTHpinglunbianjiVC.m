
//
//  ZTHpinglunbianjiVC.m
//  XingJu
//
//  Created by cncommdata on 2017/1/3.
//  Copyright © 2017年 heima. All rights reserved.
//

#import "ZTHpinglunbianjiVC.h"

#import "HMEmotionTextView.h"
#import "HMAccountTool.h"
#import "HMAccount.h"




@interface ZTHpinglunbianjiVC ()<UITextViewDelegate>
{
    UITextView * txvw;
}
@property (nonatomic,weak)HMEmotionTextView *textVieww;

@end

@implementation ZTHpinglunbianjiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor  = [UIColor colorWithWhite:0.9 alpha:1];

    self.title = @"编写评论";
    NSLog(@"传递的什么鬼%@",_content_str);

    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton19) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton19)];

    self.automaticallyAdjustsScrollViewInsets = NO;//文字不自动布局,(让文字居顶显示)

    // 1.创建输入控件
    _textVieww = [[HMEmotionTextView alloc] init];
    _textVieww.alwaysBounceVertical = YES; // 垂直方向上拥有有弹簧效果
    _textVieww.frame = CGRectMake(0, 64, ScreenWidth, 100);
    _textVieww.delegate = self;
    _textVieww.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:_textVieww];
    self.textVieww = _textVieww;
    _textVieww.placehoder = @"输入评论";
    _textVieww.font = [UIFont systemFontOfSize:15];


    UIButton * OKbtn = [[UIButton alloc]initWithFrame:CGRectMake( ScreenWidth - 110,110+64 , 100, 50)];
    [OKbtn setTitle:@"发表评论" forState:UIControlStateNormal];
    OKbtn.backgroundColor = [UIColor lightGrayColor];
    [OKbtn addTarget:self action:@selector(xxx) forControlEvents:UIControlEventTouchUpInside];



//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"backk1" highImageName:nil target:self action:@selector(clickBackButton)];

    [self.view addSubview:txvw];
    [self.view addSubview:OKbtn];


}
//点击返回按钮
- (void)tapLeftButton19
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [txvw resignFirstResponder];
}

-(void)xxx{
    NSString * url = [NSString stringWithFormat:@"%@%@",BaseUrl,@"dynamic_comment"];

    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"content"] = _textVieww.text;
    para[@"dynamicId"] = _content_str;//动态id
    para[@"commentId"] = _commentId_str;//评论id

    NSLog(@"评论传递的字段%@",para);



    [HMHttpTool post:url params:para success:^(id responseObj) {
        NSLog(@"评论成功%@",responseObj);
        [MBProgressHUD showSuccess:@"评论成功"];

        //这是通知的必写方法,传的值是""
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ChuanZhiBa" object:nil];
        [self.navigationController popViewControllerAnimated:YES];


    } failure:^(NSError *error) {
        NSLog(@"评论失败%@",error);
        [MBProgressHUD showSuccess:@"评论失败"];
    }];



}




@end


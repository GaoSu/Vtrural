//
//  VLX__chengkexuzhiVC.m
//  Vlvxing
//
//  Created by grm on 2017/10/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX__chengkexuzhiVC.h"

@interface VLX__chengkexuzhiVC ()

@end

@implementation VLX__chengkexuzhiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"乘客须知";
    
//    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton6) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;


    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton6)];

    
    UITextView * txvw = [[UITextView alloc]initWithFrame:CGRectMake(10, 10 ,ScreenWidth-15 , ScreenHeight-64-10)];
//    txvw.backgroundColor = [UIColor lightGrayColor];
    txvw.text = @"关于机票的问题，请参考(乘客须知)";
    txvw.editable = NO;
    
    [self.view addSubview:txvw];
}

-(void)tapLeftButton6
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end

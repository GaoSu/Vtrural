//
//  VLX_gaiqianshuomingViewController.m
//  Vlvxing
//
//  Created by grm on 2017/11/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_gaiqianshuomingViewController.h"

@interface VLX_gaiqianshuomingViewController ()

@end

@implementation VLX_gaiqianshuomingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton53) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton53)];

    self.title = @"改签说明";
    
    self.view.backgroundColor = rgba(245, 245, 245, 1);
    [self makeMineUI53];
    
}
-(void)tapLeftButton53
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeMineUI53{
    
}

@end

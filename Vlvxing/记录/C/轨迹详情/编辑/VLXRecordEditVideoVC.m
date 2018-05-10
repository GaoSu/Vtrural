//
//  VLXRecordEditVideoVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/15.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXRecordEditVideoVC.h"

@interface VLXRecordEditVideoVC ()<UITextFieldDelegate>
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIView *titleView;
@property (nonatomic,strong)UITextField *titleTXT;//标注点名称
@property (nonatomic,copy)NSString *address;//当前地址
//@property (nonatomic,strong)UIImage *image;//封面图
@end

@implementation VLXRecordEditVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];

    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //    //获取键盘的高度
    //    NSDictionary *userInfo = [aNotification userInfo];
    //    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //    CGRect keyboardRect = [aValue CGRectValue];
    //    int height = keyboardRect.size.height;
    [UIView animateWithDuration:0.28 animations:^{
        self.view.bounds=CGRectMake(0, 100, kScreenWidth, kScreenHeight);
    }];
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [UIView animateWithDuration:0.28 animations:^{
        self.view.bounds=CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }];
}
#pragma mark---数据
#pragma mark
#pragma mark---视图
-(void)createUI
{
    [self setNav];
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 240)];
    topView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:topView];
    _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, topView.frame.size.height)];
    //得到封面图
//    _image=[ZYYCustomTool getImage:[_url path]];
//        _imageView.image=_image;
    if (_model) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[ZYYCustomTool checkNullWithNSString:_model.coverurl]] placeholderImage:ADNoDataImage];
    }else if (_detailModel)
    {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[ZYYCustomTool checkNullWithNSString:_detailModel.coverurl]] placeholderImage:ADNoDataImage];
    }

    _imageView.contentMode=UIViewContentModeScaleAspectFit;
    _imageView.userInteractionEnabled=YES;
    [topView addSubview:_imageView];
    UIButton *playBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.center=_imageView.center;
    playBtn.bounds=CGRectMake(0, 0, 36, 36);
    [playBtn setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(btnClickedToPlay:) forControlEvents:UIControlEventTouchUpInside];
    [_imageView addSubview:playBtn];
    //
    _titleView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame)+8, kScreenWidth, 60)];
    _titleView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_titleView];
    _titleTXT=[[UITextField alloc] initWithFrame:CGRectMake(12, 12, kScreenWidth-12-90, _titleView.frame.size.height-12*2)];
    _titleTXT.placeholder=@"请输入标注名称";
    _titleTXT.delegate=self;
    _titleTXT.layer.cornerRadius=4;
    _titleTXT.layer.masksToBounds=YES;
    _titleTXT.layer.borderColor=[UIColor hexStringToColor:@"#999999"].CGColor;
    _titleTXT.layer.borderWidth=0.5;
    [_titleView addSubview:_titleTXT];
    UIButton *saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame=CGRectMake(CGRectGetMaxX(_titleTXT.frame)+15, _titleTXT.frame.origin.y, 60, _titleTXT.frame.size.height);
    saveBtn.backgroundColor=orange_color;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius=4;
    saveBtn.layer.masksToBounds=YES;
    [saveBtn addTarget:self action:@selector(btnClickedToSave:) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:saveBtn];
    
}
- (void)setNav{
    
    self.title = @"编辑视频标注点";
    self.view.backgroundColor=[UIColor hexStringToColor:@"f3f3f4"];
    //左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(tapLeftButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}
#pragma mark
#pragma mark---事件
-(void)btnClickedToPlay:(UIButton *)sender
{
    NSLog(@"轨迹video");
    KYLocalVideoPlayVC *pushViewController = [[KYLocalVideoPlayVC alloc] init];
    pushViewController.title = @"短视频";
    
//    pushViewController.URLString=[_url path];
    if (_model) {
        pushViewController.URLString=[ZYYCustomTool checkNullWithNSString:_model.videourl];
    }else if (_detailModel)
    {
        pushViewController.URLString=[ZYYCustomTool checkNullWithNSString:_detailModel.videourl];
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:pushViewController animated:YES];
}
-(void)tapLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnClickedToSave:(UIButton *)sender//编辑
{
    if ([NSString checkForNull:_titleTXT.text]) {
        [SVProgressHUD showInfoWithStatus:@"请填写标注点名称"];
        return;
    }
    if (_model) {
        [SVProgressHUD showWithStatus:@"正在保存"];
        NSMutableDictionary * dic=[NSMutableDictionary dictionary];
        
        dic[@"token"]=[NSString getDefaultToken];//
        dic[@"pathInfoId"]=[NSString stringWithFormat:@"%@",_model.pathinfoid];
        dic[@"pathName"]=[ZYYCustomTool checkNullWithNSString:_titleTXT.text];
        NSString * url=[NSString stringWithFormat:@"%@/TraRoadController/auth/updatePathinfo.html",ftpPath];
        NSLog(@"%@",dic);
        [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
            [SVProgressHUD dismiss];
            //        NSLog(@"%@",requestDic.mj_JSONString);
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            if ([requestDic[@"status"] integerValue]==1) {
                
                //                [self.navigationController popViewControllerAnimated:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else
            {
                [SVProgressHUD showErrorWithStatus:msg];
            }
            
        } failure:^(NSString *errorInfo) {
            [SVProgressHUD dismiss];
            
        }];
    }else if (_detailModel)
    {
        [SVProgressHUD showWithStatus:@"正在保存"];
        NSMutableDictionary * dic=[NSMutableDictionary dictionary];
        
        dic[@"token"]=[NSString getDefaultToken];//
        dic[@"pathInfoId"]=[NSString stringWithFormat:@"%@",_detailModel.pathinfoid];
        dic[@"pathName"]=[ZYYCustomTool checkNullWithNSString:_titleTXT.text];
        NSString * url=[NSString stringWithFormat:@"%@/TraRoadController/auth/updatePathinfo.html",ftpPath];
        NSLog(@"%@",dic);
        [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
            [SVProgressHUD dismiss];
            //        NSLog(@"%@",requestDic.mj_JSONString);
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            if ([requestDic[@"status"] integerValue]==1) {
                
                //                [self.navigationController popViewControllerAnimated:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else
            {
                [SVProgressHUD showErrorWithStatus:msg];
            }
            
        } failure:^(NSString *errorInfo) {
            [SVProgressHUD dismiss];
            
        }];
    }
}
#pragma mark
#pragma mark---textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark
#pragma mark---delegate
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

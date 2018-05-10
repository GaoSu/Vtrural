//
//  VLXPersonInfoTableVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/27.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXPersonInfoTableVC.h"
#import "XWPicChooseAlterView.h"
#import "VLXSexAlertView.h"//选择性别的弹窗
@interface VLXPersonInfoTableVC ()<UIImagePickerControllerDelegate,XWPicChooseAlterViewDelegate,VLXSexAlertViewDelegate,UIPickerViewDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTXT;
@property (weak, nonatomic) IBOutlet UITextField *sexTXT;
@property (weak, nonatomic) IBOutlet UITextField *contactNameTXT;
@property (weak, nonatomic) IBOutlet UITextField *contactPhoneTXT;
@property (weak, nonatomic) IBOutlet UITextField *contactAddressTXT;
@property (weak, nonatomic) IBOutlet UITextField *contactIDCardTXT;
@property(nonatomic,strong)UIImagePickerController * picker;
@property(nonatomic,strong)NSString * userPicStr;//头像
@property(nonatomic,assign)NSInteger sexNum;//
@end

@implementation VLXPersonInfoTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self createUI];
    [self loadData];
}
#pragma mark---数据
-(void)loadData
{
    //个人信息
    [_iconImageView sd_setImageWithURL:self.dataDic[@"userpic"] placeholderImage:[UIImage imageNamed:@"touxiang-moren"]];
    self.userPicStr=[ZYYCustomTool checkNullWithNSString:self.dataDic[@"userpic"]];
    _iconImageView.layer.cornerRadius=_iconImageView.frame.size.width/2;
    _iconImageView.layer.masksToBounds=YES;
    _userNameTXT.text=[ZYYCustomTool checkNullWithNSString:self.dataDic[@"usernick"]];
    self.sexNum=[self.dataDic[@"usersex"] integerValue];
    if ([self.dataDic[@"usersex"] integerValue]==1) {
        
        _sexTXT.text=@"男";
    }else
    {
        _sexTXT.text=@"女";
    }
    //联系人信息
    _contactNameTXT.text=[ZYYCustomTool checkNullWithNSString:self.dataDic[@"username"]];
    _contactPhoneTXT.text=[ZYYCustomTool checkNullWithNSString:self.dataDic[@"usermobile"]];
    _contactAddressTXT.text=[ZYYCustomTool checkNullWithNSString:self.dataDic[@"usercontactaddr"]];
    _contactIDCardTXT.text=[ZYYCustomTool checkNullWithNSString:self.dataDic[@"usernumber"]];
}
#pragma mark
#pragma mark---视图
-(void)createUI
{
    [self setNav];


    self.tableView.tableFooterView=[[UIView alloc] init];

    [_userNameTXT addTarget:self action:@selector(myNameAction:) forControlEvents:(UIControlEventEditingChanged)];
//    [_userNameTXT addTarget:self action:@selector(myNameStarAction:) forControlEvents:(UIControlEventEditingDidBegin)];
}
-(void)myNameAction:(UITextField *)txfd{//文本改变的时候
    NSLog(@"AAAAA");
    if (txfd.text.length>11) {
        [MBProgressHUD showError:@"名字太长"];
        txfd.text = [txfd.text substringToIndex:11];
    }
}
//-(void)myNameStarAction:(UITextField *)txfd{//开始进入第一响应
//    NSLog(@"bbbbb");
//}

- (void)setNav{
    self.title = @"个人信息";
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
#pragma mark
#pragma  mark 选择性别
-(void)chooseSex
{
    VLXSexAlertView * sexAlert=[[VLXSexAlertView alloc]init];
    sexAlert.delegate=self;
    UIWindow * window=[UIApplication sharedApplication].keyWindow;
    
    [window addSubview:sexAlert];
    
}
#pragma mark 选择性别的代理方法
-(void)bringBackMessage:(NSInteger)type
{
    self.sexNum=type;
    
//    NSIndexPath * indexpath=[NSIndexPath indexPathForRow:2 inSection:0];
//    VLXPersonLabelCell * cell=[self.tableview cellForRowAtIndexPath:indexpath];
    if (type==1) {
        _sexTXT.text=@"男";
    }else
    {
        _sexTXT.text=@"女";
    }
    MyLog(@"%ld",(long)type);
}
#pragma mark ---- picChooseDelegate
-(void)clickBtnNumber:(int)type{
    if(type==0)//拍照上传
    {
        if (![UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
            [SVProgressHUD showErrorWithStatus:@"相机不可用"];//RWNLocalizedString(@"SheZhi-TheCameraIsNotAvailable");
        }else
        {
            self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.picker animated:YES completion:nil];
        }
    }
    else //本地上传
    {
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.picker animated:YES completion:nil];
    }
}
#pragma mark imagePicker代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    MyLog(@"得到照片");
    UIImage *portraitImg = info[UIImagePickerControllerEditedImage];
//    VLXiPersonImageCell * cell=[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    cell.userImageview.image=portraitImg;
    _iconImageView.image=portraitImg;
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
    
    [UploadImageTool UploadImage:portraitImg upLoadProgress:^(float progress) {
        
        
    } successUrlBlock:^(NSString *url) {
        if (url) {
            
            [self uplodimage:url];
        }
        MyLog(@"%@",url);
        
        
    } failBlock:^(NSString *error) {
        
        MyLog(@"%@",error);
    }];
    
    
}
-(void)uplodimage:(NSString * )imgString
{
    self.userPicStr=imgString;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark---事件
#pragma mark --- 选择图片
-(void)choosePic
{
    XWPicChooseAlterView *picChooseAlertView = [[XWPicChooseAlterView alloc]init];
    picChooseAlertView.delegate = self;
    UIWindow *window= [UIApplication sharedApplication].keyWindow;
    [window addSubview:picChooseAlertView];
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.allowsEditing = YES;
    self.picker.delegate = self;
}


-(void)tapLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)beforeSave
{
    if ([NSString checkForNull:_userNameTXT.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请填写用户名"];
        return NO;
    }else if (!_sexNum)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择您的性别"];
        return NO;
    }else if (![_contactPhoneTXT.text isMobileNumber:_contactPhoneTXT.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return NO;
    }else if (![NSString validateIdentityCard:_contactIDCardTXT.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的身份证号"];
        return NO;
    }
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"变");
    return YES;
}

-(void)rightBarClick
{
    [self.view endEditing:YES];
    MyLog(@"点击右边");
    //在这里进行上传操作
    BOOL isFull= YES;    // [self beforeSave];
    if (isFull) {
        [SVProgressHUD showWithStatus:@"加载中..."];
        NSMutableDictionary * dic=[NSMutableDictionary dictionary];
        dic[@"token"]=[NSString getDefaultToken];
        dic[@"userPic"]=self.userPicStr;
        dic[@"userNick"]=[ZYYCustomTool checkNullWithNSString:_userNameTXT.text];
        dic[@"userSex"]=[NSString stringWithFormat:@"%ld",(long)self.sexNum];
        dic[@"username"]=[ZYYCustomTool checkNullWithNSString:_contactNameTXT.text];
        dic[@"usermobile"]=[ZYYCustomTool checkNullWithNSString:_contactPhoneTXT.text];
        dic[@"usercontactaddr"]=[ZYYCustomTool checkNullWithNSString:_contactAddressTXT.text];
        dic[@"usernumber"]=[ZYYCustomTool checkNullWithNSString:_contactIDCardTXT.text];
        NSString * url=[NSString stringWithFormat:@"%@/MbUserController/auth/changeSetting.json",ftpPath];
        [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
            MyLog(@"%@",requestDic);
            if ([requestDic[@"status"]integerValue]==1) {
                
                [SVProgressHUD showSuccessWithStatus:@"个人资料编辑成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
//                    if ([self.delegate respondsToSelector:@selector(refresh:)]) {
//                        [self.delegate refresh:YES];
//                    }
                });
            }else
            {
                [SVProgressHUD showErrorWithStatus:msg];
            }
            
        } failure:^(NSString *errorInfo) {
            
            [SVProgressHUD dismiss];
            
        }];
    }
//    if (isFull) {
//        if (self.userPicStr.length==0) {
//            [SVProgressHUD showErrorWithStatus:@"请上传你的头像"];
//
//        }else
//        {
//
//            if (self.nickName.length==0) {
//                [SVProgressHUD showErrorWithStatus:@"请填写用户昵称"];
//            }else
//            {
//                if (!self.sexNum) {
//                    [SVProgressHUD showErrorWithStatus:@"请填选择性别"];
//                }else
//                {
//                    [SVProgressHUD showWithStatus:@"加载中..."];
//                    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
//                    dic[@"token"]=[NSString getDefaultToken];
//                    dic[@"userPic"]=self.userPicStr;
//                    dic[@"userNick"]=self.nickName;
//                    dic[@"userSex"]=[NSString stringWithFormat:@"%ld",(long)self.sexNum];
//                    dic[@"username"]=self.userName;
//                    dic[@"usermobile"]=self.phoneNumber;
//                    dic[@"usercontactaddr"]=self.address;
//                    dic[@"usernumber"]=self.IDCard;
//                    NSString * url=[NSString stringWithFormat:@"%@/MbUserController/auth/changeSetting.json",ftpPath];
//                    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
//                        MyLog(@"%@",requestDic);
//                        if ([requestDic[@"status"]integerValue]==1) {
//                            
//                            [SVProgressHUD showSuccessWithStatus:@"个人资料编辑成功"];
//                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                [self.navigationController popViewControllerAnimated:YES];
//                                if ([self.delegate respondsToSelector:@selector(refresh:)]) {
//                                    [self.delegate refresh:YES];
//                                }
//                            });
//                        }else
//                        {
//                            [SVProgressHUD showErrorWithStatus:msg];
//                        }
//                        
//                    } failure:^(NSString *errorInfo) {
//                        
//                        [SVProgressHUD dismiss];
//                        
//                    }];
//                }
//            }
//        }
//    }
    
    
    
}
#pragma mark
#pragma mark---textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark
#pragma mark
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark---delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    NSLog(@"row: %ld",indexPath.row);
    if (indexPath.row==0) {
        [self choosePic];
    }else if (indexPath.row==2)
    {
        [self chooseSex];
    }
}
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

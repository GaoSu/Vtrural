//
//  VLXPersonalMessageVC.m
//  Vlvxing
//
//  Created by Michael on 17/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXPersonalMessageVC.h"
#import "VLXiPersonImageCell.h"//第一个cell
#import "VLXPersonLabelCell.h"//第二个cell
#import "XWPicChooseAlterView.h"//选择头像
#import "VLXFixUsernameVC.h"//修改用户名
#import "VLXSexAlertView.h"//选择性别的弹窗
#import "UIImageView+WebCache.h"
#import "VLXContactInputVC.h"
@interface VLXPersonalMessageVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,XWPicChooseAlterViewDelegate,VLXSexAlertViewDelegate,UIPickerViewDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)UIImagePickerController * picker;
@property(nonatomic,assign)NSInteger sexNum;//
@property(nonatomic,strong)NSString * nickName;//用户名
@property(nonatomic,strong)NSString * userPicStr;//头像
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,copy)NSString *phoneNumber;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *IDCard;
@end
@implementation VLXPersonalMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    if ([self.delegate respondsToSelector:@selector(refresh:)]) {
        [self.delegate refresh:NO];
    }
}
-(void)createUI
{
    [self setNav];
    [self.view addSubview:self.tableview];

}

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

#pragma  mark 代理方法点击事件

-(void)tapLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)beforeSave
{
    if ([NSString checkForNull:_userPicStr]) {
        [SVProgressHUD showErrorWithStatus:@"请上传你的头像"];
        return NO;
    }else if ([NSString checkForNull:_nickName])
    {
        [SVProgressHUD showErrorWithStatus:@"请填写用户名"];
        return NO;
    }else if (!_sexNum)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择您的性别"];
        return NO;
    }else if ([NSString checkForNull:_userName])
    {
        [SVProgressHUD showErrorWithStatus:@"请填写联系人姓名"];
        return NO;
    }else if (![_phoneNumber isMobileNumber:_phoneNumber])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的联系人手机号"];
        return NO;
    }else if ([NSString checkForNull:_address])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入联系人地址"];
        return NO;
    }else if (![NSString validateIdentityCard:_IDCard])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的联系人身份证号"];
        return NO;
    }
    return YES;
}
-(void)rightBarClick
{

    MyLog(@"点击右边");
//在这里进行上传操作
    BOOL isFull=[self beforeSave];
    if (isFull) {
        if (self.userPicStr.length==0) {
            [SVProgressHUD showErrorWithStatus:@"请上传你的头像"];
            
        }else
        {
            
            if (self.nickName.length==0) {
                [SVProgressHUD showErrorWithStatus:@"请填写用户昵称"];
            }else
            {
                if (!self.sexNum) {
                    [SVProgressHUD showErrorWithStatus:@"请填选择性别"];
                }else
                {
                    [SVProgressHUD showWithStatus:@"加载中..."];
                    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
                    dic[@"token"]=[NSString getDefaultToken];
                    dic[@"userPic"]=self.userPicStr;
                    dic[@"userNick"]=self.nickName;
                    dic[@"userSex"]=[NSString stringWithFormat:@"%ld",(long)self.sexNum];
                    dic[@"username"]=self.userName;
                    dic[@"usermobile"]=self.phoneNumber;
                    dic[@"usercontactaddr"]=self.address;
                    dic[@"usernumber"]=self.IDCard;
                    NSString * url=[NSString stringWithFormat:@"%@/MbUserController/auth/changeSetting.json",ftpPath];
                    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
                        MyLog(@"%@",requestDic);
                        if ([requestDic[@"status"]integerValue]==1) {
                            
                            [SVProgressHUD showSuccessWithStatus:@"个人资料编辑成功"];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.navigationController popViewControllerAnimated:YES];
                                if ([self.delegate respondsToSelector:@selector(refresh:)]) {
                                    [self.delegate refresh:YES];
                                }
                            });
                        }else
                        {
                            [SVProgressHUD showErrorWithStatus:msg];
                        }
                        
                    } failure:^(NSString *errorInfo) {
                        
                        [SVProgressHUD dismiss];
                        
                    }];
                }
            }
        }
    }



}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }
    return 4;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            VLXiPersonImageCell * imageCEll=[tableView dequeueReusableCellWithIdentifier:@"personImage" forIndexPath:indexPath];
            imageCEll.selectionStyle=UITableViewCellSelectionStyleNone;
            [imageCEll.userImageview sd_setImageWithURL:self.dataDic[@"userpic"] placeholderImage:[UIImage imageNamed:@"touxiang-moren"]];
            self.userPicStr=[NSString stringWithFormat:@"%@",self.dataDic[@"userpic"]];
            return imageCEll;
        }else
        {
            VLXPersonLabelCell * labelcell=[tableView dequeueReusableCellWithIdentifier:@"personlabel" forIndexPath:indexPath];
            labelcell.selectionStyle=UITableViewCellSelectionStyleNone;
            if (indexPath.row==1) {
                
                labelcell.rightlabel.text=[ZYYCustomTool checkNullWithNSString:self.dataDic[@"usernick"]];
                self.nickName=self.dataDic[@"usernick"];
                
                
            }else
            {
                labelcell.leftlabel.text=@"性别";
                self.sexNum=[self.dataDic[@"usersex"] integerValue];
                if ([self.dataDic[@"usersex"] integerValue]==1) {
                    
                    labelcell.rightlabel.text=@"男";
                }else
                {
                    labelcell.rightlabel.text=@"女";
                }
                
                labelcell.rightlabel.textColor=[UIColor hexStringToColor:@"999999"];
                labelcell.footerview.hidden=YES;
                
            }
            return labelcell;
        }
    }else if (indexPath.section==1)
    {
        VLXPersonLabelCell * labelcell=[tableView dequeueReusableCellWithIdentifier:@"personlabel" forIndexPath:indexPath];
        labelcell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (indexPath.row==0) {
            labelcell.leftlabel.text=@"姓名";
            labelcell.rightlabel.text=[ZYYCustomTool checkNullWithNSString:self.dataDic[@"username"]];
            self.userName=self.dataDic[@"username"];
        }else if (indexPath.row==1)
        {
            labelcell.leftlabel.text=@"手机";
            labelcell.rightlabel.text=[ZYYCustomTool checkNullWithNSString:self.dataDic[@"usermobile"]];
            self.phoneNumber=self.dataDic[@"usermobile"];
        }else if (indexPath.row==2)
        {
            labelcell.leftlabel.text=@"地址";
            labelcell.rightlabel.text=[ZYYCustomTool checkNullWithNSString:self.dataDic[@"usercontactaddr"]];
            self.address=self.dataDic[@"usercontactaddr"];
        }else if (indexPath.row==3)
        {
            labelcell.leftlabel.text=@"身份证号";
            labelcell.rightlabel.text=[ZYYCustomTool checkNullWithNSString:self.dataDic[@"usernumber"]];
            self.IDCard=self.dataDic[@"usernumber"];
        }
        return labelcell;
    }
    return nil;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 94;
        }
        return 44.5;
    }
    return 44.5;

}

#pragma mark didselect
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            [self choosePic];
            
        }else if (indexPath.row==1)
        {
            VLXFixUsernameVC * name=[[VLXFixUsernameVC alloc]init];
            name.backblock=^(NSString * nameStr)
            {
                NSIndexPath * indexpath=[NSIndexPath indexPathForRow:1 inSection:0];
                VLXPersonLabelCell * cell= [self.tableview cellForRowAtIndexPath:indexPath];
                cell.rightlabel.text=[ZYYCustomTool checkNullWithNSString:nameStr];
                self.nickName=nameStr;
            };
            [self.navigationController pushViewController:name animated:YES];
            
        }else{
            [self chooseSex];
        }
    }else if (indexPath.section==1)
    {
        VLXContactInputVC *contactVC=[[VLXContactInputVC alloc] init];
        if (indexPath.row==0) {
            contactVC.titleStr=@"姓名";
        }else if (indexPath.row==1)
        {
            contactVC.titleStr=@"手机";
        }else if (indexPath.row==2)
        {
            contactVC.titleStr=@"地址";
        }else if (indexPath.row==3)
        {
            contactVC.titleStr=@"身份证号";
        }
        [self.navigationController pushViewController:contactVC animated:YES];
        contactVC.backblock=^(NSString *textStr)
        {
            if (indexPath.row==0) {
//                _userName=textStr;
                VLXPersonLabelCell * cell= [self.tableview cellForRowAtIndexPath:indexPath];
                cell.rightlabel.text=[ZYYCustomTool checkNullWithNSString:textStr];
                self.userName=textStr;
            }else if (indexPath.row==1)
            {
//                _phoneNumber=textStr;
                VLXPersonLabelCell * cell= [self.tableview cellForRowAtIndexPath:indexPath];
                cell.rightlabel.text=[ZYYCustomTool checkNullWithNSString:textStr];
                self.phoneNumber=textStr;
            }else if (indexPath.row==2)
            {
//                _address=textStr;
                VLXPersonLabelCell * cell= [self.tableview cellForRowAtIndexPath:indexPath];
                cell.rightlabel.text=[ZYYCustomTool checkNullWithNSString:textStr];
                self.address=textStr;
            }else if (indexPath.row==3)
            {
//                _IDCard=textStr;
                VLXPersonLabelCell * cell= [self.tableview cellForRowAtIndexPath:indexPath];
                cell.rightlabel.text=[ZYYCustomTool checkNullWithNSString:textStr];
                self.IDCard=textStr;
            }
        };
    }



}
#pragma mark---头尾视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44.5)];
        titleView.backgroundColor=[UIColor whiteColor];
        UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-10, 44.5)];
        titleLab.text=@"联系人信息";
        titleLab.font=[UIFont systemFontOfSize:16];
        titleLab.textAlignment=NSTextAlignmentLeft;
        [titleView addSubview:titleLab];
        //
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(12, titleView.frame.size.height-1, kScreenWidth, 1)];
        lineView.backgroundColor=separatorColor1;
        [titleView addSubview:lineView];
        //
        return titleView;
    }
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 44.5;
    }
    return 0.00001;
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
    NSIndexPath * indexpath=[NSIndexPath indexPathForRow:2 inSection:0];
    VLXPersonLabelCell * cell=[self.tableview cellForRowAtIndexPath:indexpath];
    if (type==1) {
        cell.rightlabel.text=@"男";
    }else
    {
          cell.rightlabel.text=@"女";
    }
    MyLog(@"%ld",(long)type);
}
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
    VLXiPersonImageCell * cell=[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.userImageview.image=portraitImg;

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
#pragma mark 懒加载
-(UITableView * )tableview
{
    if (!_tableview) {
        _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        _tableview.backgroundColor=[UIColor hexStringToColor:@"f3f3f4"];
        _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"VLXiPersonImageCell" bundle:nil] forCellReuseIdentifier:@"personImage"];
        [_tableview registerNib:[UINib nibWithNibName:@"VLXPersonLabelCell" bundle:nil] forCellReuseIdentifier:@"personlabel"];
    }

    return _tableview;
}
@end

//
//  VLXMySettingVC.m
//  Vlvxing
//
//  Created by Michael on 17/5/19.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXMySettingVC.h"//点击上的设置按钮才会跳转到这个界面
#import "VLXMysetingTableViewCell.h"
#import "VLXFindPWVC.h"//找回密码
#import "VLXFixPhoneVC.h"//修改手机号
#import "VLXFeadBackVC.h"//意见反馈
#import "VLXAboutUSVC.h"//关于我们
#import "VLXLoginVC.h"//登录
#import "UIImageView+WebCache.h"

#import<CommonCrypto/CommonDigest.h>//sha1哈希算法


@interface VLXMySettingVC ()<UITableViewDelegate,UITableViewDataSource,SetCellSwicthDelegate>
@property(nonatomic,strong)UITableView * tableviewl;
@property(nonatomic,strong)NSArray * nameArray;
@property(nonatomic,strong)NSArray * ImageArray;
@property(nonatomic,strong)NSString * sizeString;
@property(nonatomic,copy)NSString * phoneStr;
@end

@implementation VLXMySettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self makesizeOfCach];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    if ([NSString getDefaultToken]) {

   [self getNetWorking];
    }else
    {

        NSIndexPath * indexpath=[NSIndexPath indexPathForRow:1 inSection:0];

        VLXMysetingTableViewCell * cell =[self.tableviewl cellForRowAtIndexPath:indexpath];
        cell.rightlabel.text=@"未绑定手机号";
    }

}
-(void)getNetWorking
{
    [SVProgressHUD show];
    NSString * url =[NSString stringWithFormat:@"%@/MbUserController/auth/getUserInfo.json",ftpPath];
    NSDictionary * dic =@{@"token":[NSString getDefaultToken]};
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        NSLog_JSON(@"这是返回的所有的用户信息::%@",requestDic);
        if ([requestDic[@"status"] integerValue]==1) {
            NSString * phoneNum =[NSString stringWithFormat:@"%@", requestDic[@"data"][@"usermobile"]];

            [self reloadthisview:phoneNum];

/*

            //先获取Signature (数据签名)
            //APP secret: fWIyqLQSTb

            NSString * AppKey = @"cpj2xarlc1xyn";

            int suijishu = arc4random() % 100000;//获取一个随机数0到十万之内的
            NSString * Nonce = [NSString stringWithFormat:@"%d",suijishu];//随机数

            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970]*1000;
            NSString *Timestamp = [NSString stringWithFormat:@"%.0f", a];//转为字符型,省去小数点后边的
            NSString * pinjieStr = [NSString stringWithFormat:@"%@%@%@",AppKey,Nonce,Timestamp];

            NSString * Signature =[self sha1:pinjieStr];
           // /*

            NSString * urserID =[NSString stringWithFormat:@"%d",[requestDic[@"data"][@"userid"] intValue]];
            NSString * nickName = [NSString stringWithFormat:@"%@",requestDic[@"data"][@"usernick"]];
            NSString * userPic = [NSString stringWithFormat:@"%@",requestDic[@"data"][@"userpic"]];

            NSString * tURL1 = @"http://api.cn.ronghub.com/user/getToken";//获取融云token的地址
            //获取融云token
            NSMutableDictionary * tPara = [NSMutableDictionary dictionary];
            tPara[@"userId"]= urserID;
            tPara[@"name"] =  nickName;
            tPara[@"portraitUri"]=userPic;
            NSLog(@"tpara:::%@",tPara);

            //json格式的参数
            NSError * err ;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:tPara options:NSJSONWritingPrettyPrinted error:&err];
            NSString * jsonString =[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog_JSON(@"惊悚json:%@",jsonString);//打印出的是json格式的参数
            NSString * tURL2 =[NSString stringWithFormat:@"%@%@",tURL1,jsonString];

            [HMHttpTool post:tURL2 params:nil success:^(id responseObj) {
                NSLog_JSON(@"获取融云token👌:%@",responseObj);
            } failure:^(NSError *error) {
                NSLog_JSON(@"获取融云token失败:%@",error);
            }];
            */


        }else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
        [self.tableviewl reloadData];

    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];

    }];
}
-(NSString *)sha1:(NSString * )str{

    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];

    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(data.bytes, (unsigned int)data.length, digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

//刷新手机号
-(void)reloadthisview:(NSString * )phoneNun
{
    self.phoneStr=phoneNun;
        NSIndexPath * indexpath=[NSIndexPath indexPathForRow:1 inSection:0];

    [self.tableviewl reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)createUI
{


    self.phoneStr=self.dic[@"usermobile"];

    self.nameArray=@[@[@"修改密码",@"更换手机号"],@[@"信息提醒",@"关于我们"],@[@"意见反馈",@"清除本地缓存"]];
    self.ImageArray=@[@[@"password",@"phone-number"],@[@"remind",@"about"],@[@"opinion",@"-clear"]];
    [self setNav];
    [self.view addSubview:self.tableviewl];
    //创建tableviewfooter
    UIView * footer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,ScaleHeight(245.5))];
    footer.backgroundColor=[UIColor hexStringToColor:@"f3f3f4"];
    self.tableviewl.tableFooterView=footer;

    UIButton * logoffBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    logoffBtn.frame=CGRectMake(ScaleWidth(15), ScaleHeight(147.5),ScaleWidth(345), 44);
//    logoffBtn.frame=CGRectMake(ScaleWidth(15), footer.frame.size.height-ScaleHeight(24)-44,ScaleWidth(345), 44);
    [logoffBtn setBackgroundColor:[UIColor hexStringToColor:@"999999"]];
    [logoffBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoffBtn setTitleColor:[UIColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];
    [logoffBtn addTarget:self action:@selector(logoffClick) forControlEvents:UIControlEventTouchUpInside];
    logoffBtn.layer.masksToBounds=YES;
    logoffBtn.layer.cornerRadius=4;
    [footer addSubview:logoffBtn];
}

-(void)logoffClick
{

    UIAlertController * alertControl=[UIAlertController alertControllerWithTitle:@"确定退出登录？" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction * cancleAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        MyLog(@"取消");

    }];
    UIAlertAction * sureAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [NSString removeDefaultToken];
        //友盟退出登录 先注调
        
        [UMessage removeAllTags:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
            
        }];
        [UMessage addTag:@"2" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
            
        }];
        
        
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"alias"];
        VLXLoginVC * login=[[VLXLoginVC alloc]init];

        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:nil];
        MyLog(@"确定退出");
    }];
    [alertControl addAction:cancleAction];
    [alertControl addAction:sureAction];
    [self presentViewController:alertControl animated:YES completion:^{


    }];

}


#pragma mark 计算缓存的大小
-(void)makesizeOfCach
{

    NSInteger  size =  [[SDImageCache sharedImageCache]getSize];

    //    NSLog(@"%.1fM",size/1024.0/1024.0);
    NSString * sizeStr=[NSString stringWithFormat:@"%.2fM",size/1024.0/1024.0];
//    MyLog(@"%@",sizeStr);
    NSIndexPath * indexpath=[NSIndexPath indexPathForRow:2 inSection:2];
    self.sizeString=sizeStr;
//    [self.tableviewl reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];

    [self.tableviewl reloadData];
}




- (void)setNav{

    self.title = @"设置";
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
-(void)tapLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

//iOS 11.2以后,分组的头和尾部的frame会变大,所以需要加上这两个方法,让头和尾部的view从视觉上看是正常
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}


#pragma mark 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return self.nameArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * rowArray=self.nameArray[section];
    return rowArray.count;

}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VLXMysetingTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"setingCell" forIndexPath:indexPath];
    UIImage * image=[UIImage imageNamed:self.ImageArray[indexPath.section][indexPath.row]] ;
    cell.leftimageview.image=image;
    cell.leftLabel.text=self.nameArray[indexPath.section][indexPath.row];
    cell.leftimageview.size=image.size;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.switchview.transform= CGAffineTransformMakeScale(0.715,0.709);
    if ([self.nameArray[indexPath.section][indexPath.row] isEqual:@"更换手机号"]||[self.nameArray[indexPath.section][indexPath.row] isEqual:@"关于我们"]||[self.nameArray[indexPath.section][indexPath.row] isEqual:@"检查更新"]) {

        cell.footerline.hidden=YES;
    }else
    {
        cell.footerline.hidden=NO;
    }

    if ([self.nameArray[indexPath.section][indexPath.row] isEqual:@"信息提醒"]) {
        cell.delegate = self;
        cell.switchview.hidden=NO;
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.rightlabel.hidden=YES;
        NSString *pushStr = [NSString stringWithFormat:@"%d",[self.dic[@"userispush"] intValue]];
        if ([pushStr isEqualToString:@"1"]) { // 推送
            cell.switchview.on = YES;
        }else{ // 不推送
            cell.switchview.on = NO;
        }

    }else
    {
        cell.switchview.hidden=YES;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.rightlabel.hidden=NO;
    }
 cell.rightlabel.hidden=YES;
//设定右边图形的显示和隐藏
    if (indexPath.section==0&&indexPath.row==1) {

        cell.rightlabel.hidden=NO;


        if ([NSString checkForNull:self.phoneStr]) {
//没有返回手机号
            cell.rightlabel.text=@"尚未绑定手机号";
        }else
        {
            //弄小星星
            NSString * headerstring=[self.phoneStr substringToIndex:3];
            NSString * footerString=[self.phoneStr substringFromIndex:7];
            NSString * finalStr=[NSString stringWithFormat:@"%@****%@",headerstring,footerString];
            cell.rightlabel.text=finalStr;
        }

    }
    if (indexPath.section==2&&indexPath.row==1) {
        cell.rightlabel.hidden=NO;
        cell.rightlabel.text=self.sizeString;
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section:%ld row:%ld",indexPath.section,indexPath.row);
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            if ([NSString getDefaultToken]) {
                VLXFindPWVC * find=[[VLXFindPWVC alloc]init];
                find.titleString=@"修改密码";
                [self.navigationController pushViewController:find animated:YES];


            }else
            {
//                [SVProgressHUD showInfoWithStatus:@"暂未登陆,请先登录"];
                UIAlertController * alertControl=[UIAlertController alertControllerWithTitle:@"暂未登录,请您登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * cancleAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    MyLog(@"取消");
                    
                }];
                UIAlertAction * sureAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [NSString removeDefaultToken];
                    VLXLoginVC * login=[[VLXLoginVC alloc]init];
                    
                    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:nil];
                    MyLog(@"确定退出");
                }];
                [alertControl addAction:cancleAction];
                [alertControl addAction:sureAction];
                [self presentViewController:alertControl animated:YES completion:^{
                    
                    
                }];
            }
        }
        else
        {
            //修改手机号
            VLXFixPhoneVC * phone=[[VLXFixPhoneVC alloc]init];
            phone.oldPhoneNumber=self.dic[@"usermobile"];
#pragma mark 修改手机号的回调
            [phone getPhoneBlock:^(NSString *phone) {
                //弄小星星
                NSString * headerstring=[phone substringToIndex:3];
                NSString * footerString=[phone substringFromIndex:7];
                NSString * finalStr=[NSString stringWithFormat:@"%@****%@",headerstring,footerString];
                NSIndexPath * indexpath=[NSIndexPath indexPathForRow:1 inSection:0];
              VLXMysetingTableViewCell * cell=  [self.tableviewl cellForRowAtIndexPath:indexpath];
                cell.rightlabel.text=finalStr;


            }];

            if ([NSString getDefaultToken]) {
                [self.navigationController pushViewController:phone animated:YES];


            }else
            {
//                [SVProgressHUD showInfoWithStatus:@"暂未登陆,请先登录"];
                UIAlertController * alertControl=[UIAlertController alertControllerWithTitle:@"暂未登录,请您登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * cancleAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    MyLog(@"取消");
                    
                }];
                UIAlertAction * sureAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [NSString removeDefaultToken];
                    VLXLoginVC * login=[[VLXLoginVC alloc]init];
                    
                    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:nil];
                    MyLog(@"确定退出");
                }];
                [alertControl addAction:cancleAction];
                [alertControl addAction:sureAction];
                [self presentViewController:alertControl animated:YES completion:^{
                    
                    
                }];
            }

            

        }
    }else if (indexPath.section==1)
    {
        if (indexPath.row==0) {

        }else
        {
        if ([NSString getDefaultToken]) {
            VLXAboutUSVC * usVC=[[VLXAboutUSVC alloc]init];
            [self.navigationController pushViewController:usVC animated:YES];

            }else
            {
//                [SVProgressHUD showInfoWithStatus:@"暂未登陆,请先登录"];
                UIAlertController * alertControl=[UIAlertController alertControllerWithTitle:@"暂未登录,请您登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * cancleAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    MyLog(@"取消");
                    
                }];
                UIAlertAction * sureAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [NSString removeDefaultToken];
                    VLXLoginVC * login=[[VLXLoginVC alloc]init];
                    
                    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:nil];
                    MyLog(@"确定退出");
                }];
                [alertControl addAction:cancleAction];
                [alertControl addAction:sureAction];
                [self presentViewController:alertControl animated:YES completion:^{
                    
                    
                }];
            }


        }
    }else
    {
        if (indexPath.row==0) {

        if ([NSString getDefaultToken]) {
                          VLXFeadBackVC * fead=[[VLXFeadBackVC alloc]init];
                          [self.navigationController pushViewController:fead animated:YES];


            }else
            {
//                [SVProgressHUD showInfoWithStatus:@"暂未登陆,请先登录"];
                UIAlertController * alertControl=[UIAlertController alertControllerWithTitle:@"暂未登录,请您登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * cancleAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    MyLog(@"取消");
                    
                }];
                UIAlertAction * sureAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [NSString removeDefaultToken];
                    VLXLoginVC * login=[[VLXLoginVC alloc]init];
                    
                    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:nil];
                    MyLog(@"确定退出");
                }];
                [alertControl addAction:cancleAction];
                [alertControl addAction:sureAction];
                [self presentViewController:alertControl animated:YES completion:^{
                    
                    
                }];
            }

        }else if(indexPath.row==1)
        {
            MyLog(@"清理缓存");
//            [[SDImageCache sharedImageCache] clearDisk];

            [[SDImageCache sharedImageCache] clearMemory];//可有可无
             [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                 NSString * str=[NSString stringWithFormat:@"清除%@缓存",self.sizeString];
                 [SVProgressHUD showSuccessWithStatus:str];
                 [self makesizeOfCach];

             }];

        }else
        {

        }

    }
}

#pragma mark ============= 点击switch的事件
-(void)changeSwitchStatusWithSwitch:(UISwitch *)mySwitch{
    mySwitch.selected = !mySwitch.selected;
    if (mySwitch.on) {
        [self changePushStatusWithString:@"1"]; // 推送
    }else{
        [self changePushStatusWithString:@"2"]; // 不推送
    }
}

#pragma mark =========== 调接口修改状态
-(void)changePushStatusWithString:(NSString *)type{
    [SVProgressHUD showWithStatus:@"正在修改"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/MbUserController/isUserPush.json",ftpPath];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"userId"] = [NSString stringWithFormat:@"%@",self.dic[@"userid"]];
    dic[@"isPush"] = type;
    [SPHttpWithYYCache postRequestUrlStr:urlStr withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        if ([requestDic[@"status"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:errorInfo];
    }];
}
#pragma mark 懒加载
-(UITableView * )tableviewl
{
    if (!_tableviewl) {
        _tableviewl=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenHeight-64) style:UITableViewStyleGrouped];
        _tableviewl.delegate=self;
        _tableviewl.dataSource=self;
        _tableviewl.backgroundColor=[UIColor hexStringToColor:@"f3f3f4"];        _tableviewl.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_tableviewl registerNib:[UINib nibWithNibName:@"VLXMysetingTableViewCell" bundle:nil] forCellReuseIdentifier:@"setingCell"];
    }
    return _tableviewl;
}
@end

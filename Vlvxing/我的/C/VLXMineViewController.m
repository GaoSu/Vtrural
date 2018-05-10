//
//  VLXMineViewController.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/18.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXMineViewController.h"
#import "VLXMineStaticCell.h"
#import "VLXUnLoginHeaderView.h"//未登录头视图
#import "VLXLoginVC.h"//登录
#import "VLXMineUserCell.h"//登录以后的第一个cell
#import "VLXMySettingVC.h"//我的设置
#import "VLXPersonalMessageVC.h"//个人中心
#import "VLXMyDingZhiVC.h"//我的定制
#import "VLXMyOrderVC.h"//我的订单
#import "VLXCollectVC.h"//我的收藏

#import "VLXWebViewVC.h"//白金信用卡

#import "ShareBtnView.h"
#import "ShareTool.h"
#import "VLXPersonInfoTableVC.h"

#import "VLX_Mine_GZ_Vc.h"//关注
#import "VLX_Mine_Fensi_VC.h"//粉丝
#import "VLX_Mine_TAdynamic_VC.h"//TA话题动态

@interface VLXMineViewController ()<UITableViewDelegate,UITableViewDataSource,VLXPersonalMessageVCDelegate,ShareBtnViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *iconImageArray;
@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,assign)NSInteger cellnumber;
@property (nonatomic,strong)VLXUnLoginHeaderView * unLoginHeader;
@property(nonatomic,strong)NSDictionary * dataDic;

@property(nonatomic,weak)UIView * blackView;
@property(nonatomic,weak)ShareBtnView*shareView;

@property (nonatomic,strong)NSString *  isXYK;//是否展示办信用卡, (=1展示) ,(=0不展示)
@property (nonatomic,strong)NSNumber * followsNumber;//喜欢数
@property (nonatomic,strong)NSNumber * fansNumber;//粉丝数

@property (nonatomic,strong) UIButton *topTitleBt1;//顶端三个文字按钮,(关注,粉丝,话)
@property (nonatomic,strong) UIButton *topTitleBt2;//顶端三个文字按钮,(关注,粉丝,话)
@property (nonatomic,strong) UIButton *topTitleBt3;//顶端三个文字按钮,(关注,粉丝,话)


@end

@implementation VLXMineViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    _isXYK = [userDefaultes  stringForKey:@"is_XINGYONGKA"];
    if (_isXYK == nil) {
        NSLog(@"没有xyk");
    }
    else{
        NSLog(@"有xyk,,");
    }
//    _isXYK=@"1";//不展示
    //观察通知
    NSLog(@"_isXYK1:%@",_isXYK);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI:) name:@"sameLogin" object:nil];

    //
    if ([NSString getDefaultToken])
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        if ([_isXYK isEqualToString:@"0"] || _isXYK == nil){
            self.cellnumber=6;
        }else{
            self.cellnumber=7;
        }
        //        self.cellnumber=6;
        self.tableView.tableHeaderView=nil;

        [self loadData];


    }else
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        _tableView.tableHeaderView=self.unLoginHeader;
        if ([_isXYK isEqualToString:@"0"] || _isXYK == nil){
            self.cellnumber=5;
        }else{
            self.cellnumber=6;
        }
        //        self.cellnumber=5;
    }


    [self.tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if ( self.navigationController.childViewControllers.count > 1 ) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sameLogin" object:nil];
}
#pragma mark---刷新界面
-(void)refreshUI:(NSNotification *)notify
{
    if ([notify.userInfo[@"loginout"] integerValue]==1) {
        if ([NSString getDefaultToken])
        {
            NSLog(@"_isXYK2:%@",_isXYK);
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            if ([_isXYK isEqualToString:@"0"] || _isXYK == nil){
                self.cellnumber=6;
            }else{
                self.cellnumber=7;
            }
//            self.cellnumber=6;
            self.tableView.tableHeaderView=nil;
            
            [self loadData];

        }else
        {
            NSLog(@"_isXYK3:%@",_isXYK);
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            _tableView.tableHeaderView=self.unLoginHeader;
            if ([_isXYK isEqualToString:@"0"] || _isXYK == nil){
                self.cellnumber=5;
            }else{
                self.cellnumber=6;
            }
//            self.cellnumber=5;
        }
        
        
        [self.tableView reloadData];
    }
}
#pragma mark自定义刷新方法的回调
-(void)refresh:(BOOL)refreshed
{

//    self.shaxin=refreshed;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.shaxin=YES;
    // Do any additional setup after loading the view.小字亮灰,成功立领十元红包
    //初始化
//    _iconImageArray=@[@"information",@"indent",@"dingzhi1",@"collect",@"WechatIMG29",@"share-green"];
//    _iconImageArray=@[@"information",@"indent",@"dingzhi1",@"collect",@"share-green"];

//    _titleArray=@[@"个人信息",@"我的订单",@"我的定制",@"我的收藏",@"白金信用卡申请",@"分享"];
//    _titleArray=@[@"个人信息",@"我的订单",@"我的定制",@"我的收藏",@"分享"];
//_isXYK=@"1";//展示
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    _isXYK = [userDefaultes  stringForKey:@"is_XINGYONGKA"];
    NSLog(@"_isXYK4:%@",_isXYK);
    if ([_isXYK isEqualToString:@"0"] || _isXYK == nil){//要想隐藏信用卡,只需要后台返回状态码为0即可,前台不需要任何操作
        _iconImageArray=@[@"information",@"indent",@"dingzhi1",@"collect",@"share-green"];
        _titleArray=@[@"个人信息",@"我的订单",@"我的定制",@"我的收藏",@"分享"];

    }else{
        _iconImageArray=@[@"information",@"indent",@"dingzhi1",@"collect",@"WechatIMG29",@"share-green"];
        _titleArray=@[@"个人信息",@"我的订单",@"我的定制",@"我的收藏",@"白金信用卡申请",@"分享"];


    }



    //
    self.automaticallyAdjustsScrollViewInsets = NO;//防止frame乱搞
    [self createUI];
//    [self loadData];
}



#pragma mark---数据
-(void)loadData
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"token"]=[NSString getDefaultToken];
    NSLog(@"token::::%@",dic);
    NSString * url=[NSString stringWithFormat:@"%@/MbUserController/auth/getUserInfo.json",ftpPath];
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        NSLog_JSON(@"我的OK:%@",requestDic.mj_JSONString);
        if ([requestDic[@"status"] integerValue]==1) {


            NSString * usernameStr  = requestDic[@"data"][@"usernick"];
            NSString * pictureStr = requestDic[@"data"][@"userpic"];

            NSLog(@"%@-------%@",usernameStr,pictureStr);


            //存储登陆之后的用户名昵称和头像
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"%@",usernameStr] forKey:@"nameForRY"];
            [defaults setObject:[NSString stringWithFormat:@"%@",pictureStr] forKey:@"pictureForRY"];
            [defaults synchronize];//同步到plist文件中


            self.dataDic=requestDic[@"data"];
//            NSIndexPath * indexpath=[NSIndexPath indexPathForRow:0 inSection:0];
//            NSArray * indexpathArray=@[indexpath];
//            [self.tableView reloadRowsAtIndexPaths:indexpathArray withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView reloadData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failure:^(NSString *errorInfo) {
        MyLog(@"%@",errorInfo);
    [SVProgressHUD dismiss];
    }];

    //查询关注,粉丝,的数量
     NSString  * url2 = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/userfollow/findByUser.json"];
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *userID2 = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
    para[@"userId"] =userID2;//两个参数都是用自己的userid
    para[@"ownerId"] =userID2;//两个参数都是用自己的userid

    NSLog(@"关注,粉丝信息:::::%@",para);
    [HMHttpTool post:url2 params:para success:^(id responseObj) {
        NSLog_JSON(@"基本信息%@",responseObj);
        if ([responseObj[@"status"] isEqual:@1]) {
            _fansNumber = responseObj[@"data"][@"fans"];
            _followsNumber = responseObj[@"data"][@"follows"];

            NSLog(@"%@",_followsNumber);
            NSString *str1 = @"";
            NSString *str2 = @"";
            if ([_followsNumber isKindOfClass:[NSNull class]]) {
                NSLog(@"我是空的");
                str1 = @"关注 | 0";
            }else{
                str1 = [NSString stringWithFormat:@"%@%@",@"关注 | ",_followsNumber];
            }
            if ([_fansNumber isKindOfClass:[NSNull class]]) {
                str2 = @"粉丝 | 0";
            }else{
                str2 = [NSString stringWithFormat:@"%@%@",@"粉丝 | ",_fansNumber];
            }



            [_topTitleBt1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_topTitleBt1 setTitle:str1 forState:UIControlStateNormal];
            [_topTitleBt2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_topTitleBt2 setTitle:str2 forState:UIControlStateNormal];
            [_topTitleBt3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_topTitleBt3 setTitle:@"我的话题" forState:UIControlStateNormal];

        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];



}



#pragma mark---视图
-(void)createUI
{
    [self setNav];
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-49-50-14) style:UITableViewStylePlain];
    _tableView.backgroundColor=[UIColor hexStringToColor:@"f3f3f4"];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"VLXMineUserCell" bundle:nil] forCellReuseIdentifier:@"VLXMineUserCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VLXMineStaticCell" bundle:nil] forCellReuseIdentifier:@"VLXMineStaticCellID"];
    VLXUnLoginHeaderView *unLoginHeader=[[VLXUnLoginHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.unLoginHeader=unLoginHeader;
#pragma mark 判断登录与否 展示headerview

    if ([NSString getDefaultToken]) {

    }else
    {
//1125.2436
    }
    //回调
    __block VLXMineViewController *weakSelf=self;
    unLoginHeader.loginBlock=^(NSInteger type)//type  1表示登录   2表示点设置
    {
        if (type==1) {
            VLXLoginVC *vc=[[VLXLoginVC alloc] init];
            [weakSelf presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:^{
                
            }];
        }else if (type==2)
        {
            VLXMySettingVC * myset=[[VLXMySettingVC alloc]init];
            myset.dic=self.dataDic;
            [self.navigationController pushViewController:myset animated:YES];
        }
    };
}
- (void)setNav{
    
    self.title = @"我的";
    
    self.view.backgroundColor =backgroun_view_color;
    //右边按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 20, 20);
    [rightBtn setImage:[UIImage imageNamed:@"set-hot"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(tapRightButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButton;

    [self titleUI];//三个文字按钮
}
-(void)titleUI{
//    self.lineView
}
#pragma mark---事件
-(void)tapRightButton:(UIButton *)sender
{
    VLXMySettingVC * myset=[[VLXMySettingVC alloc]init];
    myset.dic=self.dataDic;
    [self.navigationController pushViewController:myset animated:YES];
    NSLog(@"tapRightButton");
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
#pragma mark---delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"_isXYK5:%@",_isXYK);
    return self.cellnumber;
//    return 7;//
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([NSString getDefaultToken]) {
        if (indexPath.row==0) {
//            return 94;
            return 94+50+50;//加了个
        }else{
   return 67;
        }

    }else
    {
   return 67;
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([NSString getDefaultToken]) {//已经登录时候的状态
        VLXMineUserCell * cell=[tableView dequeueReusableCellWithIdentifier:@"VLXMineUserCellID"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (self.dataDic) {
            [cell setcellValuewithDic:self.dataDic];
        }
        if (indexPath.row==0) {


            if (self.topTitleBt1) {//防止多层按钮
            }
            else{
            self.topTitleBt1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 1, ScreenWidth/3, 48)];
            [self.topTitleBt1 addTarget:self action:@selector(pressTitle1) forControlEvents:UIControlEventTouchUpInside];

            self.topTitleBt2 = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/3, 1, ScreenWidth/3, 48)];
            [self.topTitleBt2 addTarget:self action:@selector(pressTitle2) forControlEvents:UIControlEventTouchUpInside];

            self.topTitleBt3 = [[UIButton alloc]initWithFrame:CGRectMake(2*(ScreenWidth/3), 1, ScreenWidth/3, 48)];
            [self.topTitleBt3 addTarget:self action:@selector(pressTitle3) forControlEvents:UIControlEventTouchUpInside];


            [cell.lineView1 addSubview:self.topTitleBt1];
            [cell.lineView1 addSubview:self.topTitleBt2];
            [cell.lineView1 addSubview:self.topTitleBt3];

            }

            return cell;
        }
        NSLog(@"_isXYK6:%@",_isXYK);

        if ([_isXYK isEqualToString:@"0"] || _isXYK == nil) {
                VLXMineStaticCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXMineStaticCellID" forIndexPath:indexPath];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                if (_titleArray) {
                    [cell createUIWithIcon:_iconImageArray[indexPath.row-1] andTitleName:_titleArray[indexPath.row-1]];
                }
                return cell;
        }else{
            if(indexPath.row == 5){
            VLXMineStaticCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXMineStaticCellID" forIndexPath:indexPath];
            cell.jianjieLb.text = @"成功立领十元红包";
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            if (_titleArray) {
                [cell createUIWithIcon:_iconImageArray[indexPath.row-1] andTitleName:_titleArray[indexPath.row-1]];
            }
            return cell;
        }
        }
        {
            VLXMineStaticCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXMineStaticCellID" forIndexPath:indexPath];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            if (_titleArray) {
                [cell createUIWithIcon:_iconImageArray[indexPath.row-1] andTitleName:_titleArray[indexPath.row-1]];
            }
            return cell;
        }
    }
    else{//未登录时候的状态
        VLXMineStaticCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXMineStaticCellID" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (_titleArray) {
            [cell createUIWithIcon:_iconImageArray[indexPath.row] andTitleName:_titleArray[indexPath.row]];
        }
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    VLXPersonalMessageVC * person=[[VLXPersonalMessageVC alloc]init];
    person.dataDic=self.dataDic;
    person.delegate=self;
    VLXMyDingZhiVC * dingzhi=[[VLXMyDingZhiVC alloc]init];
    VLXMyOrderVC * order=[[VLXMyOrderVC alloc]init];
    VLXCollectVC * collection=[[VLXCollectVC alloc]init];
    VLXWebViewVC *webView = [[VLXWebViewVC alloc]init];
    webView.type = 4;
    webView.urlStr = @"https://ecentre.spdbccc.com.cn/creditcard/indexActivity.htm?data=P2135341";
    UIStoryboard *customSB=[UIStoryboard storyboardWithName:@"CustomSB" bundle:nil];
    //新的个人信息
    VLXPersonInfoTableVC *personVC=[customSB instantiateViewControllerWithIdentifier:@"VLXPersonInfoTableVCID"];
    personVC.dataDic=self.dataDic;
    if ([NSString getDefaultToken]) {
        //登录之后的点击效果
        NSLog(@"_isXYK7:%@",_isXYK);

        if ([_isXYK isEqualToString:@"0"] || _isXYK == nil) {
            switch (indexPath.row) {
                case 0:
                    //                [self.navigationController pushViewController:person animated:YES];


                    [self.navigationController pushViewController:personVC animated:YES];
                    break;

                case 1:
                    //                [self.navigationController pushViewController:person animated:YES];
                    [self.navigationController pushViewController:personVC animated:YES];
                    break;
                case 2:
                    [self.navigationController pushViewController:order animated:YES];
                    break;
                case 3:
                    [self.navigationController pushViewController:dingzhi animated:YES];
                    break;
                case 4:
                    //我的收藏
                    [self.navigationController pushViewController:collection animated:YES];
                    break;
                    //            case 5:
                    //                [self.navigationController pushViewController:webView animated:YES];
                    //                break;
                case 5:
                    [self thirdShareWithUrl:[NSString stringWithFormat:@"%@/shareurl/appshare.json",ftpPath]];
                default:
                    break;
            }
        }
        else{
            switch (indexPath.row) {
                case 0:
                    //                [self.navigationController pushViewController:person animated:YES];


                    [self.navigationController pushViewController:personVC animated:YES];
                    break;

                case 1:
                    //                [self.navigationController pushViewController:person animated:YES];
                    [self.navigationController pushViewController:personVC animated:YES];
                    break;
                case 2:
                    [self.navigationController pushViewController:order animated:YES];
                    break;
                case 3:
                    [self.navigationController pushViewController:dingzhi animated:YES];
                    break;
                case 4:
                    //我的收藏
                    [self.navigationController pushViewController:collection animated:YES];
                    break;
                case 5:
                    [self.navigationController pushViewController:webView animated:YES];
                    break;
                case 6:
                    [self thirdShareWithUrl:[NSString stringWithFormat:@"%@/shareurl/appshare.json",ftpPath]];
                default:
                    break;
            }
        }

    }else
    {
        NSLog(@"_isXYK8:%@",_isXYK);

        //        [SVProgressHUD showInfoWithStatus:@"暂未登录，请先登录"];
        if ([_isXYK isEqualToString:@"0"] || _isXYK == nil) {
            if (indexPath.row==4) {//未登录也可以分享
                [self thirdShareWithUrl:[NSString stringWithFormat:@"%@/shareurl/appshare.json",ftpPath]];
                return;
            }

        }else{
            if (indexPath.row==5) {//未登录也可以分享
                [self thirdShareWithUrl:[NSString stringWithFormat:@"%@/shareurl/appshare.json",ftpPath]];
                return;
            }
        }
        if (![NSString getDefaultToken]) {
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

    NSLog(@"%ld",(long)indexPath.row);



}

#pragma mark 三方分享调用
-(void)thirdShareWithUrl:(NSString * )url
{
    UIWindow*window=[UIApplication sharedApplication].keyWindow;
    UIView*blackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.blackView=blackView;
    blackView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.3];
    [window addSubview:blackView];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clcikClose)];
    [blackView addGestureRecognizer:tap];
    ShareBtnView*shareView=[[ShareBtnView alloc]init];
    shareView.delegate = self;
    __block VLXMineViewController * blockSelf=self;;
    shareView.btnShareBlock=^(NSInteger tag)
    {


        MyLog(@"share:%ld",tag);
        //555,QQ 556,新浪微博 557,微信 558,朋友圈
        switch (tag) {
            case 555:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_QQ andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:@"V旅行" andDesc:@"看世界、V旅行！" andWebPageUrl:url];
                [blockSelf clcikClose];

            }
                break;
            case 556:
            {

                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_Sina andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:@"V旅行" andDesc:@"看世界、V旅行！" andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            case 557:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatSession andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:@"V旅行" andDesc:@"看世界、V旅行！" andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            case 558:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:@"V旅行" andDesc:@"看世界、V旅行！" andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            default:
                break;
        }
    };
    [window addSubview:shareView];
    self.shareView=shareView;
    
}
#pragma mark--点击关闭按钮
-(void)clcikClose
{
    [self.shareView removeFromSuperview];
    [self .blackView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pressTitle1{
    VLX_Mine_GZ_Vc  * vc= [[VLX_Mine_GZ_Vc alloc]init];

    [self.navigationController pushViewController:vc animated:YES];
}
-(void)pressTitle2{
    VLX_Mine_Fensi_VC  * vc= [[VLX_Mine_Fensi_VC alloc]init];

    [self.navigationController pushViewController:vc animated:YES];
}
-(void)pressTitle3{
    VLX_Mine_TAdynamic_VC  * vc= [[VLX_Mine_TAdynamic_VC alloc]init];
//    vc.typee2=1;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

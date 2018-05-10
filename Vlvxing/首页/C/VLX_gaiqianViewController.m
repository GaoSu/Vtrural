
//
//  VLX_gaiqianViewController.m
//  Vlvxing
//
//  Created by grm on 2017/11/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_gaiqianViewController.h"

#import "VLX_gaiqianshuomingViewController.h"

#import "VLX_choose_Aera_VC.h"//地区

#import "CalendarHomeViewController.h"//日历

#import "VLX_gaiqianChooseVC.h"//选取改签的票
#import "HMHttpTool.h"


@interface VLX_gaiqianViewController ()
{
    CalendarHomeViewController * dateVc_2;
}



@property (nonatomic,strong)UILabel * areaLb2;//地点
@property (nonatomic,strong)UILabel * dateLb2;//日期
@property (nonatomic,strong)UILabel * dateLb3;//周几

@end

@implementation VLX_gaiqianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton51) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton51)];

    self.title = @"改签";
    
    self.view.backgroundColor = rgba(245, 245, 245, 1);
    [self makeMineUI5];
    NSLog(@">>>>>%@", _jiadePassengerid);
    
}
-(void)tapLeftButton51
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)makeMineUI5{
    
    //一,scvw
    UIScrollView * scrView = [[UIScrollView alloc]init];
    scrView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
    scrView.contentSize = CGSizeMake(0, ScreenHeight-64+10);
    scrView.showsHorizontalScrollIndicator = NO;
    scrView.showsVerticalScrollIndicator = NO;
    
    
    UIView * view1  = [[UIView alloc]initWithFrame:CGRectMake(0, 5, ScreenWidth, 54)];
    view1.backgroundColor = [UIColor whiteColor];
    
    
    UITapGestureRecognizer* tapvw1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shuomingVw)];
    [view1 addGestureRecognizer:tapvw1];
    
    UILabel * shuomingLb = [[UILabel alloc]initWithFrame:CGRectMake(8, 22, 95, 16)];
    shuomingLb.text = @"改签说明";
    shuomingLb.textColor =[UIColor lightGrayColor];
    shuomingLb.font = [UIFont systemFontOfSize:15];
    
    UIImageView * imgvw1 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-25, 18, 13, 13)];
    imgvw1.image = [UIImage imageNamed:@"ios—前往"];
    
    [view1 addSubview:shuomingLb];
    [view1 addSubview:imgvw1];
    
    
    
    
    UIView * view2  = [[UIView alloc]initWithFrame:CGRectMake(0, 5+5+54, ScreenWidth, 64)];
    view2.backgroundColor = [UIColor whiteColor];
    
//    UITapGestureRecognizer* tapvw2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(areaVw)];
//    [view2 addGestureRecognizer:tapvw2];
    
    UILabel * areaLb = [[UILabel alloc]initWithFrame:CGRectMake(8, 30, 95, 16)];
    areaLb.text = @"目的地";
    areaLb.textColor =[UIColor lightGrayColor];
    areaLb.font = [UIFont systemFontOfSize:15];
    
    _areaLb2 = [[UILabel alloc]initWithFrame:CGRectMake(110, 22, ScreenWidth- 130, 28)];
    _areaLb2.text = _downCityStr;
    UIFont *font1 = [UIFont fontWithName:@"Verdana-Bold" size:22.0f];
    _areaLb2.font = font1;
    
    [view2 addSubview:areaLb];
    [view2 addSubview:_areaLb2];
    
    
    
    
    UIView * view3  = [[UIView alloc]initWithFrame:CGRectMake(0, 5+5+5+54+64, ScreenWidth, 64)];
    view3.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer* tapvw3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateVw)];
    [view3 addGestureRecognizer:tapvw3];
    
    
    UILabel * dateLb = [[UILabel alloc]initWithFrame:CGRectMake(8, 25, 100, 16)];
    dateLb.text = @"修改出发日期";
    dateLb.textColor =[UIColor lightGrayColor];
    dateLb.font = [UIFont systemFontOfSize:15];
    
    
    NSDate *currentDate = [NSDate date];
    //用于向下传递当天的具体年-月-日 例:2017-12-30
    NSDateFormatter * dateformatter1=[[NSDateFormatter alloc] init];
    [dateformatter1 setDateFormat:@"YYYY-MM-dd"];
    NSString * stringDate = [dateformatter1 stringFromDate:currentDate];
    _dateLb2 = [[UILabel alloc]initWithFrame:CGRectMake(110, 20, ScreenWidth- 160, 28)];
    _dateLb2.text = _flyDatesStr;
    UIFont *font2 = [UIFont fontWithName:@"Verdana-Bold" size:22.0f];
    _dateLb2.font = font2;
    
    _dateLb3 = [[UILabel alloc]initWithFrame:CGRectMake(268, 30, 58, 14)];
    _dateLb3.text = _xingqijiStr;//@"星期三";
    _dateLb3.textColor =[UIColor lightGrayColor];
    _dateLb3.font = [UIFont systemFontOfSize:14];
    
    [view3 addSubview:dateLb];
    [view3 addSubview:_dateLb2];
    [view3 addSubview:_dateLb3];

    
    UIButton * changeBt =[[ UIButton alloc]initWithFrame:CGRectMake(15, 285, ScreenWidth-30, 42)];
    changeBt.layer.cornerRadius = 6;
    changeBt.backgroundColor = rgba(230, 87, 36, 1);
    [changeBt setTitle:@"查询改签" forState:UIControlStateNormal];
    [changeBt addTarget:self action:@selector(pressChangeBt) forControlEvents:UIControlEventTouchUpInside];


    
    
    [scrView addSubview:view1];
    [scrView addSubview:view2];
    [scrView addSubview:view3];
    [scrView addSubview:changeBt];

    
    [self.view addSubview:scrView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//三个跳转
-(void)shuomingVw
{
    VLX_gaiqianshuomingViewController * vc =[[VLX_gaiqianshuomingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//-(void)areaVw{
//    VLX_choose_Aera_VC * vc = [[VLX_choose_Aera_VC alloc]init];
//    vc.tagStringgg = @"change";
//    [self.navigationController pushViewController:vc animated:YES];
//}
-(void)dateVw{
    dateVc_2 = [[CalendarHomeViewController alloc]init];
    [dateVc_2 setAirPlaneToDay:364 ToDateforString:nil];//初始化方法364天
    
    dateVc_2.calendarblock = ^(CalendarDayModel *model){
        
        NSString * str = [NSString stringWithFormat:@"%@",[model toString]];//日历列表返回的时间str串
//        _bookTimeStr = str;//传递用户选择的时间
        NSLog(@"%@",str);
        
        
        NSString *tihuan0 = [str stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
        NSString *tihuan1 = [tihuan0 stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
        NSString *tihuan2 = [tihuan1 stringByReplacingOccurrencesOfString:@"日" withString:@""];//把日替换成""
        
        _dateLb2.text = tihuan2;
        

        NSString * str2 = [NSString stringWithFormat:@"%@",[model getWeek]];//周几
        NSLog(@"%@",str2);
        
        _dateLb3.text = str2;
        
    };
    [self.navigationController pushViewController:dateVc_2 animated:YES];

}
//选择地区
//-(void)dealloc
//{
//    //移除观察者
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeCity1" object:nil];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeCity2" object:nil];
//
//}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoTiCHgaCity2:) name:@"changeCity1" object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyToChangeCity2:) name:@"changeCity2" object:nil];
//}

//-(void)NoTiCHgaCity2:(NSNotification *)nott
//{
//    _areaLb2.text = [NSString getCity];
//}

//-(void)notifyToChangeCity2:(NSNotification *)notify
//{
//    _areaLb2.text = notify.userInfo[@"areaname"];
//    
//}
//确认改签
-(void)pressChangeBt{
    
    VLX_gaiqianChooseVC * vc = [[VLX_gaiqianChooseVC alloc]init];
    vc.orderno = _orderno;
    vc.flyDatesStr2 = _dateLb2.text;
    vc.nav_title1 = _flyCityStr;
    vc.nav_title2 = _downCityStr;
    vc.xingqijiStr = _dateLb3.text;
    vc.passengeridArray = [NSMutableArray array];
    vc.passengeridArray = _passengeridArray;
    
//    vc.jiadePassengerid = _jiadePassengerid;//假的id


    NSLog(@"传递时间:%@",vc.flyDatesStr2);
    [self.navigationController pushViewController:vc animated:YES];

}



@end

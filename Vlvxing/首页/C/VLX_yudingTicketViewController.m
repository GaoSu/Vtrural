//
//  VLX_yudingTicketViewController.m
//  Vlvxing
//
//  Created by grm on 2017/10/11.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_yudingTicketViewController.h"
#import "VLX_buyTicketViewController.h"//买票页

#import "HMHttpTool.h"
@interface VLX_yudingTicketViewController ()
{
    UILabel * navLb1;//地点1
    UIImageView * jiantouVw;//箭头
    UILabel * navLb2;//地点2
    
    
    UILabel * serverLb ;//航班 准点率 餐食
    UILabel * nameLb1;//航空公司及航班号
    UILabel * flyLb1;//起飞机场
    UILabel * downLb1;//降落机场
    UILabel * dateLb1;//日期和星期
    UIButton * bookingBt;//预定按钮
    UILabel * jiageLb;

}

//参数
@property (nonatomic,strong)NSString * vendorStr;//需要转URLEncoder.encode转码
@property (nonatomic,strong)NSString * depCode;//出发城市三字码
@property (nonatomic,strong)NSString * arrCode;//落地城市三字码
@property (nonatomic,strong)NSString * code;//航班号
@property (nonatomic,strong)NSString * date;//起飞日期 2017-11-30
@property (nonatomic,strong)NSString * carrier;//航司
@property (nonatomic,strong)NSString *  btime;//起飞时间11:15
@property (nonatomic,strong)NSString * bookingResult;//预定结果,生单用

//@property (nonatomic,strong)NSString * zhenshiJiage;//筛选的真实价格
@property (nonatomic,strong)NSNumber * zhenshiJiage;//筛选的真实价格


@end

@implementation VLX_yudingTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.//74,0 ,715 553
    
    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton3) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton3)];

    [self lodaDATA_yuding];//预定的接口数据
    
    
    [self makeNav2];
    
    [self makeUI2];
//    [self lodaDATA_yuding];//预定的接口数据
 
    
}
-(void)tapLeftButton3{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeNav2
{ //中间
    UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(-70, 7, ScreenWidth-25, 30)];


//    NSLog(@"宽%f",titleView.frame.size.width);//350-xxx-295
    
    //为了frame,多加一层方便计算
    UIView * smallView = [[UIView alloc] init];
    
    
    navLb1 = [[UILabel alloc]init];
    navLb1.text = _navStr1;
    navLb1.text = _navStr1;
    UIFont *fnt = [UIFont fontWithName:@"Courier New" size:20.0f];
    navLb1.font = fnt;
    // 根据字体得到NSString的尺寸
    CGSize size1 = [navLb1.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName,nil]];
    //W
    CGFloat nameW1 = size1.width;
    navLb1.frame = CGRectMake(-20,5, nameW1,22);
    
    
    
    
    
    
    jiantouVw = [[UIImageView alloc]initWithFrame:CGRectMake(-20+3+navLb1.frame.size.width , 8, 26, 15)];
    jiantouVw.image = [UIImage imageNamed:@"目的地"];
    
    navLb2 = [[UILabel alloc]init];//WithFrame:CGRectMake(-20+3+navLb1.frame.size.width+26+3, 5, 125, 22)
    navLb2.text = _NavStr2;
    navLb2.font = fnt;
    CGSize size2 = [navLb2.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName,nil]];
    //W
    CGFloat nameW2 = size2.width;
    navLb2.frame = CGRectMake(-20+3+3+navLb1.frame.size.width + jiantouVw.frame.size.width,5, nameW2, 22);
    
    CGFloat width3 = navLb1.frame.size.width + jiantouVw.frame.size.width + navLb2.frame.size.width;
    
    smallView.frame = CGRectMake(titleView.frame.size.width/2 - width3 /2 - 15 , 0, 3+3+3+ width3, 30);
    
    [smallView addSubview:navLb1];
    [smallView addSubview:jiantouVw];
    [smallView addSubview:navLb2];

    [titleView addSubview:smallView];

    self.navigationItem.titleView=titleView;
    
    
    

}

-(void)makeUI2 //74,0 ,714 552
{

    UIView * backgroundView1 = [[UIView alloc]initWithFrame:CGRectMake(9, 37, ScreenWidth-18, 276)];
    backgroundView1.layer.cornerRadius=6;
    backgroundView1.layer.borderWidth=0.5;
    backgroundView1.layer.borderColor=[rgba(225, 110, 65, 1)CGColor];//CGColor不能少
    
    //渐变色
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer * gradientLayer = [[CAGradientLayer alloc]init];
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = backgroundView1.bounds;
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [backgroundView1.layer addSublayer:gradientLayer];
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:(252/255.0) green:(247/255.0) blue:(243/255.0) alpha:1].CGColor,
                             (__bridge id)[UIColor colorWithRed:(236/255.0) green:(110/255.0) blue:(63/255.0) alpha:1].CGColor];
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = @[@(0.1f), @(1.0f)];//参数含义,第一个是渐变从上到下过度的程度,第二个参数是??

    
    
//    设置上面的各种控件
    //航班图像
//    UIImageView * imgVw =[[UIImageView alloc]initWithFrame:CGRectMake(8, 15, 16, 16)];
////    [imgVw sd_setImageWithURL:(nullable NSURL *)];
//    imgVw.image = [UIImage imageNamed:@"航空标志小"];
    
    //航班及公司
    nameLb1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, 195, 20)];
//    nameLb1.text = [NSString stringWithFormat:@"%@%@",_name1,_hangbanhaoStr]; //_name1;
    nameLb1.textColor = rgba(225, 110, 65, 1);
    nameLb1.font = [UIFont systemFontOfSize:14];
    
    //日期和星期
    dateLb1 = [[UILabel alloc]initWithFrame:CGRectMake(backgroundView1.frame.size.width-130, 15, 125, 20)];
    dateLb1.textAlignment = NSTextAlignmentRight;
    //_bookDateStr订票时间
    NSString *tihuan0 = [_date2 stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    NSString *tihuan1 = [tihuan0 stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    NSString *tihuan2 = [tihuan1 stringByReplacingOccurrencesOfString:@"日" withString:@""];//把日替换成""
    
//    dateLb1.text = [NSString stringWithFormat:@"%@%@",tihuan2,_xingqijiStr];
    dateLb1.textColor = rgba(225, 110, 65, 1);
    dateLb1.font = [UIFont systemFontOfSize:13];
    
    //小小背景
    UIView * LittleBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 53, backgroundView1.frame.size.width, backgroundView1.frame.size.height-63+5)];//-53
    LittleBackgroundView.backgroundColor = rgba(225, 110, 65, 1);
    
    //解决下部分圆角问题
    UIView * LittleBackgroundView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 53+LittleBackgroundView.frame.size.height-5, backgroundView1.frame.size.width, 15)];
    LittleBackgroundView2.backgroundColor = rgba(225, 110, 65, 1);
    LittleBackgroundView2.layer.cornerRadius = 6.0;

    
    //开始时间
    UILabel * stateTime =[[UILabel alloc]initWithFrame:CGRectMake(6, 59, 90, 23)];
//    stateTime.font = [UIFont systemFontOfSize:23];
    stateTime.font = [UIFont fontWithName:@"HelveticaNeue-Bold"size:23];//黑粗体
    stateTime.text = _sta3;
    stateTime.textColor = [UIColor whiteColor];
    //结束时间
    UILabel * overTime =[[UILabel alloc]initWithFrame:CGRectMake(LittleBackgroundView.frame.size.width - 6-90, 59, 90, 23)];
    overTime.text = _over4;
    overTime.textColor = [UIColor whiteColor];
    overTime.textAlignment = NSTextAlignmentRight;
    overTime.font = [UIFont fontWithName:@"HelveticaNeue-Bold"size:23];
    //总时长234 188 170
    UILabel * totalTime = [[UILabel alloc]initWithFrame:CGRectMake(LittleBackgroundView.frame.size.width / 2 -38, 60, 76, 12)];
    totalTime.textAlignment = NSTextAlignmentCenter;
    totalTime.text = _total5;
    totalTime.textColor = [UIColor whiteColor];//rgba(234, 188, 170, 1);
    totalTime.font = [UIFont systemFontOfSize:12];
    //加一天
    UILabel * plusTime = [[UILabel alloc]initWithFrame:CGRectMake(LittleBackgroundView.frame.size.width-107, 44, 30, 12)];
    plusTime.font = [UIFont systemFontOfSize:12];
    plusTime.text = @"+1天";
    plusTime.textColor = rgba(234, 188, 170, 1);

    
    //线
    UILabel * line4 = [[UILabel alloc]initWithFrame:CGRectMake(LittleBackgroundView.frame.size.width / 2 -49, 82, 98, 1)];
    line4.backgroundColor = rgba(234, 188, 170, 1);

    //起飞机场14
    flyLb1 =[[UILabel alloc]initWithFrame:CGRectMake(6, 106, 100, 14)];
    flyLb1.font = [UIFont systemFontOfSize:14];
//    flyLb.text = _fly7;
    flyLb1.textColor = [UIColor whiteColor];//rgba(234, 188, 170, 1);
    //降落机场
    downLb1 =[[UILabel alloc]initWithFrame:CGRectMake(LittleBackgroundView.frame.size.width-6-100, 106, 100, 14)];
    downLb1.font = [UIFont systemFontOfSize:14];
//    downLb.text = _down8;
    downLb1.textColor = [UIColor whiteColor];//rgba(234, 188, 170, 1);
    downLb1.textAlignment = NSTextAlignmentRight;
    
    
    //服务质量及内容//需要拼接字符串
    serverLb =[[UILabel alloc]initWithFrame:CGRectMake(LittleBackgroundView.frame.size.width / 2 - 125, 170, 250, 14)];
    serverLb.font = [UIFont systemFontOfSize:14];
//    serverLb.text = _servers9;
    serverLb.textColor =[UIColor whiteColor];// rgba(234, 188, 170, 1);
    serverLb.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    [LittleBackgroundView addSubview:stateTime];
    [LittleBackgroundView addSubview:overTime];
    [LittleBackgroundView addSubview:totalTime];
//    [LittleBackgroundView addSubview:plusTime];
    [LittleBackgroundView addSubview:line4];
    [LittleBackgroundView addSubview:flyLb1];
    [LittleBackgroundView addSubview:downLb1];
    [LittleBackgroundView addSubview:serverLb];

    
    
    
    [backgroundView1 addSubview:LittleBackgroundView];
    [backgroundView1 addSubview:LittleBackgroundView2];
//    [backgroundView1 addSubview:imgVw];
    [backgroundView1 addSubview:nameLb1];
    [backgroundView1 addSubview:dateLb1];
    
    
    
    
    //1
    [self.view addSubview:backgroundView1];
    
    
    
    jiageLb =[[ UILabel alloc]initWithFrame:CGRectMake(26, 350, 90, 23)];
//    jiageLb.text = _jiage10;// ¥234
    jiageLb.textColor = rgba(225, 110, 65, 1);
    jiageLb.font = [UIFont systemFontOfSize:23];

    
    bookingBt =[[ UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-108, 345, 90, 31)];
    bookingBt.layer.cornerRadius = 6;
    bookingBt.backgroundColor =rgba(225, 110, 65, 1);
    [bookingBt setTitle:@"预 定" forState:UIControlStateNormal];
//    [bookingBt addTarget:self action:@selector(pressBookingBt) forControlEvents:UIControlEventTouchUpInside];
    

    
    
    UIImageView * imgvw4 = [[UIImageView alloc]initWithFrame:CGRectMake(18, 393, 16, 16)];
    imgvw4.image = [UIImage imageNamed:@"注意"];
    
    
    
//    UILabel * changeLb = [[ UILabel alloc]initWithFrame:CGRectMake(37, 394, 70, 13)];
//    changeLb.text = @"退改45元起";
//    changeLb.textColor =rgba(225, 110, 65, 1);
//    changeLb.font = [UIFont systemFontOfSize:13];
    
    
    //经济舱
//    UILabel * jingjicang = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-108, 395, 80, 13)];
//    jingjicang.text = @"经济舱3.8折";
//    jingjicang.textColor = [UIColor grayColor];
//    jingjicang.font = [UIFont systemFontOfSize:13];
//    
    
    
    //2
    [self.view addSubview:jiageLb];
    [self.view addSubview:bookingBt];
    
//    [self.view addSubview:bookingBt_jia];
//    [self.view addSubview:bookingBt_jia2jia];
//    [self.view addSubview:changeLb];
//    [self.view addSubview:imgvw4];
//    [self.view addSubview:jingjicang];
}
#pragma mark 点击预定按钮
-(void)pressBookingBt{
//    sleep(1.0f);
    
    
    if([NSString getDefaultToken]) {
    VLX_buyTicketViewController * vc = [[VLX_buyTicketViewController alloc]init];
    vc.navStr11 = _navStr1;
    vc.NavStr22 = _NavStr2;
    vc.jiageStr_0 = jiageLb.text;
    vc.timeStr = [dateLb1.text substringToIndex:10];//去掉星期几
    vc.xingqiStr = _xingqijiStr;
    vc.jijianranyoustr = _jijianranyoustr;
    
    vc.bookingResult = _bookingResult;
    [self.navigationController pushViewController:vc animated:YES];
    }
    else if(![NSString getDefaultToken]) {
        
        [SVProgressHUD showInfoWithStatus:@"您未登录,请您登录"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)lodaDATA_yuding
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSString * url = [NSString stringWithFormat:@"%@%@",tangyangURL,@"searchQuote"];
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"dptCity"] = _navStr1;
    para[@"arrCity"] = _NavStr2;
    NSString *tihuan0 = [_date2 stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    NSString *tihuan1 = [tihuan0 stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    NSString *tihuan2 = [tihuan1 stringByReplacingOccurrencesOfString:@"日" withString:@""];//把日替换成""
    para[@"date"]    = tihuan2;
    para[@"flightNum"] = _hangbanhaoStr;
    para[@"ex_track"]=@"youxuan";//youxuan
    
    NSLog(@"searchQuote参数:%@",para);
    [HMHttpTool get:url params:para success:^(id responseObj) {
        NSLog_JSON(@"预定结果成功:%@",responseObj);
        [SVProgressHUD dismiss];
        if ([responseObj[@"status"]  isEqual: @1]  ) {

            NSDictionary * newdic = [NSDictionary dictionary];
            
            NSDictionary * panduan = [NSDictionary dictionary];
            panduan = responseObj[@"data"];
            _vendorStr = responseObj[@"data"][@"vendorStr"];//参数1
            
            if ([panduan[@"result"] isKindOfClass:[NSNull class]]) {
                NSLog(@"空");
            }
            else
            {
                newdic = responseObj[@"data"][@"result"];
//                NSLog(@"新新新字典的数据%@",newdic);
                
                _depCode = newdic[@"depCode"];//出发城市三字码,参数2
                _arrCode = newdic[@"arrCode"];//落地城市三字码,参数3
                _code    = newdic[@"code"];////////////////,参数4
                _date   = newdic[@"date"];////////////////,参数5
                _carrier = newdic[@"carrier"];///航司////////,参数5
                _btime   = newdic[@"btime"];//起飞时间11:15//,参数6

                _zhenshiJiage  =newdic[@"vendors"][0][@"barePrice"];
                NSLog(@"%@",newdic[@"vendors"][0][@"barePrice"]);
                NSLog(@"%@",_zhenshiJiage);


                NSString * chifan = [[NSString alloc]init];//给不给吃饭
                chifan = @"";
                if ([newdic[@"meal"] isEqual: @0]) {//meal是boolean
                    chifan = @"无餐食";
                }
                else if([newdic[@"meal"] isEqual: @1]){
                    chifan = @"有餐食";
                }
//               NSLog(@"%@", newdic[@"correct"]);//76%

        nameLb1.text = [NSString stringWithFormat:@"%@%@",newdic[@"com"],_hangbanhaoStr]; //_name1;
        dateLb1.text = [NSString stringWithFormat:@"%@%@",newdic[@"date"],_xingqijiStr];
        serverLb.text = [NSString stringWithFormat:@"%@  准点率%@  %@",_servers9,newdic[@"correct"],chifan];
        flyLb1.text = [NSString stringWithFormat:@"%@ %@",_fly7,newdic[@"depTerminal"]];
        downLb1.text = [NSString stringWithFormat:@"%@ %@",_down8,newdic[@"arrTerminal"]];
//                int jia20float = 0;//
//                jia20float = [_zhenshiJiage intValue] +20;
//                NSLog(@"grmgrmgrm%d",jia20float);
        jiageLb.text = [NSString stringWithFormat:@"%@",_zhenshiJiage];//barePrice票面价
//        jiageLb.text = [NSString stringWithFormat:@"%d",jia20float];//票面价加20元

                [self pressBookingBt_BK];
            }

        }
        else if([responseObj[@"status"]  isEqual: @0])
        {
//                    NSLog(@"未知错误");
            [SVProgressHUD showErrorWithStatus:@"获取航班详细信息失败!"];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"失败:%@",error);
        [SVProgressHUD dismiss];
        
    }];
    
    
    
}

-(void)pressBookingBt_BK//bk请求的结果,为了拿到 bookingResult串
{
    NSString* string2 = [_vendorStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * url = [NSString stringWithFormat:@"%@%@",tangyangURL,@"booking"];
    
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"vendorStr"] = string2;
    para[@"depCode"] = _depCode;
    para[@"arrCode"] = _arrCode;
    para[@"date"]=_date;
    para[@"code"] = _code;
    para[@"carrier"] = _carrier;
    para[@"btime"]=_btime;
    
    
    [SVProgressHUD showWithStatus:@"正在抢票中"];
    NSLog_JSON(@"bk参数:%@",para);
    [HMHttpTool get:url params:para success:^(id responseObj) {
        NSLog_JSON(@"bk数据OK:%@",responseObj);
//        NSErrorFailingURLStringKey
        NSLog(@"bk:%@",NSURLFileScheme);
        if ([responseObj[@"status"]  isEqual: @1]  ) {
            
            [SVProgressHUD dismiss];
            if ([responseObj[@"data"][@"result"][@"bookingStatus"] isEqualToString:@"BOOKING_SUCCESS"]) {
                NSLog(@"bookingOK:");
                _bookingResult = responseObj[@"data"][@"bookingResult"];//
                [bookingBt addTarget:self action:@selector(pressBookingBt) forControlEvents:UIControlEventTouchUpInside];
                [SVProgressHUD dismiss];
            }else{
                NSLog(@"bookingFail");
            }
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"数据失败:%@",error);
        [bookingBt addTarget:self action:@selector(pressBookingBtFale) forControlEvents:UIControlEventTouchUpInside];

    }];
    

    
}
-(void)pressBookingBtFale{
    [SVProgressHUD showInfoWithStatus:@"抢票失败,请返回重试"];
}


@end

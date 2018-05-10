//
//  VLX_TicketViewController.m
//  Vlvxing
//
//  Created by grm on 2017/10/6.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_TicketViewController.h"

#import "VLXCityChooseVC.h"//城市列表 //废弃
#import "VLX_choose_Aera_VC.h"//新城市列表
#import "UIControl+JPBtnClickDelay.h"//延迟点击


#import "CalendarHomeViewController.h"//日历相关控件
#import "CalendarViewController.h"
#import "Color.h"


#import "VLX_SearchTickerViewController.h"//搜索结果

#import "VLX_myOrderViewController.h"//我的订单

#import "VLXHomeAdsModel.h"//轮播图model
#import "VLXWebViewVC.h"


@interface VLX_TicketViewController ()<SDCycleScrollViewDelegate>
{
    NSTimer * timer;
    UIView * backgroundView;
    CalendarHomeViewController * vc_1;
 
    NSString * nianyueriStr;//用于传递当天的年-月-日,或者选择日历后的年-月-日
    UIView * bigimgVw;
}

@property (nonatomic , strong) UIButton * areaBt1;

@property (nonatomic , strong) UIButton * areaBt2;

@property (nonatomic , strong)UILabel * dateLb;//显示时间
@property (nonatomic , strong)UILabel * weakLb;//显示周几
@property (nonatomic , strong)NSString *locationString;//当前时间,月日
@property (nonatomic , strong)NSString * bookTimeStr;//用户选择的订票时间
@property (nonatomic , strong) NSString * anniu;//标记是哪个按钮
@property (nonatomic , assign) int  zhuanhuan;//标记是怎么切换的
@property (nonatomic,strong)SDCycleScrollView *adScrollVw;//广告轮播图grm

//
////关于去哪儿网机票的网络请求
//@property(nonatomic , assign)long  createTime;//时间戳;需要的是long类型的毫秒数
//@property(nonatomic , strong)NSString * sign;//API输入参数签名结果,
//@property(nonatomic , strong)NSString * tag;//API接口标识
//@property(nonatomic , strong)NSString * pinjieStr;//所有参数拼接的长字符串
//@property(nonatomic , strong)NSString * token;//QAE分配给用户的token，通过授权获取
//@property(nonatomic , strong)NSString * key;//登录开发者页面获取
//@property(nonatomic , strong)NSMutableDictionary * parammm;//将应用级参数用json形式表达
//@property(nonatomic , strong)NSString *params;


@property (nonatomic,strong)VLXHomeAdsModel *adsModel_1;//广告轮播图数据


@end

@implementation VLX_TicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    _zhuanhuan = 1;
    _bookTimeStr = @"0";//开始设置个值,用于判断是否点进去选择日历
    //实现背景渐变
    

    
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer * gradientLayer = [[CAGradientLayer alloc]init];
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.view.layer addSublayer:gradientLayer];
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:(252/255.0) green:(247/255.0) blue:(243/255.0) alpha:1].CGColor,
                                  (__bridge id)[UIColor colorWithRed:(236/255.0) green:(110/255.0) blue:(63/255.0) alpha:1].CGColor];
    
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = @[@(0.3f), @(1.0f)];
    

    
//    if (@available(iOS 11.1, *)) {
////        self.view contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
////        self.view contentin
//        CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
//        NSLog(@"%d",statusRect);
//
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = false;
//        // Fallback on earlier versions
//    }

//    CGRect tatusRect = [[UIApplication sharedApplication] statusBarFrame];
//    NSLog(@"status h - %f", tatusRect.size.height);
//    
//    // 导航栏（navigationbar）
//    CGRect rectNav = self.navigationController.navigationBar.frame;
//    NSLog(@"nav h - %f", rectNav.size.height);  // 高度
    
    
    
    [self makeTicketUI];
    
    [self makeNav];
    
    [self load_ad_Data];//广告轮播图数据
}



-(void)makeNav
{
    self.title = @"机票";
//    self.navigationController.navigationBar.backItem
    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton1) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton1)];



    //右边

    UIImageView * PhoneVw=[[UIImageView alloc] initWithFrame:CGRectMake(0, -38, 23, 20)];
    //
    PhoneVw.image = [UIImage imageNamed:@"ios客服"];


    UILabel * wen =[[UILabel alloc] initWithFrame:CGRectMake(-13, 20,49 , 12)];
    wen.text = @"客 服";
    wen.textColor=rgba(234, 105, 73, 1);
    wen.textAlignment = NSTextAlignmentCenter;
    wen.font=[UIFont systemFontOfSize:11];
//    [PhoneVw addSubview:wen];
    UIButton * bt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    bt.backgroundColor = [UIColor clearColor];
    bt.jp_acceptEventInterval = 5.0f;
    [bt addTarget:self action:@selector(telePhone) forControlEvents:UIControlEventTouchUpInside];
    [PhoneVw addSubview:bt];

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:PhoneVw];



    
    
}

-(void)telePhone{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt:010-50928502"]];
}
-(void)tapLeftButton1{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)makeTicketUI{
    
    backgroundView = [[UIView alloc]initWithFrame:CGRectMake(10, 25, ScreenWidth-20, 676/2)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    

    //广告轮播图
    _adScrollVw=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth-20, 230/2) delegate:self placeholderImage:ADNoDataImage];


    _adScrollVw.contentMode =UIViewContentModeScaleAspectFill;
    _adScrollVw.clipsToBounds = YES;//是否剪切掉超出 UIImageView 范围的图片
    [_adScrollVw setContentScaleFactor:[[UIScreen mainScreen]scale]];
    //以上三行可以上UIIMageView图片不变形,超出裁切,充满控件,然鹅这个继承自UIView,不起作用
//    _adScrollVw.currentPageDotColor=[UIColor hexStringToColor:@"#06f400"];//点点颜色
//    _adScrollVw.pageControlAliment=SDCycleScrollViewPageContolAlimentRight;//点点位置
    
    
    
    _areaBt1 = [[UIButton alloc]initWithFrame:CGRectMake(5*ScreenWidth/375, 228/2, 150*ScreenWidth/375, 70)];
//    if ([_locaString isEqualToString:@"北京市"] ||  _locaString ==nil) {//打印 _locaString为(null)
//        _locaString = @"北京";
//    }
//    [_areaBt1 setTitle:_locaString forState:UIControlStateNormal];
    [_areaBt1 setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    _areaBt1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_areaBt1 addTarget:self action:@selector(Clicked1:) forControlEvents:UIControlEventTouchUpInside];
    

    _areaBt2 = [[UIButton alloc]initWithFrame:CGRectMake((5+150+44)*ScreenWidth/375, 228/2 , 150 *ScreenWidth/375, 70)];
//    [_areaBt2 setTitle:@"上海" forState:UIControlStateNormal];
    [_areaBt2 setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    _areaBt2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_areaBt2 addTarget:self action:@selector(Clicked2:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel * lineLb1 = [[UILabel  alloc]initWithFrame:CGRectMake(5, 70+228/2, ScreenWidth-30, 0.5)];
    lineLb1.backgroundColor = [UIColor lightGrayColor];
    
    UILabel * lineLb2 = [[UILabel  alloc]initWithFrame:CGRectMake(5, 140+228/2, ScreenWidth-30, 0.5)];
    lineLb2.backgroundColor = [UIColor lightGrayColor];

    
    UIButton * qiehuanBt = [[UIButton alloc]initWithFrame:CGRectMake((5+150)*ScreenWidth/375, 15+228/2, 42.5 *ScreenWidth/375, 50)];


    [qiehuanBt addTarget:self action:@selector(pressqiehuanBt) forControlEvents:UIControlEventTouchUpInside];
    qiehuanBt.jp_acceptEventInterval = 0.5f;//延迟 0.5秒之后才能点击
    [qiehuanBt setImage:[UIImage imageNamed:@"往返大"] forState:UIControlStateNormal];
    

    
    //用于显示月日
    NSDateFormatter * dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM月dd日"];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期 (current:当前的)
//    NSString * yueriStr = [dateformatter stringFromDate:currentDate];
    
    //用于向下传递当天的具体年-月-日 例:2017-12-30
    NSDateFormatter * dateformatter1=[[NSDateFormatter alloc] init];
    [dateformatter1 setDateFormat:@"YYYY年MM月dd日"];
    
    nianyueriStr = [dateformatter1 stringFromDate:currentDate];

    
    
    UIView * vw = [[UIView alloc]initWithFrame:CGRectMake(5, 199, 290, 45)];//点击日期栏的其他空白出也能跳转
    UITapGestureRecognizer *tap01=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xuanzerili)];
    vw.userInteractionEnabled=YES;
    [vw addGestureRecognizer:tap01];
    
    _dateLb = [[UILabel  alloc]initWithFrame:CGRectMake(5, 95+228/2, 85, 70)];
    _dateLb.backgroundColor = [UIColor whiteColor];
    _dateLb.text =  [dateformatter stringFromDate:currentDate];//当前 月日
    _dateLb.font = [UIFont systemFontOfSize:17];
     [_dateLb sizeToFit];//文字
    
    
    _weakLb = [[UILabel  alloc]initWithFrame:CGRectMake(5+88, 100+228/2, 23, 11)];
    _weakLb.text = @"今天";
    _weakLb.textColor = [UIColor grayColor];
    _weakLb.font = [UIFont systemFontOfSize:11];
    

    
    
    
   
    
    
    
    
    
    UIButton * searchTicketBt = [[UIButton alloc]initWithFrame:CGRectMake(10, 160+228/2, ScreenWidth-40, 45)];
    [searchTicketBt addTarget:self action:@selector(pressSearchTickerBt) forControlEvents:UIControlEventTouchUpInside];
    [searchTicketBt setBackgroundColor:[UIColor orangeColor]];
    [searchTicketBt setTitle:@"搜索" forState:UIControlStateNormal];
    
    
    
    UIButton * myTickerBookBt = [[UIButton alloc]init];//WithFrame:CGRectMake(0, SCREEN_HEIGHT-50-64, ScreenWidth/2, 50)];
    myTickerBookBt.frame = CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight -50-64 , K_SCREEN_WIDTH/2, 62);
    myTickerBookBt.backgroundColor = [UIColor whiteColor];
    [myTickerBookBt addTarget:self action:@selector(pressMyTickerBookBt) forControlEvents:UIControlEventTouchUpInside];
    [myTickerBookBt setTitle:@"我的机票订单" forState:UIControlStateNormal];
    [myTickerBookBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [myTickerBookBt setFont:[UIFont systemFontOfSize:13]];
    [myTickerBookBt setImage:[UIImage imageNamed:@"captcha"] forState:UIControlStateNormal];
    [myTickerBookBt.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [myTickerBookBt.layer setBorderWidth:0.4];
    [myTickerBookBt.layer setMasksToBounds:YES];
    
    
    //按钮图片文字上下:
    myTickerBookBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [myTickerBookBt setTitleEdgeInsets:UIEdgeInsetsMake(myTickerBookBt.imageView.frame.size.height+10 ,-myTickerBookBt.imageView.frame.size.width, 18.0, 0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [myTickerBookBt setImageEdgeInsets:UIEdgeInsetsMake(-10, 0.0, 18.0, -myTickerBookBt.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    
//    备用代码 左右:(因为默认button  图片在左,文字在右, 下面代码是反过来的:   文字  图片)
//    [self.DetailButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.DetailButton.imageView.bounds.size.width, 0, self.DetailButton.imageView.bounds.size.width)];
//    
//    [self.DetailButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.DetailButton.titleLabel.bounds.size.width, 0, -self.DetailButton.titleLabel.bounds.size.width)];
    
    
    
    
    
    UIButton * chuxingwuyouBt = [[UIButton alloc]init];//WithFrame:CGRectMake(ScreenWidth/2, SCREEN_HEIGHT-50-64, ScreenWidth/2, 50)];
    chuxingwuyouBt.frame = CGRectMake(ScreenWidth/2, K_SCREEN_HEIGHT - kSafeAreaBottomHeight - 50-64 , K_SCREEN_WIDTH/2, 62);
    chuxingwuyouBt.backgroundColor = [UIColor whiteColor];
    [chuxingwuyouBt addTarget:self action:@selector(pressChuxingwuyouBt) forControlEvents:UIControlEventTouchUpInside];
    [chuxingwuyouBt setTitle:@"出行无忧" forState:UIControlStateNormal];
    [chuxingwuyouBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [chuxingwuyouBt setFont:[UIFont systemFontOfSize:13]];
    [chuxingwuyouBt setImage:[UIImage imageNamed:@"xingwuy@3x"] forState:UIControlStateNormal];//这个图没有经过打包,所以必须要改名字xingwuy@3x,不然会造成图片太大无法控制
    [chuxingwuyouBt.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [chuxingwuyouBt.layer setBorderWidth:0.4];
    [chuxingwuyouBt.layer setMasksToBounds:YES];
    //按钮图片文字上下:
    chuxingwuyouBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [chuxingwuyouBt setTitleEdgeInsets:UIEdgeInsetsMake(chuxingwuyouBt.imageView.frame.size.height+10 ,-chuxingwuyouBt.imageView.frame.size.width, 18.0, 0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [chuxingwuyouBt setImageEdgeInsets:UIEdgeInsetsMake(-10, 0.0, 18.0, -chuxingwuyouBt.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边

    
    
    
    [backgroundView addSubview:_adScrollVw];
    [backgroundView addSubview:_areaBt1];
    [backgroundView addSubview:_areaBt2];
    [backgroundView addSubview:vw];
    [backgroundView addSubview:_dateLb];
    [backgroundView addSubview:_weakLb];
    [backgroundView addSubview:lineLb1];
    [backgroundView addSubview:lineLb2];
    [backgroundView addSubview:qiehuanBt];
    [backgroundView addSubview:searchTicketBt];
    

    
    [self.view addSubview:backgroundView];
    [self.view addSubview:myTickerBookBt];
    [self.view addSubview:chuxingwuyouBt];
    
}



#pragma mark---广告轮播图 代理
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"广告轮播图:%ld",index);
    NSMutableArray *imageUrlArr=[NSMutableArray array];
    for (VLXHomeAdsDataModel *dataModel in _adsModel_1.data) {
        [imageUrlArr addObject:[ZYYCustomTool checkNullWithNSString:dataModel.adcontents]];
    }
    NSString *urlStr = imageUrlArr[index];
        NSLog(@"广告轮%@",urlStr);
    VLXWebViewVC *webView = [[VLXWebViewVC alloc]init];
    webView.urlStr = urlStr;
    webView.type = 4;
    [self.navigationController pushViewController:webView animated:YES];
}
-(void)loadTickerData
{
    /*
     
     _createTimeDate = createTimeDate_0;
     _key = @"0748cebf8cf346cf64070333c7fed08f";
     _tag = @"flight.national.supply.sl.searchprice";
     _token = @"109cfbc62855bdc711a68c77c3e6bd97";
     
     _params =[NSMutableDictionary dictionary];
     _params[@"dpt"] = @"PEK";
     _params[@"arr"] = @"SHA";
     _params[@"date"] = @"2017-10-30";
     _params[@"ex_track"] = @"tehui";
     _sign =
     
     */
    
//    //utf8转码
//    [_params stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString * treee = [NSString  stringWithFormat:@"%@",_params];
//    
//    [treee stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    


}



-(void)load_ad_Data//广告轮播图数据
{
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"categoryId"]=@"4";//分类id(0:首页，1国内，2国外，3附近)
    NSString * url=[NSString stringWithFormat:@"%@/SysAdController/getSlideShow.json",ftpPath];
    
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        
        _adsModel_1=[[VLXHomeAdsModel alloc] initWithDictionary:requestDic error:nil];
        if (_adsModel_1.status.integerValue==1) {
            NSMutableArray *imageUrlArr=[NSMutableArray array];
            for (VLXHomeAdsDataModel *dataModel in _adsModel_1.data) {
                [imageUrlArr addObject:[ZYYCustomTool checkNullWithNSString:dataModel.adpicture]];
            }
            _adScrollVw.imageURLStringsGroup=imageUrlArr;
            
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
#pragma mark 选择日历
-(void)xuanzerili{
    
    
    vc_1 = [[CalendarHomeViewController alloc]init];
    
    [vc_1 setAirPlaneToDay:365 ToDateforString:nil];//初始化方法
    
    vc_1.calendarblock = ^(CalendarDayModel *model){

        NSString * str = [NSString stringWithFormat:@"%@",[model toString]];//日历列表返回的时间str串
        NSLog(@"----%@",str);
        _bookTimeStr = str;//传递用户选择的时间
        
//        NSString *tihuan0 = [str stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
//        NSString *tihuan1 = [tihuan0 stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
//        NSString *tihuan2 = [tihuan1 stringByReplacingOccurrencesOfString:@"-" withString:@"日"];//把日替换成""
//        //
        NSString * ccc1 = [str substringToIndex:4]; //截取前x位作为日期,第5位之前(不包含)的所有字符串

        
        

//        
        //用于辨识当年的年份
        NSDateFormatter * dateformatter1=[[NSDateFormatter alloc] init];
        [dateformatter1 setDateFormat:@"YYYY"];
         NSDate *currentDate = [NSDate date];//获取当前年份(current:当前的)

        NSString * ccc2 = [dateformatter1 stringFromDate:currentDate];//当前年份
        if ([ccc1 isEqual:ccc2])
        {
            
            
            NSString * ddd1 = [str substringFromIndex:5];//第x后(包含)
            NSLog(@"是同年%@",ddd1);
            

            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17],};
            CGSize textSize = [str boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
            
                    NSString *tihuan1 = [ddd1 stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
                    NSString *tihuan2 = [tihuan1 stringByReplacingOccurrencesOfString:@"-" withString:@"日"];//把日替换成""
            
            _dateLb.text = tihuan2;
            [_dateLb sizeToFit];//label文字自适应宽度

        }else
        {
            NSLog(@"不是同年");
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17],};
            CGSize textSize = [str boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
            _dateLb.text = str;
            [_dateLb sizeToFit];//label文字自适应宽度

        }

        
        
        
        NSString * str2 = [NSString stringWithFormat:@"%@",[model getWeek]];//周几
        _weakLb.text = str2;
        [_weakLb setFrame:CGRectMake(5+3+_dateLb.frame.size.width, 100+228/2, 23, 11)];
        
    };
    
    
    [self.navigationController pushViewController:vc_1 animated:YES];
    
}

-(void)pressqiehuanBt
{
    _zhuanhuan += 1;//自加
    
    if(_zhuanhuan%2==0)//如果是偶数
    {
        NSLog(@"偶数");
         timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerGo1) userInfo:nil repeats:YES];
        
    }
    else{
        
        NSLog(@"奇数");
        timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerGo2) userInfo:nil repeats:YES];
        
    }

    
}
-(void)timerGo1
{
    
    CGRect frame1 = _areaBt1.frame;
    CGRect frame2 = _areaBt2.frame;
    frame1.origin.x += 6;
    frame2.origin.x -= 6;
    
    if (frame1.origin.x > backgroundView.size.width/2 + 21) {
        //关闭定时器
        [timer setFireDate:[NSDate distantFuture]];
    }
    _areaBt1.frame = frame1;
    _areaBt1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _areaBt2.frame = frame2;
    _areaBt2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    
}
-(void)timerGo2
{
    CGRect frame11 = _areaBt1.frame;
    CGRect frame22 = _areaBt2.frame;
    frame11.origin.x -= 6;
    frame22.origin.x += 6;
    
    if (frame22.origin.x > backgroundView.size.width/2 + 21) {
        //关闭定时器
        [timer setFireDate:[NSDate distantFuture]];
    }
    _areaBt1.frame = frame11;
    _areaBt1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _areaBt2.frame = frame22;
    _areaBt2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

}

//订单
-(void)pressMyTickerBookBt{
    VLX_myOrderViewController * vc = [[VLX_myOrderViewController alloc]init];
    
    vc.biaoqian = @"1";

    [self. navigationController pushViewController:vc animated:YES ];
    
    
}
//出行无忧
-(void)pressChuxingwuyouBt{
    
    bigimgVw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    bigimgVw.backgroundColor = rgba(100, 100, 100, 0.6);
    
    UITapGestureRecognizer* tapBigvw = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gunabiVw)];

    [bigimgVw addGestureRecognizer:tapBigvw];
    
    
    
    UIView * litterVw = [[UIView alloc]initWithFrame:CGRectMake(10, 21, ScreenWidth-20, 766/2)];
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer * gradientLayer = [[CAGradientLayer alloc]init];
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = litterVw.bounds;
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [litterVw.layer addSublayer:gradientLayer];
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor,
                             (__bridge id)[UIColor colorWithRed:(239/255.0) green:(179/255.0) blue:(157/255.0) alpha:1].CGColor];
    
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = @[@(0.3f), @(1.0f)];
    
    
    UILabel * headlb = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, 120, 25)];
    headlb.text = @"出行无忧";
    headlb.textColor = rgba(223, 128, 41, 1);
    headlb.font = [UIFont systemFontOfSize:23];
    
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(20, 73, ScreenWidth-80, 1)];
    line.backgroundColor = [UIColor lightGrayColor];

    NSArray * Ay1 = [NSArray array];
    NSArray * Ay2 = [NSArray array];
//    NSArray * Ay3 = [NSArray array];
    Ay1 = @[@"出票保障",@"出票保障",@"出票保障"];
    Ay2 = @[@"支付成功之后,V旅行保证100%按支付价格成功出票。",@"支付成功之后,V旅行保证100%,正常办理登记,保障您的出行。",@"退票、改签要求,V旅行严格按照航空公司标准执行。"];
//    Ay3 = @[@"",@"",@""];
    
    for(int a = 0; a < 3;a++)
    {
        UIImageView  * imgv= [[UIImageView alloc]initWithFrame:CGRectMake(31, 90+(a * 98), 25, 25)];
    
        imgv.image =[ UIImage imageNamed:@"选择后"];
        
        
        [litterVw addSubview:imgv];
    }
    for(int b = 0; b < Ay1.count;b++)
    {
        UILabel  * lb1= [[UILabel alloc]initWithFrame:CGRectMake(65, 92+(b * 98), 120, 20)];
        lb1.text = Ay1[b];
        
        
        [litterVw addSubview:lb1];
    }
    for(int c = 0; c < Ay1.count;c++)
    {
        UILabel  * lb2= [[UILabel alloc]initWithFrame:CGRectMake(31, 123+(c * 98), ScreenWidth-72, 45)];
        lb2.text = Ay2[c];
        lb2.numberOfLines = 0;//设置多行显示

        
        [litterVw addSubview:lb2];
    }
    
    
    
    
    
    [litterVw addSubview:headlb];
    [litterVw addSubview:line];
    [bigimgVw addSubview:litterVw];

    [self.view addSubview:bigimgVw];
}
-(void)gunabiVw{
    [bigimgVw removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//弹出选择地区的方法
-(void)Clicked1:(int)sender
{
    _anniu = @"1";
    NSLog(@"Clicked");
    __block VLX_TicketViewController *blockSelf=self;
    VLX_choose_Aera_VC * city=[[VLX_choose_Aera_VC alloc]init];
    city.tagStringgg = @"booking";
    [self.navigationController pushViewController:city animated:YES];
    
}
-(void)Clicked2:(int)sender
{
    _anniu = @"2";
    NSLog(@"Clicked");
        __block VLX_TicketViewController *blockSelf=self;
    VLX_choose_Aera_VC * city=[[VLX_choose_Aera_VC alloc]init];
    [self.navigationController pushViewController:city animated:YES];
    
}

//
-(void)pressSearchTickerBt//点击搜索时候,跳转下个界面,数据会乱,所以要区分下
{
    VLX_SearchTickerViewController * vc = [[VLX_SearchTickerViewController alloc]init];
    
    if(_zhuanhuan%2==0){             //如果是偶数
        vc.area1 =_areaBt2.titleLabel.text;
        vc.area2 =_areaBt1.titleLabel.text;
    }
    else
    {
        vc.area1 =_areaBt1.titleLabel.text;
        vc.area2 =_areaBt2.titleLabel.text;
    }
    if ([_bookTimeStr isEqualToString:@"0"]) {//如果用户直接点击搜索按钮,而没有选择日历的话
        vc.bookDateStr = nianyueriStr;
    }else{
        vc.bookDateStr = _bookTimeStr;//用户选择的起飞时间
    }
    vc.locationStr = nianyueriStr;//当前时间
    vc.xingqijiStr = _weakLb.text;//周几
    
    
    [self.navigationController pushViewController:vc animated:YES];
    


    
}








-(void)dealloc
{
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeCity1" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeCity2" object:nil];

}
-(void)viewWillAppear:(BOOL)animated
{
    [self readNSUserDefaults3];//读取缓存地区

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyToChangeCity1:) name:@"changeCity1" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoTiCHgaCity2:) name:@"changeCity2" object:nil];



    
}
-(void)notifyToChangeCity1:(NSNotification *)notify
{
    if([_anniu isEqualToString: @"1"]){
        
        [_areaBt1 setTitle:[NSString getCity] forState:UIControlStateNormal];
        NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
        [defaults1 setObject:[NSString getCity] forKey:@"areaAddressOne"];
        [defaults1 synchronize];
    }
    else if ([_anniu isEqualToString: @"2"])
    {
        [_areaBt2 setTitle:[NSString getCity] forState:UIControlStateNormal];

        NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
        [defaults2 setObject:[NSString getCity] forKey:@"areaAddressTwo"];
        [defaults2 synchronize];
    }






}
-(void)NoTiCHgaCity2:(NSNotification *)nott
{
    NSLog(@"值:%@",_anniu);
    NSLog(@"通知%@",nott.userInfo[@"address"]);
    if([_anniu isEqualToString: @"1"]){
     [_areaBt1 setTitle: nott.userInfo[@"address"] forState:UIControlStateNormal];
        NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
        [defaults1 setObject: nott.userInfo[@"address"] forKey:@"areaAddressOne"];
        [defaults1 synchronize];

    }else if ([_anniu isEqualToString: @"2"])
    {
    [_areaBt2 setTitle: nott.userInfo[@"address"] forState:UIControlStateNormal];
        NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
        [defaults2 setObject: nott.userInfo[@"address"] forKey:@"areaAddressTwo"];
        [defaults2 synchronize];

    }
    
}
//读取缓存的地区
-(void)readNSUserDefaults3{

    if(_zhuanhuan%2==0){             //如果是偶数
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        //读取数组NSArray类型的数据
        NSString * areaStringg1 = [userDefaultes stringForKey:@"areaAddressTwo"];
        NSLog(@"duqu:%@",areaStringg1);
        if (areaStringg1 == nil) {
            [_areaBt2 setTitle:@"上海" forState:UIControlStateNormal];
        }
        else{
            [_areaBt2 setTitle:areaStringg1 forState:UIControlStateNormal];

        }
        //读取数组NSArray类型的数据
        NSString * areaStringg2 = [userDefaultes stringForKey:@"areaAddressOne"];
        NSLog(@"duqu偶数:%@",areaStringg2);
        if (areaStringg2 == nil) {
            if ([_locaString isEqualToString:@"北京市"] ||  _locaString ==nil) {//打印 _locaString为(null)
                _locaString = @"北京";
            }
            [_areaBt1 setTitle:_locaString forState:UIControlStateNormal];
        }
        else{
            [_areaBt1 setTitle:areaStringg2 forState:UIControlStateNormal];
        }
    }
    else{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数组NSArray类型的数据
    NSString * areaStringg1 = [userDefaultes stringForKey:@"areaAddressOne"];
//    NSLog(@"duqu:%@",areaStringg1);
    if (areaStringg1 == nil) {
        if ([_locaString isEqualToString:@"北京市"] ||  _locaString ==nil) {//打印 _locaString为(null)
            _locaString = @"北京";
        }
        [_areaBt1 setTitle:_locaString forState:UIControlStateNormal];
    }
    else{
        [_areaBt1 setTitle:areaStringg1 forState:UIControlStateNormal];
    }
    //读取数组NSArray类型的数据
    NSString * areaStringg2 = [userDefaultes stringForKey:@"areaAddressTwo"];
//    NSLog(@"duqu奇数:%@",areaStringg2);
    if (areaStringg2 == nil) {
        [_areaBt2 setTitle:@"上海" forState:UIControlStateNormal];
    }
    else{
        [_areaBt2 setTitle:areaStringg2 forState:UIControlStateNormal];
    }

    }


}

@end

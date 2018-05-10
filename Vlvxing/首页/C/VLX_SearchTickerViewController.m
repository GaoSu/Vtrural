#import "VLX_SearchTickerViewController.h"

#import "VLX_riliCollectionViewCell.h"
#import "VLX_jiageTableViewCell.h"
#import "VLX_SearchModel.h"
#import "VLX_zuobianlanTableViewCell.h"
#import "VLX_youbianlanTableViewCell.h"
#import "VLX_yudingTicketViewController.h"
//天气相关
#import "WSLocation.h"
#import "WeatherModel.h"


#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

@interface VLX_SearchTickerViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{

    int page;
    int size;
    NSMutableArray * _mainDataArr;

    NSMutableArray * _hangCompanyNameCodeAry;////航空公司名字和二字码,真
    NSMutableArray * selectHangCompanyNameCodeAry;//选中航空公司名字和二字码,真

    NSMutableArray * _CodeAry;////航空公司二字码,真
    NSMutableArray * _NameAry;//航空公司名字,真

    NSMutableArray * _flyAirportAry;////起飞机场,真
    NSMutableArray * _downAirportAry;////降落机场,真

    UILabel * navLb1;//地点1
    UIImageView * jiantouVw;//箭头
    UILabel * navLb2;//地点2

    UIImageView *tianqiVw;//天气图
    UILabel * wendu;//温度


    NSInteger  seleStr;//选中;
    UIView * backgroundVw;


    UILabel * _dateLb_1;
    UILabel * _xingqiLb_1;
    UILabel * _jiageLb_1;

    NSInteger xuanzhongxiabiao;//选中下标


    NSString * book_nian;//预定年
    NSString * book_yue;//预定月
    NSString * book_ri;//预定ri

    NSString * location_nian;//当前年
    NSString * location_yue;//当前月
    NSString * location_ri;//当前日



    NSString * str111;//时间段
    NSString * str222;//航空公司
    NSString * str333;//起飞机场
    NSString * str444;//降落机场


    UIView * _bigVw;//弹窗背景半透明
    UIView * _popView;//弹窗


    VLX_SearchModel * jiageModel;


    NSArray * imgAry;//左边栏点击后图片
    NSArray * titleAry;//左边栏title
    NSArray * imgNOary;//左边栏没有点击时图片
    NSArray * timeAry;//起飞时间数组

    NSArray * hangbanAry;//航空公司名字,假




    NSInteger  biaojiInteger_1;//用于标记是左边哪个的点击事件,默认等于1

    NSString * biaojiRiliStr;//用于标记是哪个..

    UIButton * shaixuanBt;//筛选
    UIButton * shijianBt;//时间排序
    UIButton * jiageBt;//价格排序

    NSString * stopStr;//是否经停 true是, false否
    NSString * carrierStr;//航空公司
    NSString * sortStr;//(1时间正序,-1时间倒序) (2价格正序,-2价格倒序) (3飞行时间正序,-3飞行时间倒序)
    NSString * A0000A;//4个中转字符串,用于记录选择的是哪个时间段
    NSString * B6666B;
    NSString * C1212C;
    NSString * D2424D;
    int flytimeInt;    //起飞时间


    int a ;//时间排序用
    int b ;//价格排序用


    NSMutableArray * hangkgsAry;//用于筛选中转航空公司,只是二字码,不是键值対
    NSMutableArray * qifeiAry;//用于起飞机场中转
    NSMutableArray * jiangluosAry;//用于降落机场中转


    UIView * konngView;//数据为空,展示没有查询到信息


}
@property (nonatomic,strong)UICollectionView * riliCollectionVw;//横横横横横横横横横横向日历

@property (nonatomic,strong)UITableView * jiageTableVw;//价格列表
@property(nonatomic,assign)int currentPage1;//当前页
@property(nonatomic,strong) NSMutableArray *dataArr; // 存放价格列表数据
@property (nonatomic,strong)NSMutableArray * dates;//年月日期数据
@property (nonatomic,strong)NSMutableArray * xingqi;//每天是星期几



@property (nonatomic,strong) UITableView * zuobianlanTBVW;//左边栏

@property (nonatomic,strong) UITableView * youbianlanTBVW_1;//左边栏
@property (nonatomic,strong) UITableView * youbianlanTBVW_2;//右边栏
@property (nonatomic,strong) UITableView * youbianlanTBVW_3;//左边栏
@property (nonatomic,strong) UITableView * youbianlanTBVW_4;//右边栏





@property (nonatomic,assign) float realValue;

@property (nonatomic,assign) int shaixuantiaojian;//等于0就是没有任何筛选条件,等于1有条件筛选,等于2有时间或价格排序

@end

@implementation VLX_SearchTickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //    NSLog(@"地点1,2,预定时间,当前时间\n%@\n%@\n%@\n%@",_area1,_area2,_bookDateStr,_locationStr);//都是2017年12月12日

    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton2) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton2)];

    self.automaticallyAdjustsScrollViewInsets = NO;//防止frame乱搞

    //    _dataArr=[NSMutableArray array];

    biaojiInteger_1 = 0;
    biaojiRiliStr =@"a";
    _shaixuantiaojian=0;//默认没有任何筛选条件
    //固定数据
    imgAry = [NSArray array];
    titleAry = [NSArray array];
    imgNOary = [NSArray array];
    timeAry = [NSArray array];
    hangbanAry = [NSArray array];
    imgAry = @[@"筛选—经停-点击", @"筛选—起飞时段-点击", @"筛选—航空公司-点击", @"筛选—机场落地-点击"];
    titleAry = @[@"直飞/经停",@"起飞时段",@"航空公司",@"机场落地"];
    imgNOary = @[@"筛选—经停-未点击",@"筛选—起飞时段-未点击",@"筛选—航空公司-未点击",@"筛选—机场落地-未点击"];
    timeAry = @[@"00:00-06:00",@"06:00-12:00",@"12:00-18:00",@"18:00-23:00"];



    hangkgsAry = [NSMutableArray array];
    qifeiAry = [NSMutableArray array];
    jiangluosAry = [NSMutableArray array];

    A0000A = @"";
    B6666B = @"";
    C1212C = @"";
    D2424D = @"";

    _mainDataArr = [NSMutableArray array];
    _hangCompanyNameCodeAry = [NSMutableArray array];
    selectHangCompanyNameCodeAry = [NSMutableArray array];
    _flyAirportAry = [NSMutableArray array];
    _downAirportAry = [NSMutableArray array];

    _CodeAry = [NSMutableArray array];
    _NameAry = [NSMutableArray array];

    stopStr = @"false";//默认经停
    sortStr = @"1";//默认是时间正序

    [self makeNav];

    //请求天气数据
    //    [self sendRequestToServer_2:_area2];
    [self riliData];//日历数据
    [self hengxiangrili];//横向日历
    [self loadMainData];
    [self tableVw];
    [self ThreeBt];//底部三个按钮
    seleStr = 1;

    a=0;
    b=0;


}

-(void)tapLeftButton2{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 请求主类表价格数据
-(void)loadMainData
{
    [_jiageTableVw.mj_header endRefreshing];

    [SVProgressHUD showWithStatus:@"正在加载参考票价"];
    NSString * url = [NSString stringWithFormat:@"%@%@",tangyangURL,@"searchFlight"];
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"dptCity"] = _area1;
    para[@"arrCity"] = _area2;

    //_bookDateStr订票时间
    NSString *tihuan0 = [_bookDateStr stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    NSString *tihuan1 = [tihuan0 stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    NSString *tihuan2 = [tihuan1 stringByReplacingOccurrencesOfString:@"日" withString:@""];//把日替换成""
    para[@"date"]    = tihuan2;
    para[@"ex_track"]=@"youxuan";//youxuan
    para[@"sort"]=@"1";
    if(_shaixuantiaojian==1){
        str111 = [[NSString alloc]init];
        if ([A0000A isEqualToString:@""] && [B6666B isEqualToString:@""] && [C1212C isEqualToString:@""] &&[D2424D isEqualToString:@""]) {
            str111 = @"";
        }else
        {
            str111 = [NSString stringWithFormat:@"%@%@%@%@",A0000A,B6666B,C1212C,D2424D];
        }
        if ([str111 isEqualToString:@""]) {
            para[@"dptFlyTime"]=@"";
        }else{
            para[@"dptFlyTime"]=str111;
        }

        if ([str222 isEqualToString:@""]) {
            para[@"airlineName"] = @"";
        }else{
            para[@"airlineName"] = str222;
        }

        if ([str333 isEqualToString:@""]) {
            para[@"dptAirpot"] = @"";
        }else{
            para[@"dptAirpot"] = str333;
        }

        if ([str444 isEqualToString:@""]) {
            para[@"arriAirpot"] = @"";
        }else
        {
            para[@"arriAirpot"] = str444;
        }

    }else{}




    NSLog(@"价格列表参数%@",para);

    //
    [HMHttpTool get:url params:para success:^(id responseObj) {
        NSLog_JSON(@"价格列表成功%@",responseObj);
        [SVProgressHUD dismiss];
        if ([responseObj[@"status"]  isEqual: @1]  ) {
            NSDictionary * newdic = [NSDictionary dictionary];
            NSDictionary * panduan = [NSDictionary dictionary];
            panduan = responseObj[@"data"];

            //取出键值対
            NSMutableArray * ary000 = [[NSMutableArray alloc]init];
            NSMutableArray * ary001 = [[NSMutableArray alloc]init];
            [responseObj[@"data"][@"result"][@"airlineMap"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSLog(@"key:%@~ obj:%@", key, obj);
                NSString * pinjieStr = [NSString stringWithFormat:@"%@                                                             =%@",key,obj];
                [ary000 addObject:pinjieStr];//全部
                [ary001 addObject:obj];
                //                [_NameAry ]

            }];
            _hangCompanyNameCodeAry = [ary000 valueForKeyPath:@"@distinctUnionOfObjects.self"];
            _CodeAry = [ary001 valueForKeyPath:@"@distinctUnionOfObjects.self"];



            if ([panduan[@"result"] isKindOfClass:[NSNull class]]) {NSLog(@"不可以");}
            else
            {
                //三个中转数组
                NSMutableArray * ary002 = [[NSMutableArray alloc]init];
                NSMutableArray * ary003 = [[NSMutableArray alloc]init];
                newdic = responseObj[@"data"][@"result"][@"flightInfos"];

                for (NSDictionary  * dic in newdic) {
                    VLX_SearchModel * model = [VLX_SearchModel infoListWithDict:dic];
                    [_mainDataArr addObject:model];
                    if (_flyAirportAry.count>0) {}
                    [ary002 addObject:model.dptAirport];
                    if (_downAirportAry.count>0) {}
                    [ary003 addObject:model.arrAirport];
                }
                //过滤数组中重复的元素
                _flyAirportAry = [ary002 valueForKeyPath:@"@distinctUnionOfObjects.self"];
                _downAirportAry = [ary003 valueForKeyPath:@"@distinctUnionOfObjects.self"];
                [_jiageTableVw.mj_header endRefreshing];

                _jiageTableVw.hidden = NO;
                [_jiageTableVw reloadData];
                [_youbianlanTBVW_3 reloadData];
                [_youbianlanTBVW_4 reloadData];
            }
        }
        else if([responseObj[@"status"]  isEqual: @0])
        {
            [SVProgressHUD showErrorWithStatus:@"暂无该航班"];
            _jiageTableVw.hidden = YES;
        }
    } failure:^(NSError *error) {
        //        NSLog(@"价格列表失败%@",error);
        [_jiageTableVw.mj_footer endRefreshing];
        [_jiageTableVw.mj_header endRefreshing];
        [SVProgressHUD dismiss];

        [SVProgressHUD showErrorWithStatus:@"查询失败!"];

    }];

}

#pragma mark 日历数据,默认60天
-(void)riliData
{


    _dates= [NSMutableArray array];
    _xingqi = [NSMutableArray array];

    //_bookDateStr订票时间
    NSString *tihuan0 = [_bookDateStr stringByReplacingOccurrencesOfString:@"年" withString:@"/"];
    NSString *tihuan1 = [tihuan0 stringByReplacingOccurrencesOfString:@"月" withString:@"/"];
    NSString *tihuan2 = [tihuan1 stringByReplacingOccurrencesOfString:@"日" withString:@""];//把日替换成""
    //_locationStr当前时间
    NSString *tihuan3 = [_locationStr stringByReplacingOccurrencesOfString:@"年" withString:@"/"];
    NSString *tihuan4 = [tihuan3 stringByReplacingOccurrencesOfString:@"月" withString:@"/"];
    NSString *tihuan5 = [tihuan4 stringByReplacingOccurrencesOfString:@"日" withString:@""];



    if ([tihuan5 isEqual:tihuan2])
    {//同天

        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];

        long long int date = (long long int)time;//当前时间 秒值
        //        NSLog(@"当前时间%lld",date);
        NSDateFormatter *formatter0 = [[NSDateFormatter alloc] init];
        [formatter0 setDateFormat:@"HH:mm:ss"];
        NSString *qiegeDateStr = [formatter0 stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];

        //        NSLog(@"当前日期%@",qiegeDateStr);
        NSString * hhh = [qiegeDateStr substringToIndex:3];//时
        NSString * zhuanhuan0001 = [qiegeDateStr substringFromIndex:4];
        NSString * mmm = [zhuanhuan0001 substringToIndex:3];//分
        NSString * sss = [zhuanhuan0001 substringFromIndex:4];//秒
        long long jianquTime = [hhh intValue] * 3600 + [mmm intValue]*60 +[sss intValue];

        long long nowTime = date; //
        long long endTime = date + 24*60*60 * 60;//结束时间,默认从今天开始往后60天
        long long dayTime = 86400;//86400
        long long timeTotal = date - jianquTime;
        //        NSLog(@"余数是多少%lld,%lld",date%dayTime,jianquTime);

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd-EEEE"];


        //        NSLog(@"时间问题%lld:%lld",timeTotal,nowTime);
        while (timeTotal < endTime) {
            NSString *showOldDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeTotal + date%dayTime]];
            NSString * aa = [showOldDate substringToIndex:5];//截取前五位作为日期,第5位之前(不包含)的所有字符串
            [_dates addObject:aa];
            NSString * bb = [showOldDate substringFromIndex:6];//从第六位开始往后截取,第6位之后(包含)的所有字符串

            [_xingqi addObject:bb];
            timeTotal += dayTime;
        }
    }
    else {
        //        NSLog(@"不同天");
        //各种切割
        //订票的年月日 tihuan2订票日期, 假如说是2017年12月20日
        book_nian = [tihuan2 substringToIndex:4];//2017
        NSString * aaa1 = [tihuan2 substringFromIndex:5];   //12月20日//中转字符
        book_yue = [aaa1 substringToIndex:2];    //12
        book_ri =[aaa1 substringFromIndex:3];      //20


        //当前的年月日 tihuan5当前日期
        location_nian = [tihuan5 substringToIndex:4];
        NSString * aaa2 = [tihuan5 substringFromIndex:5];//中转字符
        location_yue = [aaa2 substringToIndex:2];
        location_ri = [aaa2 substringFromIndex:3];


        //同年同月不同天
        if ([book_nian intValue]==[location_nian intValue] && [book_yue intValue]==[location_yue intValue] && [book_ri isEqualToString:location_ri] == NO) {
            //            NSLog(@"同年同月不同天");
            NSTimeInterval time = [[NSDate date] timeIntervalSince1970];

            long long int date = (long long int)time;//当前时间 秒值


            //            NSLog(@"当前时间%lld",date);
            NSDateFormatter *formatter0 = [[NSDateFormatter alloc] init];
            [formatter0 setDateFormat:@"HH:mm:ss"];
            NSString *qiegeDateStr = [formatter0 stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];

            //            NSLog(@"当前日期%@",qiegeDateStr);
            NSString * hhh = [qiegeDateStr substringToIndex:3];//时
            NSString * zhuanhuan0001 = [qiegeDateStr substringFromIndex:4];
            NSString * mmm = [zhuanhuan0001 substringToIndex:3];//分
            NSString * sss = [zhuanhuan0001 substringFromIndex:4];//秒
            long long jianquTime = [hhh intValue] * 3600 + [mmm intValue]*60 +[sss intValue];

            long long nowTime = date; //
            long long endTime = date + 24*60*60 * (60+([book_ri intValue]-[location_ri intValue]));//结束时间,默认从今天开始往后60天
            long long dayTime = 24*60*60;
            long long timeTotal = date - jianquTime%dayTime;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM/dd-EEEE"];

            while (timeTotal < endTime) {
                NSString *showOldDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeTotal+ nowTime%dayTime]];
                NSString * aa = [showOldDate substringToIndex:5];//截取前五位作为日期,第5位之前(不包含)的所有字符串
                [_dates addObject:aa];
                NSString * bb = [showOldDate substringFromIndex:6];//从第六位开始往后截取,第6位之后(包含)的所有字符串

                [_xingqi addObject:bb];
                timeTotal += dayTime;
            }

            xuanzhongxiabiao =[_dates indexOfObject:_dates[[book_ri intValue]-[location_ri intValue]]] ;
            ////                NSLog(@"获取年同月不同天下标%ld",(long)xuanzhongxiabiao);
        }
        //同年不同月
        else if ([book_nian intValue]==[location_nian intValue] &&[book_yue isEqualToString:location_yue]==NO)
        {
            //            NSLog(@"同年不同月");
            //写个方法
            [self youduoshaotian :location_yue :book_yue];
        }
        //不同年
        else if ([book_nian isEqualToString:location_nian]==NO)
        {
            //            NSLog(@"不同年");
            [self youduoshaotian_kuanian :location_yue :book_yue];
        }


    }

}

//同年不同月
-(void)youduoshaotian:(NSString *)locationStr :(NSString *)bookStr
{
    int tianshu1 = 0;
    if([locationStr intValue]== 1)
    {
        if ([bookStr intValue] ==1) {
            tianshu1 = [book_ri intValue]-[location_ri intValue];
        }
        else if ([bookStr intValue] ==2) {
            tianshu1 = [book_ri intValue]+31-[location_ri intValue];
        }
        else if ([bookStr intValue] ==3) {
            tianshu1 = [book_ri intValue]+31-[location_ri intValue]+28;
        }
        else if ([bookStr intValue] ==4) {
            tianshu1 = [book_ri intValue]+31-[location_ri intValue]+28+31;
        }
        else if ([bookStr intValue] ==5) {
            tianshu1 = [book_ri intValue]+31-[location_ri intValue]+28+31+30;
        }
        else if ([bookStr intValue] ==6) {
            tianshu1 = [book_ri intValue]+31-[location_ri intValue]+28+31+30+31;
        }
        else if ([bookStr intValue] ==7) {
            tianshu1 = [book_ri intValue]+31-[location_ri intValue]+28+31+30+31+30;
        }
        else if ([bookStr intValue] ==8) {
            tianshu1 = [book_ri intValue]+31-[location_ri intValue]+28+31+30+31+30+31;
        }
        else if ([bookStr intValue] ==9) {
            tianshu1 = [book_ri intValue]+31-[location_ri intValue]+28+31+30+31+30+31+31;
        }else if ([bookStr intValue] ==10) {
            tianshu1 = [book_ri intValue]+31-[location_ri intValue]+28+31+30+31+30+31+31+30;
        }else if ([bookStr intValue] ==11) {
            tianshu1 =[book_ri intValue]+31-[location_ri intValue]+28+31+30+31+30+31+31+30+31;
        }else if ([bookStr intValue] ==12) {
            tianshu1 = [book_ri intValue]+31-[location_ri intValue]+28+31+30+31+30+31+31+30+31+30;
        }

    }
    else if ([locationStr intValue] == 2)
    {
        if ([bookStr intValue] ==2) {
            tianshu1 = [book_ri intValue]-[location_ri intValue];
        }
        else if ([bookStr intValue] ==3) {
            tianshu1 = [book_ri intValue]+28-[location_ri intValue];
        }
        else if ([bookStr intValue] ==4) {
            tianshu1 = [book_ri intValue]+28-[location_ri intValue]+31;
        }
        else if ([bookStr intValue] ==5) {
            tianshu1 = [book_ri intValue]+28-[location_ri intValue]+31+30;
        }
        else if ([bookStr intValue] ==6) {
            tianshu1 = [book_ri intValue]+28-[location_ri intValue]+31+30+31;
        }
        else if ([bookStr intValue] ==7) {
            tianshu1 = [book_ri intValue]+28-[location_ri intValue]+31+30+31+30;
        }
        else if ([bookStr intValue] ==8) {
            tianshu1 = [book_ri intValue]+28-[location_ri intValue]+31+30+31+30+31;
        }
        else if ([bookStr intValue] ==9) {
            tianshu1 = [book_ri intValue]+28-[location_ri intValue]+31+30+31+30+31+31;
        }else if ([bookStr intValue] ==10) {
            tianshu1 = [book_ri intValue]+28-[location_ri intValue]+31+30+31+30+31+31+30;
        }else if ([bookStr intValue] ==11) {
            tianshu1 = [book_ri intValue]+28-[location_ri intValue]+31+30+31+30+31+31+30+31;
        }else if ([bookStr intValue] ==12) {
            tianshu1 = [book_ri intValue]+28-[location_ri intValue]+31+30+31+30+31+31+30+31+30;
        }
    }
    else if ([locationStr intValue] == 3)
    {
        if ([bookStr intValue] ==3) {
            tianshu1 = [book_ri intValue]-[location_ri intValue];
        }
        else if ([bookStr intValue] ==4) {
            tianshu1 = [book_ri intValue]+31-[location_ri intValue];
        }
        else if ([bookStr intValue] ==5) {
            tianshu1 = [book_ri intValue]+31-[location_ri intValue]+30;
        }
        else if ([bookStr intValue] ==6) {
            tianshu1 = [book_ri intValue]+31-[location_ri intValue]+30+31;
        }
        else if ([bookStr intValue] ==7) {
            tianshu1 = [book_ri intValue]+31-[location_ri intValue]+30+31+30;
        }
        else if ([bookStr intValue] ==8) {
            tianshu1 = [book_ri intValue]+31-[location_ri intValue]+30+31+30+31;
        }
        else if ([bookStr intValue] ==9) {
            tianshu1 = [book_ri intValue]+31-[location_ri intValue]+30+31+30+31+31;
        }else if ([bookStr intValue] ==10) {
            tianshu1 = [book_ri intValue]+31-[location_ri intValue]+30+31+30+31+31+30;
        }else if ([bookStr intValue] ==11) {
            tianshu1 = [book_ri intValue]+31-[location_ri intValue]+30+31+30+31+31+30+31;
        }else if ([bookStr intValue] ==12) {
            tianshu1 = [book_ri intValue]+31-[location_ri intValue]+30+31+30+31+31+30+61;
        }

    }
    else if ([locationStr intValue] == 4)
    {
        if ([bookStr intValue] ==4) {
            tianshu1 = [book_ri intValue]-[location_ri intValue];
        }
        else if ([bookStr intValue] ==5) {
            tianshu1 = [book_ri intValue]+30-[location_ri intValue];
        }
        else if ([bookStr intValue] ==6) {
            tianshu1 = [book_ri intValue]+30-[location_ri intValue]+31;
        }
        else if ([bookStr intValue] ==7) {
            tianshu1 = [book_ri intValue]+30-[location_ri intValue]+31+30;
        }
        else if ([bookStr intValue] ==8) {
            tianshu1 = [book_ri intValue]+30-[location_ri intValue]+31+30+31;
        }
        else if ([bookStr intValue] ==9) {
            tianshu1 = [book_ri intValue]+30-[location_ri intValue]+31+30+31+31;
        }else if ([bookStr intValue] ==10) {
            tianshu1 = [book_ri intValue]+30-[location_ri intValue]+31+30+31+31+30;
        }else if ([bookStr intValue] ==11) {
            tianshu1 = [book_ri intValue]+30-[location_ri intValue]+31+30+31+31+30+31;
        }else if ([bookStr intValue] ==12) {
            tianshu1 = [book_ri intValue]+30-[location_ri intValue]+31+30+31+31+30+61;
        }
    }
    else if ([locationStr intValue] == 5)
    {
        if ([bookStr intValue] ==5) {
            tianshu1 = [book_ri intValue]-[location_ri intValue];
        }
        else if ([bookStr intValue] ==6) {
            tianshu1 = [book_ri intValue]-[location_ri intValue]+31;
        }
        else if ([bookStr intValue] ==7) {
            tianshu1 = [book_ri intValue]-[location_ri intValue]+31+30;
        }
        else if ([bookStr intValue] ==8) {
            tianshu1 = [book_ri intValue]-[location_ri intValue]+31+30+31;
        }
        else if ([bookStr intValue] ==9) {
            tianshu1 = [book_ri intValue]-[location_ri intValue]+31+30+31+31;
        }else if ([bookStr intValue] ==10) {
            tianshu1 = [book_ri intValue]-[location_ri intValue]+31+30+31+31+30;
        }else if ([bookStr intValue] ==11) {
            tianshu1 = [book_ri intValue]-[location_ri intValue]+31+30+31+31+30+31;
        }else if ([bookStr intValue] ==12) {
            tianshu1 = [book_ri intValue]-[location_ri intValue]+31+30+31+31+30+61;
        }

    }
    else if ([locationStr intValue] == 6)
    {
        if ([bookStr intValue] ==6) {
            tianshu1 = [book_ri intValue]-[location_ri intValue];
        }
        else if ([bookStr intValue] ==7) {
            tianshu1 = [book_ri intValue]+30-[location_ri intValue];
        }
        else if ([bookStr intValue] ==8) {
            tianshu1 = [book_ri intValue]+30-[location_ri intValue]+31;
        }
        else if ([bookStr intValue] ==9) {
            tianshu1 = [book_ri intValue]+30-[location_ri intValue]+31+31;
        }else if ([bookStr intValue] ==10) {
            tianshu1 = [book_ri intValue]+30-[location_ri intValue]+31+31+30;
        }else if ([bookStr intValue] ==11) {
            tianshu1 = [book_ri intValue]+30-[location_ri intValue]+31+31+30+31;
        }else if ([bookStr intValue] ==12) {
            tianshu1 = [book_ri intValue]+30-[location_ri intValue]+31+31+30+31+30;
        }

    }
    else if ([locationStr intValue] == 7)
    {
        if ([bookStr intValue] ==7) {
            tianshu1 = [book_ri intValue]-[location_ri intValue];
        }
        else if ([bookStr intValue] ==8) {
            tianshu1 = [book_ri intValue]-[location_ri intValue]+31;
        }
        else if ([bookStr intValue] ==9) {
            tianshu1 = [book_ri intValue]-[location_ri intValue]+31+31;
        }else if ([bookStr intValue] ==10) {
            tianshu1 = [book_ri intValue]-[location_ri intValue]+31+31+30;
        }else if ([bookStr intValue] ==11) {
            tianshu1 = [book_ri intValue]-[location_ri intValue]+31+31+30+31;
        }else if ([bookStr intValue] ==12) {
            tianshu1 = [book_ri intValue]-[location_ri intValue]+31+31+30+31+30;
        }

    }
    else if ([locationStr intValue] == 8)
    {
        if ([bookStr intValue] ==8) {
            tianshu1 = [book_ri intValue]-[location_ri intValue];
        }
        else if ([bookStr intValue] ==9) {
            tianshu1 = [book_ri intValue]-[location_ri intValue]+31;
        }else if ([bookStr intValue] ==10) {
            tianshu1 = [book_ri intValue]-[location_ri intValue]+31+30;
        }else if ([bookStr intValue] ==11) {
            tianshu1 = [book_ri intValue]-[location_ri intValue]+31+30+31;
        }else if ([bookStr intValue] ==12) {
            tianshu1 = [book_ri intValue]-[location_ri intValue]+31+30+31+30;
        }
    }
    else if ([locationStr intValue] == 9)
    {
        if ([bookStr intValue] ==9) {
            tianshu1 = [book_ri intValue]-[location_ri intValue];
        }else if ([bookStr intValue] ==10) {
            tianshu1 = [book_ri intValue]+30-[location_ri intValue];
        }else if ([bookStr intValue] ==11) {
            tianshu1 = [book_ri intValue]+30-[location_ri intValue]+31;
        }else if ([bookStr intValue] ==12) {
            tianshu1 = [book_ri intValue]+30-[location_ri intValue]+31+30;
        }
    }
    else if ([locationStr intValue] == 10)
    {
        if ([bookStr intValue] ==10) {
            tianshu1 = [book_ri intValue]-[location_ri intValue];
        }else if ([bookStr intValue] ==11) {
            tianshu1 = [book_ri intValue]+31-[location_ri intValue];
        }else if ([bookStr intValue] ==12) {
            tianshu1 = tianshu1 = [book_ri intValue]+31-[location_ri intValue]+30;
        }
    }
    else if ([locationStr intValue] == 11)
    {
        if ([bookStr intValue] ==11) {
            tianshu1 = [book_ri intValue]-[location_ri intValue];
        }else if ([bookStr intValue] ==12) {
            tianshu1 = tianshu1 = [book_ri intValue]+30-[location_ri intValue];
        }
    }
    else if ([locationStr intValue] == 12)
    {
        tianshu1 = [book_ri intValue]-[location_ri intValue];
    }

    //算时间
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];

    long long int date = (long long int)time;//当前时间 秒值

    NSDateFormatter *formatter0 = [[NSDateFormatter alloc] init];
    [formatter0 setDateFormat:@"HH:mm:ss"];
    NSString *qiegeDateStr = [formatter0 stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];

    NSString * hhh = [qiegeDateStr substringToIndex:3];//时
    NSString * zhuanhuan0001 = [qiegeDateStr substringFromIndex:4];
    NSString * mmm = [zhuanhuan0001 substringToIndex:3];//分
    NSString * sss = [zhuanhuan0001 substringFromIndex:4];//秒
    long long jianquTime = [hhh intValue] * 3600 + [mmm intValue]*60 +[sss intValue];

    long long nowTime = date; //
    long long endTime = date + 24*60*60 * (60+tianshu1);//结束时间,默认从今天开始往后60天
    long long dayTime = 24*60*60;
    long long timeTotal = date - jianquTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd-EEEE"];

    while (timeTotal < endTime) {
        NSString *showOldDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeTotal+nowTime%dayTime]];
        NSString * aa = [showOldDate substringToIndex:5];//截取前五位作为日期,第5位之前(不包含)的所有字符串
        [_dates addObject:aa];
        NSString * bb = [showOldDate substringFromIndex:6];//从第六位开始往后截取,第6位之后(包含)的所有字符串

        [_xingqi addObject:bb];
        timeTotal += dayTime;
    }

    xuanzhongxiabiao =[_dates indexOfObject:_dates[tianshu1]] ;
}

//跨年的月份天数计算,后续还需要补充
-(void)youduoshaotian_kuanian:(NSString *)locationStr :(NSString *)bookStr
{
    int tianshu1 = 0;

    if([locationStr intValue] == 1)
    {
        if ([bookStr intValue] ==1) {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]);
        }
        else if ([bookStr intValue] ==2) {
            tianshu1 = 365+31+[book_ri intValue];
        }
        else if ([bookStr intValue] ==3) {
            tianshu1 = 365+31+28+[book_ri intValue];
        }
        else if ([bookStr intValue] ==4) {
            tianshu1 = 365+31+28+31+[book_ri intValue];
        }
        else if ([bookStr intValue] ==5) {
            tianshu1 = 365+31+28+31+30+[book_ri intValue];
        }
        else if ([bookStr intValue] ==6) {
            tianshu1 = 365+31+28+31+30+31+[book_ri intValue];
        }
        else if ([bookStr intValue] ==7) {
            tianshu1 = 365+31+28+31+30+31+30+[book_ri intValue];
        }
        else if ([bookStr intValue] ==8) {
            tianshu1 = 365+31+28+31+30+31+30+31+[book_ri intValue];
        }
        else if ([bookStr intValue] ==9) {
            tianshu1 = 365+31+28+31+30+31+30+31+31+[book_ri intValue];
        }else if ([bookStr intValue] ==10) {
            tianshu1 = 365+31+28+31+30+31+30+31+31+30+[book_ri intValue];
        }else if ([bookStr intValue] ==11) {
            tianshu1 = 365+31+28+31+30+31+30+31+31+30+31+[book_ri intValue];
        }else if ([bookStr intValue] ==12) {
            tianshu1 = 365+31+28+31+30+31+30+31+31+30+31+30+[book_ri intValue];
        }

    }
    else if ([locationStr intValue] == 2)
    {

        if ([bookStr intValue] ==1) {
            tianshu1 = 365-31+([book_ri intValue]-[location_ri intValue]);
        }
        else if ([bookStr intValue] ==2) {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]);
        }
        else if ([bookStr intValue] ==3) {
            tianshu1 = 365+28+[book_ri intValue];
        }
        else if ([bookStr intValue] ==4) {
            tianshu1 = 365+28+31+[book_ri intValue];
        }
        else if ([bookStr intValue] ==5) {
            tianshu1 = 365+28+31+30+[book_ri intValue];
        }
        else if ([bookStr intValue] ==6) {
            tianshu1 = 365+28+31+30+31+[book_ri intValue];
        }
        else if ([bookStr intValue] ==7) {
            tianshu1 = 365+28+31+30+31+30+[book_ri intValue];
        }
        else if ([bookStr intValue] ==8) {
            tianshu1 = 365+28+31+30+31+30+31+[book_ri intValue];
        }
        else if ([bookStr intValue] ==9) {
            tianshu1 = 365+28+31+30+31+30+31+31+[book_ri intValue];
        }else if ([bookStr intValue] ==10) {
            tianshu1 = 365+28+31+30+31+30+31+31+30+[book_ri intValue];
        }else if ([bookStr intValue] ==11) {
            tianshu1 = 365+28+31+30+31+30+31+31+30+31+[book_ri intValue];
        }else if ([bookStr intValue] ==12) {
            tianshu1 = 365+28+31+30+31+30+31+31+30+31+30+[book_ri intValue];
        }
    }
    else if ([locationStr intValue] == 3)
    {
        if ([bookStr intValue] ==1) {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue])-28-31;
        }
        else if ([bookStr intValue] ==2)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue])-28;
        }else if ([bookStr intValue] ==3) {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]);
        }else if ([bookStr intValue] ==4) {
            tianshu1 = 365+31+[book_ri intValue];
        }else if ([bookStr intValue] ==5) {
            tianshu1 = 365+[book_ri intValue]+31+30;
        }else if ([bookStr intValue] ==6) {
            tianshu1 = 365+[book_ri intValue]+31+30+31;
        }else if ([bookStr intValue] ==7) {
            tianshu1 = 365+[book_ri intValue]+31+30+31+30;
        }else if ([bookStr intValue] ==8) {
            tianshu1 = 365+[book_ri intValue]+31+30+31+30+31;
        }else if ([bookStr intValue] ==9) {
            tianshu1 = 365+[book_ri intValue]+31+30+31+30+31+31;
        }else if ([bookStr intValue] ==10) {
            tianshu1 = 365+[book_ri intValue]+31+30+31+30+31+31+30;
        }else if ([bookStr intValue] ==11) {
            tianshu1 = 365+[book_ri intValue]+31+30+31+30+31+31+30+31;
        }else if ([bookStr intValue] ==12) {
            tianshu1 = 365+[book_ri intValue]+31+30+31+30+31+31+30+31+30;
        }

    }
    else if ([locationStr intValue] == 4)
    {
        if ([bookStr intValue] ==1) {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue])-31-28-31;
        }
        else if ([bookStr intValue] ==2)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue])-31-28;
        }else if ([bookStr intValue] ==3)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue])-31;
        }else if ([bookStr intValue] ==4) {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]);
        }
        else if ([bookStr intValue] ==5) {
            tianshu1 = 365+[book_ri intValue]+30;
        }
        else if ([bookStr intValue] ==6) {
            tianshu1 = 365+[book_ri intValue]+30+31;
        }
        else if ([bookStr intValue] ==7) {
            tianshu1 = 365+[book_ri intValue]+30+31+30;
        }
        else if ([bookStr intValue] ==8) {
            tianshu1 = 365+[book_ri intValue]+30+31+30+31;
        }
        else if ([bookStr intValue] ==9) {
            tianshu1 = 365+[book_ri intValue]+30+31+30+31+31;
        }else if ([bookStr intValue] ==10) {
            tianshu1 = 365+[book_ri intValue]+30+31+30+31+31+30;
        }else if ([bookStr intValue] ==11) {
            tianshu1 = 365+[book_ri intValue]+30+31+30+31+31+30+31;
        }else if ([bookStr intValue] ==12) {
            tianshu1 = 365+[book_ri intValue]+30+31+30+31+31+30+31+30;
        }
    }
    else if ([locationStr intValue] == 5)
    {
        if ([bookStr intValue] ==1) {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-30-31-28-31);
        }
        else if ([bookStr intValue] ==2)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-30-31-28);
        }else if ([bookStr intValue] ==3)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-30-31);
        }else if ([bookStr intValue] ==4)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-30);
        }else if ([bookStr intValue] ==5) {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]);
        }
        else if ([bookStr intValue] ==6) {
            tianshu1 = 365+[book_ri intValue]+31;
        }
        else if ([bookStr intValue] ==7) {
            tianshu1 = 365+[book_ri intValue]+31+30;
        }
        else if ([bookStr intValue] ==8) {
            tianshu1 = 365+[book_ri intValue]+31+30+31;
        }
        else if ([bookStr intValue] ==9) {
            tianshu1 = 365+[book_ri intValue]+31+30+31+31;
        }else if ([bookStr intValue] ==10) {
            tianshu1 = 365+[book_ri intValue]+31+30+31+31+30;
        }else if ([bookStr intValue] ==11) {
            tianshu1 = 365+[book_ri intValue]+31+30+31+31+30+31;
        }else if ([bookStr intValue] ==12) {
            tianshu1 = 365+[book_ri intValue]+31+30+31+31+30+31+30;
        }

    }
    else if ([locationStr intValue] == 6)
    {
        if ([bookStr intValue] ==1) {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-31-30-31-28-31);
        }
        else if ([bookStr intValue] ==2)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-31-30-31-28);
        }else if ([bookStr intValue] ==3)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-31-30-31);
        }else if ([bookStr intValue] ==4)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-31-30);
        }else if ([bookStr intValue] ==5)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-31);
        }else if ([bookStr intValue] ==6) {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]);
        }
        else if ([bookStr intValue] ==7) {
            tianshu1 = 365+[book_ri intValue]+30;
        }
        else if ([bookStr intValue] ==8) {
            tianshu1 = 365+[book_ri intValue]+30+31;
        }
        else if ([bookStr intValue] ==9) {
            tianshu1 = 365+[book_ri intValue]+30+31+31;
        }else if ([bookStr intValue] ==10) {
            tianshu1 = 365+[book_ri intValue]+30+31+31+30;
        }else if ([bookStr intValue] ==11) {
            tianshu1 = 365+[book_ri intValue]+30+31+31+30+31;
        }else if ([bookStr intValue] ==12) {
            tianshu1 = 365+[book_ri intValue]+30+31+31+30+31+30;
        }

    }
    else if ([locationStr intValue] == 7)
    {
        if ([bookStr intValue] ==1) {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-30-31-30-31-28-31);
        }
        else if ([bookStr intValue] ==2)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-30-31-30-31-28);
        }else if ([bookStr intValue] ==3)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-30-31-30-31);
        }else if ([bookStr intValue] ==4)
        {tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-30-31-30);

        }else if ([bookStr intValue] ==5)
        {tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-30-31);

        }else if ([bookStr intValue] ==6)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-30);
        }
        else if ([bookStr intValue] ==7) {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]);
        }
        else if ([bookStr intValue] ==8) {
            tianshu1 = 365+[book_ri intValue]+31;
        }
        else if ([bookStr intValue] ==9) {
            tianshu1 = 365+[book_ri intValue]+31+31;
        }else if ([bookStr intValue] ==10) {
            tianshu1 = 365+[book_ri intValue]+31+31+30;
        }else if ([bookStr intValue] ==11) {
            tianshu1 = 365+[book_ri intValue]+31+31+30+31;
        }else if ([bookStr intValue] ==12) {
            tianshu1 = 365+[book_ri intValue]+31+31+30+31+30;
        }

    }
    else if ([locationStr intValue] == 8)
    {
        if ([bookStr intValue] ==1) {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-31-30-31-30-31-28-31);
        }
        else if ([bookStr intValue] ==2)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-31-30-31-30-31-28);
        }else if ([bookStr intValue] ==3)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-31-30-31-30-31);
        }else if ([bookStr intValue] ==4)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-31-30-31-30);
        }else if ([bookStr intValue] ==5)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-31-30-31);
        }else if ([bookStr intValue] ==6)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-31-30);
        }
        else if ([bookStr intValue] ==7)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-31);

        }else if ([bookStr intValue] ==8) {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]);
        }
        else if ([bookStr intValue] ==9) {
            tianshu1 = 365+[book_ri intValue]+31;
        }else if ([bookStr intValue] ==10) {
            tianshu1 = 365+[book_ri intValue]+31+30;
        }else if ([bookStr intValue] ==11) {
            tianshu1 = 365+[book_ri intValue]+31+30+31;
        }else if ([bookStr intValue] ==12) {
            tianshu1 = 365+[book_ri intValue]+31+30+61;
        }
    }
    else if ([locationStr intValue] == 9)
    {
        if ([bookStr intValue] ==1) {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-31-31+30+31+30+31+28+31);
        }
        else if ([bookStr intValue] ==2)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-31-31+30+31+30+31+28);
        }else if ([bookStr intValue] ==3)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-31-31+30+31+30+31);
        }else if ([bookStr intValue] ==4)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-31-31+30+31+30);
        }else if ([bookStr intValue] ==5)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-31-31+30+31);
        }else if ([bookStr intValue] ==6)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-31-31+30);
        }
        else if ([bookStr intValue] ==7)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-31-31);
        }else if ([bookStr intValue] ==8)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]-31);
        }else if([bookStr intValue] ==9) {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]);
        }else if ([bookStr intValue] ==10) {
            tianshu1 = 365+[book_ri intValue]+30;
        }else if ([bookStr intValue] ==11) {
            tianshu1 = 365+[book_ri intValue]+30+31;
        }else if ([bookStr intValue] ==12) {
            tianshu1 = 365+[book_ri intValue]+30+31+30;
        }
    }
    else if ([locationStr intValue] == 10)
    {
        if ([bookStr intValue] ==1) {
            tianshu1 = (31-[location_ri intValue])+31+[book_ri intValue]+30; //+12月天数+预定天数 + 11月天数
        }
        else if ([bookStr intValue] ==2)
        {
            tianshu1 = (31-[location_ri intValue])+31+[book_ri intValue]+30+31;
        }else if ([bookStr intValue] ==3)
        {
            tianshu1 = (31-[location_ri intValue])+31+[book_ri intValue]+30+31+28;
        }else if ([bookStr intValue] ==4)
        {
            tianshu1 = (31-[location_ri intValue])+31+[book_ri intValue]+30+31+28+31;
        }else if ([bookStr intValue] ==5)
        {
            tianshu1 = (31-[location_ri intValue])+31+[book_ri intValue]+30+31+28+31+30;
        }else if ([bookStr intValue] ==6)
        {
            tianshu1 = (31-[location_ri intValue])+31+[book_ri intValue]+30+31+28+31+30+31;
        }
        else if ([bookStr intValue] ==7)
        {
            tianshu1 = (31-[location_ri intValue])+31+[book_ri intValue]+30+31+28+31+30+31+30;
        }else if ([bookStr intValue] ==8)
        {
            tianshu1 = (31-[location_ri intValue])+31+[book_ri intValue]+30+31+28+31+30+31+30+31;

        }else if ([bookStr intValue] ==9)
        {
            tianshu1 = (31-[location_ri intValue])+31+[book_ri intValue]+30+31+28+31+30+31+30+31+31;

        }else if ([bookStr intValue] ==10) {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]);
        }else if ([bookStr intValue] ==11) {
            tianshu1 = 365+[book_ri intValue]+31;
        }else if ([bookStr intValue] ==12) {
            tianshu1 = 365+[book_ri intValue]+61;
        }
    }
    else if ([locationStr intValue] == 11)
    {
        if ([bookStr intValue] ==1) {
            tianshu1 = (30-[location_ri intValue])+31+[book_ri intValue];
        }
        else if ([bookStr intValue] ==2) {
            tianshu1 = (30-[location_ri intValue])+31+[book_ri intValue]+31;
        }
        else if ([bookStr intValue] ==3) {
            tianshu1=(30-[location_ri intValue])+31+[book_ri intValue]+31+28;
        }
        else if ([bookStr intValue] ==4) {
            tianshu1=(30-[location_ri intValue])+31+[book_ri intValue]+31+28+31;
        }
        else if ([bookStr intValue] ==5) {
            tianshu1=(30-[location_ri intValue])+31+[book_ri intValue]+31+28+31+30;
        }
        else if ([bookStr intValue] ==6) {
            tianshu1=(30-[location_ri intValue])+31+[book_ri intValue]+31+28+31+30+31;
        }
        else if ([bookStr intValue] ==7) {
            tianshu1=(30-[location_ri intValue])+31+[book_ri intValue]+31+28+31+30+31+30;
        }else if ([bookStr intValue] ==8) {
            tianshu1=(30-[location_ri intValue])+31+[book_ri intValue]+31+28+31+30+31+30+31;
        }else if ([bookStr intValue] ==9) {
            tianshu1=(30-[location_ri intValue])+31+[book_ri intValue]+31+28+31+30+31+30+31+31;
        }else if ([bookStr intValue] ==10) {
            tianshu1=(30-[location_ri intValue])+31+[book_ri intValue]+31+28+31+30+31+30+31+31+30;
        }
        else if ([bookStr intValue] ==11) {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]);
        }else if ([bookStr intValue] ==12) {
            tianshu1 = 365+[book_ri intValue]+30;
        }
    }
    else if ([locationStr intValue] == 12)
    {
        if ([bookStr intValue] ==1) {
            tianshu1 = ([book_ri intValue]-[location_ri intValue])+31;
        }
        else if ([bookStr intValue] ==2)
        {
            tianshu1 = ([book_ri intValue]-[location_ri intValue])+31+31;
        }else if ([bookStr intValue] ==3)
        {
            tianshu1 = ([book_ri intValue]-[location_ri intValue])+31+31+28;
        }else if ([bookStr intValue] ==4)
        {
            tianshu1 = ([book_ri intValue]-[location_ri intValue])+31+31+28+31;
        }else if ([bookStr intValue] ==5)
        {
            tianshu1 = ([book_ri intValue]-[location_ri intValue])+31+31+28+31+30;
        }else if ([bookStr intValue] ==6)
        {
            tianshu1 = ([book_ri intValue]-[location_ri intValue])+31+31+28+31+30+31;
        }
        else if ([bookStr intValue] ==7)
        {
            tianshu1 = ([book_ri intValue]-[location_ri intValue])+31+31+28+31+30+31+30;
        }else if ([bookStr intValue] ==8)
        {
            tianshu1 = ([book_ri intValue]-[location_ri intValue])+31+31+28+31+30+31+30+31;
        }else if ([bookStr intValue] ==9)
        {
            tianshu1 = ([book_ri intValue]-[location_ri intValue])+31+31+28+31+30+31+30+31+31;
        }else if ([bookStr intValue] ==10)
        {
            tianshu1 = ([book_ri intValue]-[location_ri intValue])+31+31+28+31+30+31+30+31+31+30;
        }
        else if ([bookStr intValue] ==11)
        {
            tianshu1 = ([book_ri intValue]-[location_ri intValue])+31+31+28+31+30+31+30+31+31+30+31;
        }else if ([bookStr intValue] ==12)
        {
            tianshu1 = 365+([book_ri intValue]-[location_ri intValue]);

        }


    }
    //算时间
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];

    long long int date = (long long int)time;//当前时间 秒值


    //    NSLog(@"当前时间%lld",date);
    NSDateFormatter *formatter0 = [[NSDateFormatter alloc] init];
    [formatter0 setDateFormat:@"HH:mm:ss"];
    NSString *qiegeDateStr = [formatter0 stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];

    //    NSLog(@"当前日期%@",qiegeDateStr);
    NSString * hhh = [qiegeDateStr substringToIndex:3];//时
    NSString * zhuanhuan0001 = [qiegeDateStr substringFromIndex:4];
    NSString * mmm = [zhuanhuan0001 substringToIndex:3];//分
    NSString * sss = [zhuanhuan0001 substringFromIndex:4];//秒
    long long jianquTime = [hhh intValue] * 3600 + [mmm intValue]*60 +[sss intValue];


    long long nowTime = date; //
    //    NSLog(@"算时间%d",tianshu1);
    long long endTime = date + 24*60*60 * (60+tianshu1);//结束时间,默认从今天开始往后60天
    long long dayTime = 24*60*60;
    long long timeTotal = date - jianquTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd-EEEE"];

    while (timeTotal < endTime) {
        NSString *showOldDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeTotal+ nowTime%dayTime]];
        NSString * aa = [showOldDate substringToIndex:5];//截取前五位作为日期,第5位之前(不包含)的所有字符串
        [_dates addObject:aa];
        NSString * bb = [showOldDate substringFromIndex:6];//从第六位开始往后截取,第6位之后(包含)的所有字符串

        [_xingqi addObject:bb];
        timeTotal += dayTime;
    }

    xuanzhongxiabiao =[_dates indexOfObject:_dates[tianshu1]] ;

}

//天气请求
-(void)sendRequestToServer_2:(NSString *)cityName
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"https://api.thinkpage.cn/v3/weather/daily.json?key=osoydf7ademn8ybv&location=%@&language=zh-Hans&start=0&days=3",cityName];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];


    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //                NSLog(@"天气信息:%@",responseObject);
        NSArray *resultArray = responseObject[@"results"];
        for (NSDictionary *dic in resultArray) {
            WeatherModel *model = [[WeatherModel alloc]init];
            model.cityName = dic[@"location"][@"name"];
            model.todayDic = (NSDictionary *)[dic[@"daily"] objectAtIndex:0];//今天

            NSString * str1 =[NSString stringWithFormat:@"%@-%@°C",[model.todayDic objectForKey:@"high"],[model.todayDic objectForKey:@"low"]];
            //            NSLog(@"wendu%@",str1);
            wendu.text = str1;


            //            NSLog(@"图片:%@",[model.todayDic objectForKey:@"text_day"]);
            tianqiVw.image = [UIImage imageNamed:[model.todayDic objectForKey:@"text_day"]];

        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}

-(void)makeNav{


    //中间
    UIView *zhongView=[[UIView alloc] initWithFrame:CGRectMake(0, 7, ScaleWidth(240), 44-7*2)];
    //    zhongView.layer.cornerRadius=15;
    //    zhongView.layer.masksToBounds=YES;
    //    zhongView.layer.borderColor=gray_color.CGColor;
    //    zhongView.layer.borderWidth=1;
    self.navigationItem.titleView=zhongView;

    navLb1=[[UILabel alloc] initWithFrame:CGRectMake(0, 6, ScaleWidth(110), 18)];
    navLb1.text=_area1;
    navLb1.textColor=[UIColor blackColor];
    navLb1.textAlignment=NSTextAlignmentRight;
    UIFont *font1 = [UIFont fontWithName:@"Courier New" size:18.0f];
    navLb1.font = font1;
    // 根据字体得到NSString的尺寸
    CGSize size1 = [navLb1.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font1,NSFontAttributeName,nil]];
    // 名字的W
    CGFloat nav1textW = size1.width;


    [zhongView addSubview:navLb1];




    jiantouVw=[[UIImageView alloc] initWithFrame:CGRectMake(3+navLb1.frame.size.width, (30-17)/2, 40, 15)];
    [jiantouVw setImage:[UIImage imageNamed:@"目的地"]];
    [zhongView addSubview:jiantouVw];

    navLb2=[[UILabel alloc] initWithFrame:CGRectMake(6+navLb1.frame.size.width+jiantouVw.frame.size.width, 6, ScaleWidth(110), 18)];
    navLb2.text=_area2;
    navLb2.font = [UIFont fontWithName:@"Courier New" size:18.0f];
    navLb2.textColor=[UIColor blackColor];
    navLb2.textAlignment=NSTextAlignmentLeft;
    [zhongView addSubview:navLb2];

}

-(void)hengxiangrili
{



    //此处必须要有创见一个UICollectionViewFlowLayout的对象
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //同一行相邻两个cell的最小间距
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//横向滚动
    layout.minimumInteritemSpacing = 0;
    //最小两行之间的间距
    layout.minimumLineSpacing = 0;

    _riliCollectionVw = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 75)collectionViewLayout:layout];
    _riliCollectionVw.delegate = self;
    _riliCollectionVw.dataSource = self;
    _riliCollectionVw.backgroundColor = [UIColor whiteColor];

    //这种是自定义cell的注册
    [_riliCollectionVw registerClass:[VLX_riliCollectionViewCell class] forCellWithReuseIdentifier:@"myheheIdentifier"];
    if (xuanzhongxiabiao == 3 || xuanzhongxiabiao > 3) {//从第三天开始才有居中效果
        [_riliCollectionVw setContentOffset:CGPointMake(ScreenWidth/5 * (xuanzhongxiabiao - 2), 0)];
    }
    //    NSLog(@"日历下标%ld",xuanzhongxiabiao);

    //这是头部与脚部的注册
    [_riliCollectionVw registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];



    [self.view addSubview:_riliCollectionVw];



}



#pragma 横向日历的代理方法
//组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//行数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dates.count;
}

//即将显示时候,
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //    [(VLX_riliCollectionViewCell *) cell configureCellWithPostURL:@"postImage.jpg"];


    VLX_riliCollectionViewCell * cell1 =(id) [_riliCollectionVw cellForItemAtIndexPath:indexPath];
    cell1 = cell;

    if ([_bookDateStr isEqualToString:_locationStr] && indexPath.row == 0) {//如果是同一天
        cell1.backgroundColor = [UIColor whiteColor];
        cell1.dateLb.textColor = rgba(230, 107, 61, 1);
        cell1.xingqiLb.textColor =rgba(230, 107, 61, 1);
        cell1.jiageLb.textColor =rgba(230, 107, 61, 1);

    }
    else{ //不是同一天
        //
        if (indexPath.row == xuanzhongxiabiao) {
            //            cell.selected = YES;
            cell1.backgroundColor = [UIColor whiteColor];
            cell1.dateLb.textColor = rgba(230, 107, 61, 1);
            cell1.xingqiLb.textColor =rgba(230, 107, 61, 1);
            cell1.jiageLb.textColor =rgba(230, 107, 61, 1);

        }else {
            //            cell.selected = NO;

            cell1.backgroundColor = rgba(230, 107, 61, 1);
            cell1.dateLb.textColor = [UIColor whiteColor];
            cell1.xingqiLb.textColor =[UIColor whiteColor];
            cell1.jiageLb.textColor =[UIColor whiteColor];

        }

    }


}

//填充
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{



    VLX_riliCollectionViewCell *cell = [_riliCollectionVw dequeueReusableCellWithReuseIdentifier:@"myheheIdentifier" forIndexPath:indexPath];


    cell.backgroundColor = rgba(230, 107, 61, 1);
    cell.dateLb.text = _dates[indexPath.row];
    cell.xingqiLb.text = _xingqi[indexPath.row];

    //_bookDateStr,_locationStr
    //    if ([_bookDateStr isEqualToString:_locationStr]) {//如果是同一天
    //
    //    }
    if ([biaojiRiliStr isEqualToString:@"a"] && indexPath.row == 0) {
        //            cell.selected = YES;
        cell.backgroundColor = [UIColor whiteColor];
        cell.dateLb.textColor = rgba(230, 107, 61, 1);
        cell.xingqiLb.textColor =rgba(230, 107, 61, 1);
        cell.jiageLb.textColor =rgba(230, 107, 61, 1);
        return cell;

    }
    else{ //不是同一天
        //
        if (indexPath.row == xuanzhongxiabiao) {
            //            cell.selected = YES;
            cell.backgroundColor = [UIColor whiteColor];
            cell.dateLb.textColor = rgba(230, 107, 61, 1);
            cell.xingqiLb.textColor =rgba(230, 107, 61, 1);
            cell.jiageLb.textColor =rgba(230, 107, 61, 1);
            return cell;

        }else {
            //            cell.selected = NO;

            cell.backgroundColor = rgba(230, 107, 61, 1);

            cell.dateLb.textColor = [UIColor whiteColor];
            cell.xingqiLb.textColor =[UIColor whiteColor];
            cell.jiageLb.textColor =[UIColor whiteColor];
            return cell;
        }

    }
    //    [_riliCollectionVw selectItemAtIndexPath: indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];


    return nil;
}
//组头组尾设置
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *headerView = [_riliCollectionVw dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionViewHeader" forIndexPath:indexPath];
        if(headerView == nil)
        {
            headerView = [[UICollectionReusableView alloc] init];
        }
        headerView.backgroundColor = [UIColor grayColor];

        return headerView;
    }


    return nil;
}


//间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(ScreenWidth/5, 75);
}
//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    biaojiRiliStr = @"b";//

    NSArray * ary = [collectionView indexPathsForVisibleItems];//视图里边所有可视的

    //    NSLog(@"视图里边所有可视的%lu",(unsigned long)ary.count);//5个
    for (NSIndexPath * abc in ary) {
        VLX_riliCollectionViewCell * cell =(id) [_riliCollectionVw cellForItemAtIndexPath:abc];
        cell.backgroundColor = rgba(230, 107, 61, 1);
        cell.dateLb.textColor = [UIColor whiteColor];
        cell.xingqiLb.textColor =[UIColor whiteColor];
        cell.jiageLb.textColor =[UIColor whiteColor];
    }
    VLX_riliCollectionViewCell * cell =(id) [_riliCollectionVw cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.dateLb.textColor = rgba(230, 107, 61, 1);
    cell.xingqiLb.textColor =rgba(230, 107, 61, 1);
    cell.jiageLb.textColor =rgba(230, 107, 61, 1);

    xuanzhongxiabiao = indexPath.row;

    //获取当前的时间戳, 秒值
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970];
    long long createTimeDate_0 = [[NSNumber numberWithDouble:nowtime] longLongValue];

    //将当前时间加上天数的秒数
    NSString *chuoTime = [NSString stringWithFormat:@"%llu",createTimeDate_0 + 24*3600* xuanzhongxiabiao];

    NSTimeInterval interval   = [chuoTime doubleValue];
    NSDate *date              = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _bookDateStr = [formatter stringFromDate: date];
    //    NSLog(@"对应的时间是:%@",_bookDateStr);
    //    NSLog(@"横向日历天数%ld",(long)xuanzhongxiabiao);


    _xingqijiStr = cell.xingqiLb.text;//向下传递周几

    if (_shaixuantiaojian == 0) {
        [_mainDataArr removeAllObjects];//在这里只移除一个,剩下的在请求里边移除
        [self loadMainData];
    }
    else if (_shaixuantiaojian == 1){
        [_mainDataArr removeAllObjects];//在这里只移除一个,剩下的在请求里边移除
        [self loadMainData];
    }
    else{
        [_mainDataArr removeAllObjects];//在这里只移除一个,剩下的在请求里边移除
        [self loadTimeData];

    }

    //cell被电击后移动的动画
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionTop];
}

//丝滑!!
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    CGPoint originalTargetContentOffset = CGPointMake(targetContentOffset->x, targetContentOffset->y);
    CGPoint targetCenter = CGPointMake(originalTargetContentOffset.x + CGRectGetWidth(_riliCollectionVw.bounds)/2, CGRectGetHeight(_riliCollectionVw.bounds) / 2);
    NSIndexPath *indexPath = nil;
    NSInteger i = 0;

    while (indexPath == nil) {
        targetCenter = CGPointMake(originalTargetContentOffset.x + CGRectGetWidth(_riliCollectionVw.bounds)/2 + 10*i, CGRectGetHeight(_riliCollectionVw.bounds) / 2);
        indexPath = [_riliCollectionVw indexPathForItemAtPoint:targetCenter];
        i++;
    }




    //这里用attributes比用cell要好很多，因为cell可能因为不在屏幕范围内导致cellForItemAtIndexPath返回nil
    UICollectionViewLayoutAttributes *attributes = [_riliCollectionVw.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
    if (attributes) {
        *targetContentOffset = CGPointMake(attributes.center.x - CGRectGetWidth(_riliCollectionVw.bounds)/2, originalTargetContentOffset.y);


    } else {
        //        NSLog(@"center is %@; indexPath is {%@, %@}; cell is %@",NSStringFromCGPoint(targetCenter), @(indexPath.section), @(indexPath.item), attributes);
    }

}



-(void)tableVw{
    _jiageTableVw = [[UITableView alloc]initWithFrame:CGRectMake(0, 75, ScreenWidth, ScreenHeight-75-48-48-16)];//32
    _jiageTableVw.separatorColor = [UIColor grayColor];
    _jiageTableVw.delegate = self;
    _jiageTableVw.dataSource = self;
    //去除多余分割线
    _jiageTableVw.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //刷新
    //    _jiageTableVw.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData1)];

    _jiageTableVw.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self refreshData1];
        });
    }];
    //加载
    //    _jiageTableVw.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData1)];

    [self.view addSubview: _jiageTableVw];

}

-(void)refreshData1
{


    if (_shaixuantiaojian == 0) {
        [_mainDataArr removeAllObjects];//清空数据源
        [self loadMainData];
    }else if (_shaixuantiaojian == 1)
    {
        [_mainDataArr removeAllObjects];//清空数据源
        [self loadTimeData];
    }
    else{//==2
        [_mainDataArr removeAllObjects];//清空数据源
        [self loadTimeData];
    }

}
-(void)reloadMoreData1
{//    self.currentPage++;
    //    [self loadRecommandData:2];
}
#pragma mark -  底部三个按钮
-(void)ThreeBt{

    shaixuanBt = [[UIButton alloc]init];//WithFrame:CGRectMake(0, ScreenHeight-48-64, ScreenWidth/3, 48)];
    shaixuanBt.frame = CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight -48-64 , K_SCREEN_WIDTH/3, 48);
    [shaixuanBt addTarget:self action:@selector(pressShaixuanBt) forControlEvents:UIControlEventTouchUpInside];
    [shaixuanBt setTitle:@"筛选" forState:UIControlStateNormal];
    [shaixuanBt setFont:[UIFont systemFontOfSize:13]];
    [shaixuanBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    shaixuanBt.backgroundColor = [UIColor colorWithRed:(238.0/255.0) green:(238.0/255.0) blue:(238.0/255.0) alpha:1];


    shijianBt = [[UIButton alloc]init];//WithFrame:CGRectMake(ScreenWidth/3, ScreenHeight-48-64, ScreenWidth/3, 48)];
    shijianBt.frame = CGRectMake(ScreenWidth/3, K_SCREEN_HEIGHT - kSafeAreaBottomHeight -48-64 , K_SCREEN_WIDTH/3, 48);

    [shijianBt addTarget:self action:@selector(pressShijianBt) forControlEvents:UIControlEventTouchUpInside];
    [shijianBt setTitle:@"时间 ∧" forState:UIControlStateNormal];
    [shijianBt setFont:[UIFont systemFontOfSize:13]];

    [shijianBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    shijianBt.backgroundColor = [UIColor colorWithRed:(238.0/255.0) green:(238.0/255.0) blue:(238.0/255.0) alpha:1];


    jiageBt = [[UIButton alloc]init];//WithFrame:CGRectMake(ScreenWidth/3 * 2, ScreenHeight-48-64, ScreenWidth/3, 48)];
    jiageBt.frame = CGRectMake(ScreenWidth/3 * 2, K_SCREEN_HEIGHT - kSafeAreaBottomHeight -48-64 , K_SCREEN_WIDTH/3, 48);
    [jiageBt addTarget:self action:@selector(pressJiageBt) forControlEvents:UIControlEventTouchUpInside];
    [jiageBt setTitle:@"价格 ∧" forState:UIControlStateNormal];
    [jiageBt setFont:[UIFont systemFontOfSize:13]];

    [jiageBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    jiageBt.backgroundColor = [UIColor colorWithRed:(238.0/255.0) green:(238.0/255.0) blue:(238.0/255.0) alpha:1];


    [self.view addSubview:shaixuanBt];
    [self.view addSubview:shijianBt];
    [self.view addSubview:jiageBt];

}


#pragma mark -  弹出窗
-(void)pressShaixuanBt{

    if (_popView.hidden == YES || _bigVw.hidden == YES) {
        //        NSLog(@"hidden");
        _popView.hidden = NO;
        _bigVw.hidden = NO;
    }

    else{
        _bigVw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _bigVw.backgroundColor = rgba(115, 115, 115, 0.5);


        _popView= [[UIView alloc]init];//WithFrame:CGRectMake(0, ScreenHeight-485, ScreenWidth, 485)];
        _popView.frame = CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight - 485 , ScreenWidth, 485);
        _popView.backgroundColor = [UIColor colorWithRed:(223.0/255.0) green:(223.0/255.0) blue:(223.0/255.0) alpha:1];
        //    NSLog(@"GAO--%f",_popView.frame.size.height);//485
        //关闭弹窗按钮
        UIButton * guanbiBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-49, 10, 20, 20)];
        [guanbiBt setImage:[UIImage imageNamed:@"筛选关闭（大）"] forState:UIControlStateNormal];
        [guanbiBt addTarget:self action:@selector(pressGuanbiBt) forControlEvents:UIControlEventTouchUpInside];
        //横分割线
        UILabel * linelb3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, 1)];
        linelb3.backgroundColor = [UIColor lightGrayColor];


        _zuobianlanTBVW = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, 72, 420-48) style:UITableViewStylePlain];
        _zuobianlanTBVW.delegate = self;
        _zuobianlanTBVW.dataSource = self;
        //去除多余分割线
        _zuobianlanTBVW.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _zuobianlanTBVW.backgroundColor = rgba(223, 223, 223, 1);



        //



        _youbianlanTBVW_1 = [[UITableView alloc]initWithFrame:CGRectMake(72, 40, ScreenWidth-72, 420-48) style:UITableViewStylePlain];
        _youbianlanTBVW_1.delegate = self;
        _youbianlanTBVW_1.dataSource = self;
        _youbianlanTBVW_1.allowsMultipleSelection = YES;//允许多选
        _youbianlanTBVW_1.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

        _youbianlanTBVW_2 = [[UITableView alloc]initWithFrame:CGRectMake(72, 40, ScreenWidth-72, 420-48) style:UITableViewStylePlain];
        _youbianlanTBVW_2.delegate = self;
        _youbianlanTBVW_2.dataSource = self;
        _youbianlanTBVW_2.allowsMultipleSelection = YES;//允许多选
        _youbianlanTBVW_2.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

        _youbianlanTBVW_3= [[UITableView alloc]initWithFrame:CGRectMake(72, 40, ScreenWidth-72, 420-48-40) style:UITableViewStylePlain];
        _youbianlanTBVW_3.delegate = self;
        _youbianlanTBVW_3.dataSource = self;
        _youbianlanTBVW_3.allowsMultipleSelection = YES;//允许多选
        _youbianlanTBVW_3.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

        _youbianlanTBVW_4= [[UITableView alloc]initWithFrame:CGRectMake(72, 40, ScreenWidth-72, 420-48-40) style:UITableViewStylePlain];
        _youbianlanTBVW_4.delegate = self;
        _youbianlanTBVW_4.dataSource = self;
        _youbianlanTBVW_4.allowsMultipleSelection = YES;//允许多选
        _youbianlanTBVW_4.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];




        //分割线
        UILabel * line3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 485 - 48-65, ScreenWidth, 1)];
        line3.backgroundColor = [UIColor lightGrayColor];
        //删除全部按钮
        UIButton * qingchuBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 485 - 48-64, ScreenWidth /2, 48)];
        [qingchuBt addTarget:self action:@selector(pressQingchuBt) forControlEvents:UIControlEventTouchUpInside];
        qingchuBt.backgroundColor = [UIColor whiteColor];
        [qingchuBt setTitle:@"清除全部" forState:UIControlStateNormal];
        [qingchuBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];






        //完成按钮232 86 35 rgb
        UIButton * wanchengBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth /2, 485 - 48-64, ScreenWidth /2, 48)];
        [wanchengBt addTarget:self action:@selector(pressWanchengBt) forControlEvents:UIControlEventTouchUpInside];
        wanchengBt.backgroundColor = rgba(232, 86, 35, 1);
        [wanchengBt setTitle:@"完成" forState:UIControlStateNormal];


        [_popView addSubview: _zuobianlanTBVW];

        //默认选择第一个
        NSIndexPath * selIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        [_zuobianlanTBVW selectRowAtIndexPath:selIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
        NSIndexPath * path = [NSIndexPath indexPathForItem:0 inSection:0];
        [self tableView:_zuobianlanTBVW didSelectRowAtIndexPath:path];


        [_popView addSubview: _youbianlanTBVW_1];
        [_popView addSubview: _youbianlanTBVW_2];
        [_popView addSubview: _youbianlanTBVW_3];
        [_popView addSubview: _youbianlanTBVW_4];

        _youbianlanTBVW_1.hidden = NO;
        _youbianlanTBVW_2.hidden = YES;
        _youbianlanTBVW_3.hidden = YES;
        _youbianlanTBVW_4.hidden = YES;




        [_popView addSubview:guanbiBt];
        [_popView addSubview:linelb3];
        [_popView addSubview:line3];
        [_popView addSubview:qingchuBt];
        [_popView addSubview:wanchengBt];

        [_bigVw addSubview:_popView];
        [self.view addSubview:_bigVw];
    }
}

#pragma mark - 关闭弹窗
-(void)pressGuanbiBt{
    [_popView removeFromSuperview];
    [_bigVw removeFromSuperview];
    //    _popView.hidden = YES;
    //    _bigVw.hidden = YES;

}

#pragma mark -  清除按钮
-(void)pressQingchuBt{
    _shaixuantiaojian =0;
    NSArray * ary = [_youbianlanTBVW_1 indexPathsForRowsInRect:CGRectMake(0, 0, _youbianlanTBVW_1.size.width, 10000)];
    for (NSIndexPath * abc in ary) {
        VLX_youbianlanTableViewCell * cell = [_youbianlanTBVW_1 cellForRowAtIndexPath:abc];
        cell.selected = NO;
        cell.selectBt.selected = NO;
        cell.youbianlanname.textColor =[UIColor blackColor];
    }

    NSArray * ary2 = [_youbianlanTBVW_2 indexPathsForRowsInRect:CGRectMake(0, 0, _youbianlanTBVW_2.size.width, 1000)];
    for (NSIndexPath * abc in ary2) {
        VLX_youbianlanTableViewCell * cell = [_youbianlanTBVW_2 cellForRowAtIndexPath:abc];
        cell.selected = NO;
        cell.selectBt.selected = NO;
        cell.youbianlanname.textColor =[UIColor blackColor];
    }
    NSArray * ary3 = [_youbianlanTBVW_3 indexPathsForRowsInRect:CGRectMake(0, 0, _youbianlanTBVW_3.size.width, 1000)];
    for (NSIndexPath * abc in ary3) {
        VLX_youbianlanTableViewCell * cell = [_youbianlanTBVW_3 cellForRowAtIndexPath:abc];
        cell.selected = NO;
        cell.selectBt.selected = NO;
        cell.youbianlanname.textColor =[UIColor blackColor];
    }
    NSArray * ary4 = [_youbianlanTBVW_4 indexPathsForRowsInRect:CGRectMake(0, 0, _youbianlanTBVW_4.size.width, 1000)];
    for (NSIndexPath * abc in ary4) {
        VLX_youbianlanTableViewCell * cell = [_youbianlanTBVW_4 cellForRowAtIndexPath:abc];
        cell.selected = NO;
        cell.selectBt.selected = NO;
        cell.youbianlanname.textColor =[UIColor blackColor];
    }



    [_mainDataArr removeAllObjects];




    A0000A=@"";
    B6666B=@"";
    C1212C=@"";
    D2424D=@"";
    [selectHangCompanyNameCodeAry removeAllObjects];
    [qifeiAry removeAllObjects];
    [jiangluosAry removeAllObjects];

    [SVProgressHUD showWithStatus:@"正在加载参考票价"];

    [self loadMainData];
    sleep(0.5f);
    [_popView removeFromSuperview];
    [_bigVw removeFromSuperview];
    [SVProgressHUD dismiss];

}


#pragma mark -  完成按钮
-(void)pressWanchengBt
{
    _shaixuantiaojian = 1;//有条件
    [self loadShaixuanData];//请求筛选条件数据
}
//请求筛选条件数据
-(void)loadShaixuanData{

    [SVProgressHUD showWithStatus:@"正在加载参考票价"];
    [_mainDataArr removeAllObjects];//在这里只移除一个,剩下的在请求里边移除
    //    NSString * str000 = stopStr;


    str111 = [[NSString alloc]init];
    if ([A0000A isEqualToString:@""] && [B6666B isEqualToString:@""] && [C1212C isEqualToString:@""] &&[D2424D isEqualToString:@""]) {
        str111 = @"";
    }else
    {
        str111 = [NSString stringWithFormat:@"%@%@%@%@",A0000A,B6666B,C1212C,D2424D];
        //        NSLog(@"时间段:%@",str111);
    }

    str222 = [[NSString alloc]init];
    NSMutableArray * array2 = [NSMutableArray array];
    for(int i=0;i<selectHangCompanyNameCodeAry.count;i++){
        NSString * stringgg = selectHangCompanyNameCodeAry[i];
        NSRange range = [stringgg rangeOfString:@"="];
        stringgg = [stringgg substringFromIndex:range.location+1];
        [array2 addObject:stringgg];
    }
    //    NSLog(@"hangkgsAry:%ld",hangkgsAry.count);
    hangkgsAry = [array2 valueForKeyPath:@"@distinctUnionOfObjects.self"];

    str222 =[hangkgsAry componentsJoinedByString:@","];
    //    NSLog(@"str222:%@",str222);




    str333 = [[NSString alloc]init];
    str333 = [qifeiAry componentsJoinedByString:@","];

    str444 = [[NSString alloc]init];
    str444 = [jiangluosAry componentsJoinedByString:@","];


    //[self loadShaixuanData];//筛选完成之后的价格列表
    NSString * url = [NSString stringWithFormat:@"%@%@",tangyangURL,@"searchFlight"];
    NSMutableDictionary * para = [NSMutableDictionary dictionary];


    para[@"dptCity"] = _area1;
    para[@"arrCity"] = _area2;
    NSString *tihuan0 = [_bookDateStr stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    NSString *tihuan1 = [tihuan0 stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    NSString *tihuan2 = [tihuan1 stringByReplacingOccurrencesOfString:@"日" withString:@""];//把日替换成""
    para[@"date"]    = tihuan2;
    para[@"ex_track"]=@"youxuan";//youxuan
    para[@"stop"] = stopStr;
    para[@"dptFlyTime"] = str111;
    para[@"sort"] = @"1";




    if ([str222 isEqualToString:@""]) {
        para[@"airlineName"] = @"";
    }else
    {
        para[@"airlineName"] = str222;
    }

    if ([str333 isEqualToString:@""]) {
        para[@"dptAirpot"] = @"";
    }else{
        para[@"dptAirpot"] = str333;
    }

    if ([str444 isEqualToString:@""]) {
        para[@"arriAirpot"] = @"";
    }else
    {
        para[@"arriAirpot"] = str444;
    }

    NSLog(@"筛选参数%@",para);
    [HMHttpTool get:url params:para success:^(id responseObj) {
        //        NSLog_JSON(@"筛选结果成功%@",responseObj);
        [SVProgressHUD dismiss];
        if ([responseObj[@"status"]  isEqual: @1]  ) {

            NSDictionary * newdic = [NSDictionary dictionary];

            NSDictionary * panduan = [NSDictionary dictionary];
            panduan = responseObj[@"data"];
            if ([panduan[@"result"] isKindOfClass:[NSNull class]]) {
                _jiageTableVw.hidden = YES;
                [SVProgressHUD showErrorWithStatus:@"暂无该航班"];

            }
            else
            {

                newdic = responseObj[@"data"][@"result"][@"flightInfos"];

                //                NSLog_JSON(@"新新新字典的数据%@",newdic);
                NSArray * array = [newdic copy];
                //                NSLog(@"array:%ld",array.count);
                if(array.count == 0){
                    [SVProgressHUD showErrorWithStatus:@"暂无该航班"];
                    _jiageTableVw.hidden = YES;
                }else{
                    _jiageTableVw.hidden = NO;
                    NSDictionary * dic = [[NSDictionary alloc]init];
                    for (dic in array) {
                        VLX_SearchModel * model = [VLX_SearchModel infoListWithDict:dic];
                        [_mainDataArr addObject:model];
                    }

                }

                [_jiageTableVw.mj_header endRefreshing];
                [_jiageTableVw.mj_footer endRefreshing];
                //                [_mainDataArr removeAllObjects];

                [_jiageTableVw reloadData];
                //                [self loadMainData];
            }

        }
        else if([responseObj[@"status"]  isEqual: @0])
        {
            [SVProgressHUD dismiss];
            //        NSLog(@"");
            [SVProgressHUD showErrorWithStatus:@"暂无该航班"];
            _jiageTableVw.hidden = YES;
        }

    } failure:^(NSError *error) {
        //        NSLog(@"筛选结果失败%@",error);
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
        //        [_jiageTableVw removeFromSuperview];

    }];


    sleep(0.2);
    [_popView removeFromSuperview];
    [_bigVw removeFromSuperview];
    //    _popView.hidden = YES;
    //    _bigVw.hidden = YES;

    //    A0000A=@"";
    //    B6666B=@"";
    //    C1212C=@"";
    //    D2424D=@"";
    //    [selectHangCompanyNameCodeAry removeAllObjects];
    //    [hangkgsAry removeAllObjects];
    //    [qifeiAry removeAllObjects];
    //    [jiangluosAry removeAllObjects];

}

#pragma mark -   按时间排序
-(void)pressShijianBt
{
    a += 1;

    _shaixuantiaojian = 2;//有排序
    if(a%2==0)//如果是偶数
    {
        [shijianBt setTitle:@"从晚到早  ∧" forState:UIControlStateNormal];
        [shijianBt setTitleColor:rgba(230, 107, 61, 1) forState:UIControlStateNormal];
        sortStr = @"-1";//倒序
    }
    else
    {
        [shijianBt setTitle:@"从早到晚  ∨" forState:UIControlStateNormal];
        [shijianBt setTitleColor:rgba(230, 107, 61, 1) forState:UIControlStateNormal];
        sortStr = @"1";//正序
    }
    [jiageBt setTitle:@"价格 ∧" forState:UIControlStateNormal];
    [jiageBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    [self loadTimeData];//请求时间排序列表;

}
#pragma mark -   按价格排序
-(void)pressJiageBt
{
    b +=1;
    _shaixuantiaojian = 2;//有排序
    if (b%2 ==0) {
        [jiageBt setTitle:@"价格最高  ∧" forState:UIControlStateNormal];
        [jiageBt setTitleColor:rgba(230, 107, 61, 1) forState:UIControlStateNormal];
        sortStr = @"-2";

    }else
    {
        [jiageBt setTitle:@"价格最低  ∨" forState:UIControlStateNormal];
        [jiageBt setTitleColor:rgba(230, 107, 61, 1) forState:UIControlStateNormal];
        sortStr = @"2";
    }

    [shijianBt setTitle:@"时间  ∧" forState:UIControlStateNormal];
    [shijianBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self loadTimeData];//请求价格排序列表
}

-(void)loadTimeData
{
    [_mainDataArr removeAllObjects];//在这里只移除一个,剩下的在请求里边移除

    [SVProgressHUD showWithStatus:@"正在加载参考票价"];

    NSString * url = [NSString stringWithFormat:@"%@%@",tangyangURL,@"searchFlight"];
    NSMutableDictionary * para = [NSMutableDictionary dictionary];


    para[@"dptCity"] = _area1;
    para[@"arrCity"] = _area2;
    NSString *tihuan0 = [_bookDateStr stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    NSString *tihuan1 = [tihuan0 stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    NSString *tihuan2 = [tihuan1 stringByReplacingOccurrencesOfString:@"日" withString:@""];//把日替换成""
    para[@"date"]    = tihuan2;
    para[@"ex_track"]=@"youxuan";
    para[@"stop"] = stopStr;
    para[@"sort"] = sortStr;


    if (_shaixuantiaojian == 0) {
        para[@"dptFlyTime"] = @"";
        para[@"airlineName"] = @"";
        para[@"dptAirpot"] = @"";
        para[@"arriAirpot"] = @"";
    }else{
        para[@"dptFlyTime"] = str111;
        para[@"airlineName"] = str222;
        para[@"dptAirpot"] = str333;
        para[@"arriAirpot"] = str444;
    }




    //    NSLog(@"时间排序参数是:%@",para);

    [HMHttpTool get:url params:para success:^(id responseObj) {
        //        NSLog_JSON(@"排序结果成功%@",responseObj);
        //        [SVProgressHUD dismiss];
        if ([responseObj[@"status"]  isEqual: @1]  ) {

            NSDictionary * newdic = [NSDictionary dictionary];

            NSDictionary * panduan = [NSDictionary dictionary];
            panduan = responseObj[@"data"];
            if ([panduan[@"result"] isKindOfClass:[NSNull class]]) {//为空 = "<null>";
                //                NSLog(@"不可以");
                _jiageTableVw.hidden = YES;
                [SVProgressHUD showErrorWithStatus:@"暂无该航班"];

            }
            else
            {

                newdic = responseObj[@"data"][@"result"][@"flightInfos"];
                for (NSDictionary  * dic in newdic) {
                    VLX_SearchModel * model = [VLX_SearchModel infoListWithDict:dic];

                    [_mainDataArr addObject:model];

                }
                _jiageTableVw.hidden = NO;
                [_jiageTableVw.mj_header endRefreshing];
                [_jiageTableVw.mj_footer endRefreshing];

                [_jiageTableVw reloadData];
            }

        }
        else if([responseObj[@"status"]  isEqual: @0])
        {
            _jiageTableVw.hidden = YES;
            [SVProgressHUD showErrorWithStatus:@"暂无该航班"];
        }

        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        //        NSLog(@"筛选结果失败%@",error);
        [SVProgressHUD dismiss];
    }];
}







#pragma mark - 的代理方法
//头高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(_youbianlanTBVW_4 == tableView)
    {
        return 40;
    }
    else return 0.001;
}
//row高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(_jiageTableVw == tableView)
    {
        return 106;//行高
    }
    else if (_zuobianlanTBVW == tableView)
    {
        return 72;
    }
    else
        return  55;

}
//zu
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_youbianlanTBVW_4 ==tableView) {
        return 2;
    }
    else return 1;
}//行数

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(_jiageTableVw == tableView){
        if (_mainDataArr.count) {
            return _mainDataArr.count;
        }else
        {
            return 0;
        }
    }
    else if (_zuobianlanTBVW == tableView)
    {
        return 4;
    }
    else if(_youbianlanTBVW_1 == tableView)
    {
        return 1;
    }
    else if(_youbianlanTBVW_2 == tableView)//选择4个时间段
    {
        return 4;
    }
    else if(_youbianlanTBVW_3 == tableView)//选择航空公司,这个需要数据源
    {
        return _hangCompanyNameCodeAry.count;
    }
    else if(_youbianlanTBVW_4 == tableView)//选择机场,这个需要数据源
    {
        if (section == 0) {
            return _flyAirportAry.count;
        }else if(section == 1){
            return _downAirportAry.count;
        }
    }
    return 0;

}


//自定义的组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(_youbianlanTBVW_4 == tableView)
    {
        if(section == 0){
            UIView * headerVw =[[UIView alloc]initWithFrame:CGRectMake(0, 0, _youbianlanTBVW_4.frame.size.width, 40)];
            UILabel  * lb1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 16)];
            lb1.text = @"起飞机场";
            lb1.textColor = [UIColor lightGrayColor];
            lb1.font = [UIFont systemFontOfSize:15];
            [headerVw addSubview:lb1];
            return headerVw;
        }
        else{
            UIView * headerVw =[[UIView alloc]initWithFrame:CGRectMake(0, 0, _youbianlanTBVW_4.frame.size.width, 40)];
            UILabel  * lb1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 16)];
            lb1.text = @"降落机场";
            lb1.textColor = [UIColor lightGrayColor];
            lb1.font = [UIFont systemFontOfSize:15];
            [headerVw addSubview:lb1];
            return headerVw;
        }
    }
    else return nil;
}
//填充
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_jiageTableVw == tableView)
    {
        static NSString *ID = @"cell";
        VLX_jiageTableViewCell *cell = [_jiageTableVw dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[VLX_jiageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        if (_mainDataArr.count > 0) {
            [cell FillWithModel:_mainDataArr[indexPath.row]];
        }
        return cell;
    }
    else if (_zuobianlanTBVW == tableView)
    {
        static NSString * id1 = @"bcell";
        VLX_zuobianlanTableViewCell * cell = [_zuobianlanTBVW dequeueReusableCellWithIdentifier:id1];
        if (!cell) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell = [[VLX_zuobianlanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
            cell.zuobianlanname.text =titleAry[indexPath.row];
            cell.zuobianlanImgVw.image = [UIImage imageNamed:imgNOary[indexPath.row]];
            cell.zuobianlanImgVw.highlightedImage = [UIImage imageNamed:imgAry[indexPath.row]];
        }
        return cell;
    }
    else if(_youbianlanTBVW_1 == tableView)
    {
        static NSString * id2 = @"c_cell";
        VLX_youbianlanTableViewCell * cell = [_youbianlanTBVW_1 dequeueReusableCellWithIdentifier:id2];
        if (!cell) {
            cell = [[VLX_youbianlanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id2];
            cell.youbianlanname.text = @"直飞";
        }
        return cell;
    }
    else if(_youbianlanTBVW_2 == tableView)
    {
        static NSString * id3 = @"d_cell";
        VLX_youbianlanTableViewCell * cell = [_youbianlanTBVW_2 dequeueReusableCellWithIdentifier:id3];
        if (!cell) {
            cell = [[VLX_youbianlanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id3];
            cell.youbianlanname.text = timeAry[indexPath.row];//12:00-18:00

            if (indexPath.row == 0){
                if ([A0000A isEqualToString:@"1"]) {
                    cell.youbianlanname.textColor =rgba(234, 105,73, 1);
                    cell.selectBt.selected = YES;
                }else{
                    cell.youbianlanname.textColor =[UIColor blackColor];
                    cell.selectBt.selected = NO;
                }
            }else if (indexPath.row == 1){
                if ([B6666B isEqualToString:@"2"]) {
                    cell.youbianlanname.textColor =rgba(234, 105,73, 1);
                    cell.selectBt.selected = YES;

                }else{
                    cell.youbianlanname.textColor =[UIColor blackColor];
                    cell.selectBt.selected = NO;
                }
            }else if (indexPath.row == 2){
                if ([C1212C isEqualToString:@"3"]) {
                    cell.youbianlanname.textColor =rgba(234, 105,73, 1);
                    cell.selectBt.selected = YES;
                }else{
                    cell.youbianlanname.textColor =[UIColor blackColor];
                    cell.selectBt.selected = NO;
                }

            }else if (indexPath.row == 3){
                if ([D2424D isEqualToString:@"4"]) {
                    cell.youbianlanname.textColor =rgba(234, 105,73, 1);
                    cell.selectBt.selected = YES;
                }else{
                    cell.youbianlanname.textColor =[UIColor blackColor];
                    cell.selectBt.selected = NO;
                }
            }
        }
        return cell;
    }
    else if(_youbianlanTBVW_3 == tableView)
    {
        NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
        VLX_youbianlanTableViewCell * cell = [_youbianlanTBVW_3 dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[VLX_youbianlanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.youbianlanname.text = _hangCompanyNameCodeAry[indexPath.row];//string;//
            BOOL xgcs = NO;
            for (NSString * string1 in selectHangCompanyNameCodeAry) {
                if ([[string1 substringFromIndex:string1.length-2] isEqualToString:[cell.youbianlanname.text substringFromIndex:cell.youbianlanname.text.length-2]]) {
                    xgcs = YES;
                }
            }
            if (xgcs == YES) {
                cell.youbianlanname.textColor =rgba(234, 105,73, 1);
                cell.selectBt.selected = YES;
            }else{
                cell.youbianlanname.textColor =[UIColor blackColor];
                cell.selectBt.selected = NO;
            }
        }
        return cell;
    }
    else if(_youbianlanTBVW_4 == tableView)
    {
        static NSString * id5 = @"f_cell";
        VLX_youbianlanTableViewCell * cell = [_youbianlanTBVW_4 dequeueReusableCellWithIdentifier:id5];
        if (!cell) {
            cell = [[VLX_youbianlanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id5];
            if (indexPath.section == 0) {
                cell.youbianlanname.text = _flyAirportAry[indexPath.row];
                BOOL xgcs2 = NO;
                for (NSString * string2 in qifeiAry) {
                    if ([string2  isEqualToString:cell.youbianlanname.text]) {
                        xgcs2 = YES;
                    }
                }//循环外边
                if (xgcs2 == YES) {
                    cell.youbianlanname.textColor =rgba(234, 105,73, 1);
                    cell.selectBt.selected = YES;
                }else{
                    cell.youbianlanname.textColor =[UIColor blackColor];
                    cell.selectBt.selected = NO;
                }
            }else if(indexPath.section == 1){
                cell.youbianlanname.text = _downAirportAry[indexPath.row];
                BOOL xgcs3 = NO;
                for (NSString * string3 in jiangluosAry) {
                    if ([string3  isEqualToString:cell.youbianlanname.text]) {
                        xgcs3 = YES;
                    }
                }
                if (xgcs3 == YES) {
                    cell.youbianlanname.textColor =rgba(234, 105,73, 1);
                    cell.selectBt.selected = YES;
                }else{
                    cell.youbianlanname.textColor =[UIColor blackColor];
                    cell.selectBt.selected = NO;
                }

            }
        }
        return cell;
    }
    return nil;

}
-(void)viewDidAppear:(BOOL)animated
{
    NSInteger selectedIndex = 0;

    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];

    [_youbianlanTBVW_2 selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

    [super viewDidAppear:animated];
}
//选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{

    if (_jiageTableVw == tableView) {
        VLX_yudingTicketViewController * vc = [[VLX_yudingTicketViewController alloc]init];
        VLX_jiageTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        // 选中不变色
        [_jiageTableVw deselectRowAtIndexPath:indexPath animated:NO];
        vc.navStr1 = navLb1.text;
        vc.NavStr2 = navLb2.text;

        //航空公司名称及航班
        vc.name1 = cell.hangbanNameLb.text;//航空公司名称及航班
        vc.date2 = _bookDateStr;//日期
        vc.xingqijiStr = _xingqijiStr;
        vc.sta3 =cell.kaishiTimeLb.text;
        vc.over4 = cell.daodaTimeLb.text;
        vc.total5 = cell.totalTimeLb.text;
        vc.fly7 = cell.qifeiAreaLb.text;
        vc.down8 = cell.daodaAreaLb.text;
        vc.servers9 = cell.planNoLb.text;//飞机型号
        vc.jiage10 = cell.jiageLabel.text;
        vc.hangbanhaoStr = cell.hangbanNameLb_2.text;////航班号,HU7707
        vc.jijianranyoustr= cell.jijian.text;

        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (_zuobianlanTBVW == tableView)
    {
        biaojiInteger_1 = indexPath.row;
        if(biaojiInteger_1 == 0)
        {
            _youbianlanTBVW_1.hidden = NO;
            _youbianlanTBVW_2.hidden = YES;
            _youbianlanTBVW_3.hidden = YES;
            _youbianlanTBVW_4.hidden = YES;
        }
        else if (biaojiInteger_1 == 1)
        {
            _youbianlanTBVW_1.hidden = YES;
            _youbianlanTBVW_2.hidden = NO;
            _youbianlanTBVW_3.hidden = YES;
            _youbianlanTBVW_4.hidden = YES;
        }
        else if (biaojiInteger_1 == 2)
        {
            _youbianlanTBVW_1.hidden = YES;
            _youbianlanTBVW_2.hidden = YES;
            _youbianlanTBVW_3.hidden = NO;
            _youbianlanTBVW_4.hidden = YES;
        }
        else if (biaojiInteger_1 == 3)
        {
            _youbianlanTBVW_1.hidden = YES;
            _youbianlanTBVW_2.hidden = YES;
            _youbianlanTBVW_3.hidden = YES;
            _youbianlanTBVW_4.hidden = NO;
        }
    }
    else if (_youbianlanTBVW_1 == tableView)
    {
        VLX_youbianlanTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectBt.selected = !cell.selectBt.selected;
        stopStr = @"true";
    }
    else if (_youbianlanTBVW_2 == tableView)
    {
        VLX_youbianlanTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        //        cell.selectBt.selected = !cell.selectBt.selected;
        if (indexPath.row==0) {
            if (cell.selectBt.selected) {
                cell.youbianlanname.textColor =[UIColor blackColor];
                cell.selectBt.selected = NO;
                A0000A = @"";
            }else{
                A0000A = @"1";
                cell.youbianlanname.textColor = rgba(234, 105,73, 1);
                cell.selectBt.selected = YES;
            }
        }
        else if (indexPath.row==1) {

            if (cell.selectBt.selected) {
                cell.youbianlanname.textColor =[UIColor blackColor];
                cell.selectBt.selected = NO;
                B6666B = @"";
            }else{
                B6666B = @"2";
                cell.youbianlanname.textColor = rgba(234, 105,73, 1);
                cell.selectBt.selected = YES;
            }
        }else if (indexPath.row==2) {

            if (cell.selectBt.selected) {
                cell.youbianlanname.textColor =[UIColor blackColor];
                cell.selectBt.selected = NO;
                C1212C = @"";
            }else{
                C1212C = @"3";
                cell.youbianlanname.textColor = rgba(234, 105,73, 1);
                cell.selectBt.selected = YES;
            }

        }else if (indexPath.row==3) {

            if (cell.selectBt.selected) {
                cell.youbianlanname.textColor =[UIColor blackColor];
                cell.selectBt.selected = NO;
                D2424D = @"";
            }else{
                D2424D = @"4";
                cell.youbianlanname.textColor = rgba(234, 105,73, 1);
                cell.selectBt.selected = YES;
            }
        }
    }
    else if (_youbianlanTBVW_3 == tableView)
    {
        VLX_youbianlanTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.selectBt.selected) {
            cell.youbianlanname.textColor =[UIColor blackColor];
            cell.selectBt.selected = NO;
            NSInteger xiabiao = indexPath.row;
            NSLog(@"点击航空公司下标:%ld",(long)xiabiao);
            [selectHangCompanyNameCodeAry removeObject:_hangCompanyNameCodeAry[xiabiao]];
            NSLog(@"点击航空公司个数是多少::%ld",hangkgsAry.count);
        }else{
            cell.youbianlanname.textColor = rgba(234, 105,73, 1);
            cell.selectBt.selected = YES;

            NSInteger xiabiao = indexPath.row;
            //        NSLog(@"点击航空公司下标:%ld",(long)xiabiao);
            [selectHangCompanyNameCodeAry addObject:_hangCompanyNameCodeAry[xiabiao]];
        }
    }
    else if (_youbianlanTBVW_4 == tableView)
    {  VLX_youbianlanTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        //        cell.selectBt.selected = !cell.selectBt.selected;
        if (indexPath.section == 0) {
            NSInteger xiabiao1 = indexPath.row;
            if (cell.selectBt.selected) {
                cell.youbianlanname.textColor =[UIColor blackColor];
                cell.selectBt.selected = NO;
                [qifeiAry removeObject:_flyAirportAry[xiabiao1]];
            }
            else{
                cell.youbianlanname.textColor =rgba(234, 105,73, 1);
                cell.selectBt.selected = YES;
                [qifeiAry addObject:_flyAirportAry[xiabiao1]];
            }
        }
        else if (indexPath.section == 1) {
            NSInteger xiabiao2 = indexPath.row;

            if (cell.selectBt.selected) {
                cell.youbianlanname.textColor =[UIColor blackColor];
                cell.selectBt.selected = NO;
                [jiangluosAry removeObject:_downAirportAry[xiabiao2]];
            }
            else{
                cell.youbianlanname.textColor =rgba(234, 105,73, 1);
                cell.selectBt.selected = YES;
                [jiangluosAry addObject:_downAirportAry[xiabiao2]];
            }
        }
    }
}

//取消选中
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (_youbianlanTBVW_1 == tableView)
    {
        VLX_youbianlanTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectBt.selected = !cell.selectBt.selected;

        stopStr = @"false";
    }
    else if (_youbianlanTBVW_2 == tableView)
    {
        VLX_youbianlanTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        //        cell.selectBt.selected = !cell.selectBt.selected;

        if (indexPath.row==0) {
            if (cell.selectBt.selected) {
                cell.youbianlanname.textColor =[UIColor blackColor];
                cell.selectBt.selected = NO;
                A0000A = @"";
            }
            else{
                cell.youbianlanname.textColor =rgba(234, 105,73, 1);
                cell.selectBt.selected = YES;
                A0000A = @"1";
            }

        }else if (indexPath.row==1) {
            if (cell.selectBt.selected) {
                cell.youbianlanname.textColor =[UIColor blackColor];
                cell.selectBt.selected = NO;
                B6666B = @"";
            }
            else{
                cell.youbianlanname.textColor =rgba(234, 105,73, 1);
                cell.selectBt.selected = YES;
                B6666B = @"2";
            }
        }else if (indexPath.row==2) {
            if (cell.selectBt.selected) {
                cell.youbianlanname.textColor =[UIColor blackColor];
                cell.selectBt.selected = NO;
                C1212C = @"";
            }
            else{
                cell.youbianlanname.textColor =rgba(234, 105,73, 1);
                cell.selectBt.selected = YES;
                C1212C = @"3";
            }
        }else if (indexPath.row==3) {

            if (cell.selectBt.selected) {
                cell.youbianlanname.textColor =[UIColor blackColor];
                cell.selectBt.selected = NO;
                D2424D = @"";
            }
            else{
                cell.youbianlanname.textColor =rgba(234, 105,73, 1);
                cell.selectBt.selected = YES;
                D2424D = @"4";
            }
        }
    }
    else if (_youbianlanTBVW_3 == tableView)
    {
        VLX_youbianlanTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.selectBt.selected) {
            cell.youbianlanname.textColor =[UIColor blackColor];
            cell.selectBt.selected = NO;

            NSInteger xiabiao = indexPath.row;
            NSLog(@"点击航空公司下标:%ld",(long)xiabiao);
            [selectHangCompanyNameCodeAry removeObject:_hangCompanyNameCodeAry[xiabiao]];
            NSLog(@"点击航空公司个数是多少::%ld",hangkgsAry.count);

        }else{
            cell.youbianlanname.textColor = rgba(234, 105,73, 1);
            cell.selectBt.selected = YES;
        }

    }
    else if (_youbianlanTBVW_4 == tableView)
    {
        VLX_youbianlanTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        //        cell.selectBt.selected = !cell.selectBt.selected;
        if (indexPath.section == 0) {
            NSInteger xiabiao1 = indexPath.row;
            if (cell.selectBt.selected) {
                cell.youbianlanname.textColor =[UIColor blackColor];
                cell.selectBt.selected = NO;
                [qifeiAry removeObject:_flyAirportAry[xiabiao1]];
            }
            else{
                cell.youbianlanname.textColor = rgba(234, 105,73, 1);
                cell.selectBt.selected = YES;
            }

        }
        else if (indexPath.section == 1) {
            NSInteger xiabiao2 = indexPath.row;

            if (cell.selectBt.selected) {
                cell.youbianlanname.textColor =[UIColor blackColor];
                cell.selectBt.selected = NO;
                [jiangluosAry removeObject:_downAirportAry[xiabiao2]];
            }
            else{
                cell.youbianlanname.textColor = rgba(234, 105,73, 1);
                cell.selectBt.selected = YES;
            }

        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)ButOONTouch:(UIButton * )btn :(NSInteger)integer{
    if (btn.selected)
    {//改变颜色
        [btn setImage:[UIImage imageNamed:@"选择后"] forState:UIControlStateSelected];
    }else
    {//变成原来的颜色
        [btn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
    }
}

@end


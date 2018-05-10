
//
//  VLX_gaiqianChooseVC.m
//  Vlvxing
//
//  Created by grm on 2017/11/21.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_gaiqianChooseVC.h"
#import "VLX_riliCollectionViewCell.h"

#import "VLX_gaiqianChooseTBVWCell.h"//仿照价格列表
#import "VLX_gaiqianChooseModel.h"//


#import "VLX_gaiqianDoneViewController.h"//改签确认并支付

@interface VLX_gaiqianChooseVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>
{
    NSString * book_nian;//预定年
    NSString * book_yue;//预定月
    NSString * book_ri;//预定ri
    
    NSString * location_nian;//当前年
    NSString * location_yue;//当前月
    NSString * location_ri;//当前日
    NSInteger xuanzhongxiabiao;//选中下标
    NSString * biaojiRiliStr;//用于标记是哪个..
    
    NSMutableArray * _mainDataArr;
    NSMutableArray * _mainDataArr_1;
    NSMutableArray * _mainDataArr_2;
    NSMutableArray * _mainDataArr_3;
    NSMutableArray * _mainDataArr_4;
    NSMutableArray * _mainDataArr_5;
    NSMutableArray * _mainDataArr_6;//乘客数组!
    NSMutableArray * array4;
    NSMutableArray * array5;
    
    
    NSArray * bopiArray;//层层拨皮

}

@property (nonatomic,strong)UITableView * jiageTableVw2;//价格列表
@property (nonatomic,strong)UICollectionView * riliCollectionVw2;//横横向日历

@property (nonatomic,strong)NSMutableArray * dates;//年月日期数据
@property (nonatomic,strong)NSMutableArray * xingqi;//每天是星期几

@property (nonatomic,strong) NSMutableArray * passengeridArray_1;//真实的id

@end

@implementation VLX_gaiqianChooseVC
//
//-(void)viewWillAppear:(BOOL)animated{
//    [SVProgressHUD dismiss];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

    
    self.title = [NSString stringWithFormat:@"%@ - %@",_nav_title1,_nav_title2];
    
    self.automaticallyAdjustsScrollViewInsets = NO;//防止frame乱搞
    
    
    _mainDataArr = [NSMutableArray array];
    _mainDataArr_1 = [NSMutableArray array];
    _mainDataArr_2 = [NSMutableArray array];
    _mainDataArr_3 = [NSMutableArray array];
    _mainDataArr_4 = [NSMutableArray array];
    _mainDataArr_5 = [NSMutableArray array];
    _mainDataArr_6 = [NSMutableArray array];//乘客数组
    array4 =[[NSMutableArray alloc]init];
    array5 =[[NSMutableArray alloc]init];//主列表
    
    _passengeridArray_1 = [NSMutableArray array];

    bopiArray = [NSArray array];
    
    [self riliData2];//日历数据
    [self hengxiangrili2];//横向日历
    [self tableVw2];


}
-(void)tapLeftButton2{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 主数据
-(void)loadMainData2
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSString * url = [NSString stringWithFormat:@"%@%@",tangyangURL,@"changeSearch"];//改签查询
    NSMutableDictionary * para = [NSMutableDictionary dictionary];

    para[@"orderNo"]=_orderno;
    para[@"changeDate"]=_flyDatesStr2;
    NSLog(@"查询的参数%@",para);


// 要注释掉
//    para[@"orderNo"]=@"gef180226135046026";//
//    para[@"changeDate"]=@"2018-03-24";//_flyDatesStr2;
//    NSLog(@"查询的参数%@",para);//为了查询张春丽那张改签票
//
    [HMHttpTool post:url params:para success:^(id responseObj) {
        [SVProgressHUD dismiss];
        NSLog_JSON(@"改签查询OK:%@",responseObj);
        if ([responseObj[@"status"]  isEqual: @1] ) {
            NSMutableDictionary * newdic = [NSMutableDictionary dictionary];
            newdic = responseObj[@"data"][@"result"];
            NSDictionary * dict1 = [[NSDictionary alloc]init];
            NSDictionary * dict2 = [[NSDictionary alloc]init];
            NSDictionary * dict3 = [[NSDictionary alloc]init];
            NSDictionary * dict4 = [[NSDictionary alloc]init];
            
            
            NSArray* arr1= [newdic copy]; //可变字典变为不可变数组
            
            for(dict1 in arr1){
                if (![dict1[@"changeSearchResult"][@"tgqReasons"]isKindOfClass:[NSNull class]]) {
                    for(dict2 in dict1[@"changeSearchResult"][@"tgqReasons"]){
                        if(array4){
                            [array4 removeAllObjects];
                        }
                        [array4 addObject:dict2[@"changeFlightSegmentList"]];
                    }
//                    NSLog(@"------%@",array4[0]);
                    if ([array4[0] isKindOfClass:[NSNull class]]) {

                        [SVProgressHUD showInfoWithStatus:@"当前没有可改签航班"];
                        
                    }else{
                        for (dict3 in array4[0]) {//目前暂定是取第一个元素,后边的元素不管,
                            [array5 addObject:dict3];
                            

                        }
                    }

                    [_jiageTableVw2 reloadData];
 
                }
                else{
                    
                    
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"获取改签信息失败" message:nil delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil];
                    alert.tag = 2;
                    [alert show];
                }
            }
            
            for (NSDictionary * dic6 in arr1) {
//                NSLog(@"乘客id1:%@", dic6[@"id"]);
                [_passengeridArray_1 addObject:dic6[@"id"]];
//                NSLog(@"乘客id2:%@",_passengeridArray_1[0]);
            }
            
            //获取乘客列表数据
            for (dict4 in arr1) {
                [_mainDataArr_6 addObject: dict4[@"changeSearchResult"][@"contactInfo"]];
            }
        }
        else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"获取改签信息失败" message:nil delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil];
            alert.tag = 1;
            [alert show];
        }
        
        
    } failure:^(NSError *error) {
//        NSLog_JSON(@"改签查询Fail:%@",error);
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"您的网络网络好像有问题" message:nil delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil];
        alert.tag = 0;
        [alert show];
        [SVProgressHUD dismiss];

        
    }];
    
    
    
}
-(void)riliData2
{

    _dates= [NSMutableArray array];
    _xingqi = [NSMutableArray array];
    
    NSDate *currentDate = [NSDate date];
    //用于向下传递当天的具体年-月-日 例:2017-12-30
    NSDateFormatter * dateformatter1=[[NSDateFormatter alloc] init];
    [dateformatter1 setDateFormat:@"YYYY年MM月dd日"];
    _locationStr2 = [dateformatter1 stringFromDate:currentDate];
    
    
    
    //订票时间
    NSString *tihuan0 = [_flyDatesStr2 stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    NSString *tihuan2 = [tihuan0 stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    //当前时间
    NSString *tihuan3 = [_locationStr2 stringByReplacingOccurrencesOfString:@"年" withString:@"/"];
    NSString *tihuan4 = [tihuan3 stringByReplacingOccurrencesOfString:@"月" withString:@"/"];
    NSString *tihuan5 = [tihuan4 stringByReplacingOccurrencesOfString:@"日" withString:@""];
    
//    NSLog(@"将用户的起飞日期 替换之后%@~%@",tihuan2,tihuan5);

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
        [self loadMainData2];

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
        if ([book_nian intValue]==[location_nian intValue] && [book_yue intValue]==[location_yue intValue] && [book_ri intValue]>[location_ri intValue]) {
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
            
            [self loadMainData2];

        }
        //同年不同月
        else if ([book_nian intValue]==[location_nian intValue] &&[book_yue isEqualToString:location_yue]==NO)
        {
            //写个方法
            [self youduoshaotian :location_yue :book_yue];
            [self loadMainData2];

        }
        //不同年
        else if ([book_nian isEqualToString:location_nian]==NO)
        {
            [self youduoshaotian_kuanian :location_yue :book_yue];
            [self loadMainData2];

        }
        else if ([book_nian intValue]<[location_nian intValue] || [book_yue intValue]<[location_yue intValue] || [book_ri intValue]<[location_ri intValue]){
            
//            UIAlertView * altvw = [[UIAlertView alloc]init];
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"订单已经过期" message:nil delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil];
            alert.tag = 0;
            [alert show];
            
        }
        
        
    }

    

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"该订单已经过期:%ld",(long)buttonIndex);ok
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark 同
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
#pragma mark跨年
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
        NSString *showOldDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeTotal+ nowTime%dayTime]];
        NSString * aa = [showOldDate substringToIndex:5];//截取前五位作为日期,第5位之前(不包含)的所有字符串
        [_dates addObject:aa];
        NSString * bb = [showOldDate substringFromIndex:6];//从第六位开始往后截取,第6位之后(包含)的所有字符串
        
        [_xingqi addObject:bb];
        timeTotal += dayTime;
    }
    
    xuanzhongxiabiao =[_dates indexOfObject:_dates[tianshu1]] ;
    
}


-(void)hengxiangrili2{
    //此处必须要有创见一个UICollectionViewFlowLayout的对象
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //同一行相邻两个cell的最小间距
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//横向滚动
    layout.minimumInteritemSpacing = 0;
    //最小两行之间的间距
    layout.minimumLineSpacing = 0;
    
    _riliCollectionVw2 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 75)collectionViewLayout:layout];
    _riliCollectionVw2.delegate = self;
    _riliCollectionVw2.dataSource = self;
    _riliCollectionVw2.backgroundColor = [UIColor whiteColor];
    
    //这种是自定义cell的注册
    [_riliCollectionVw2 registerClass:[VLX_riliCollectionViewCell class] forCellWithReuseIdentifier:@"myheheIdentifier"];
    if (xuanzhongxiabiao == 3 || xuanzhongxiabiao > 3) {//从第三天开始才有居中效果
        [_riliCollectionVw2 setContentOffset:CGPointMake(ScreenWidth/5 * (xuanzhongxiabiao - 2), 0)];
    }
    //    NSLog(@"日历下标%ld",xuanzhongxiabiao);
    
    //这是头部与脚部的注册
    [_riliCollectionVw2 registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
    
    
    
    [self.view addSubview:_riliCollectionVw2];

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

//
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    VLX_riliCollectionViewCell * cell1 =(id) [_riliCollectionVw2 cellForItemAtIndexPath:indexPath];
    cell1 = cell;
    
    if ([_flyDatesStr2 isEqualToString:_locationStr2] && indexPath.row == 0) {//如果是同一天
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
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    VLX_riliCollectionViewCell *cell = [_riliCollectionVw2 dequeueReusableCellWithReuseIdentifier:@"myheheIdentifier" forIndexPath:indexPath];
    
    
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
        UICollectionReusableView *headerView = [_riliCollectionVw2 dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionViewHeader" forIndexPath:indexPath];
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
    
    return CGSizeMake(ScreenWidth/5, 60);
}
//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    biaojiRiliStr = @"b";//
    
    NSArray * ary = [collectionView indexPathsForVisibleItems];//视图里边所有可视的
    
    //    NSLog(@"视图里边所有可视的%lu",(unsigned long)ary.count);//5个
    for (NSIndexPath * abc in ary) {
        
        VLX_riliCollectionViewCell * cell =(id) [_riliCollectionVw2 cellForItemAtIndexPath:abc];
        cell.backgroundColor = rgba(230, 107, 61, 1);
        cell.dateLb.textColor = [UIColor whiteColor];
        cell.xingqiLb.textColor =[UIColor whiteColor];
        cell.jiageLb.textColor =[UIColor whiteColor];
        
    }
    VLX_riliCollectionViewCell * cell =(id) [_riliCollectionVw2 cellForItemAtIndexPath:indexPath];
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
    _flyDatesStr2 = [formatter stringFromDate: date];
    NSLog(@"横向日历天数%ld",(long)xuanzhongxiabiao);
    
    
    _xingqijiStr = cell.xingqiLb.text;//向下传递周几
    
    [_jiageTableVw2 removeFromSuperview];
    
    [_mainDataArr_6 removeAllObjects];//为了传递数组时候,越来越多
    
    [array5 removeAllObjects];//在这里只移除一个,剩下的在请求里边移除
    [self loadMainData2];
    [self tableVw2];
    
    
    //cell被电击后移动的动画
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionTop];
}

//丝滑! 滑动适当距离
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    CGPoint originalTargetContentOffset = CGPointMake(targetContentOffset->x, targetContentOffset->y);
    CGPoint targetCenter = CGPointMake(originalTargetContentOffset.x + CGRectGetWidth(_riliCollectionVw2.bounds)/2, CGRectGetHeight(_riliCollectionVw2.bounds) / 2);
    NSIndexPath *indexPath = nil;
    NSInteger i = 0;
    
    while (indexPath == nil) {
        targetCenter = CGPointMake(originalTargetContentOffset.x + CGRectGetWidth(_riliCollectionVw2.bounds)/2 + 10*i, CGRectGetHeight(_riliCollectionVw2.bounds) / 2);
        indexPath = [_riliCollectionVw2 indexPathForItemAtPoint:targetCenter];
        i++;
    }
    
    
    //这里用attributes比用cell要好很多，因为cell可能因为不在屏幕范围内导致cellForItemAtIndexPath返回nil
    UICollectionViewLayoutAttributes *attributes = [_riliCollectionVw2.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
    if (attributes) {
        *targetContentOffset = CGPointMake(attributes.center.x - CGRectGetWidth(_riliCollectionVw2.bounds)/2, originalTargetContentOffset.y);
        
        
    } else {
        NSLog(@"center is %@; indexPath is {%@, %@}; cell is %@",NSStringFromCGPoint(targetCenter), @(indexPath.section), @(indexPath.item), attributes);
    }
    
    
    
}


-(void)tableVw2{
//    _jiageTableVw2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 75, ScreenWidth, ScreenHeight-75-48-16)];//32
    _jiageTableVw2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 75, ScreenWidth, ScreenHeight-75-48-16) style:UITableViewStylePlain];
    _jiageTableVw2.delegate = self;
    _jiageTableVw2.dataSource = self;
    _jiageTableVw2.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _jiageTableVw2.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData1)];
    [self.view addSubview: _jiageTableVw2];

}

-(void)refreshData1
{
    [_mainDataArr_6 removeAllObjects];//清空数据源
    [array5 removeAllObjects];
    [self loadMainData2];
    // 让刷新控件停止刷新（恢复默认的状态）
    [self.jiageTableVw2.mj_header endRefreshing];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_jiageTableVw2 == tableView) {
        return 1;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_jiageTableVw2 == tableView) {
        return array5.count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_jiageTableVw2 == tableView) {
        return  100;
    }
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

   if (_jiageTableVw2 == tableView) {
    
    static NSString *ID = @"cell";
    
    VLX_gaiqianChooseTBVWCell *cell = [_jiageTableVw2 dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[VLX_gaiqianChooseTBVWCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.kaishiTimeLb.text = array5[indexPath.row][@"startTime"];
        
        cell.daodaTimeLb.text = array5[indexPath.row][@"endTime"];
        
        
        cell.allfeeLb.text = [NSString stringWithFormat:@"¥%@",array5[indexPath.row][@"allFee"]];//总价
        cell.qifeiAreaLb.text = array5[indexPath.row][@"startPlace"];
        cell.daodaAreaLb.text = array5[indexPath.row][@"endPlace"];
        cell.hangbanNumberLb.text = array5[indexPath.row][@"flightNo"];//航班号,不展示
        cell.cabinCodeLb.text = array5[indexPath.row][@"cabinCode"];//改签用的,不展示

        cell.planNoLb.text = [NSString stringWithFormat:@"%@ 丨 %@",array5[indexPath.row][@"flight"],array5[indexPath.row][@"flightType"]];//;//飞机类型1
        cell.hangbanNameLb_2.text = array5[indexPath.row][@"flight"];//航空公司,不展示
        cell.gqLabel.text = array5[indexPath.row][@"gqFee"];
//        NSLog(@"???????:%@",array5[indexPath.row][@"gqFee"]);
        cell.upgradeFeelb.text = array5[indexPath.row][@"upgradeFee"];
//        cell.kaishiTimeLb.text = array5[indexPath.row][@"startTime"];
        cell.uniqKeyLb.text = array5[indexPath.row][@"uniqKey"];;
//        NSLog(@"array5[indexPath.row=%@",array5[indexPath.row][@"uniqKey"]);
        //计算时长
        NSString * string1 = cell.kaishiTimeLb.text;
        NSString * string2 = cell.daodaTimeLb.text;
        NSString * string3_h = [string1 substringToIndex:2];
        NSString * string4_h = [string2 substringToIndex:2];
        NSString * string5_m = [string1 substringFromIndex:3];
        NSString * string6_m = [string2 substringFromIndex:3];

//        NSLog(@"%@,%@,%@,%@,",string3_h,string4_h,string5_m,string6_m);

        int h = 0;
        if([string3_h intValue] > [string4_h intValue]){
            h = 24-([string3_h intValue] - [string4_h intValue] );
 
        }else{
           h = [string4_h intValue] - [string3_h intValue];
        }
        int m = 60-([string5_m intValue] - [string6_m intValue]);
        if (h==1) {
        if (m<60) {
            h=0;
        }else{
        }
        }
        
        cell.totalTimeLb.text = @"";//[NSString stringWithFormat:@"%d时%d分",h,m];
        
        
        
//        NSLog(@"nibi:%@",array5[indexPath.row][@"startTime"]);
    }
    return cell;
   }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    VLX_gaiqianChooseTBVWCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [_jiageTableVw2 deselectRowAtIndexPath:indexPath animated:NO];
    
    VLX_gaiqianDoneViewController * vc = [[VLX_gaiqianDoneViewController alloc]init];
    
    vc.date2 = _flyDatesStr2;
    vc.sta3 = cell.kaishiTimeLb.text;
    vc.over4 = cell.daodaTimeLb.text;
    vc.total5 = cell.totalTimeLb.text;
    vc.fly7 = cell.qifeiAreaLb.text;
    vc.down8 = cell.daodaAreaLb.text;
    vc.gqfee = cell.gqLabel.text;//改签价格,不是总价
    vc.upgradeFee = cell.upgradeFeelb.text;//升舱价格
    vc.allfee = cell.allfeeLb.text;//真实总价
    vc.hangbanhaoStr = cell.hangbanNumberLb.text;
    vc.cabinCodeStr = cell.cabinCodeLb.text;
    vc.name1 = cell.hangbanNameLb_2.text;//cell.hangkonggsNameLb2.text;
    vc.uniqKey = cell.uniqKeyLb.text;
    vc.passengeridArray = [NSMutableArray array];
    vc.passengeridArray = _passengeridArray_1;

    vc.chengkeArray = [[NSMutableArray alloc]init];
    
    vc. chengkeArray = _mainDataArr_6;//乘客数组
    
    vc.orderNo = _orderno;
//    NSLog(@"ckshul亮:%ld" ,vc.chengkeArray.count);

    
    vc.xingqijiStr = _xingqijiStr;

    
    [self.navigationController pushViewController:vc animated:YES];

}

@end

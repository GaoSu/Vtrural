//  VLX_myOrderDetailVC_new.m
//  Vlvxing
//
//  Created by grm on 2017/11/10.
//

#import "VLX_myOrderDetailVC_new.h"

#import "VLX_gaiqianViewController.h"

#import "VLX_tuipiaoViewController.h"
#import "VLX_myOrderModel.h"

@interface VLX_myOrderDetailVC_new ()
//////////////////////////////////统一主色调 rgba(230, 87, 36, 1)[

@property (nonatomic,strong)UILabel * nameLb;
@property (nonatomic,strong)UILabel * shenfenzhengLb;
@property (nonatomic,strong)UILabel * PhoneONLb;




@end

@implementation VLX_myOrderDetailVC_new

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton5) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton5)];

    self.title = @"订单详情";
    
    self.view.backgroundColor = rgba(245, 245, 245, 1);

    [self loadData];
//    [self xingqizhuanhuan:_flyDatesStr];
//    [self makeMineUI];


    
}
-(void)tapLeftButton5
{
    [self.navigationController popViewControllerAnimated:YES];
}
//要是从消息列表跳转的就需要请求
-(void)loadData{
    if ([_typeNum isEqual:@3]) {
        NSMutableDictionary * para = [[NSMutableDictionary alloc]init];
        para[@"token"]=[NSString getDefaultToken];
        para[@"orderId"]=[NSString stringWithFormat:@"%@",_orderid];
        NSString * url=[NSString stringWithFormat:@"%@/OrderInfoController/auth/getOrderInfo.html",ftpPath];
        [HMHttpTool post:url params:para success:^(id responseObj) {
            NSLog_JSON(@"详情OK:%@",responseObj);
            _flyCityStr = responseObj[@"data"][@"deptcity"];
            _flyTimeStr = responseObj[@"data"][@"depttime"];
            _flyPortStr = responseObj[@"data"][@"deptairportcity"];
            _flyDatesStr = responseObj[@"data"][@"deptdate"];
            _downportStr= responseObj[@"data"][@"arriairportcity"];
            _downCityStr = responseObj[@"data"][@"arricity"];
            _zongshichang =responseObj[@"data"][@"flighttimes"];
            _downTimeStr = responseObj[@"data"][@"arritime"];
            _hangbanNoStr = responseObj[@"data"][@"flightnum"];
//            _typeStr= responseObj[@"data"][@"flightnum"];
//            _jiageStr = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"nopayamount"]];
            _chengkexinxiAry =[NSMutableArray array];
            for (NSDictionary  * dic in responseObj[@"data"][@"passengers"]) {
//                VLX_myOrderModel * model = [VLX_myOrderModel infoListWithDict:dic];
                [_chengkexinxiAry addObject:dic];
            }
            _orderno =responseObj[@"data"][@"orderno"];
            _orderid = responseObj[@"data"][@"orderid"];
            [self xingqizhuanhuan:_flyDatesStr];
            [self makeMineUI];
        } failure:^(NSError *error) {
            NSLog_JSON(@"Fail:%@",error);
        }];
//        [SPHttpWithYYCache postRequestUrlStr:url withDic:para success:^(NSDictionary *requestDic, NSString *msg) {
//            NSLog_JSON(@"%@",requestDic.mj_JSONString);
//        } failure:^(NSString *errorInfo) {
//            NSLog_JSON(@"Fail:%@",errorInfo);
//        }];

        
    }
    else{

        [self xingqizhuanhuan:_flyDatesStr];
        [self makeMineUI];
    }




}

-(void)makeMineUI{
    //一,vw
    UIScrollView * scrView = [[UIScrollView alloc]init];
    scrView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-59);
    scrView.contentSize = CGSizeMake(0, ScreenHeight+135*(_chengkexinxiAry.count - 1));
    scrView.showsHorizontalScrollIndicator = NO;
    scrView.showsVerticalScrollIndicator = NO;
    //(小一vw)
    UIView * view1  = [[UIView alloc]initWithFrame:CGRectMake(0, 7, ScreenWidth, 159)];
    view1.backgroundColor = [UIColor whiteColor];
    
    UILabel * dateLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 140, 15)];
    dateLb.text = _flyDatesStr;//2017-11-11;
    dateLb.font = [UIFont systemFontOfSize:15];
    
    UILabel * xingqiLb = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 140, 15)];
    xingqiLb.text = _xingqijiStr;//星期三
    xingqiLb.font = [UIFont systemFontOfSize:15];
    
    
    UILabel * area1 = [[UILabel alloc]init];//WithFrame:CGRectMake(110+30+20, 5, 100, 15)];
    area1.text = [NSString stringWithFormat:@"%@ - ",_flyCityStr];//@"北京";
    // 设置Label的字体 HelveticaNeue  Courier
    UIFont *font1 = [UIFont fontWithName:@"Helvetica" size:15.0f];
    area1.font = font1;
    // 根据字体得到NSString的尺寸
    CGSize size1 = [area1.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font1,NSFontAttributeName,nil]];
    // 名字的W
    CGFloat nameW = size1.width;
    area1.frame = CGRectMake(110+30+20,5, nameW,15);
    
    
    
    
    UILabel * area2 = [[UILabel alloc]initWithFrame:CGRectMake(110+30+20+area1.frame.size.width, 5, 100, 15)];
    area2.text = _downCityStr;//上海";
    area2.font = [UIFont systemFontOfSize:15];
    
    UILabel * time1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 60, 20)];
    
    NSString * bb = [_flyTimeStr substringFromIndex:3];//从第位开始往后截取,第6位之后(包含)的所有字符串
    if(_flyTimeStr.length == 5){
        time1.text = _flyTimeStr;
    }else{
        time1.text = bb;//@"20:45";
    }
    time1.font = [UIFont systemFontOfSize:20];
    
    UILabel * time2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-60-10, 50, 60, 20)];
    time2.text = _downTimeStr;//@"22:25";
    time2.textAlignment = NSTextAlignmentRight;
    time2.font = [UIFont systemFontOfSize:20];
    
    UILabel * totaltTime = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, 52, 100, 14)];
    totaltTime.text = _zongshichang;//@"2小时45分钟";
    totaltTime.textColor =[UIColor lightGrayColor];
    totaltTime.textAlignment = NSTextAlignmentCenter;
    totaltTime.font = [UIFont systemFontOfSize:14];
    

    
    UIImageView * imgvw = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, 52+15, 100, 5)];
    imgvw.image = [UIImage imageNamed:@"ios—去往—大grm.psd"];
    
    
    UILabel * jichang1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 88, 60, 14)];
    jichang1.text = _flyPortStr;//@"首都机场";
    jichang1.textColor =rgba(230, 87, 36, 1);
    jichang1.font = [UIFont systemFontOfSize:14];
    
    UILabel * jichang2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-60-10, 88, 60, 14)];
    jichang2.text = _downportStr;//@"新疆机场";
    jichang2.textColor =rgba(230, 87, 36, 1);
    jichang2.textAlignment = NSTextAlignmentRight;
    jichang2.font = [UIFont systemFontOfSize:14];
    
    UILabel * fuwuzhiliangLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 115, ScreenWidth-20, 14)];
    fuwuzhiliangLb.text = _hangbanNoStr;//@"深航UFO007";
    fuwuzhiliangLb.textAlignment = NSTextAlignmentCenter;
    fuwuzhiliangLb.font = [UIFont systemFontOfSize:14];
    
    
    [view1 addSubview:dateLb];
    [view1 addSubview:xingqiLb];
    [view1 addSubview:area1];
    [view1 addSubview:area2];
    [view1 addSubview:time1];
    [view1 addSubview:time2];
    [view1 addSubview:totaltTime];
    [view1 addSubview:imgvw];
    [view1 addSubview:jichang1];
    [view1 addSubview:jichang2];
    [view1 addSubview:fuwuzhiliangLb];
    
    
    
    NSMutableArray * _nameLbArr  = [NSMutableArray array];
    for (int i = 0; i<_chengkexinxiAry.count; i++) {
        UIView * view2  = [[UIView alloc]initWithFrame:CGRectMake(0, 159+7+7 + 87*i, ScreenWidth, 135)];
        view2.backgroundColor = [UIColor whiteColor];
        
        UILabel * chengjirenLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 56, 16)];
        chengjirenLb.text = @"乘机人";
        chengjirenLb.textColor =[UIColor lightGrayColor];
        chengjirenLb.font = [UIFont systemFontOfSize:16];
        
        _nameLb = [[UILabel alloc]initWithFrame:CGRectMake(82, 25, 70, 16)];
        _nameLb.text = _chengkexinxiAry[i][@"name"];
        _nameLb.font = [UIFont systemFontOfSize:16];
        //        NSLog(@"张三吗:%@",stringg);
        
        _shenfenzhengLb = [[UILabel alloc]initWithFrame:CGRectMake(82, 58, 235, 16)];
        NSString * sfz_a = _chengkexinxiAry[i][@"cardno"];
        NSString * sfz_b = [[NSString alloc]init];
        NSRange range_sfz=NSMakeRange (4, 10);//从第4位开始的10位数转换成****
        sfz_b= [sfz_a stringByReplacingCharactersInRange:range_sfz withString:@"****"];
        [_nameLbArr addObject:sfz_b];
        _shenfenzhengLb.text = [NSString stringWithFormat:@"身份证: %@",_nameLbArr[i]];
        _shenfenzhengLb.font = [UIFont systemFontOfSize:16];
        
        UILabel * _line1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 86, ScreenWidth-30, 1)];
        _line1.backgroundColor =rgba(240, 240, 240, 1);
        
        [view2 addSubview:chengjirenLb];
        [view2 addSubview:_nameLb];
        [view2 addSubview:_shenfenzhengLb];
        [view2 addSubview:_line1];
        
        [scrView addSubview:view2];
        
        
    }
    
    UILabel * shoujiLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 18, 76, 16)];
    shoujiLb.text = @"联系手机";
    shoujiLb.textColor =[UIColor lightGrayColor];
    shoujiLb.font = [UIFont systemFontOfSize:16];
    
    UILabel * _line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, ScreenWidth-30, 1)];
    _line2.backgroundColor =rgba(240, 240, 240, 1);
    
    _PhoneONLb = [[UILabel alloc]initWithFrame:CGRectMake(82, 18, 150, 16)];
    
    NSString * No_a =  _Phone_NoStr;
    NSString * No_b = [[NSString alloc]init];
    NSRange rangeNo=NSMakeRange (3, 5);//从第4位开始的10位数转换成****
    No_b= [No_a stringByReplacingCharactersInRange:rangeNo withString:@"****"];
    _PhoneONLb.text = No_b;
    _PhoneONLb.font = [UIFont systemFontOfSize:16];
    
    
    
    
    
    
    
    UIView * buttonVw = [[UIView alloc]initWithFrame:CGRectMake(0, 159+7+5+ 87*_chengkexinxiAry.count, ScreenWidth, 102)];
    buttonVw.backgroundColor = [UIColor whiteColor];
    
    UIButton * chakanBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 55, 59, 110, 17)];
    [chakanBt setTitle:@"查看加密信息" forState:UIControlStateNormal];
    [chakanBt setTitleColor:rgba(230, 87, 36, 1) forState:UIControlStateNormal];//ios—看.png
    chakanBt.backgroundColor = [UIColor whiteColor];
    [chakanBt addTarget:self action:@selector(pressjiamiBt:) forControlEvents:UIControlEventTouchUpInside];
    [chakanBt setFont:[UIFont systemFontOfSize:14]];
    [chakanBt setImage:[UIImage imageNamed:@"ios—看grm"] forState:UIControlStateNormal];
    //左文字  右图片//    顺序上左下右
    //        [chakanBt setTitleEdgeInsets:UIEdgeInsetsMake(0, -chakanBt.imageView.bounds.size.width, 0, chakanBt.imageView.bounds.size.width)];
    //        [chakanBt setImageEdgeInsets:UIEdgeInsetsMake(0, chakanBt.titleLabel.bounds.size.width, 0, -chakanBt.titleLabel.bounds.size.width)];
    //左图片//右文字
    [chakanBt setTitleEdgeInsets:UIEdgeInsetsMake(0, chakanBt.titleLabel.bounds.size.width, 0, chakanBt.titleLabel.bounds.size.width-20)];
    [chakanBt setImageEdgeInsets:UIEdgeInsetsMake(0, -chakanBt.imageView.bounds.size.width+15, 0, chakanBt.imageView.bounds.size.width)];
    
    
    [buttonVw addSubview:chakanBt];
    [buttonVw addSubview:_line2];
    [buttonVw addSubview:shoujiLb];
    [buttonVw addSubview:_PhoneONLb];
    
    
    //(小三vw)
    UIView * view3  = [[UIView alloc]initWithFrame:CGRectMake(0, 159+7+7+188+7, ScreenWidth, 64)];
    view3.backgroundColor = [UIColor whiteColor];
    
    UIImageView * imgvw2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 18, 27, 27)];
    imgvw2.image = [UIImage imageNamed:@"ios—车—"];
    
    UILabel * jianjieLb2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, ScreenWidth-68, 16)];
    jianjieLb2.text = @"豪车接送,VIP服务,一价全含";
    jianjieLb2.textColor =[UIColor lightGrayColor];
    jianjieLb2.font = [UIFont systemFontOfSize:16];
    
    UIImageView * imgvw3 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-25, 18, 13, 13)];
    imgvw3.image = [UIImage imageNamed:@"ios—前往"];
    
    [view3 addSubview:imgvw2];
    [view3 addSubview:jianjieLb2];
    [view3 addSubview:imgvw3];
    
    
    
    [scrView addSubview:view1];
    //[scrView addSubview:view2];
    [scrView addSubview:buttonVw];
    
    
    
    //二,vw
    UIView * buttomVw = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-59-64, ScreenWidth, 59)];
    buttomVw.frame = CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight -59-64 , ScreenWidth, 59+10);
    buttomVw.backgroundColor = [UIColor whiteColor];
    
    UIButton * gaiqianBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 50)];
    gaiqianBt.backgroundColor = [UIColor whiteColor];
    [gaiqianBt addTarget:self action:@selector(pressgaiqianBt) forControlEvents:UIControlEventTouchUpInside];
    [gaiqianBt setTitle:@"改签" forState:UIControlStateNormal];
    [gaiqianBt setTitleColor:rgba(230, 87, 36, 1) forState:UIControlStateNormal];
    [gaiqianBt setFont:[UIFont systemFontOfSize:13]];
    [gaiqianBt setImage:[UIImage imageNamed:@"ios—改签—大@3x"] forState:UIControlStateNormal];
    //按钮图片文字上下:
    gaiqianBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [gaiqianBt setTitleEdgeInsets:UIEdgeInsetsMake(gaiqianBt.imageView.frame.size.height+10 ,-gaiqianBt.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [gaiqianBt setImageEdgeInsets:UIEdgeInsetsMake(-10, 0.0,0.0, -gaiqianBt.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    
    
    
    UIButton * tuipiaoBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 50)];
    tuipiaoBt.backgroundColor = [UIColor whiteColor];
    [tuipiaoBt addTarget:self action:@selector(presstuipiaoBt) forControlEvents:UIControlEventTouchUpInside];
    [tuipiaoBt setTitle:@"退票" forState:UIControlStateNormal];
    [tuipiaoBt setTitleColor:rgba(230, 87, 36, 1) forState:UIControlStateNormal];
    [tuipiaoBt setFont:[UIFont systemFontOfSize:13]];
    [tuipiaoBt setImage:[UIImage imageNamed:@"ios—退票—大@3x.png"] forState:UIControlStateNormal];//这个图没有经过打包,所以必须要改名字xingwuy@3x,不然会造成图片太大无法控制
    //按钮图片文字上下:
    tuipiaoBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [tuipiaoBt setTitleEdgeInsets:UIEdgeInsetsMake(tuipiaoBt.imageView.frame.size.height+10 ,-tuipiaoBt.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [tuipiaoBt setImageEdgeInsets:UIEdgeInsetsMake(-10, 0.0,0.0, -tuipiaoBt.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    
    [buttomVw addSubview:gaiqianBt];
    [buttomVw addSubview:tuipiaoBt];
    
    
    
    [self.view addSubview:buttomVw];
    [self.view addSubview:scrView];
    
}
#pragma mark 显示隐藏信息
-(void)pressjiamiBt:(UIButton *)btn
{
    btn.selected  = !btn.selected;
    
    if (btn.selected) {
        for (int i = 0; i<_chengkexinxiAry.count; i++) {
            _shenfenzhengLb.text = [NSString stringWithFormat:@"身份证: %@",_chengkexinxiAry[i][@"cardno"]];
        }
        _PhoneONLb.text=_Phone_NoStr;
    }
    else{
        for (int i = 0; i<_chengkexinxiAry.count; i++) {
            
            NSString * sfz_a = _chengkexinxiAry[i][@"cardno"];
            NSString * sfz_b = [[NSString alloc]init];
            NSRange range_sfz=NSMakeRange (4, 10);//从第4位开始的10位数转换成****
            sfz_b= [sfz_a stringByReplacingCharactersInRange:range_sfz withString:@"****"];
            _shenfenzhengLb.text = [NSString stringWithFormat:@"身份证: %@",sfz_b];
        }
        
        NSString * No_a =  _Phone_NoStr;
        NSString * No_b = [[NSString alloc]init];
        NSRange rangeNo=NSMakeRange (3, 5);//从第4位开始的10位数转换成****
        No_b= [No_a stringByReplacingCharactersInRange:rangeNo withString:@"****"];
        _PhoneONLb.text = No_b;
        
    }
    
    
}

#pragma mark 改签
-(void)pressgaiqianBt
{
    VLX_gaiqianViewController * vc = [[VLX_gaiqianViewController alloc]init];
    vc.flyCityStr = _flyCityStr;
    vc.downCityStr = _downCityStr;//降落城市
    vc.flyDatesStr = _flyDatesStr;//起飞日期
    vc.orderno = _orderno;//订单号
    vc.xingqijiStr = _xingqijiStr;
    vc.passengeridArray = [NSMutableArray array];
    vc.passengeridArray = _passengeridArray;
    vc.jiadePassengerid = _jiadePassengerid;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 退票
-(void)presstuipiaoBt
{
    VLX_tuipiaoViewController * vc = [[VLX_tuipiaoViewController alloc]init];
//    vc.NAMEStr1 = _NAMEStr;
    vc.flyCityStr1 = _flyCityStr;
    vc.flyDatesStr1 = _flyDatesStr;
    vc.flyPortStr1 = _flyPortStr;
    if(_flyTimeStr.length == 5){
        vc.flyTimeStr1 = _flyTimeStr;
    }else{
        vc.flyTimeStr1 = [_flyTimeStr substringFromIndex:3];
    }
    vc.downTimeStr1 = _downTimeStr;
    vc.downCityStr1 = _downCityStr;
    vc.downportStr1 = _downportStr;
    vc.zongshichang1 = _zongshichang;
    vc.hangbanNoStr1 = _hangbanNoStr;
    vc.Name_Str1 = _nameLb.text;
    vc.ID_cardNoStr1 = _ID_cardNoStr;
    vc.jiageStr1 = _jiageStr;
    vc.Phone_NoStr1 = _Phone_NoStr;
    vc.orderid1 = _orderid;
    vc.orderno1 = _orderno;
    vc.statusdescStr1 = _statusdescStr;
    vc.xingqijiStr1= _xingqijiStr;
    vc.jiadePassengerid = _jiadePassengerid;
    vc.passengeridArray = [NSMutableArray array];
    vc.passengeridArray = _passengeridArray;


    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)xingqizhuanhuan:(NSString *)str{
    //年
    NSString * nian = [str substringToIndex:4];//截取前五位作为日期,第5位之前(不包含)的所有字符串
    //中转
    NSString * yue_And_ri = [str substringFromIndex:5];
    //月
    NSString * yue = [yue_And_ri substringToIndex:2];//
    //日
    NSString * ri = [yue_And_ri substringFromIndex:3];
    
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:[ri intValue]];
    [_comps setMonth:[yue intValue]];
    [_comps setYear:[nian intValue]];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSWeekdayCalendarUnit fromDate:_date];
    int _weekday = [weekdayComponents weekday];
//    NSLog(@"_weekday::%d",_weekday);//以周日为第一天, 0=星期天,7=星期六
    
    switch (_weekday) {
        case 1:
            //            return @"星期天";
            _xingqijiStr = @"星期天";
            break;
        case 2:
            //            return @"星期一";
            _xingqijiStr = @"星期一";
            break;
        case 3:
            //            return @"星期二";
            _xingqijiStr = @"星期二";
            break;
        case 4:
            //            return @"星期三";
            _xingqijiStr = @"星期三";
            break;
        case 5:
            //            return @"星期四";
            _xingqijiStr = @"星期四";
            break;
        case 6:
            //            return @"星期五";
            _xingqijiStr = @"星期五";
            break;
        case 7:
            //            return @"星期六";
            _xingqijiStr = @"星期六";
            break;
            
        default:
            break;
    }
}




@end





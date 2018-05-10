//
//  VLX_guoqibookingVC.m
//  Vlvxing
//
//  Created by grm on 2017/11/28.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_guoqibookingVC.h"//过期的订单,

@interface VLX_guoqibookingVC ()

@property (nonatomic,strong)UILabel * nameLb;
@property (nonatomic,strong)UILabel * shenfenzhengLb;
@property (nonatomic,strong)UILabel * PhoneONLb;

@end

@implementation VLX_guoqibookingVC

- (void)viewDidLoad {
    [super viewDidLoad];
self.title = @"详情";

//左边按钮
//UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//leftBtn.frame = CGRectMake(0, 0, 20, 20);
//[leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//[leftBtn addTarget:self action:@selector(tapLeftButton6) forControlEvents:UIControlEventTouchUpInside];
//UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton6)];


[self xingqizhuanhuan2:_flyDatesStr];
[self makeMineUI2];


}
-(void)tapLeftButton6
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeMineUI2{
    //一,vw
    UIScrollView * scrView = [[UIScrollView alloc]init];
    scrView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-59-100);
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
    
    NSString * bb = [_flyTimeStr substringFromIndex:3];//从第六位开始往后截取,第6位之后(包含)的所有字符串
    time1.text = bb;//@"20:45";
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
    
    //    UILabel * totaltTime_line = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, 52+15, 100, 1)];
    //    totaltTime_line.backgroundColor =[UIColor lightGrayColor];
    
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
    
    //左图片//右文字
    [chakanBt setTitleEdgeInsets:UIEdgeInsetsMake(0, chakanBt.titleLabel.bounds.size.width, 0, chakanBt.titleLabel.bounds.size.width-20)];
    [chakanBt setImageEdgeInsets:UIEdgeInsetsMake(0, -chakanBt.imageView.bounds.size.width+15, 0, chakanBt.imageView.bounds.size.width)];
    
    
    [buttonVw addSubview:chakanBt];
    [buttonVw addSubview:_line2];
    [buttonVw addSubview:shoujiLb];
    [buttonVw addSubview:_PhoneONLb];
    
    
    
    
    [scrView addSubview:view1];
    //[scrView addSubview:view2];
    [scrView addSubview:buttonVw];
    
    //二,vw
    UIView * buttomVw = [[UIView alloc]init];//WithFrame:CGRectMake(0, ScreenHeight-59-64, ScreenWidth, 59)];
    buttomVw.frame = CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight - 59-64 , K_SCREEN_WIDTH/2, 59);
    buttomVw.backgroundColor = [UIColor whiteColor];
    
    UIButton * zhifuBt1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 8, ScreenWidth-20, 50)];
    zhifuBt1.backgroundColor = [UIColor lightGrayColor];
    [zhifuBt1 addTarget:self action:@selector(tapLeftButton6) forControlEvents:UIControlEventTouchUpInside];
    [zhifuBt1 setTitle:@"返回" forState:UIControlStateNormal];

    

    
    [buttomVw addSubview:zhifuBt1];

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

-(void)xingqizhuanhuan2:(NSString *)str{
    //年
    NSString * nian = [str substringToIndex:4];//截取前五位作为日期,第5位之前(不包含)的所有字符串
    
    //中转
    NSString * yue_And_ri = [str substringFromIndex:5];
    
    //月
    NSString * yue = [yue_And_ri substringToIndex:2];//
    
    //日
    NSString * ri = [yue_And_ri substringFromIndex:3];
    
    
    //    NSLog(@"%@,%@,%@",nian,yue,ri);
    
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
            _xingqijiStr = @"星期天";
            break;
        case 2:
            _xingqijiStr = @"星期一";
            break;
        case 3:
            _xingqijiStr = @"星期二";
            break;
        case 4:
            _xingqijiStr = @"星期三";
            break;
        case 5:
            _xingqijiStr = @"星期四";
            break;
        case 6:
            _xingqijiStr = @"星期五";
            break;
        case 7:
            _xingqijiStr = @"星期六";
            break;
            
        default:
            break;
    }
}




@end

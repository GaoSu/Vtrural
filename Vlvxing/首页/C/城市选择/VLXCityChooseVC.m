//
//  VLXCityChooseVC.m
//  Vlvxing
//诸葛
//  Created by Michael on 17/5/27.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXCityChooseVC.h"
#import "VLXCityChooseModel.h"//城市选择model
#import "NSString+WigthAndHeight.h"//获取首字母
#import "VLXChooseCityCell.h"
@interface VLXCityChooseVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)NSMutableArray * CacheArray;//缓存数组//grm新增

@property(nonatomic,strong)NSMutableArray * normalCityArray;
@property(nonatomic,strong)UILabel * locationLabel;
@property(nonatomic,strong)UILabel * SectionLabel;

/**
 *  索引数据源
 */
@property (nonatomic,strong) NSMutableArray *indexSourceArr;
@property(nonatomic,strong) NSString * dingweiString;

@end

@implementation VLXCityChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据数组
    self.dataArray=[NSMutableArray array];
    self.normalCityArray=[NSMutableArray array];
    self.indexSourceArr=[NSMutableArray array];
    _normalCityArray=[NSMutableArray array];//

    //获取当前位置
    [[CCLocationManager shareLocation] getCity:^(NSString *addressString) {
        self.locationLabel.text=[ZYYCustomTool checkNullWithNSString:addressString];
//        [self getAreaIDWithCity:addressString];
    }];
    //
    [self readVersion];//先读取缓存的版本,有,则和系统版本比较判断,没有则生成系统版本并存储
//    [self readCacheData_0];//主列表缓存数据
    [self createUI];
}
-(void)readVersion{//1.9
    //1,系统版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_nowNO = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //2读取缓存版本号
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * app_cacheNo = [userDefaultes stringForKey:@"app_VersionNo"];//读取字符串类型的数据
    NSLog(@"读取的版本号?%@",app_cacheNo);//1.8([responseObj[@"data"] isKindOfClass:[NSNull class]]) {

    if (app_cacheNo == nil) {//没有则生成系统版本并存储,该情况是用户以前没装过app,或者是老版本,所以不会有缓存数据
        NSLog(@"@@@@@@@@@@@@@@@@");

        //把版本号存起来(第一次下载,或者1.8以前版本)
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSString stringWithFormat:@"%@",app_nowNO] forKey:@"app_VersionNo"];
        [defaults synchronize];//同步到plist文件中
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        //读取数剧
        NSData * mainData = [userDefaultes dataForKey:@"CacheAreaList_0"];//
        if (mainData == nil) {//没装过
            [self readCacheData_0];

        }else{//老版本
            //删除旧的数据,,没有进行过版本存储的旧版本会遇到这个问题
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CacheAreaList_0"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //
            [self readCacheData_0];
            //            [self getNetwork];

        }



    }
    else{//新版本1.9以后//有版本号,读取缓存的版本,和系统版本比较判断

        NSLog(@"APP当前版本:%@",app_nowNO);//只是xcode内部版本,不是上线版本,
        if([app_nowNO floatValue]>[app_cacheNo floatValue]){
            NSLog(@"大于");
            //删除旧的数据
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CacheAreaList_0"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//            //读
//            NSData * mainData = [userDefaultes dataForKey:@"CacheAreaList_0"];
//            if (mainData == nil) {
//                NSLog(@"真的删除了");
//            }
            //把版本号存起来(1.9以后更新)
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"%@",app_nowNO] forKey:@"app_VersionNo"];
            [defaults synchronize];//同步到plist文件中
            //请求最新数据
            [self readCacheData_0];
            //            [self getNetwork];

        }else{
            NSLog(@"不大于");
            [self readCacheData_0];
        }

    }
}


-(void)readCacheData_0{

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数组NSArray类型的数据
    NSData * mainData = [userDefaultes dataForKey:@"CacheAreaList_0"];//arrayForKey:@"CacheAreaList"];
//    NSString * NOber = [userDefaultes stringForKey:@"app_VersionNo"];
//    NSLog(@"1.9版本或者之后:%@",NOber);
    if (mainData == nil) {
        [self getNetwork];
    }else{
        self.normalCityArray = [NSKeyedUnarchiver unarchiveObjectWithData:mainData];
        NSLog(@"aaaa%ld",_dataArray.count);

        self.dataArray =[self sortArray:self.normalCityArray];
        [self.tableview reloadData];
    }


}
-(void)createUI
{
    [self setNav];
    [self createTopView];
    [self.view addSubview:self.tableview];

}
#pragma mark---当前位置id,目前不知
-(void)getAreaIDWithCity:(NSString *)city//根据地区获取areaid
{
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"areaName"]=[ZYYCustomTool checkNullWithNSString:[NSString getCity]];//地区id（这个可以不传）
    NSString * url=[NSString stringWithFormat:@"%@/sysArea/getAreaIdByAreaName.json",ftpPath];
    
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        //        NSLog(@"%@",requestDic.mj_JSONString);
        //将得到的areaid 保存下来
        if ([requestDic[@"status"] integerValue]==1) {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"%@",requestDic[@"data"]] forKey:@"areaID"];
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
        
    } failure:^(NSString *errorInfo) {
        //        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"地区获取失败"];
        
    }];
}
#pragma mark

-(void)createTopView
{
    UIView * topview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];

    topview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topview];
    UILabel * weizhi =[UILabel new];
   weizhi.text=@"当前位置：";
   weizhi.textColor=[UIColor hexStringToColor:@"111111"];
   weizhi.font=[UIFont systemFontOfSize:14];
    [topview addSubview:weizhi];
    [weizhi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topview.mas_centerY);
        make.height.mas_equalTo(14);
        make.left.mas_equalTo(ScaleWidth(12));
    }];


    self.locationLabel=[UILabel new];
//    self.locationLabel.text=[NSString getCity];
    self.locationLabel.textColor=[UIColor hexStringToColor:@"111111"];
    self.locationLabel.font=[UIFont systemFontOfSize:14];
    [topview addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weizhi.mas_right).offset(ScaleWidth(7.5));
         make.centerY.mas_equalTo(topview.mas_centerY);
         make.height.mas_equalTo(14);
    }];

}

-(void)getNetwork//
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSDictionary * dic=@{};
//    NSString * url=[NSString stringWithFormat:@"%@/sysArea/ getTheCity.json",ftpPath];
    NSString * url=[NSString stringWithFormat:@"%@/sysArea/getTheCity.json",ftpPath];

    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
//        MyLog(@"%@",requestDic);
        [SVProgressHUD dismiss];
if([requestDic[@"status"] integerValue]==1)
{
     NSArray * subArray=requestDic[@"data"];

    for (NSDictionary * dic in subArray) {
        VLXCityChooseModel * model =[[VLXCityChooseModel alloc]initWithDictionary:dic error:nil];
        model.areanamewithspell=dic[@"areanamewithspell"];//[dic[@"areaname"] firstCharactor];
        [self.dataArray addObject:model];
//        MyLog(@"%@",model);
        NSMutableDictionary * mutableDic=[NSMutableDictionary dictionaryWithDictionary:dic];
        mutableDic[@"areanamewithspell"]=dic[@"areanamewithspell"];;//[dic[@"areaname"] firstCharactor];
//        MyLog(@"%@",mutableDic);
        [self.normalCityArray addObject:mutableDic];
    }
    self.dataArray =[self sortArray:self.normalCityArray];

    NSData * _miandata = [NSKeyedArchiver archivedDataWithRootObject:self.normalCityArray];//

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_miandata forKey:@"CacheAreaList_0"];
    [defaults synchronize];//同步到plist文件中




//    MyLog(@"%@",self.dataArray);
    [self.tableview reloadData];
}
        else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }

    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
    }];

}


#pragma mark 对元数据进行加工
- (NSMutableArray *)sortArray:(NSMutableArray *)originalArray
{
    NSMutableArray *array = [[NSMutableArray alloc]init];

    //根据拼音对数组排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"areanamewithspell" ascending:YES]];

    //排序
    [originalArray sortUsingDescriptors:sortDescriptors];
//    MyLog(@"%@",originalArray);
    NSMutableArray *tempArray = nil;
    BOOL flag = NO;

    //分组
    for (int i = 0;i < originalArray.count; i++) {
        NSString *pinyin = [originalArray[i] objectForKey:@"areanamewithspell"];
        NSString *firstChar = [pinyin substringToIndex:1];

        if (![_indexSourceArr containsObject:[firstChar uppercaseString]]) {
            [_indexSourceArr addObject:[firstChar uppercaseString]];
            tempArray = [[NSMutableArray alloc]init];
            flag = NO;
        }
        if ([_indexSourceArr containsObject:[firstChar uppercaseString]]) {
            [tempArray addObject:originalArray[i]];
            if (flag == NO) {
                [array addObject:tempArray];
                flag = YES;
            }
        }
    }
    return array;
}


- (void)setNav{

    self.title = @"城市选择";
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark 创建tableview的header
//-(NSString * )tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//
////return self.dataArray[section]
//    return self.indexSourceArr[section];
//
//}
#pragma mark 创建右边的索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{

    return self.indexSourceArr;

}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

#pragma mark 自定义headerr
-(UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
UIView * headerview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth
                                                           , 30)];
    headerview.backgroundColor=[UIColor hexStringToColor:@"dddddd"];

    self.SectionLabel=[UILabel new];
     self.SectionLabel.text=self.indexSourceArr[section];
    self.SectionLabel.textColor=[UIColor hexStringToColor:@"444444"];
    self.SectionLabel.font=[UIFont systemFontOfSize:14];
    [headerview addSubview:self.SectionLabel];
    [self.SectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleWidth(11.5));
        make.centerY.equalTo(headerview.mas_centerY);
        make.height.mas_equalTo(14);

    }];

    return headerview;
}



#pragma mark delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.dataArray[section]count];
}


-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic;
    if (self.dataArray.count>0) {
      dic= self.dataArray[indexPath.section][indexPath.row];
    }

    VLXChooseCityCell * cell=[VLXChooseCityCell cellWithTableView:tableView];
    cell.leftlabel.text=dic[@"areaname"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%ld",indexPath.row);
    NSArray *subArray=_dataArray[indexPath.section];
    NSDictionary *dic=subArray[indexPath.row];
    //更新userdefaluts
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //保存城市 areaid
    [defaults setObject:[ZYYCustomTool checkNullWithNSString:[NSString stringWithFormat:@"%@",dic[@"areaname"]]] forKey:@"city"];
    [defaults setObject:[ZYYCustomTool checkNullWithNSString:[NSString stringWithFormat:@"%@",dic[@"areaid"]]] forKey:@"areaID"];
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCity" object:nil userInfo:@{}];
    //
//    if (_cityBlock) {
//        _cityBlock([ZYYCustomTool checkNullWithNSString:[NSString stringWithFormat:@"%@",dic[@"areaname"]]]);
//    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(UITableView * )tableview
{

    if (!_tableview) {
        _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+11.5, ScreenWidth, ScreenHeight-64-44) style:UITableViewStylePlain];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        _tableview.sectionIndexBackgroundColor = [UIColor clearColor];//修改右边索引的背景色
        _tableview.sectionIndexColor = [UIColor hexStringToColor:@"00baff"];//修改右边索引字体的颜色
//        _tableview.sectionIndexTrackingBackgroundColor = [UIColor orangeColor];//修改右边索引点击时候的背景
        _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;

    }


    return _tableview;
}


@end

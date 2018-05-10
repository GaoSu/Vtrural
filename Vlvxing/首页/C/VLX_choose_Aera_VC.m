
//
//  VLX_choose_Aera_VC.m
//  Vlvxing
//
//  Created by grm on 2017/11/6.
//  Copyright © 2017年 王静雨. All rights reserved.
//热门地区不加入进去历史记录,会导致功能重复,

#import "VLX_choose_Aera_VC.h"

#import "historyManager.h"//搜索历史Model
#import "VLXCityChooseModel.h"//城市选择model

#import "VLX_cityChooseMOdel_2.h"//城市选择model,新

#import "NSString+WigthAndHeight.h"//获取首字母
#import "VLXChooseCityCell.h"

#import "VLX_searchAreaVw.h"//搜索地区弹出的单独一个界面

#import "VLX_PingyinZimu_Model.h"//拼音&字母搜索Model,

@interface VLX_choose_Aera_VC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,NSCoding>
{
    NSMutableArray * aryyyyyy_all_name;//用于搜索过滤的数组
    NSMutableArray * ary_seach_name;//过滤之后的数组地名
    NSMutableArray * ary_Sheng_name;//省下边的市区地名

//    NSArray * shengName;//国内省名,23省加5自治区,

    NSString * subStr;//真实的地名

}
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray * dataArray;//主列表 组数
@property(nonatomic,strong)NSMutableArray * CacheArray;//缓存数组

@property(nonatomic,strong)NSMutableArray * normalCityArray;
@property(nonatomic,strong)UILabel * locationLabel;
@property(nonatomic,strong)UILabel * SectionLabel;

@property (nonatomic,weak)UITextField *searchField;
@property (nonatomic,weak)UISearchBar *customSearchBar;
@property (nonatomic,strong)NSArray *myArray;//搜索记录的数组
@property (nonatomic,strong)NSMutableArray *myMutableArray;





@property (nonatomic,strong)VLX_searchAreaVw * vieeeeew;//搜索弹出的覆盖界面
@property (nonatomic,strong)UITableView * search_Tbvw;//搜索弹出的列表
@property (nonatomic,strong)UITableView * search_sheng_Tbvw;//搜索弹出的列表_省

/*
 *  索引数据源
 */
@property (nonatomic,strong) NSMutableArray *indexSourceArr;
@property (nonatomic,strong) NSString * dingweiString;

@property (nonatomic,assign)CGFloat lishi_Height;//历史高度

@property(nonatomic,strong) NSMutableArray * remendiquArr;//热门地区数据源


@end

@implementation VLX_choose_Aera_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化数据数组
    self.dataArray=[NSMutableArray array];
    self.CacheArray = [NSMutableArray array];

    _normalCityArray=[NSMutableArray array];
    self.indexSourceArr=[NSMutableArray array];
    
    ary_seach_name = [NSMutableArray array];
    ary_Sheng_name = [NSMutableArray array];
    
    _remendiquArr = [NSMutableArray array];

    //获取当前位置
    [[CCLocationManager shareLocation] getCity:^(NSString *addressString) {
        self.locationLabel.text=[ZYYCustomTool checkNullWithNSString:addressString];
        //        [self getAreaIDWithCity:addressString];
    }];
    //

//    [self readCacheData];//主列表缓存数据

    [self readVersion2];//先读取缓存的版本,有,则和系统版本比较判断,没有则生成系统版本并存储

    [self createUI];

    [self readNSUserDefaults];//历史缓存数据

    _vieeeeew = [[VLX_searchAreaVw alloc]init];
    
    //弹出覆盖view
    //    _fugaiView = [[UIView alloc]init];
    _vieeeeew.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight -64);
    _vieeeeew.backgroundColor = [UIColor greenColor];

    _search_Tbvw = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -64) style:UITableViewStylePlain];
    _search_Tbvw.delegate = self;
    _search_Tbvw.dataSource = self;
    _search_Tbvw.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    _search_sheng_Tbvw = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -64) style:UITableViewStyleGrouped];
    _search_sheng_Tbvw.delegate = self;
    _search_sheng_Tbvw.dataSource = self;
    _search_sheng_Tbvw.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];


    
    
}

-(void)readVersion2{
    //1,系统版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_nowNO = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //2读取缓存版本号
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * app_cacheNo = [userDefaultes stringForKey:@"app_VersionNo_2"];//读取字符串类型的数据
    NSLog(@"读取的版本号?%@",app_cacheNo);//1.8([responseObj[@"data"] isKindOfClass:[NSNull class]]) {

    if (app_cacheNo == nil) {//没有则生成系统版本并存储,该情况是用户以前没装过app,或者是老版本,所以不会有缓存数据
        NSLog(@"@@@@@@@@@@@@@@@@");

        //把版本号存起来(第一次下载,或者1.8以前版本)
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSString stringWithFormat:@"%@",app_nowNO] forKey:@"app_VersionNo_2"];
        [defaults synchronize];//同步到plist文件中
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        //读取数剧
        NSData * mainData = [userDefaultes dataForKey:@"CacheAreaList"];//
        if (mainData == nil) {//没装过
            [self readCacheData];

        }else{//老版本
            //删除旧的数据,,没有进行过版本存储的旧版本会遇到这个问题
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CacheAreaList"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CacheRemenAreaList"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            //
            [self readCacheData];

        }



    }
    else{//新版本1.9以后//有版本号,读取缓存的版本,和系统版本比较判断

        NSLog(@"APP当前版本:%@",app_nowNO);//只是xcode内部版本,不是上线版本,
        if([app_nowNO floatValue]>[app_cacheNo floatValue]){
            NSLog(@"大于");
            //删除旧的数据
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CacheAreaList"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CacheRemenAreaList"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            //把版本号存起来(1.9以后更新)
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"%@",app_nowNO] forKey:@"app_VersionNo_2"];
            [defaults synchronize];//同步到plist文件中
            //请求最新数据
            [self readCacheData];
            //            [self getNetwork];

        }else{
            NSLog(@"不大于");
            [self readCacheData];
        }

    }
}

-(void)createUI
{
    [self setNav];
    [self createTopView];//当前位置
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self.view addSubview:self.tableview];
//    });
    
    
}
- (void)setNav{
    
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

    
    //中间
    UIView *BJView = [[UIView alloc]initWithFrame:CGRectMake(40, 33,self.view.frame.size.width-80,40)];
    BJView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = BJView;
        
    
    UISearchBar *customSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 7, ScaleWidth(240), 44-7*2)];
    customSearchBar.delegate = self;
    customSearchBar.placeholder = @"请输入搜索内容";
    customSearchBar.layer.cornerRadius=14;
    customSearchBar.layer.masksToBounds=YES;
    customSearchBar.layer.borderColor=rgba(201, 201, 206, 1).CGColor;
    customSearchBar.layer.borderWidth=1;
    customSearchBar.backgroundColor = [UIColor whiteColor];
    [BJView addSubview:customSearchBar];
    _customSearchBar = customSearchBar;
    // 设置圆角和边框颜色
    UITextField *searchField = [customSearchBar valueForKey:@"searchField"];
    if (searchField) {
        searchField.backgroundColor = [UIColor whiteColor];
        searchField.keyboardType = UIReturnKeyDefault;//默认键盘
    }
    _searchField = searchField;
}
#pragma mark 搜索历史的处理↓
#pragma mark 实时监听searchBar的输入框变化
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [_vieeeeew removeFromSuperview];
    

    if ([searchText isEqualToString:@"宁夏"] || [searchText isEqualToString:@"广西"] || [searchText isEqualToString:@"西藏"] || [searchText isEqualToString:@"新疆"] || [searchText isEqualToString:@"内蒙古"] || [searchText isEqualToString:@"台湾"] || [searchText isEqualToString:@"青海"] || [searchText isEqualToString:@"甘肃"] || [searchText isEqualToString:@"海南"] || [searchText isEqualToString:@"广东"] || [searchText isEqualToString:@"云南"] || [searchText isEqualToString:@"贵州"] || [searchText isEqualToString:@"四川"] || [searchText isEqualToString:@"湖南"] || [searchText isEqualToString:@"湖北"] || [searchText isEqualToString:@"福建"] || [searchText isEqualToString:@"江西"] || [searchText isEqualToString:@"安徽"] || [searchText isEqualToString:@"浙江"] || [searchText isEqualToString:@"江苏"] || [searchText isEqualToString:@"黑龙江"] || [searchText isEqualToString:@"吉林省"] || [searchText isEqualToString:@"辽宁"] || [searchText isEqualToString:@"河南"] || [searchText isEqualToString:@"山东"] || [searchText isEqualToString:@"陕西"] || [searchText isEqualToString:@"山西"] || [searchText isEqualToString:@"河北"]) {

        NSLog(@"省份名字");
        [self loadShengData:searchText];
        [self creadeShengView];//创建省view
    }
    else if ([searchText caseInsensitiveCompare:@"ningxia"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"guangxi"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"xizang"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"xinjiang"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"neimenggu"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"taiwan"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"qinghai"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"gansu"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"hainan"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"guangdong"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"yunnan"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"guizhou"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"sichuan"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"hunan"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"hubei"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"fujian"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"jiangxi"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"anhui"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"zhejiang"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"jiangsu"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"heilongjiang"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"jilinsheng"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"liaoning"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"henan"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"shandong"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"shanxi"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"hebei"] == NSOrderedSame ){
        NSLog(@"省份拼音全拼");
        [self loadShengData:searchText];
        [self creadeShengView];//创建省view
    }
    else{
    


        NSString * stringggg = searchText;//查询有 "山" 的所有元素
        NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",stringggg];
        [aryyyyyy_all_name filteredArrayUsingPredicate:pred];

    if(ary_seach_name.count>0){
        [ary_seach_name removeAllObjects];
    }
    //加个多线程，否则数量量大的时候，有明显的卡顿现象
//    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
//    dispatch_async(globalQueue,^{
        if (searchText!=nil && searchText.length>0) {
            for (NSString * areastring in aryyyyyy_all_name) {
                NSString *tempStr = areastring;
                //----------->把所有的搜索结果转成成拼音
                NSString *pinyin = [self transformToPinyin:tempStr];
                //            NSLog(@"pinyin--%@",pinyin);

                if ([pinyin rangeOfString:searchText options:NSCaseInsensitiveSearch].length >0 ) {
                    //把搜索结果存放self.resultArray数组
                    [ary_seach_name addObject:areastring];
                }
            }
        }
        //回到主线程
//        dispatch_async(dispatch_get_main_queue(), ^{
            ////////////////////////////////////////////////
            //        NSLog(@"搜索过滤完成的数组_2:%@",ary_seach_name);
            [_vieeeeew addSubview:_search_Tbvw];
            [self.view addSubview:_vieeeeew];
            [_search_Tbvw reloadData];
//        });
//    });
    }
}
#pragma mark--获取汉字转成拼音字符串 通讯录模糊搜索 支持拼音检索 首字母 全拼 汉字 搜索
- (NSString *)transformToPinyin:(NSString *)aString{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSArray *pinyinArray = [str componentsSeparatedByString:@" "];
    NSMutableString *allString = [NSMutableString new];

    int count = 0;

    for (int  i = 0; i < pinyinArray.count; i++)
    {

        for(int i = 0; i < pinyinArray.count;i++)
        {
            if (i == count) {
                [allString appendString:@"#"];//区分第几个字母
            }
            [allString appendFormat:@"%@",pinyinArray[i]];

        }
        [allString appendString:@","];
        count ++;

    }

    NSMutableString *initialStr = [NSMutableString new];//拼音首字母

    for (NSString *s in pinyinArray)
    {
        if (s.length > 0)
        {

            [initialStr appendString:  [s substringToIndex:1]];
        }
    }

    [allString appendFormat:@"#%@",initialStr];
    [allString appendFormat:@",#%@",aString];

    return allString;
}


/** 本地保存 */
-(void)saveNSUserDefaults
{
    //判断是否有相同记录，有就移除
    if (_myMutableArray == nil) {
        
        _myMutableArray = [[NSMutableArray alloc]init];
    }
    else {
        _myMutableArray = [_myMutableArray valueForKeyPath:@"@distinctUnionOfObjects.self"];//过滤重复元素
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_myMutableArray forKey:@"myMutableArray_lishijilu"];
    [defaults synchronize];
    
}
/** 取出缓存的数据 */ //点击搜索时候才调用
-(void)readNSUserDefaults{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数组NSArray类型的数据
    NSArray * myArray_1 = [userDefaultes arrayForKey:@"myMutableArray_lishijilu"];
    
    //这里要把数组转换为可变数组
    NSMutableArray *myMutableArray_1 = [NSMutableArray arrayWithArray:myArray_1];
    
    self.myMutableArray = myMutableArray_1;

//    NSLog(@"_myMutableArray:%@",_myMutableArray);

    [_customSearchBar resignFirstResponder];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_customSearchBar resignFirstResponder];
}



-(void)tapLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
//读取主列表缓存数据
-(void)readCacheData{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数组NSArray类型的数据
    NSData * mainData = [userDefaultes dataForKey:@"CacheAreaList"];//arrayForKey:@"CacheAreaList"];
    _remendiquArr = [NSMutableArray arrayWithArray:[userDefaultes arrayForKey:@"CacheRemenAreaList"]];
    if (mainData == nil) {
        [self getNetwork];
    }else{
    //这里要把数组转换为可变数组
//    NSMutableArray *myMutableArray_1 = [NSMutableArray arrayWithArray:myArray_1];
//
////    self.dataArray = myMutableArray_1;
//        NSLog(@"youel存进来了%ld",myMutableArray_1.count);
        self.normalCityArray = [NSKeyedUnarchiver unarchiveObjectWithData:mainData];
//        NSLog(@"aaaa%ld",_dataArray.count);
//        NSLog(@"aaaa%@",_dataArray[0]);
//        NSLog(@"aaaa%@",_dataArray);
//        NSLog_JSON(@"aaaa数据四排序后的字典:%@",self.normalCityArray);//23组数组,
//        self.dataArray = _dataArray_cache;
        self.dataArray =[self sortArray:self.normalCityArray];
        [self.tableview reloadData];

        aryyyyyy_all_name = [NSMutableArray arrayWithArray:[userDefaultes arrayForKey:@"CacheLishiAreaList"]];
        NSLog(@"---------->%ld",aryyyyyy_all_name.count);


    };



}

-(void)getNetwork
{


//    [SVProgressHUD showWithStatus:@"正在加载"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary * dic=@{};
    NSString * url = [NSString stringWithFormat:@"%@%@",tangyangURL,@"getTheCity"];

    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSLog(@"类型%@", NSStringFromClass([requestDic[@"status"] class]));
//        NSLog_JSON(@"返回👌:%@",requestDic);
        if([requestDic[@"status"] integerValue]==1)
        {
            NSArray * subArray=requestDic[@"data"];
            aryyyyyy_all_name=[NSMutableArray array];
            for (NSDictionary * dic in subArray) {
                VLX_cityChooseMOdel_2 * model = [[VLX_cityChooseMOdel_2 alloc]initWithDictionary:dic error:nil];
                [self.dataArray addObject:model];
                model.address= [dic[@"address"] firstCharactor];//dic[@"areanamewithspell"];//
//                MyLog(@"数据一:%@",self.dataArray);
                NSMutableDictionary * mutableDic=[NSMutableDictionary dictionaryWithDictionary:dic];
                mutableDic[@"capitalized"]=dic[@"belongtocity"];//[dic[@"address"] firstCharactor];
                MyLog(@"数据二:%@",mutableDic);
                if([model.isHot isEqualToString:@"1"]){
                    [_remendiquArr addObject:dic[@"address"]];
                }
                [aryyyyyy_all_name addObject:dic[@"address"]];
                [_normalCityArray addObject:mutableDic];
//                MyLog(@"数据二:%ld",self.normalCityArray.count);

            }
            self.dataArray =[self sortArray:_normalCityArray];

            NSLog(@"bbbb%ld",_dataArray.count);
//            NSLog(@"bbbbremendiquArr:%@",_remendiquArr[0]);
            NSLog(@"bbbb%@",_dataArray);


            NSData * _miandata0 = [NSKeyedArchiver archivedDataWithRootObject:self.normalCityArray];//

            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:_miandata0 forKey:@"CacheAreaList"];
            [defaults synchronize];//同步到plist文件中

            NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
            [defaults2 setObject:aryyyyyy_all_name forKey:@"CacheLishiAreaList"];
            [defaults2 synchronize];

            NSUserDefaults *defaults3 = [NSUserDefaults standardUserDefaults];
            [defaults3 setObject:_remendiquArr forKey:@"CacheRemenAreaList"];
            [defaults3 synchronize];



            [self.tableview reloadData];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
    
}
//当前位置
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

#pragma mark 对元数据进行加工
- (NSMutableArray *)sortArray:(NSMutableArray *)originalArray
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    //根据拼音对数组排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"capitalized" ascending:YES]];
    
    //排序
    [originalArray sortUsingDescriptors:sortDescriptors];
//    MyLog(@"%@",originalArray);
    NSMutableArray *tempArray = nil;
    BOOL flag = NO;
    
    //分组
    for (int i = 0;i < originalArray.count; i++) {
        NSString *pinyin = [originalArray[i] objectForKey:@"capitalized"];
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

#pragma mark 创建右边的索引
//5
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (_tableview == tableView) {
        return self.indexSourceArr;
    }
    return nil;
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{

     if (_tableview == tableView) {
    return index;
     }
    return 0;
}

//头高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     if (_tableview == tableView) {
    if (section == 0) {
        
        int  height2 = 0;
        for (int i = 0; i < (_remendiquArr.count+ _myMutableArray.count); i++) {
            height2 = i/3 *40  + 40;
            
        }
//        NSLog(@"_lishiHeight3:%d",height2);
            return 115 + height2;
        }else
        {
            return 30;
        }
     }
     else if (_search_sheng_Tbvw == tableView){
         return 30;
     }
    return 0;
}

#pragma mark 自定义头
//7
-(UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
    {
        if (_tableview == tableView) {

            _lishi_Height = 10+(_myMutableArray.count/3) * (80 + (self.view.frame.size.width-30 - 3 * 80) / (3 - 1)) + 10    ;
//            NSLog(@"_lishi_Height7_1:%f",_lishi_Height);//20

            UIView * headerview=[[UIView alloc]init];
            if (section == 0) {
//                headerview=[[UIView alloc]init];
                headerview.backgroundColor=[UIColor whiteColor];


                //1
                UIView * bacgvw1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
                bacgvw1.backgroundColor = rgba(221, 221, 221, 1);

                UILabel * lishiLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
                lishiLb.text = @"历史记录";
                lishiLb.font = [UIFont systemFontOfSize:14];
                [bacgvw1 addSubview:lishiLb];
                [headerview addSubview:bacgvw1];

                CGFloat W = 80;
                CGFloat H = 20;
                //每行列数
                NSInteger rank = 3;
                //每列间距
                CGFloat rankMargin = (self.view.frame.size.width-30 - rank * W) / (rank - 1);
                //每行间距
                CGFloat rowMargin = 20;


                for (int i = 0; i < _myMutableArray.count; i++) {

                    //Item X轴
                    CGFloat X = 10+(i % rank) * (W + rankMargin);
                    //Item Y轴
                    NSUInteger Y = (i / rank) * (H +rowMargin);
                    //Item top
                    CGFloat top = 10;

                    UIButton * btn = [[UIButton alloc]init];//历史搜索
                    [btn setTitle:_myMutableArray[i] forState:UIControlStateNormal];
                    btn.frame = CGRectMake(X, Y+top+30, W, H);

                    btn.layer.borderWidth = 1;
                    btn.layer.borderColor = [UIColor orangeColor].CGColor;
                    btn.layer.cornerRadius = 5;
                    btn.tag = 200+i;
                    btn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(spitlotBtnClick_lishi:) forControlEvents:UIControlEventTouchUpInside];


                    [headerview addSubview:btn];

                    _lishi_Height = Y+top;//Y=10+(_myMutableArray.count/3) * (80 +
                }
                headerview.frame = CGRectMake(0, 0, ScreenWidth, 115+_lishi_Height);//135

                NSLog(@"frame:%@",NSStringFromCGRect(headerview.frame));


                UIView * bacgvw2 = [[UIView alloc]initWithFrame:CGRectMake(0, 60+_lishi_Height, ScreenWidth, 30)];
                bacgvw2.backgroundColor = rgba(221, 221, 221, 1);

                UILabel * remenLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
                remenLb.text = @"热门地区";
                remenLb.font = [UIFont systemFontOfSize:14];

                [bacgvw2 addSubview:remenLb];
                [headerview addSubview:bacgvw2];



                for (int i = 0; i < _remendiquArr.count; i++) {

                    //Item X轴
                    CGFloat X = 10+(i % rank) * (W + rankMargin);
                    //Item Y轴
                    NSUInteger Y = (i / rank) * (H +rowMargin);
                    //Item top
                    CGFloat top = 10;

                    UIButton * btn = [[UIButton alloc]init];//热门地区
                    //            btn.backgroundColor = [UIColor lightGrayColor];
                    [btn setTitle:self.remendiquArr[i] forState:UIControlStateNormal];
                    btn.frame = CGRectMake(X, 60+30+10+Y+top+ _lishi_Height, W, H);
//                    NSLog(@"remen高度:%f",H);
                    btn.layer.borderWidth = 1;
                    btn.layer.borderColor = [UIColor orangeColor].CGColor;
                    btn.layer.cornerRadius = 5;
                    btn.tag = 100+i;
                    btn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(spitlotBtnClick:) forControlEvents:UIControlEventTouchUpInside];


                    [headerview addSubview:btn];
                }


            }
            else{//section>0
                headerview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
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
            }
            return headerview;

        }
        else if (_search_sheng_Tbvw == tableView){
            UIView * headerview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
            headerview.backgroundColor=[UIColor hexStringToColor:@"dddddd"];

            UILabel * tipsLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth, 30)];
            tipsLb.text = @"您可能想查找以下地区:";
            tipsLb.textAlignment = NSTextAlignmentLeft;
            tipsLb.font=[UIFont systemFontOfSize:14];
            [headerview addSubview:tipsLb];
            return headerview;
        }
        return nil;
    }

-(void)spitlotBtnClick_lishi:(UIButton *)bt{
    
    NSLog(@"历史aaaa:%ld",(long)bt.tag);

    NSInteger inttegg = bt.tag - 200;
    NSString * remenAreaStr =_myMutableArray[inttegg];
    
    NSLog(@"历史bbbbb:%@",remenAreaStr);

    NSDictionary *dic = [NSDictionary dictionaryWithObject:remenAreaStr forKey:@"address"];//@"areaname"];//忘记这个地方的键是啥了?
    //创建通知并发送
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCity2" object:nil userInfo:dic];
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 按钮点击事件
- (void)spitlotBtnClick:(UIButton *)bt{

//    NSLog(@"%ld",(long)bt.tag);

    NSInteger inttegg = bt.tag - 100;
    NSString * remenAreaStr =_remendiquArr[inttegg];
    
    NSLog(@"热门ccccc:%@",remenAreaStr);

    NSDictionary *dic = [NSDictionary dictionaryWithObject:remenAreaStr forKey:@"address"];
    //创建通知并发送
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCity2" object:nil userInfo:dic];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark delegate
////组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_tableview == tableView){
        return self.dataArray.count;
    }
    else if (_search_Tbvw == tableView){
        return 1;
    }
    else if (_search_sheng_Tbvw == tableView){
        return 1;
    }
    return 0;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     if(_tableview == tableView){
         return [self.dataArray[section]count];
     }
     else if (_search_Tbvw == tableView){
         return ary_seach_name.count;
     }
     else if (_search_sheng_Tbvw==tableView){
         NSLog(@"^^^^^^^%ld",ary_Sheng_name.count);
         return ary_Sheng_name.count;
     }
    return 0;
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tableview == tableView) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return 44;
            }
        }
        return 44;
    }
    else if (_search_Tbvw == tableView){
        return 44;
    }
    else if (_search_sheng_Tbvw == tableView){
        return 44;
    }
    return 0;
}
//6
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableview == tableView) {
    
        VLXChooseCityCell * cell=[VLXChooseCityCell cellWithTableView:tableView];
        NSDictionary * dic=[NSDictionary dictionary];
        if (self.dataArray.count>0) {
            dic= self.dataArray[indexPath.section][indexPath.row];
        }
        cell.leftlabel.text=dic[@"address"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (_search_Tbvw == tableView){
        VLXChooseCityCell * cell=[VLXChooseCityCell cellWithTableView:tableView];
        NSString * dStr = [[NSString alloc]init];
        if (ary_seach_name.count>0) {
            dStr = ary_seach_name[indexPath.row];
        }
        cell.leftlabel.text= dStr;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;

    }
    else if (_search_sheng_Tbvw == tableView){
        VLXChooseCityCell * cell=[VLXChooseCityCell cellWithTableView:tableView];
        NSString * dStr = [[NSString alloc]init];
        if (ary_Sheng_name.count>0) {
            dStr = ary_Sheng_name[indexPath.row];
        }
        cell.leftlabel.text =dStr;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;

    }

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableview == tableView) {
//        NSLog(@"%ld",indexPath.row);
        NSArray * subArray = _dataArray[indexPath.section];
        NSDictionary *dic=subArray[indexPath.row];
//        NSLog(@"葫芦里什么药:%@",dic);
        //更新userdefaluts
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        //保存城市 areaid
        [defaults setObject:[ZYYCustomTool checkNullWithNSString:[NSString stringWithFormat:@"%@",dic[@"address"]]] forKey:@"city"];

        [_myMutableArray addObject:dic[@"address"]];
        [self saveNSUserDefaults];

        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCity1" object:nil userInfo:@{}];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(_search_Tbvw == tableView){
        subStr = ary_seach_name[indexPath.row];//真实的地名
        //更新userdefaluts
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];

        //保存城市 areaid
        [defaults setObject:[ZYYCustomTool checkNullWithNSString:[NSString stringWithFormat:@"%@",subStr]] forKey:@"city"];
//        [defaults setObject:[ZYYCustomTool checkNullWithNSString:[NSString stringWithFormat:@"%@",dic[@"areaid"]]] forKey:@"areaID"];
        [_myMutableArray addObject:subStr];
        [self saveNSUserDefaults];
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCity1" object:nil userInfo:@{}];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (_search_sheng_Tbvw==tableView){
        subStr = ary_Sheng_name[indexPath.row];//真实的地名
        //保存城市 areaid
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:[ZYYCustomTool checkNullWithNSString:[NSString stringWithFormat:@"%@",subStr]] forKey:@"city"];
        [_myMutableArray addObject:subStr];
        [self saveNSUserDefaults];//本地保存
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCity1" object:nil userInfo:@{}];
        [self.navigationController popViewControllerAnimated:YES];


    }
}

//1
-(UITableView * )tableview
{
    
    if (!_tableview) {
        _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+11.5, ScreenWidth, ScreenHeight-64-44) style:UITableViewStylePlain];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        _tableview.sectionIndexBackgroundColor = [UIColor clearColor];//修改右边索引的背景色
        _tableview.sectionIndexColor = [UIColor hexStringToColor:@"00baff"];//修改右边索引字体的颜色
        //        _tableview.sectionIndexTrackingBackgroundColor = [UIColor orangeColor];//修改右边索引点击时候的背景
//        _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        
    }
    
    
    return _tableview;
}

//列表滑动时候
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_customSearchBar resignFirstResponder];
    int  height2 = 0;
    for (int i = 0; i < (_remendiquArr.count+ _myMutableArray.count); i++) {
        height2 = i/3 *40  + 40;
    }
    if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= height2+115) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y >= height2+115){
        scrollView.contentInset = UIEdgeInsetsMake(-height2-115, 0, 0, 0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//
-(void)loadShengData:(NSString *)shengString{
    if (ary_Sheng_name.count>0) {
        [ary_Sheng_name removeAllObjects];
    }

    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"provinces"]=shengString;

    NSString * url = [NSString stringWithFormat:@"%@%@",tangyangURL,@"selectByprovinces"];
    [HMHttpTool post:url params:para success:^(id responseObj) {
        NSLog(@"OK ::::%@",responseObj);
        if([responseObj[@"status"] isEqual:@1]){
            for (NSDictionary * dic in responseObj[@"data"]) {
                [ary_Sheng_name addObject:dic[@"address"]];
            }
            NSLog(@"下属地区数量%ld",ary_Sheng_name.count);
        }
        [_search_sheng_Tbvw reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Fail::::%@",error);
    }];
}
//省下边的市区
-(void)creadeShengView{
    
    [_vieeeeew addSubview:_search_sheng_Tbvw];
    [self.view addSubview:_vieeeeew];
//    [_search_sheng_Tbvw reloadData];
}



@end

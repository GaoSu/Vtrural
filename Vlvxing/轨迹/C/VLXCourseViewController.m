//
//  VLXCourseViewController.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/18.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXCourseViewController.h"
#import "VLXCustomAlertView.h"
#import "VLXAddImageVC.h"
@interface VLXCourseViewController ()<BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKMapViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(nonatomic,strong) BMKMapView  * mapview;
@property(nonatomic,assign) NSInteger level;
@property(nonatomic,strong)BMKLocationService * locService;
@property(nonatomic,assign) CLLocationCoordinate2D  codinate;
@property(nonatomic,assign)BOOL nightClicked;
@property(nonatomic,assign)BOOL WCClicked;
@property(nonatomic,strong)BMKPoiSearch * searcher;
@property(nonatomic,assign)NSInteger num;//用于标记用户只定位一次
@property(nonatomic,strong)NSMutableArray * animationArray;
@end

@implementation VLXCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化
    self.nightClicked=NO;
    self.WCClicked=NO;
    self.level=17;
    self.num=0;
    [VLXMapTool setMapCustomStyleWithNight];//注：必须在BMKMapView对象初始化之前设置 夜间模式
    //
    [self createUI];
    [self.mapview setZoomLevel:self.level];
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapview viewWillAppear];
    _mapview.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapview viewWillDisappear];
    _mapview.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _searcher.delegate = nil;
}
- (void)dealloc {
    if (_mapview) {
        _mapview = nil;
    }
}
#pragma mark---数据
#pragma mark
#pragma mark---视图
-(void)createUI
{
//设置地图样式的路径
   self.view.backgroundColor=[UIColor whiteColor];
     BMKMapView * mapview  =[[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64-49)];
    [self.view addSubview:mapview];
//    mapview.mapType = BMKMapTypeStandard;

    self.mapview.zoomEnabledWithTap=YES;

    self.mapview=mapview;
    [self createNav];
    [self createBtns];
    [self locationBtn];
    [self createThreeBtns];
    [self createlocation];
    [self bottomThreeBtns];
//    [self makeSearch];

}


-(void)createNav
{
    CGFloat leftHeight=14;
    //中间
    UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 7, ScaleWidth(240), 44-7*2)];
    titleView.layer.cornerRadius=4;
    titleView.layer.masksToBounds=YES;
    titleView.layer.borderColor=orange_color.CGColor;
    titleView.layer.borderWidth=1;
    self.navigationItem.titleView=titleView;
    UIImageView *search=[[UIImageView alloc] initWithFrame:CGRectMake(ScaleWidth(56.5), (30-17)/2, 17, 17)];
    [search setImage:[UIImage imageNamed:@"search"]];
    [titleView addSubview:search];
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(search.frame)+5, 0, CGRectGetWidth(titleView.frame)-ScaleWidth(56.5)*2, 30)];
    titleLab.text=@"请输入关键词查询";
    titleLab.textColor=[UIColor hexStringToColor:@"#999999"];
    titleLab.font=[UIFont systemFontOfSize:14];
    titleLab.textAlignment=NSTextAlignmentLeft;
    [titleView addSubview:titleLab];
    //
    titleView.userInteractionEnabled=YES;
    UITapGestureRecognizer *centerTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerNavItemClicked:)];
    [titleView addGestureRecognizer:centerTap];
    //右边
    CGFloat imageWidth=22;

    //添加手势
    UILabel * rightlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 57, 14)];
    rightlabel.text=@"路程规划";
    rightlabel.textColor=orange_color;
    rightlabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:14];

    UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightlabel];
    self.navigationItem.rightBarButtonItem=rightItem;


}


-(void)centerNavItemClicked:(UITapGestureRecognizer *)tap
{

    MyLog(@"点击了搜索栏");
}


#pragma mark 创建搜索
-(void)makeSearch//搜索附近wc
{
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 1;
    option.pageCapacity = 10;
    option.location =self.codinate;
    option.keyword = @"厕所";
    BOOL flag = [_searcher poiSearchNearBy:option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}

//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    self.animationArray=[NSMutableArray array];
    NSMutableArray * animationArray=[NSMutableArray array];
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
//        BMKPoiInfo * info=poiResultList.poiInfoList[0];
        for (BMKPoiInfo * info in poiResultList.poiInfoList) {
            MyLog(@"%@---%f",info.name,info.pt.latitude);
        }
        for (BMKPoiInfo * info in poiResultList.poiInfoList) {
            BMKPointAnnotation * animation=[[BMKPointAnnotation alloc]init];
            animation.coordinate=info.pt;
            animation.title=info.name;

            [animationArray addObject:animation];
        }

        [_mapview addAnnotations:animationArray];
        [self.animationArray addObjectsFromArray:animationArray];
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
//        NSLog(@"起始点有歧义");
        [SVProgressHUD showErrorWithStatus:@"起始点有歧义"];
    } else {
//        NSLog(@"抱歉，未找到结果");
        [SVProgressHUD showInfoWithStatus:@"抱歉，未找到结果"];
    }
}


// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

#pragma mark 创建定位视图
-(void)createlocation
{
    _locService=[[BMKLocationService alloc]init];
    _locService.delegate=self;
    [_locService startUserLocationService];
    //
    _mapview.showsUserLocation = YES;//显示定位图层
    _mapview.userTrackingMode=BMKUserTrackingModeFollow;
    //去掉精度圈
    BMKLocationViewDisplayParam *param=[[BMKLocationViewDisplayParam alloc] init];
    param.isAccuracyCircleShow=NO;
    [_mapview updateLocationViewWithParam:param];
    
}
#pragma mark 定位的代理方法

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{

    [_mapview updateLocationData:userLocation];
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapview updateLocationData:userLocation];
    self.codinate=userLocation.location.coordinate;
    if (self.num==0) {
        self.num++;
        self.mapview.centerCoordinate=userLocation.location.coordinate;
    }
}
#pragma mark 创建右边那些Btn
-(void)createBtns
{
    UIView * bottomView=[[UIView alloc]initWithFrame:CGRectMake(ScreenWidth-ScaleWidth(6)-38,ScaleHeight(391.5), 38, 79)];
    bottomView.backgroundColor=[UIColor whiteColor]
    ;
    //加号view
    UIView * jiahaoView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 38, 39)];
    jiahaoView.backgroundColor=[UIColor whiteColor];
    [bottomView addSubview:jiahaoView];
//减号View
    UIView * jianhaoView=[[UIView alloc]initWithFrame:CGRectMake(0, 39, 38, 39)];
    jianhaoView.backgroundColor=[UIColor whiteColor];
    [bottomView addSubview:jianhaoView];
    [self.view addSubview:bottomView];

    UIImageView * jiahaoimageview=[UIImageView new];
    jiahaoimageview.image=[UIImage imageNamed:@"fangda"];
    [jiahaoView addSubview:jiahaoimageview];
    [jiahaoimageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(jiahaoView.mas_centerX);
        make.centerY.equalTo(jiahaoView.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];

    UIImageView * jianhaoimageview=[UIImageView new];
    jianhaoimageview.image=[UIImage imageNamed:@"GJ_jianhao"];
    [jianhaoView addSubview:jianhaoimageview];
    [jianhaoimageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(jianhaoView.mas_centerX);
        make.centerY.equalTo(jianhaoView.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(2);
    }];

//加号减号view添加点击手势
    UITapGestureRecognizer * addTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addClick)];
    jiahaoView.userInteractionEnabled=YES;
    [jiahaoView addGestureRecognizer:addTap];

    UITapGestureRecognizer * minusTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(minusClick)];
    jianhaoView.userInteractionEnabled=YES;
    [jianhaoView addGestureRecognizer:minusTap];

//设置圆角
    bottomView.layer.masksToBounds=YES;
    bottomView.layer.cornerRadius=YES;
}


#pragma mark---定位Btn
-(void)locationBtn
{
    UIView * locationView=[[UIView alloc]initWithFrame:CGRectMake(ScreenWidth-ScaleWidth(6)-38, ScaleHeight(340.5), 38, 38)];
    locationView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:locationView];
    locationView.layer.masksToBounds=YES;
    locationView.layer.cornerRadius=4;

//创建image
    UIImageView * locationImageview=[UIImageView new];
    locationImageview.image=[UIImage imageNamed:@"Navigate"];
    [locationView addSubview:locationImageview];
    [locationImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(locationView.mas_centerX);
        make.centerY.equalTo(locationView.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);

    }];

    locationView.userInteractionEnabled=YES;
    UITapGestureRecognizer * locationTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationClick)];
    [locationView addGestureRecognizer:locationTap];



}

#pragma mark 创建三个Btns
-(void)createThreeBtns
{
    //创建厕所的view
    UIView * WCView=[[UIView alloc]initWithFrame:CGRectMake(ScreenWidth-ScaleWidth(6)-38, ScaleHeight(198.5), 38, 38)];
    WCView.backgroundColor=[UIColor whiteColor];
    WCView.layer.cornerRadius=4;
    WCView.layer.masksToBounds=YES;
    [self.view addSubview:WCView];


//    创建image
    UIImageView * WCImageview=[UIImageView new];
    WCImageview.image=[UIImage imageNamed:@"WC"];
    [WCView addSubview:WCImageview];
    [WCImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(WCView.mas_centerX);
        make.centerY.equalTo(WCView.mas_centerY);
        make.width.mas_equalTo(23.5);
        make.height.mas_equalTo(11);

    }];


//创建夜间模式

    UIView * nightView=[[UIView alloc]initWithFrame:CGRectMake(ScreenWidth-ScaleWidth(6)-38, ScaleHeight(150.5), 38, 38)];
    nightView.backgroundColor=[UIColor whiteColor];
    nightView.layer.cornerRadius=4;
    nightView.layer.masksToBounds=YES;
    [self.view addSubview:nightView];

//夜间模式中的图片
    UIImageView * nightImageview=[UIImageView new];
    nightImageview.image=[UIImage imageNamed:@"GJ_sun"];
    [nightView addSubview:nightImageview];
    [nightImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nightView.mas_centerX);
        make.centerY.equalTo(nightView.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);

    }];



//关闭图片

    UIView * closePic=[[UIView alloc]initWithFrame:CGRectMake(ScreenWidth-ScaleWidth(6)-38, ScaleHeight(97.5), 38, 38)];
    closePic.backgroundColor=[UIColor whiteColor];
    closePic.layer.cornerRadius=4;
    closePic.layer.masksToBounds=YES;
    [self.view addSubview:closePic];
//关闭图片的image
    UIImageView * ClosePicImageview=[UIImageView new];
    ClosePicImageview.image=[UIImage imageNamed:@"conceal"];
    [closePic addSubview:ClosePicImageview];
    [ClosePicImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(closePic.mas_centerX);
        make.centerY.equalTo(closePic.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(14);

    }];


#pragma mark 创建点击事件
    UITapGestureRecognizer * closeTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeClick)];
    UITapGestureRecognizer * nightTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nightClick)];
    UITapGestureRecognizer * wcTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(WCClick)];

    closePic.userInteractionEnabled=YES;
    nightView.userInteractionEnabled=YES;
    WCView.userInteractionEnabled=YES;
    [closePic addGestureRecognizer:closeTap];
    [nightView addGestureRecognizer:nightTap];
    [WCView addGestureRecognizer:wcTap];

}



#pragma mark 底部三个Button
-(void)bottomThreeBtns
{
//播放view
    UIView * bofangView=[[UIView alloc]initWithFrame:CGRectMake(ScaleWidth(71.5), ScreenHeight-59-48-64, 48, 48)];
    bofangView.backgroundColor=[UIColor whiteColor];
    bofangView.layer.masksToBounds=YES;
    bofangView.layer.cornerRadius=24;
    [self.view addSubview:bofangView];
    //添加播放的图片
    UIImageView * bofangImage=[UIImageView new];
    bofangImage.image=[UIImage imageNamed:@"play"];
    [bofangView  addSubview:bofangImage];
    [bofangImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bofangView.mas_centerX);
        make.centerY.equalTo(bofangView.mas_centerY);
        make.width.mas_equalTo(14.5);
        make.height.mas_equalTo(18);

    }];
///创建拍照按钮
    UIView * paizhaoView=[[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-48)/2, ScreenHeight-59-48-64, 48, 48)];
    paizhaoView.backgroundColor=[UIColor whiteColor];
    paizhaoView.layer.masksToBounds=YES;
    paizhaoView.layer.cornerRadius=24;
    [self.view addSubview:paizhaoView];

    //添加拍照的图片
    UIImageView * paizhaoimage=[UIImageView new];
    paizhaoimage.image=[UIImage imageNamed:@"GJ-camera"];
    [paizhaoView  addSubview:paizhaoimage];
    [paizhaoimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(paizhaoView.mas_centerX);
        make.centerY.equalTo(paizhaoView.mas_centerY);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(18);

    }];

    //=====创建停止按钮
    UIView * stopView=[[UIView alloc]initWithFrame:CGRectMake(ScreenWidth-ScaleWidth(75.5)-48,  ScreenHeight-59-48-64, 48, 48)];
    stopView.backgroundColor=[UIColor whiteColor];
    stopView.layer.masksToBounds=YES;
    stopView.layer.cornerRadius=24;
    [self.view addSubview:stopView];

//停止时候的按钮图片
    UIImageView * stopImage=[UIImageView new];
    stopImage.image=[UIImage imageNamed:@"jieshu"];
    [stopView addSubview:stopImage];
    [stopImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(stopView.mas_centerX);
        make.centerY.equalTo(stopView.mas_centerY);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];



#pragma mark 底下横排的三个按钮的点击

    bofangView.userInteractionEnabled=YES;
    paizhaoView.userInteractionEnabled=YES;
    stopView.userInteractionEnabled=YES;

    UITapGestureRecognizer * bofangtap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bofangClick)];
    [bofangView addGestureRecognizer:bofangtap];

    UITapGestureRecognizer * paizhaoTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(paizhaoClick)];
    [paizhaoView addGestureRecognizer:paizhaoTap];

    UITapGestureRecognizer * stoptap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stopClick)];
    [stopView addGestureRecognizer:stoptap];



}
#pragma mark---拍照  拍视频
-(void)openCameraForPhoto//打开摄像头 用于拍照
{
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
    imagePicker.delegate=self;
    imagePicker.allowsEditing=YES;
    NSLog(@"拍照片");
    if (![UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
        [SVProgressHUD showErrorWithStatus:@"相机不可用"];//RWNLocalizedString(@"SheZhi-TheCameraIsNotAvailable");
    }else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
#pragma mark
#pragma mark---imagePicker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {//如果是拍照
        NSLog(@"%@",info);
        VLXAddImageVC *vc=[[VLXAddImageVC alloc] init];
        vc.image=info[UIImagePickerControllerEditedImage];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"imagePickerControllerDidCancel");
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark
#pragma mark 底下三个按钮点击
-(void)bofangClick
{
    MyLog(@"播放");
}
-(void)paizhaoClick
{
    MyLog(@"拍照");
    __block VLXCourseViewController *blockSelf=self;
    VLXCustomAlertView *alertView=[[VLXCustomAlertView alloc] initWithTitle:@"拍照/拍视频" andContent1:@"拍照" andContent2:@"拍视频"];
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    alertView.alertBlock=^(NSInteger index)
    {
        NSLog(@"index:%ld",index);
        if (index==1) {
            [blockSelf openCameraForPhoto];
        }else if (index==2)
        {
            
        }
    };
}
-(void)stopClick
{
    MyLog(@"停止");

}


#pragma mark---点击事件
-(void)addClick
{
    MyLog(@"添加");

    if (self.level<21) {
        ++self.level;
        [self.mapview setZoomLevel:self.level];
    }

}

-(void)minusClick
{
    if (self.level>3) {

        --self.level;
        [self.mapview setZoomLevel:self.level];
    }

    MyLog(@"减号");

}
#pragma mark 定位location
-(void)locationClick
{
    MyLog(@"定位locaton");
    self.mapview.centerCoordinate=self.codinate;
}
#pragma mark 关闭pic
-(void)closeClick
{
    MyLog(@"关闭图片的展示");
}
#pragma mark  夜间模式
-(void)nightClick
{
    _nightClicked=!_nightClicked;
    if (_nightClicked) {

         [BMKMapView enableCustomMapStyle:YES];//打开个性化地图

    }else
    {
        MyLog(@"点击夜间模式");
         [BMKMapView enableCustomMapStyle:NO];//打开个性化地图
    }

}
#pragma mark
-(void)WCClick
{
    MyLog(@"点击厕所按钮");

    if (self.WCClicked) {
        [self.mapview removeAnnotations:self.animationArray];
    }else
    {
          [self makeSearch];
    }
    self.WCClicked=!self.WCClicked;
}
#pragma mark
#pragma mark---delegate
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

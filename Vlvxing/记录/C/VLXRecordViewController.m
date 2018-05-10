//
//  VLXRecordViewController.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/18.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXRecordViewController.h"
#import "VLXLTYearTB.h"//选择年月
#import "VLXRecordModel.h"
#import "VLXRecordAnnotationView.h"// 大头针视图
#import "VLXRecordDetailVC.h"//轨迹 详情
#import "VLXRecordImageDetailVC.h"//图片详情
#import "VLXRecordVideoDetailVC.h"//视频详情
#import "VLXMenuPopView.h"
#import "VLXCourseAlertView.h"
#import "VLXLoginVC.h"
#import "ShareBtnView.h"
@interface VLXRecordViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,VLXLTYearTBDelegate,ShareBtnViewDelegate>
@property(nonatomic,strong)BMKMapView  * mapview;
@property(nonatomic,assign)NSInteger level;
@property(nonatomic,assign) CLLocationCoordinate2D  codinate;
@property(nonatomic,strong)BMKLocationService * locService;
@property(nonatomic,strong) VLXLTYearTB * nianView;
@property(nonatomic,strong) UIView * yearView;

@property(nonatomic,strong)UIImageView * yearImage;
@property(nonatomic,strong) UIView * selectYear;
@property(nonatomic,strong) UILabel * yearLabel;
@property (nonatomic,assign)CLLocationCoordinate2D leftTopCoord;//左上角经纬度
@property (nonatomic,assign)CLLocationCoordinate2D rightBottomCoord;//右下角经纬度
@property (nonatomic,strong)VLXRecordModel *recordModel;
@property (nonatomic,strong)VLXMenuPopView *menuView;
@property (nonatomic,assign)BOOL isShowMenu;//分享 删除
@property (nonatomic,assign)BOOL isShowYear;//年份选择
@property(nonatomic,weak)UIView * blackView;
@property(nonatomic,weak)ShareBtnView *shareView;
@property(nonatomic,strong) NSMutableArray *allDataArr; // 存放所有的请求的数组数据

@end

@implementation VLXRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.level=17;
    _isShowMenu=NO;
    _isShowYear=NO;
    // Do any additional setup after loading the view.
    [self createUI];
    [self.mapview setZoomLevel:self.level];

}

-(NSMutableArray *)allDataArr{
    if (!_allDataArr) {
        _allDataArr = [NSMutableArray array];
    }
    return _allDataArr;
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapview viewWillAppear];
    if (![NSString getDefaultToken]) {//如果没有登录
        [ZYYCustomTool userToLoginWithVC:self];
        return;

    }else
    {
        if (![NSString checkForNull:_yearLabel.text]) {
            [self loadData];
        }
    }
    
    _mapview.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapview viewWillDisappear];
    _mapview.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;

}
- (void)dealloc {
    if (_mapview) {
        _mapview = nil;
    }
}
#pragma mark---数据
-(void)getScreenLocation//获取屏幕四周的经纬度
{
    //当前屏幕中心点的经纬度
    CGFloat centerLongitude = self.mapview.region.center.longitude;
    CGFloat centerLatitude = self.mapview.region.center.latitude;
    //当前屏幕显示范围的经纬度
    CLLocationDegrees pointssLongitudeDelta = self.mapview.region.span.longitudeDelta;
    CLLocationDegrees pointssLatitudeDelta=self.mapview.region.span.latitudeDelta;
    //左上角
    CGFloat leftUpLong = centerLongitude - pointssLongitudeDelta/2.0;//经度
    CGFloat leftUpLati = centerLatitude + pointssLatitudeDelta/2.0;//纬度
    //记录
    _leftTopCoord.longitude=leftUpLong;
    _leftTopCoord.latitude=leftUpLati;
    //右下角
    CGFloat rightDownLong = centerLongitude + pointssLongitudeDelta/2.0;
    CGFloat rightDownLati = centerLatitude - pointssLatitudeDelta/2.0;
    //记录
    _rightBottomCoord.longitude=rightDownLong;
    _rightBottomCoord.latitude=rightDownLati;

}
-(void)loadData//旅途首页（按周围四个角的范围）
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    [self getScreenLocation];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"token"]=[NSString getDefaultToken];//
    dic[@"year"]=[ZYYCustomTool checkNullWithNSString:_yearLabel.text];
    dic[@"lng1"]=[NSString stringWithFormat:@"%f",_leftTopCoord.longitude];//手机左上角经度
    dic[@"lat1"]=[NSString stringWithFormat:@"%f",_leftTopCoord.latitude];//手机左上角纬度
    dic[@"lng2"]=[NSString stringWithFormat:@"%f",_rightBottomCoord.longitude];//手机右下角经度
    dic[@"lat2"]=[NSString stringWithFormat:@"%f",_rightBottomCoord.latitude];//手机右下角纬度
    NSString * url=[NSString stringWithFormat:@"%@/TraRoadController/auth/TravelRoadList.html",ftpPath];
    NSLog(@"%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        
//        NSLog(@"%@",requestDic.mj_JSONString);
        [self.allDataArr removeAllObjects];
        _recordModel=[[VLXRecordModel alloc] initWithDictionary:requestDic error:nil];
        for (int i = 0; i <_recordModel.data.count; i++) {
            VLXRecordDataModel *model = _recordModel.data[i];
            [self.allDataArr addObject:model];
//            model.countNum = [NSString stringWithFormat:@"%d",i+1];
        }
        
        for (int i = 0; i <_recordModel.content.count; i++) {
            VLXGuiJiModel *model = _recordModel.content[i];
            [self.allDataArr addObject:model];
//            model.countNum = [NSString stringWithFormat:@"%d",i+1];
        }
        
        for (int i = 0; i <_allDataArr.count; i++) {
            id obj = _allDataArr[i];
            if ([obj isKindOfClass:[VLXRecordDataModel class]]) {
                VLXRecordDataModel *model = obj;
                model.countNum = [NSString stringWithFormat:@"%d",i+1];
            }else{
                VLXGuiJiModel *model = obj;
                model.countNum = [NSString stringWithFormat:@"%d",i+1];
            }
            
        }
        
        if (_recordModel.status.integerValue==1) {
            [self createRecordAnnotation];
            [SVProgressHUD dismiss];
            
        }else
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)loadDataWithDelete//删除旅途首页中的点
{
    [SVProgressHUD showWithStatus:@"正在删除"];
    [self getScreenLocation];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"token"]=[NSString getDefaultToken];//
    dic[@"year"]=[ZYYCustomTool checkNullWithNSString:_yearLabel.text];
    dic[@"lng1"]=[NSString stringWithFormat:@"%f",_leftTopCoord.longitude];//手机左上角经度
    dic[@"lat1"]=[NSString stringWithFormat:@"%f",_leftTopCoord.latitude];//手机左上角纬度
    dic[@"lng2"]=[NSString stringWithFormat:@"%f",_rightBottomCoord.longitude];//手机右下角经度
    dic[@"lat2"]=[NSString stringWithFormat:@"%f",_rightBottomCoord.latitude];//手机右下角纬度
    NSString * url=[NSString stringWithFormat:@"%@/TraRoadController/auth/deleteTraPathinfoList.html",ftpPath];
    NSLog(@"%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        //        NSLog(@"%@",requestDic.mj_JSONString);
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        if ([requestDic[@"status"] integerValue]==1) {
            //移除之前所有的标注
            NSArray *mapAnnotationsArr=_mapview.annotations;
            if (mapAnnotationsArr&&mapAnnotationsArr.count>0) {
                [_mapview removeAnnotations:mapAnnotationsArr];
            }
            //
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
#pragma mark
#pragma mark---视图
-(void)createUI
{
    [self setNav];
    self.view.backgroundColor=[UIColor whiteColor];
    self.mapview=[[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49)];
    self.mapview.delegate=self;
    [self.mapview setZoomLevel:self.level];
    
    [self.view addSubview:self.mapview];
    [self createBtns];
    [self locationBtn];
    [self Makelocation];
    [self createYearView];
}
#pragma mark---创建记录大头针
-(void)createRecordAnnotation
{
    //移除之前所有的标注
    NSArray *mapAnnotationsArr=_mapview.annotations;
    if (mapAnnotationsArr&&mapAnnotationsArr.count>0) {
        [_mapview removeAnnotations:mapAnnotationsArr];
    }
    //
    NSMutableArray *annotationArray=[NSMutableArray array];
  
    for ( id obj in self.allDataArr) {
        if ([obj isKindOfClass:[VLXRecordDataModel class]]) {
            VLXRecordDataModel *model = obj;
            BMKPointAnnotation * point=[[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D code;
            code.latitude=[model.pathlat doubleValue];
            code.longitude=[model.pathlng doubleValue];
            point.coordinate=code;
            point.title=[ZYYCustomTool checkNullWithNSString:model.countNum];//用于标记 相当于tag
            [annotationArray addObject:point];
        }else{
            VLXGuiJiModel *model = obj;
            BMKPointAnnotation * point=[[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D code;
            code.latitude=[model.stratlat doubleValue];
            code.longitude=[model.stratlng doubleValue];
            point.coordinate=code;
            point.title=[ZYYCustomTool checkNullWithNSString:model.countNum];//用于标记 相当于tag
            [annotationArray addObject:point];
        }
        
    }
//    for (int i=0; i<_recordModel.data.count; i++) {
//        VLXRecordDataModel *model=_recordModel.data[i];
//        //
//        BMKPointAnnotation * point=[[BMKPointAnnotation alloc]init];
//        CLLocationCoordinate2D code;
//        code.latitude=[model.pathlat doubleValue];
//        code.longitude=[model.pathlng doubleValue];
//        point.coordinate=code;
//        point.title=[ZYYCustomTool checkNullWithNSString:model.countNum];//用于标记 相当于tag
//        [annotationArray addObject:point];
//
//    }
//    
//    for (int i=0; i<_recordModel.content.count; i++) {
//        VLXGuiJiModel *model=_recordModel.content[i];
//        //
//        BMKPointAnnotation * point=[[BMKPointAnnotation alloc]init];
//        CLLocationCoordinate2D code;
//        code.latitude=[model.stratlat doubleValue];
//        code.longitude=[model.stratlng doubleValue];
//        point.coordinate=code;
//        point.title=[ZYYCustomTool checkNullWithNSString:model.countNum];//用于标记 相当于tag
//        [annotationArray addObject:point];
//        
//    }
    
    [self.mapview addAnnotations:annotationArray];
}
- (void)setNav{

    self.title = @"旅途";
    self.view.backgroundColor=[UIColor hexStringToColor:@"f3f3f4"];
    //右边按钮
    UIView * rightview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    rightview.backgroundColor=[UIColor whiteColor];

    UIImageView * rightimageview=[[UIImageView alloc]initWithFrame:CGRectMake(36, 0, 4, 20)];
    rightimageview.image=[UIImage imageNamed:@"more"];
    [rightview addSubview:rightimageview];

    UIBarButtonItem * rightBaritem=[[UIBarButtonItem alloc]initWithCustomView:rightview];
    self.navigationItem.rightBarButtonItem=rightBaritem;

    rightview.userInteractionEnabled=YES;
    UITapGestureRecognizer * rightTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightClick)];
    [rightview addGestureRecognizer:rightTap];

}
-(void)tapLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 创建定位视图
-(void)Makelocation
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
    [_mapview updateLocationData:userLocation];
    self.codinate=userLocation.location.coordinate;
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}


#pragma mark
#pragma mark---事件
#pragma mark
#pragma mark 大头针重写方法
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{

    
    //自定义annotation
    NSString *AnnotationViewID = @"AnimatedAnnotation";
    VLXRecordAnnotationView *annotationView = nil;
    if (annotationView == nil) {
        annotationView = [[VLXRecordAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    NSString *title=[annotation title];
    
    for ( id obj in _allDataArr) {
        if ([obj isKindOfClass:[VLXRecordDataModel class]]) {
            VLXRecordDataModel *model = obj;
            if ([title isEqualToString:model.countNum]) {
                [annotationView createUIWithModel:model];
                break;
            }
        }else{
            VLXGuiJiModel *model = obj;
            if ([title isEqualToString:model.countNum]) {
                [annotationView createUIWithGuijiModel:model];
                break;
            }
        }
        
    }
    annotationView.canShowCallout=NO;
    return annotationView;
}
#pragma mark---大头针点击事件
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [self.mapview deselectAnnotation:view.annotation animated:YES];//让大头针可以重复点击
    NSLog(@"%@",view);
    NSString *title=[view.annotation title];
    for (id obj in _allDataArr) {
        
        if ([obj isKindOfClass:[VLXGuiJiModel class]]) {//如果travelroadid有值，表示轨迹
            VLXGuiJiModel *model = obj;
            if ([title isEqualToString:model.countNum]) {
                NSLog(@"%@",title);
                VLXRecordDetailVC *vc=[[VLXRecordDetailVC alloc] init];
                vc.travelRoadId=model.travelroadid;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            
        }else
        {
            VLXRecordDataModel *model = obj;
            if ([title isEqualToString:model.countNum]) {
                
                if (![NSString checkForNull:model.picurl]) {//表示图片
                    VLXRecordImageDetailVC *vc=[[VLXRecordImageDetailVC alloc] init];
                    vc.model=model;
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
                }
                else if (![NSString checkForNull:model.videourl])//表示视频
                {
                    VLXRecordVideoDetailVC *vc=[[VLXRecordVideoDetailVC alloc] init];
                    vc.model=model;
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
                } 
            }
           
        }
    }
    
}
#pragma mark
#pragma mark---delegate
#pragma mark

#pragma mark 创建左边的年份
-(void)createYearView
{
   
//   self.yearView =[[UIView alloc]initWithFrame:CGRectMake(0, ScaleHeight(338.5), 51, 48)];
    self.yearView =[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-215-49-64, 51, 48)];
    self.yearView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.yearView.bounds      byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight     cornerRadii:CGSizeMake(25, 24)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.yearView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.yearView.layer.mask = maskLayer;
    [self.view addSubview:self.yearView];

//创建图片
  self.yearImage =[UIImageView new];
     self.yearImage.image=[UIImage imageNamed:@"year"];//点击年份下拉view
    [self.yearView addSubview: self.yearImage];
    [ self.yearImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.yearView.mas_centerX);
        make.centerY.equalTo(self.yearView.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];


//创建选择后的年份
   self.selectYear=[UIView new];
    self.selectYear.backgroundColor=orange_color;
    [self.yearView addSubview:self.selectYear];

    self.selectYear.layer.masksToBounds=YES;
    self.selectYear.layer.cornerRadius=20;
    [self.selectYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.yearView.mas_centerX);
        make.centerY.equalTo(self.yearView.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);

    }];
    self.selectYear.hidden=YES;
//年份label
 self.yearLabel =[UILabel new];
//    self.yearLabel.text=@"2017";
    self.yearLabel.textColor=[UIColor whiteColor];
    self.yearLabel.font=[UIFont  systemFontOfSize:12];
    self.yearLabel.textAlignment=NSTextAlignmentCenter;
    [self.selectYear addSubview:self.yearLabel];
    [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.selectYear.mas_centerX);
        make.centerY.equalTo(self.selectYear.mas_centerY);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(12);

    }];


    //yearview的点击事件
    self.yearView.userInteractionEnabled=YES;
    UITapGestureRecognizer * yearTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickYear)];
    [self.yearView addGestureRecognizer:yearTap];

    self.nianView=[[VLXLTYearTB alloc]initWithFrame:CGRectMake(0, kScreenHeight-215-49-64, 74.5, 215)];
    [self.view addSubview:self.nianView];
    self.nianView.delegate=self;
    self.nianView.hidden=YES;
    __block VLXRecordViewController *blockSelf=self;
    self.nianView.yearBlock=^()
    {
        blockSelf.isShowYear=!blockSelf.isShowYear;
        if (blockSelf.isShowYear) {
            blockSelf.yearView.hidden=YES;
            blockSelf.nianView.hidden=NO;
        }else
        {
            blockSelf.yearView.hidden=NO;
            blockSelf.nianView.hidden=YES;
        }
    };
    
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

#pragma mark 自定义代理方法
-(void)tbSelcteyear:(NSInteger)year
{

    MyLog(@"123");
    self.isShowYear=!_isShowYear;

    self.nianView.hidden=YES;
    self.yearView.hidden=NO;
    self.selectYear.hidden=NO;
    self.yearLabel.text=[NSString stringWithFormat:@"%ld",(long)year];

    [self loadData];
}

#pragma mark---点击事件

#pragma mark 点击了年月
-(void)clickYear
{
    if (![NSString getDefaultToken]) {
        [ZYYCustomTool userToLoginWithVC:self];
        return;
    }
    _isShowYear=!_isShowYear;
    if (_isShowYear) {
        self.yearView.hidden=YES;
        self.nianView.hidden=NO;
    }else
    {
        self.yearView.hidden=NO;
        self.nianView.hidden=YES;
    }

    MyLog(@"clickYear");
}
#pragma mark--点击关闭按钮
-(void)clcikClose
{
    [self.shareView removeFromSuperview];
    [self .blackView removeFromSuperview];
}

#pragma mark
#pragma mark 三方分享调用
-(void)thirdShareWithUrl:(NSString * )url
{
    
    UIWindow*window=[UIApplication sharedApplication].keyWindow;
    UIView*blackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.blackView=blackView;
    blackView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.3];
    [window addSubview:blackView];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clcikClose)];
    [blackView addGestureRecognizer:tap];
    ShareBtnView*shareView=[[ShareBtnView alloc]init];
    shareView.delegate = self;
    __block VLXRecordViewController * blockSelf=self;;
    shareView.btnShareBlock=^(NSInteger tag)
    {
        
        
        MyLog(@"share:%ld",tag);
        //555,QQ 556,新浪微博 557,微信 558,朋友圈
        switch (tag) {
            case 555:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_QQ andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:@"V旅行" andDesc:@"看世界、V旅行！" andWebPageUrl:url];
                [blockSelf clcikClose];
                
            }
                break;
            case 556:
            {
                
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_Sina andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:@"V旅行" andDesc:@"看世界、V旅行！" andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            case 557:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatSession andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:@"V旅行" andDesc:@"看世界、V旅行！" andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            case 558:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:@"V旅行" andDesc:@"看世界、V旅行！" andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            default:
                break;
        }
    };
    [window addSubview:shareView];
    self.shareView=shareView;
    
}

#pragma mark 点击了右边的navi
-(void)rightClick
{
    MyLog(@"点击右上角分享按钮");
    if (![NSString getDefaultToken]) {
        [ZYYCustomTool userToLoginWithVC:self];
        return;
    }
    __block VLXRecordViewController *blockSelf=self;
    _isShowMenu=!_isShowMenu;
    if (_isShowMenu) {
        _menuView=[[VLXMenuPopView alloc] initWithFrame:CGRectZero andType:3];
        _menuView.menuBlock=^(NSInteger index)
        {
            blockSelf.isShowMenu=NO;
            if (index==0) {
                NSLog(@"分享");
            }else if (index==200)
            {
                /*
                 dic[@"lng1"]=[NSString stringWithFormat:@"%f",_leftTopCoord.longitude];//手机左上角经度
                 dic[@"lat1"]=[NSString stringWithFormat:@"%f",_leftTopCoord.latitude];//手机左上角纬度
                 dic[@"lng2"]=[NSString stringWithFormat:@"%f",_rightBottomCoord.longitude];//手机右下角经度
                 dic[@"lat2"]=[NSString stringWithFormat:@"%f",_rightBottomCoord.latitude];//手机右下角纬度
                 */
                NSLog(@"分享");
                [blockSelf thirdShareWithUrl:[NSString stringWithFormat:@"%@/shareurl/auth/travelRoadShare.json?token=%@&year=%@&lng1=%f&lat1=%f&lng2=%f&lat2=%f",ftpPath,[NSString getDefaultToken],[ZYYCustomTool checkNullWithNSString:blockSelf.yearLabel.text],blockSelf.leftTopCoord.longitude,blockSelf.leftTopCoord.latitude,blockSelf.rightBottomCoord.longitude,blockSelf.rightBottomCoord.latitude]];
//                NSLog(@"删除");
//                VLXCourseAlertView *alert=[[VLXCourseAlertView alloc] initWithFrame:CGRectZero andType:2];
//                [[UIApplication sharedApplication].keyWindow addSubview:alert];
//                alert.courseBlock=^(NSInteger tag)
//                {
//                    if (tag==101) {//确定
//                        [blockSelf loadDataWithDelete];
//                    }else if (tag==100)//取消
//                    {
//                       
//                    }
//                };
            }
        };
        [self.view addSubview:_menuView];
    }else
    {
        [_menuView removeFromSuperview];
    }
    
}

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

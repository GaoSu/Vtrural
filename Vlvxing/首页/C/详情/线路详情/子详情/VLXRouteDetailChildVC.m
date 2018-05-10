//
//  VLXRouteDetailChildVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/24.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXRouteDetailChildVC.h"
#import "VLXRouteDetailHeaderCell.h"
#import "VLXRouteSelectView.h"
#import "VLXRouteDetailBottomView.h"
#import "VLXCustomWKWebView.h"
#import "VLXHomeDetailModel.h"
#import "VLXInputOrderTableViewVC.h"//订单
#import "VLXLoginVC.h"
#import "VLXFarmYardDetailCell.h"
#import "VLXFarmYardMapVC.h"
@interface VLXRouteDetailChildVC ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)SDCycleScrollView *adScrollView;//广告轮播图
@property (nonatomic,strong)VLXRouteSelectView *selectView;
@property (nonatomic,strong)VLXRouteDetailBottomView *bottomView;
@property (nonatomic,strong)VLXCustomWKWebView *webView;


//
@property (nonatomic,strong)VLXHomeDetailModel *detailModel;//详情 数据
@property (nonatomic,assign)BOOL isCollect;//是否收藏
//

@end

@implementation VLXRouteDetailChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self loadData];
}

#pragma mark---数据
-(void)loadData
{
    if ([NSString getDefaultToken]) {
        [self loadCollectStatusWithType:1];
    }
//    [self loadCollectStatus];
    [self loadDetailData];
}
-(void)loadCollectStatusWithType:(int)type//判断收藏状态
{
    if (type == 1){
      [SVProgressHUD showWithStatus:@"正在加载"];
    }
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"token"]=[NSString getDefaultToken];
    dic[@"productId"]=_travelproductID;//产品id
    NSString * url=[NSString stringWithFormat:@"%@/ProCollectController/auth/isProCollect.json",ftpPath];
    
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
//        NSLog(@"%@",requestDic.mj_JSONString);
        if ([requestDic[@"status"] integerValue]==1) {
            if (type == 2 && [requestDic[@"data"] boolValue]) {
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            }else if (type == 3 &&[requestDic[@"data"] boolValue]==NO){
                [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
            }
            _isCollect=[requestDic[@"data"] boolValue];//记录收藏状态
            [_bottomView changeCollectStatus:[requestDic[@"data"] boolValue]];
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)collectProduct//收藏
{

    [SVProgressHUD showWithStatus:@"收藏中"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"token"]=[NSString getDefaultToken];
    dic[@"productId"]=_travelproductID;//产品id
    NSString * url=[NSString stringWithFormat:@"%@/ProCollectController/auth/saveProCollect.json",ftpPath];
    
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        //        NSLog(@"%@",requestDic.mj_JSONString);
        if ([requestDic[@"status"] integerValue]==1) {

            [self loadCollectStatusWithType:2];
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)cancleCollect//取消收藏
{
    [SVProgressHUD showWithStatus:@"取消收藏中"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"token"]=[NSString getDefaultToken];
    dic[@"productId"]=_travelproductID;//产品id
    NSString * url=[NSString stringWithFormat:@"%@/ProCollectController/auth/deleteProCollect.json",ftpPath];
    
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];

        if ([requestDic[@"status"] integerValue]==1) {

            [self loadCollectStatusWithType:3];
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)loadDetailData//详情数据
{
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"productId"]=[ZYYCustomTool checkNullWithNSString:_travelproductID];//即是每个商品的travelproductid
    dic[@"PathLng"]=[NSString getLongtitude];
    dic[@"PathLat"]=[NSString getLatitude];
    NSString * url=[NSString stringWithFormat:@"%@/ProProductController/productDetails.html",ftpPath];
    NSLog(@"%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        _detailModel=[[VLXHomeDetailModel alloc] initWithDictionary:requestDic error:nil];
        
        if (_detailModel.status.integerValue==1) {
            //刷新轮播图
            NSArray *imageUrlArr=[_detailModel.data.productbigpic componentsSeparatedByString:@","];
            _adScrollView.imageURLStringsGroup=imageUrlArr;

            NSString *resultStr =self.detailModel.data.introduction;
            self.webView.url=resultStr;

            [self.tableView reloadData];
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
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self createSelectView];
    //
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49-10) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.estimatedRowHeight=50;
    _tableView.rowHeight=UITableViewAutomaticDimension;//高度自适应
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"VLXRouteDetailHeaderCell" bundle:nil] forCellReuseIdentifier:@"VLXRouteDetailHeaderCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VLXFarmYardDetailCell" bundle:nil] forCellReuseIdentifier:@"VLXFarmYardDetailCellID"];
    //广告轮播图
    _adScrollView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, ScaleHeight(178)) delegate:self placeholderImage:[UIImage imageNamed:@"guanggao"]];
    _adScrollView.currentPageDotColor=[UIColor hexStringToColor:@"#06f400"];
    _adScrollView.pageControlAliment=SDCycleScrollViewPageContolAlimentCenter;
    _tableView.tableHeaderView=_adScrollView;
    //
    [self createWebView];
    //
    [self createBottomView];
}
-(void)createSelectView
{
    __block VLXRouteDetailChildVC *blockSelf=self;
    _selectView=[[VLXRouteSelectView alloc] initWithFrame:CGRectZero];
    _selectView.selectBlock=^(NSInteger index)
    {
        [SVProgressHUD showWithStatus:@"正在加载"];
        if (index==0) {

            blockSelf.webView.frame = CGRectMake(0, 0, kScreenWidth, 50);
            blockSelf.tableView.tableFooterView=blockSelf.webView;
            NSString *resultStr =blockSelf.detailModel.data.introduction;
            blockSelf.webView.url=resultStr;
             [SVProgressHUD dismiss];
            /*
            resultStr = [self setImageStr:resultStr];
            NSString *scriptStr =[NSString stringWithFormat:@"<script> var imgs = document.getElementsByName(\"cellImage\");var width = %f;for(var i=0;i<imgs.length;i++){var img = imgs[i];var iWidth = img.offsetWidth;var iHeight = img.offsetHeight;var height = iHeight * width / iWidth;img.style.width = width + 'px';img.style.height = height + 'px';} </script>",ScreenSize.width];
            
            resultStr = [NSString stringWithFormat:@"%@ %@",resultStr,scriptStr];
            [blockSelf.webView.webView loadHTMLString:resultStr baseURL:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
             */
            //
        }else if (index==1)
        {
            //刷新footer webView
//            [blockSelf.webView.webView loadHTMLString:[ZYYCustomTool checkNullWithNSString:blockSelf.detailModel.data.feesdescription] baseURL:nil];
            blockSelf.webView.frame = CGRectMake(0, 0, kScreenWidth, 50);
            blockSelf.tableView.tableFooterView=blockSelf.webView;
            NSString *resultStr =blockSelf.detailModel.data.feesdescription;
            blockSelf.webView.url=resultStr;
             [SVProgressHUD dismiss];
            /*
            resultStr = [self setImageStr:resultStr];
            NSString *scriptStr =[NSString stringWithFormat:@"<script> var imgs = document.getElementsByName(\"cellImage\");var width = %f;for(var i=0;i<imgs.length;i++){var img = imgs[i];var iWidth = img.offsetWidth;var iHeight = img.offsetHeight;var height = iHeight * width / iWidth;img.style.width = width + 'px';img.style.height = height + 'px';} </script>",ScreenSize.width];
            
            resultStr = [NSString stringWithFormat:@"%@ %@",resultStr,scriptStr];
            [blockSelf.webView.webView loadHTMLString:resultStr baseURL:nil];
           
             */
            //
        }else if (index==2)
        {
            //刷新footer webView
//            [blockSelf.webView.webView loadHTMLString:[ZYYCustomTool checkNullWithNSString:blockSelf.detailModel.data.notice] baseURL:nil];
            blockSelf.webView.frame = CGRectMake(0, 0, kScreenWidth, 50);
            blockSelf.tableView.tableFooterView=blockSelf.webView;
            NSString *resultStr =blockSelf.detailModel.data.notice;
            blockSelf.webView.url=resultStr;
            [SVProgressHUD dismiss];
            /*
            resultStr = [self setImageStr:resultStr];
            NSString *scriptStr =[NSString stringWithFormat:@"<script> var imgs = document.getElementsByName(\"cellImage\");var width = %f;for(var i=0;i<imgs.length;i++){var img = imgs[i];var iWidth = img.offsetWidth;var iHeight = img.offsetHeight;var height = iHeight * width / iWidth;img.style.width = width + 'px';img.style.height = height + 'px';} </script>",ScreenSize.width];
            
            resultStr = [NSString stringWithFormat:@"%@ %@",resultStr,scriptStr];
            [blockSelf.webView.webView loadHTMLString:resultStr baseURL:nil];
            [SVProgressHUD dismiss];
             */
            //
        }

    };
}

-(NSString *)setImageStr:(NSString *)urlStr{
    
    NSArray *textArray = [urlStr componentsSeparatedByString:@"<img"];
    NSMutableArray *newArray = [NSMutableArray array];
    for(int i=0;i<textArray.count;i++){
        NSString *str = textArray[i];
        
        if ([str isEqualToString:@""]) {
            continue;
        }
        
        str=[NSString stringWithFormat:@"<img name='cellImage'%@",str];
        [newArray addObject:str];
    }
    
    return [newArray componentsJoinedByString:@" "];
}

-(void)createBottomView
{
    __block VLXRouteDetailChildVC *blockSelf=self;
     _bottomView=[[VLXRouteDetailBottomView alloc] initWithFrame:CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight-49-64, kScreenWidth, 49)];
    [self.view addSubview:_bottomView];
    _bottomView.bottomBlock=^(NSInteger index)
    {
        NSLog(@"%ld",(long)index);
        if (index==0) {//咨询
            NSString *  nsStrIphone=@"iPhone";
            NSString *  nsStrIpod=@"iPod";
            NSString *  nsStrIpad=@"iPad";
            bool  bIsiPhone=false;
            bool  bIsiPod=false;
            bool  bIsiPad=false;
            bIsiPhone=[ZYYCustomTool  checkDevice:nsStrIphone];
            bIsiPod=[ZYYCustomTool checkDevice:nsStrIpod];
            bIsiPad=[ZYYCustomTool checkDevice:nsStrIpad];
            if (bIsiPod) {
                [SVProgressHUD showInfoWithStatus:@"无法拨打电话"];
                return ;
            }else if (bIsiPad)
            {
                [SVProgressHUD showInfoWithStatus:@"无法拨打电话"];
                return;
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",blockSelf.detailModel.data.tel]]];
        }else if (index==1)//收藏
        {
            if (![NSString getDefaultToken]) {
                [ZYYCustomTool userToLoginWithVC:blockSelf];
                return;
            }
            if (blockSelf.isCollect) {//已经收藏
                [blockSelf cancleCollect];
            }else//未收藏
            {
                if ([NSString getDefaultToken]) {
                    [blockSelf collectProduct];
                }else
                {
                    [SVProgressHUD showInfoWithStatus:@"请先登录!"];
                }
//                [blockSelf collectProduct];
            }
        }else if (index==2)//购买
        {
            
            if (![NSString getDefaultToken]) {
                [ZYYCustomTool userToLoginWithVC:blockSelf];
                return;
            }
            
            UIStoryboard *customSB=[UIStoryboard storyboardWithName:@"CustomSB" bundle:nil];
            VLXInputOrderTableViewVC *tripVC=[customSB instantiateViewControllerWithIdentifier:@"VLXInputOrderTableViewVCID"];
            tripVC.detailModel=blockSelf.detailModel;

            [blockSelf.navigationController pushViewController:tripVC animated:YES];
        }
    };
}
-(void)createWebView
{
    __block VLXRouteDetailChildVC *blockSelf=self;
    _webView=[[VLXCustomWKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];

    [SVProgressHUD showWithStatus:@"正在加载"];
    _webView.WkBlock=^(CGFloat height)
    {
        blockSelf.webView.frame=CGRectMake(0, 0, kScreenWidth, height);
        blockSelf.tableView.tableFooterView=blockSelf.webView;

    };
}
#pragma mark
#pragma mark---事件
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_detailModel.data.isfarmyard.integerValue==1) {
        return 2;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        VLXRouteDetailHeaderCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXRouteDetailHeaderCellID" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (_detailModel) {
            [cell creaetUIWithModel:_detailModel.data];
        }
        return cell;
    }
    else if (indexPath.row==1)
    {
        VLXFarmYardDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXFarmYardDetailCellID" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell createUIWithModel:_detailModel];
        return cell;
    }
    return nil;
//    VLXRouteDetailHeaderCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXRouteDetailHeaderCellID" forIndexPath:indexPath];
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    if (_detailModel) {
//        [cell creaetUIWithModel:_detailModel.data];
//    }
//    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return _selectView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    if (indexPath.row == 1) {
        [SVProgressHUD showWithStatus:@""];
        VLXFarmYardMapVC *mapVC=[[VLXFarmYardMapVC alloc] init];
        mapVC.detailModel=_detailModel;
        [self.navigationController pushViewController:mapVC animated:YES];
    }
}
#pragma mark
#pragma mark---tableView delegate

#pragma mark
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

//
//  VLXChooseAreaVC.m
//  Vlvxing
//
//  Created by Michael on 17/5/26.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXChooseAreaVC.h"
#import "VLXGPSLocationVC.h"//左边gps的view
#import "VLXDingZhiCell.h"//定制游cell
#import "VLXchooseAreaSearchVC.h"

@interface VLXChooseAreaVC ()<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)UISearchController * searchControll;
@property (nonatomic,strong)VLXChooseAreaModel *areaModel;
@property (nonatomic,assign)NSInteger chooseFlag;
@end

@implementation VLXChooseAreaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    _chooseFlag=1;//默认是1
    //
    [self createUI];
    [self.view addSubview:self.tableview];
    [self createHeader];
    [self loadData];

}
#pragma mark---数据
-(void)loadData//定制游中的目的地（包括国内外市）
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    

    NSString * url=[NSString stringWithFormat:@"%@/sysArea/getAllTheCity.json",ftpPath];
    
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
//        NSLog(@"%@",requestDic.mj_JSONString);
        _areaModel=[[VLXChooseAreaModel alloc] initWithDictionary:requestDic error:nil];
        if (_areaModel.status.integerValue==1) {
            [self.tableview reloadData];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
#pragma mark
#pragma mark 创建header
-(void)createHeader
{
    UIView * head=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60.5)];
    head.backgroundColor=[UIColor whiteColor];
    self.tableview.tableHeaderView=head;
    //当前定位城市
    UIView * cityview=[UIView new];

    cityview.backgroundColor=[UIColor hexStringToColor:@"dddddd"];
    [head addSubview:cityview];
    cityview.layer.masksToBounds=YES;
    cityview.layer.cornerRadius=3;
    [cityview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleWidth(15));
        make.top.mas_equalTo(ScaleHeight(23));
        make.height.mas_equalTo([[NSString getCity] sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 14)].width);
        make.width.mas_equalTo(60);
    }];
    //city里面的文字
    UILabel * citylabel=[UILabel new];
    citylabel.text=[NSString getCity];
    citylabel.textColor=[UIColor hexStringToColor:@"666666"];
    citylabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [cityview addSubview:citylabel];
    [citylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cityview.mas_centerX);
make.centerY.equalTo(cityview.mas_centerY);
        make.width.mas_equalTo([[NSString getCity] sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 14)].width);
        make.height.mas_equalTo(14);
    }];


}

-(void)createUI
{
    [self setNav];
    [self loadGPS];
    [self createSearch];
}
-(void)createSearch
{
    //搜索结果
    __block VLXChooseAreaVC *blockSelf=self;
    VLXchooseAreaSearchVC *resultVC= [[VLXchooseAreaSearchVC alloc] init];
    resultVC.resultBlock=^(VLXSearchKeyWordDataModel *model)
    {
        NSLog(@"%@",model);
        if (blockSelf.areaBlock) {
            blockSelf.areaBlock((VLXChooseAreaListModel *)model);
        }
        [blockSelf.navigationController popViewControllerAnimated:YES];
    };
    //
    
    self.searchControll=[[UISearchController alloc]initWithSearchResultsController:resultVC];
    
    self.searchControll.delegate=self;
    self.searchControll.searchResultsUpdater=self;
    self.searchControll.searchBar.placeholder=@"搜索国家、城市";
//self.searchControll.dimsBackgroundDuringPresentation = YES;
    self.searchControll.hidesNavigationBarDuringPresentation = NO;
    [self.view addSubview:self.searchControll.searchBar];
self.searchControll.searchBar.tintColor = [UIColor hexStringToColor:@"444444"];
        self.searchControll.searchBar.barTintColor =  [UIColor hexStringToColor:@"f3f3f4"];
}

- (void)willPresentSearchController:(UISearchController *)searchController{

    // 修改UISearchBar右侧的取消按钮文字颜色及背景图片

    for (id searchbuttons in [[self.searchControll.searchBar subviews][0]subviews]){ //只需在此处修改即可

        if ([searchbuttons isKindOfClass:[UIButton class]]) {

            UIButton *cancelButton = (UIButton*)searchbuttons;

            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//            cancelButton.titleLabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        }
        
    }
    
}
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {

    //刷新表格

    //    [self.tableView reloadData];
    
    MyLog(@"修改吧:%@",searchController.searchBar.text);
    VLXchooseAreaSearchVC *vc=(VLXchooseAreaSearchVC *)searchController.searchResultsController;
    vc.searchStr=[ZYYCustomTool checkNullWithNSString:searchController.searchBar.text];
    
}


-(void)loadGPS
{

    __block VLXChooseAreaVC *blockSelf=self;
    VLXGPSLocationVC * gps=[[VLXGPSLocationVC alloc]init];
    [self addChildViewController:gps];
    self.view.frame=CGRectMake(0, 44, 100, 458);
    [self.view addSubview:gps.view];
    gps.gpsBlock=^(NSInteger index)
    {
        blockSelf.chooseFlag=index;
        [blockSelf.tableview reloadData];
    };

}
- (void)setNav{

    self.title = @"选择地区";
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_chooseFlag==1) {
        return _areaModel.data.guonei.count;
    }else if (_chooseFlag==2)
    {
        return _areaModel.data.foreign.count;
    }
    return 0;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VLXDingZhiCell * dingzhi=[VLXDingZhiCell cellWithTableView:tableView];
    if (_chooseFlag==1) {
        VLXChooseAreaListModel *model=_areaModel.data.guonei[indexPath.row];
        dingzhi.leftlabel.text=[ZYYCustomTool checkNullWithNSString:model.areaname];
        dingzhi.midlabel.text=[ZYYCustomTool checkNullWithNSString:model.areanamewithspell];
    }else if (_chooseFlag==2)
    {
        VLXChooseAreaListModel *model=_areaModel.data.foreign[indexPath.row];
        dingzhi.leftlabel.text=[ZYYCustomTool checkNullWithNSString:model.areaname];
        dingzhi.midlabel.text=[ZYYCustomTool checkNullWithNSString:model.areanamewithspell];
    }
    return dingzhi;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    if (_chooseFlag==1) {
        VLXChooseAreaListModel *model=_areaModel.data.guonei[indexPath.row];
        if (_areaBlock) {
            _areaBlock(model);
        }
    }else if (_chooseFlag==2)
    {
        VLXChooseAreaListModel *model=_areaModel.data.foreign[indexPath.row];
        if (_areaBlock) {
            _areaBlock(model);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITableView * )tableview
{

    if (!_tableview) {
//        _tableview=[[UITableView alloc]initWithFrame:CGRectMake(ScaleWidth(110), 44, ScaleWidth(264.5), ScreenHeight) style:UITableViewStylePlain];
        _tableview=[[UITableView alloc]initWithFrame:CGRectMake(110, 44, kScreenWidth-110, ScreenHeight) style:UITableViewStylePlain];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        _tableview.separatorStyle=UITableViewCellSelectionStyleNone;
    }

    return _tableview;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

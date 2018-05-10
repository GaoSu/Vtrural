//
//  VLXMyDingZhiVC.m
//  Vlvxing
//
//  Created by Michael on 17/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXMyDingZhiVC.h"
#import "VLXDingZhiTableViewCell.h"
#import "VLXDingZhiModel.h"
#import "VLXMyDingZhiModel.h"
#import "VLXDingZhiAlert.h"//定制的alertview
#import "VLXDingzhiDetailVC.h"
@interface VLXMyDingZhiVC ()<UITableViewDelegate,UITableViewDataSource,VLXDingZhiAlertDelegate,TitleButtonNoDataViewDelegate>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)UIView * bottomView;
@property(nonatomic,strong)UIImageView * quanxuanimageview;
@property(nonatomic,strong)UIButton * delectBtn;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong) UIButton * rightBtn;//navigationitem
@property(nonatomic,assign) BOOL naviSelect;
@property(nonatomic,strong) VLXDingZhiAlert * dingzhi;
@property(nonatomic,strong)UIView * bgview;
@property(nonatomic,strong)UIWindow * keywindow;
@property(nonatomic,assign)BOOL quanxuanSelect;
@property (nonatomic,strong)VLXMyDingZhiModel *dingzhiModel;//数据
@property (nonatomic,strong)TitleButtonNoDataView *nodateView;

@end

@implementation VLXMyDingZhiVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    _naviSelect=NO;
    self.dataArray=[NSMutableArray array];

    //
//    [self fakeData];
    [self createUI];
//    [self loadData];

}
-(void)createAlertVIew
{
  self.dingzhi =[[VLXDingZhiAlert alloc]initWithFrame:CGRectMake(ScaleWidth(27.5), 193, ScaleWidth(320), 149)];
    self.dingzhi.delegate=self;
    self.bgview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.bgview.backgroundColor=[UIColor blackColor];
    self.bgview.alpha=0.5;
    UIWindow * keywindow=[UIApplication sharedApplication].keyWindow;
    self.keywindow=keywindow;
    [keywindow addSubview:self.bgview];
    [keywindow addSubview:self.dingzhi];
//    self.bgview.hidden=YES;
//    self.dingzhi.hidden=YES;
    self.bgview.userInteractionEnabled=YES;
    UITapGestureRecognizer * windowtap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(windowClick)];
    [self.bgview addGestureRecognizer:windowtap];

}
-(void)loadData
{
    //重置控制model数据
    [_dataArray removeAllObjects];
    //
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"token"]=[NSString getDefaultToken];//
    NSString * url=[NSString stringWithFormat:@"%@/ProCustomController/auth/getProCustom.json",ftpPath];
    [SVProgressHUD showWithStatus:@"正在加载"];
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        
        _dingzhiModel=[[VLXMyDingZhiModel alloc] initWithDictionary:requestDic error:nil];
        if (_dingzhiModel.status.integerValue==1) {
            //创建控制界面的model
            for (int i=0; i<_dingzhiModel.data.count; i++) {
                VLXDingZhiModel * model=[[VLXDingZhiModel alloc]init];
                model.selected=NO;
                model.imagename=@"dingzhi-line";
                [self.dataArray addObject:model];
            }
            if(self.dingzhiModel.data.count==0)
            {
                if(!_nodateView)
                {
                    _nodateView=[[TitleButtonNoDataView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, kScreenHeight-64)];
                    _nodateView.backgroundColor=[UIColor whiteColor];
                    _nodateView.delegate=self;
                    _nodateView.titleText=@"暂无数据";
                    //                    [self.tableView addSubview:_nodateView];
                    _tableview.tableFooterView=_nodateView;
                    _nodateView.noDataButtonIsHidden=NO;
                    //                    _nodateView.nobtnTitle=@"立即设置";
                }
                [self.tableview reloadData];
            }
            else
            {
                if(_nodateView)
                {
                    [_nodateView removeFromSuperview];
                    _nodateView=nil;
                    _tableview.tableFooterView=nil;
                }
                [self.tableview reloadData];
            }
//            [self.tableview reloadData];
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
////给假数据
//-(void)fakeData
//{
//    for (int i=0; i<3; i++) {
//        VLXDingZhiModel * model=[[VLXDingZhiModel alloc]init];
//        model.selected=NO;
//        model.imagename=@"dingzhi-line";
//        [self.dataArray addObject:model];
//    }
//}

-(void)createUI
{
    [self setNav];
    [self.view addSubview:self.tableview];
    [self createBottomView];

}
- (void)setNav{
    self.title = @"我的定制";
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
    //右边按钮
    self.rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame=CGRectMake(0, 0, 30, 20);
    [self.rightBtn setTitleColor:[UIColor hexStringToColor:@"ea5413"] forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [self.rightBtn addTarget:self action:@selector(rightBarClick) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem * rightBar=[[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem=rightBar;

}

#pragma mark 创建底部空间
-(void)createBottomView
{
    self.bottomView=[[UIView  alloc]initWithFrame:CGRectMake(0, ScreenHeight-64-49, ScreenWidth, 49)];
    self.bottomView.backgroundColor=[UIColor hexStringToColor:@"ffffff"];
    [self.view addSubview:self.bottomView];
//全选image
    self.quanxuanimageview=[[UIImageView alloc]initWithFrame:CGRectMake(ScaleWidth(12), ScaleHeight(10.5), 28, 28)];
//    self.quanxuanimageview.layer.masksToBounds=YES;
//    self.quanxuanimageview.layer.cornerRadius=14;
    self.quanxuanimageview.image=[UIImage imageNamed:@"default-red"];
    [self.bottomView addSubview:self.quanxuanimageview];
//全选label
    UILabel * quanxuanLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.quanxuanimageview.frame)+ScaleWidth(9.5), ScaleHeight(15.5), 40, 19)];
    quanxuanLabel.text=@"全选";
    quanxuanLabel.textColor=[UIColor hexStringToColor:@"111111"];
    quanxuanLabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:19];
    [self.bottomView addSubview:quanxuanLabel];


    //全选的点击域
    UIButton * quanxuanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    quanxuanBtn.frame=CGRectMake(0, 0, ScreenWidth/4, 49);
    [quanxuanBtn addTarget:self action:@selector(quanxuanBtnclick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:quanxuanBtn];

//删除btn
    self.delectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.delectBtn.frame=CGRectMake(ScreenWidth-80, 0, 80, 49);
//    [self.delectBtn setBackgroundColor:[UIColor hexStringToColor:@"c1c1c1"]];
    [self.delectBtn setBackgroundColor:orange_color];
    [self.delectBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.delectBtn setTitleColor:[UIColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];
    [self.delectBtn addTarget:self action:@selector(Btnclick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.delectBtn];
    //默认隐藏底部选择
    _bottomView.hidden=YES;
}
#pragma mark---title no data delegate
-(void)titleButtonNoDataView:(TitleButtonNoDataView *)view didClickButton:(UIButton *)button
{
    NSLog(@"titleButtonNoDataView");
    [self loadData];
}
#pragma mark
#pragma  mark 代理方法点击事件

-(void)tapLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarClick
{

    if (self.naviSelect) {
        for (VLXDingZhiModel * model in self.dataArray) {
            model.imagename=@"dingzhi-line";
        }
        [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        self.naviSelect=NO;
        //改变界面显示
        _bottomView.hidden=YES;
        
        _tableview.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);//改变高度
        
    }else
    {
        for (VLXDingZhiModel * model in self.dataArray) {
            model.imagename=@"default-blue";
            model.selected=NO;
        }
        [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        self.naviSelect=YES;
        //改变界面显示
        _bottomView.hidden=NO;
        _tableview.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-CGRectGetHeight(_bottomView.frame));//改变高度
        
    }
//    NSLog(@"%@",_dataArray);
     [self.tableview reloadData];
}
-(void)Btnclick
{
    MyLog(@"删除");
    NSLog(@"%@",_dataArray);
    [self createAlertVIew];


//    self.bgview.hidden=NO;
//    self.dingzhi.hidden=NO;
}
//全选Btn
-(void)quanxuanBtnclick
{
    if (self.naviSelect) {
        if (_quanxuanSelect) {
            self.quanxuanSelect=NO;
            for (VLXDingZhiModel * model in self.dataArray) {
                model.selected=NO;
                model.imagename=@"default-blue";
            }
//            _quanxuanimageview.image=[UIImage imageNamed:@"pitch-on-red"];
            _quanxuanimageview.image=[UIImage imageNamed:@"default-red"];
        }else
        {
            for (VLXDingZhiModel * model in self.dataArray) {
                model.selected=YES;
                model.imagename=@"pitch-on-blue";
            }
            self.quanxuanSelect=YES;
//            _quanxuanimageview.image=[UIImage imageNamed:@"default-red"];
            _quanxuanimageview.image=[UIImage imageNamed:@"pitch-on-red"];
        }
        MyLog(@"全选");
    }else
    {

    }
//    NSLog(@"%@",_dataArray);
    [self.tableview reloadData];
}
//背景的点击事件
-(void)windowClick
{
//    self.bgview.hidden=YES;
//    self.dingzhi.hidden=YES;
    [self.bgview removeFromSuperview];
    [self.dingzhi removeFromSuperview];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VLXDingZhiModel * model;
    if (self.dataArray.count>0) {
        model=self.dataArray[indexPath.section];
    }
    VLXDingZhiTableViewCell * cell=[VLXDingZhiTableViewCell cellWithTableView:tableView];
    cell.leftImage.image=[UIImage imageNamed:model.imagename];
    //数据
    if (_dingzhiModel.data&&_dingzhiModel.data.count>indexPath.row) {
        VLXMyDingZhiDataModel *dataModel=_dingzhiModel.data[indexPath.section];
        cell.rtoplabel.text=[ZYYCustomTool checkNullWithNSString:dataModel.destination];//目的地
        cell.rmidlabel.text=[ZYYCustomTool checkNullWithNSString:dataModel.departure];//出发地
        cell.rbottomlabel.text=[[NSString stringWithFormat:@"%@",dataModel.time] RwnTimeExchange];//出行时间
    }
    //
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 102;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section

{
    return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 8;
    }
    return 0.0001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_naviSelect) {

        VLXDingZhiModel * model=self.dataArray[indexPath.section];
        if (model.selected) {
            model.imagename=@"default-blue";
            model.selected=NO;
        }else
        {
            model.imagename=@"pitch-on-blue";
            model.selected=YES;
        }
        [self.tableview reloadData];

    }else
    {
        NSLog(@"%ld",indexPath.row);
        VLXDingzhiDetailVC *detailVC=[[VLXDingzhiDetailVC alloc] init];
        if (_dingzhiModel.data&&_dingzhiModel.data.count>indexPath.row) {
            VLXMyDingZhiDataModel *dataModel=_dingzhiModel.data[indexPath.section];
            detailVC.model=dataModel;
        }
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark 弹窗的代理方法
-(void)BringBackValue:(NSInteger)num
{
    [self.bgview removeFromSuperview];
    [self.dingzhi removeFromSuperview];
    if (num==0) {//确定
//        [SVProgressHUD showSuccessWithStatus:@"点击左边"];
        NSMutableArray *deleteArray=[NSMutableArray array];//需要删除的定制游数据
        for (int i=0; i<_dataArray.count; i++) {
            VLXDingZhiModel *model=_dataArray[i];
            if (model.selected==YES) {
                VLXMyDingZhiDataModel *dataModel=_dingzhiModel.data[i];
                [deleteArray addObject:[NSString stringWithFormat:@"%@",dataModel.customswimid]];
            }
        }
        NSMutableDictionary * dic=[NSMutableDictionary dictionary];
        
        dic[@"token"]=[NSString getDefaultToken];//
        dic[@"ids"]=[deleteArray componentsJoinedByString:@","];//定制游id（customswimid）如“1,2,3”中间用”,”
        NSString * url=[NSString stringWithFormat:@"%@/ProCustomController/auth/deleteProCustom.json",ftpPath];
        NSLog(@"%@",dic);
        [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
            [SVProgressHUD dismiss];
            if ([requestDic[@"status"] integerValue]==1) {
                [self loadData];
            }else
            {
                [SVProgressHUD showErrorWithStatus:msg];
            }
            
        } failure:^(NSString *errorInfo) {
            [SVProgressHUD dismiss];
            
        }];
        
    }else//取消
    {
//        [SVProgressHUD showSuccessWithStatus:@"点击右边"];
 

    }



}


#pragma mark 懒加载
-(UITableView * )tableview
{
    if (!_tableview) {
        _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        _tableview.backgroundColor=[UIColor hexStringToColor:@"f3f3f4"];

        _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
           }
    return _tableview;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

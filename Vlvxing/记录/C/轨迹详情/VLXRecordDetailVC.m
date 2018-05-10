//
//  VLXRecordDetailVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/3.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXRecordDetailVC.h"
#import "VLXRecordHeaderCell.h"
#import "VLXRecordMarkCell.h"
#import "VLXRecordDetailModel.h"
#import "VLXRecordImageDetailVC.h"
#import "VLXRecordVideoDetailVC.h"
#import "VLXMenuPopView.h"
#import "VLXCourseAlertView.h"
#import "VLXRecordDetailLineVC.h"
#import "ShareBtnView.h"
@interface VLXRecordDetailVC ()<UITableViewDelegate,UITableViewDataSource,ShareBtnViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)VLXRecordDetailModel *detailModel;
@property (nonatomic,strong)VLXMenuPopView *menuView;
@property (nonatomic,assign)BOOL isShowMenu;
@property(nonatomic,weak)UIView * blackView;
@property(nonatomic,weak)ShareBtnView*shareView;
@end

@implementation VLXRecordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isShowMenu=NO;
    [self createUI];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}
#pragma mark---数据
-(void)loadData
{
    [SVProgressHUD showWithStatus:@"正在加载"];

    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"token"]=[NSString getDefaultToken];//
    dic[@"travelRoadId"]=self.travelRoadId;
    NSString * url=[NSString stringWithFormat:@"%@/TraRoadController/auth/getTraRoad.html",ftpPath];
    NSLog(@"%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
//                NSLog(@"%@",requestDic.mj_JSONString);
        _detailModel=[[VLXRecordDetailModel alloc] initWithDictionary:requestDic error:nil];
        if (_detailModel.status.integerValue==1) {
            [self.tableView reloadData];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)loadDataWithDelete//删除旅途（需要将途中的点也删除）  将整个轨迹删除
{
    [SVProgressHUD showWithStatus:@"正在删除"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"token"]=[NSString getDefaultToken];//
    dic[@"travelRoadId"]=[NSString stringWithFormat:@"%@",_detailModel.data.travelroadid];
    NSString * url=[NSString stringWithFormat:@"%@/TraRoadController/auth/deleteTraRoad.html",ftpPath];
    NSLog(@"%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        //        NSLog(@"%@",requestDic.mj_JSONString);
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        if ([requestDic[@"status"] integerValue]==1) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)loadDataWithDeleteEvent:(NSString *)pathinfoID//删除轨迹中的单个事件
{
    [SVProgressHUD showWithStatus:@"正在删除"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"token"]=[NSString getDefaultToken];//
    dic[@"pathInfoId"]=[ZYYCustomTool checkNullWithNSString:pathinfoID];
    NSString * url=[NSString stringWithFormat:@"%@/TraRoadController/auth/deletePathinfo.html",ftpPath];
    NSLog(@"%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        //        NSLog(@"%@",requestDic.mj_JSONString);
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        if ([requestDic[@"status"] integerValue]==1) {
            [self loadData];// 重新刷新数据
            
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
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
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
    [_tableView registerNib:[UINib nibWithNibName:@"VLXRecordHeaderCell" bundle:nil] forCellReuseIdentifier:@"VLXRecordHeaderCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VLXRecordMarkCell" bundle:nil] forCellReuseIdentifier:@"VLXRecordMarkCellID"];
}
- (void)setNav{
    

    self.view.backgroundColor=[UIColor whiteColor];
    //左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(tapLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    //右边按钮
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
    __block VLXRecordDetailVC * blockSelf=self;;
    shareView.btnShareBlock=^(NSInteger tag)
    {
     
        NSString *firStr = [NSString stringWithFormat:@"%@",blockSelf.detailModel.data.travelroadtitle];
        NSString *secondStr = [NSString stringWithFormat:@"%@",blockSelf.detailModel.data.startareaanddestination];
        NSString *titleStr;
        NSString *contentStr;
        if ([NSString checkForNull:firStr]) {
           titleStr = @"V旅行";
        }else{
            titleStr = firStr;
        }
        
        if ([NSString checkForNull:secondStr]) {
            contentStr = @"看世界、V旅行！";
        }else{
            contentStr = secondStr;
        }
        
        MyLog(@"share:%ld",tag);
        //555,QQ 556,新浪微博 557,微信 558,朋友圈
        switch (tag) {
            case 555:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_QQ andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:titleStr andDesc:contentStr andWebPageUrl:url];
                [blockSelf clcikClose];
                
            }
                break;
            case 556:
            {
                
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_Sina andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:titleStr andDesc:contentStr andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            case 557:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatSession andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:titleStr andDesc:contentStr andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            case 558:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:titleStr andDesc:contentStr andWebPageUrl:url];
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
#pragma mark--点击关闭按钮
-(void)clcikClose
{
    [self.shareView removeFromSuperview];
    [self .blackView removeFromSuperview];
}
#pragma mark---事件
-(void)tapLeftButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightClick
{
    MyLog(@"点击右上角分享按钮");
    __block VLXRecordDetailVC *blockSelf=self;
    _isShowMenu=!_isShowMenu;
    if (_isShowMenu) {
        _menuView=[[VLXMenuPopView alloc] initWithFrame:CGRectZero andType:1];
        _menuView.menuBlock=^(NSInteger index)
        {
            blockSelf.isShowMenu=NO;
            if (index==0) {
                NSLog(@"分享");
                [blockSelf thirdShareWithUrl:[[NSString stringWithFormat:@"%@/shareurl/xianludetailshare.json?travelRoadId=%@",ftpPath,blockSelf.travelRoadId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else if (index==1)
            {
                NSLog(@"删除");
                VLXCourseAlertView *alert=[[VLXCourseAlertView alloc] initWithFrame:CGRectZero andType:2];
                [[UIApplication sharedApplication].keyWindow addSubview:alert];
                alert.courseBlock=^(NSInteger tag)
                {
                    if (tag==101) {//确定
                        [blockSelf loadDataWithDelete];
                    }else if (tag==100)//取消
                    {
                        
                    }
                };
            }
        };
        [self.view addSubview:_menuView];
    }else
    {
        [_menuView removeFromSuperview];
    }
}
#pragma mark
#pragma mark---delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return _detailModel.data.pathinfos.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block VLXRecordDetailVC *blockSelf=self;
    if (indexPath.section==0) {
        VLXRecordHeaderCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXRecordHeaderCellID" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (_detailModel) {
            [cell createUIWithModel:_detailModel.data];
        }
        cell.addressBlock=^()
        {
            NSLog(@"%@",blockSelf.detailModel);
            VLXRecordDetailLineVC *lineVC=[[VLXRecordDetailLineVC alloc] init];
            lineVC.detailModel=blockSelf.detailModel;
            [blockSelf.navigationController pushViewController:lineVC animated:YES];
        };
        return cell;
    }else if (indexPath.section==1)
    {
        VLXRecordMarkCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXRecordMarkCellID" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (_detailModel.data.pathinfos&&_detailModel.data.pathinfos.count>indexPath.row) {
            VLXRecordDetailInfoModel *model=_detailModel.data.pathinfos[indexPath.row];
            [cell createUIWithModel:model];
        }
        cell.cellBlock=^()
        {

            VLXCourseAlertView *alert=[[VLXCourseAlertView alloc] initWithFrame:CGRectZero andType:2];
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
            alert.courseBlock=^(NSInteger tag)
            {
                if (tag==101) {//确定
                    VLXRecordDetailInfoModel *model=blockSelf.detailModel.data.pathinfos[indexPath.row];
                    [blockSelf loadDataWithDeleteEvent:[NSString stringWithFormat:@"%@",model.pathinfoid]];
                }else if (tag==100)//取消
                {
                    
                }
            };
            

        };
        return cell;
    }
    
    return nil;
    
}
//头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
        headerView.backgroundColor=[UIColor whiteColor];
        //
        UIView *topLine=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 8)];
        topLine.backgroundColor=backgroun_view_color;
        [headerView addSubview:topLine];
        //
        UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(topLine.frame), kScreenWidth, 44)];
        titleLab.text=@"标注点";
        titleLab.textColor=[UIColor hexStringToColor:@"#313131"];
        titleLab.font=[UIFont systemFontOfSize:16];
        titleLab.textAlignment=NSTextAlignmentLeft;
        [headerView addSubview:titleLab];
        //
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 52-0.5, kScreenWidth, 0.5)];
        line.backgroundColor=separatorColor1;
        [headerView addSubview:line];
        return headerView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 52.0;
    }
    return 0.0001;
}
//尾视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}
//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return;
    }
    if (_detailModel.data.pathinfos&&_detailModel.data.pathinfos.count>indexPath.row) {
        VLXRecordDetailInfoModel *model=_detailModel.data.pathinfos[indexPath.row];
        if (![NSString checkForNull:model.picurl]) {//图片
            VLXRecordImageDetailVC *vc=[[VLXRecordImageDetailVC alloc] init];
            //                        vc.model=model;
            vc.detailModel=model;
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            VLXRecordVideoDetailVC *vc=[[VLXRecordVideoDetailVC alloc] init];
            vc.detailModel=model;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }

}
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

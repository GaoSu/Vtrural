
//
//  VLX_guanzhutixingViewController.m
//  Vlvxing
//
//  Created by grm on 2017/10/30.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_guanzhutixingViewController.h"//关注提醒

#import "VLX_guanzhutixing_TableViewCell.h"
#import "VLX_plwdModel.h"
#import "VLX_other_MainPageVC.h"

@interface VLX_guanzhutixingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * M_TableVw;//main
/**page**/
@property(nonatomic,assign)NSInteger currentPage;
/**数据源**/
@property(nonatomic,strong)NSMutableArray *mtaArray;
@end

@implementation VLX_guanzhutixingViewController

- (NSMutableArray *)mtaArray{
    
    if (_mtaArray == nil) {
        _mtaArray = [NSMutableArray array];
    }
    return _mtaArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"index.row:%ld",_xxx);
    // Do any additional setup after loading the view.
    
    self.title = @"关注提醒";
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton1) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton1)];

    
    
//    //UI
    _M_TableVw = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _M_TableVw.delegate = self;
    _M_TableVw.dataSource = self;
    _M_TableVw.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    _M_TableVw.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 1;
        [self loadData];
    }];
    _M_TableVw.mj_footer = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage += 1;
        [self loadData];
    }];
    [self.view addSubview:_M_TableVw];
    
    _currentPage = 1;
    [self loadData];
    
    
    
}

- (void)loadData{
    
        
        [SVProgressHUD showWithStatus:@""];
        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
        NSString *myselfUserId = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];//获取正式的用户id,真实的用户id
        
        //    /userfollow/systemMessage.json?currentPage=1&loginUserid=1&type=2
        NSString * url= [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/userfollow/systemMessage.json"];
        
        NSMutableDictionary * para = [NSMutableDictionary dictionary];
        
        
        para[@"currentPage"] = [NSString stringWithFormat:@"%ld",_currentPage];
        para[@"loginUserid"] = myselfUserId;
        para[@"type"]=@2;
        NSLog(@"数据参数:%@",para);
    if (_currentPage == 1) {
        [self.mtaArray removeAllObjects];
    }
        [HMHttpTool get:url params:para success:^(id responseObj) {
            NSLog_JSON(@"gz:::::%@",responseObj);
            if ([responseObj[@"status"] isEqual:@1]) {
                NSArray *arrary = responseObj[@"data"];
                if (arrary.count <= 10) {
                    [_M_TableVw.mj_footer setState:MJRefreshStateNoMoreData];
                }
                for (NSDictionary * dic in responseObj[@"data"]) {
                    VLX_plwdModel * model = [VLX_plwdModel infoListWithDict:dic[@"member"]];
                    model.createTime = dic[@"createTime"];
                    [self.mtaArray addObject:model];
                }
                
            }
            [self.M_TableVw reloadData];
//            [self.tableView1 reloadData];
//
            [self.M_TableVw.mj_header endRefreshing];
            [self.M_TableVw.mj_footer endRefreshing];
            
            [SVProgressHUD dismiss];
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];
        }];
        
}

-(void)tapLeftButton1{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.mtaArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * strID = @"message_comm_ID";
 
        VLX_guanzhutixing_TableViewCell * cell = [_M_TableVw dequeueReusableCellWithIdentifier:strID];
        
        if (!cell) {
            cell = [[VLX_guanzhutixing_TableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    
        [cell FillWithModel:self.mtaArray[indexPath.row]];
        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    VLX_other_MainPageVC * vc = [[VLX_other_MainPageVC alloc]init];
    vc.typee = 0;
    VLX_plwdModel *model = self.mtaArray[indexPath.row];
    vc.userDic = [NSDictionary dictionaryWithObject:model.userid forKey:@""];
    vc.nickNamme = model.usernick;
    
    [self.navigationController pushViewController:vc animated:YES];
}

//#pragma 左划删除左滑删除
////左划删除的两个方法
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    editingStyle = UITableViewCellEditingStyleDelete;//此处的EditingStyle可等于任意UITableViewCellEditingStyle，该行代码只在iOS8.0以前版本有作用，也可以不实现。
//
//
//}
//////只允许第xx组左划删除
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    return YES;
//}
//-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除提醒信息" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {//title可自已定义
//        //        NSMutableArray * GrmArray = [NSMutableArray array];什么鬼方法,崩溃
//        //        GrmArray = addXiaozuArray[indexPath.section];
//
//        //        if(addXiaozuArray.count > 1){
//        //            //1后台删除
//        //            NSDictionary * dicID = addXiaozuArray[ indexPath.row];
//        //            NSString * url = [NSString stringWithFormat:@"%@%@",BaseUrl,@"group_quit"];
//        //            [HMHttpTool get:url params:@{@"groupId":dicID[@"groupId"]} success:^(id responseObj) {
//        //                NSLog(@"成功删除%@",responseObj);
//        //            } failure:^(NSError *error) {
//        //                NSLog(@"删除失败%@",error);
//        //            }];
//        //            //2本地数据删除
//        //            [addXiaozuArray removeObjectAtIndex:indexPath.row];
//        //            //3UI删除
//        //            [_zuTableVidw deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        //            NSLog(@"点击删除");
//        //        }
//        //        else if(addXiaozuArray.count == 1){
//        //            //1后台删除
//        //            NSDictionary * dicID = addXiaozuArray[ indexPath.row];
//        //            NSString * url = [NSString stringWithFormat:@"%@%@",BaseUrl,@"group_quit"];
//        //            [HMHttpTool get:url params:@{@"groupId":dicID[@"groupId"]} success:^(id responseObj) {
//        //                NSLog(@"成功删除%@",responseObj);
//        //            } failure:^(NSError *error) {
//        //                NSLog(@"删除失败%@",error);
//        //            }];
//        //            //2本地数据删除
//        //            [addXiaozuArray removeObjectAtIndex:indexPath.row];
//        ////            //3UI删除
//        //            [_zuTableVidw deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
//        //        }
//
//        //没有数据,删除崩溃
//        //        //2本地数据删除
//        //        [tabArray removeObjectAtIndex:indexPath.row];
//        //        //3UI删除
//        //        [_tableVW2 deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
//
//    }];//此处是iOS8.0以后苹果最新推出的api，UITableViewRowAction，Style是划出的标签颜色等状态的定义，这里也可自行定义
//
//
//    deleteRoWAction.backgroundColor = [UIColor colorWithRed:243/255.0 green:77/255.0 blue:66/255.0 alpha:1];//主色
//
//
//
//    return @[deleteRoWAction];//最后返回这俩个RowAction 的数组
//
//}




@end

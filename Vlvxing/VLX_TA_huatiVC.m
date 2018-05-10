
//
//  VLX_TA_huatiVC.m
//  Vlvxing
//
//  Created by grm on 2018/2/6.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_TA_huatiVC.h"
#import "UIColor+Tools.h"
#import "VLX_huatiModel.h"
#import "VLX_huaotiCell.h"

#import "VLX_Community_DetailViewController.h"//帖子详情



@interface VLX_TA_huatiVC ()<UITableViewDelegate,UITableViewDataSource>
{
    VLX_huatiModel * model_ht;
    NSUInteger tttt;
    NSString * myselfUserId;//本人的id

}
@property(nonatomic,strong)NSMutableArray * huatiAry;

@property(nonatomic,strong)NSMutableArray * huatiAry_chuanzhi;//传值用
@property(nonatomic,strong)NSMutableArray * huatiUserAry;//每个用户信息
@property(nonatomic,strong)NSMutableArray * huatiDynamicIDAry;//每个帖子的信id

@property (nonatomic,assign) NSInteger pageIndex_OHT;

@end

@implementation VLX_TA_huatiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _huatiAry= [NSMutableArray array];
    _huatiAry_chuanzhi = [NSMutableArray array];
    _huatiUserAry = [NSMutableArray array];
    _huatiDynamicIDAry = [NSMutableArray array];

    self.tableView3 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-100-39) style:UITableViewStylePlain];
    //去除多余分割线
    self.tableView3.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    //    self.tableView2.backgroundColor = [UIColor redColor];
    self.tableView3.delegate = self;
    self.tableView3.dataSource = self;
    [self.view addSubview: self.tableView3];
    [self loadMain_huatiData];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.DidScrollBlock) {
        self.DidScrollBlock(scrollView.contentOffset.y);
    }
}


#pragma mark 数据
-(void)loadMain_huatiData{


    self.tableView3.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDatas111)];
    [self.tableView3.mj_header beginRefreshing];
    self.tableView3.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDatas111)];


}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.tableView3 == tableView) {
        return self.huatiAry.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView3 == tableView) {
//        NSLog(@"第1个列表高度%f",[self.huatiAry[indexPath.row] CellHeight_ht]);
        return [self.huatiAry[indexPath.row] CellHeight_ht];//自动计算高度
    }
    return 0;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    if(self.tableView3 == tableView)
    {
        static NSString *ID = @"cell1";
        //        VLX_CommunityTBVW_Cell * cell = [self.tableVW1 dequeueReusableCellWithIdentifier:ID];
        VLX_huaotiCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!cell){
            cell = [[VLX_huaotiCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_huatiAry.count > 0) {
            [cell FillWithModel:_huatiAry[indexPath.row]];
            [cell.dianzanBt addTarget:self action:@selector(dianzanBt111:) forControlEvents:UIControlEventTouchUpInside];
            cell.dianzanBt.tag = indexPath.row;
        }
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VLX_Community_DetailViewController * vc =[[VLX_Community_DetailViewController alloc]init];

    vc.detailDic = self.huatiAry_chuanzhi[indexPath.row];
    vc.userDic   = self.huatiUserAry[indexPath.row];
    vc.dynamic_id = self.huatiDynamicIDAry[indexPath.row];//帖子id
    vc.myselfUserId = myselfUserId;
    [self.navigationController pushViewController:vc animated:YES];


}





#pragma mark 点赞接口
-(void)dianzanBt111:(UIButton *)sender{
    VLX_huaotiCell *cell = [[VLX_huaotiCell alloc]init];

    UIButton * btn = [[UIButton alloc]init];
    btn = cell.dianzanBt;
    tttt = sender.tag;
    VLX_huatiModel * model3 = _huatiAry[tttt];//找到对应的行号
    if([model3.isFavor isEqual:@0]){//未点赞
        [btn setImage:[UIImage imageNamed:@"like_highlighted"] forState:UIControlStateNormal];
        model3.isFavor = @1;
        [MBProgressHUD showSuccess:@"点赞成功"];
        //        //一个cell刷新,刷新这一行
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:tttt inSection:0];
        [self.tableView3 reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if([model3.isFavor isEqual:@1]){//已近点赞
        [btn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        model3.isFavor = @0;

        [MBProgressHUD showSuccess:@"取消点赞"];

        //一个cell刷新,刷新这一行
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:tttt inSection:0];
        [self.tableView3 reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    NSString * url3 = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/favor.json"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"userid"] = myselfUserId;//本人的用户id,不是帖子发布者的id
    dic[@"weiboId"] = model3.dynamicId;//帖子id
    [HMHttpTool get:url3 params:dic success:^(id responseObj) {
        NSLog(@"点赞OK:::%@",responseObj);


    } failure:^(NSError *error) {
        NSLog(@"%@",error);

    }];

}



#pragma  mark 加载最新数据
-(void)loadNewDatas111{
    self.pageIndex_OHT = 1;
    if (self.huatiUserAry.count>0) {
        [self.huatiUserAry removeAllObjects];
        [self.huatiAry_chuanzhi removeAllObjects];
        [self.huatiAry removeAllObjects];
        [self.huatiDynamicIDAry removeAllObjects];
    }
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
        NSString *myselfUserId = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];//获取正式的用户id,真实的用户id

        NSString * url= [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/list.json"];

        NSMutableDictionary * paras =[NSMutableDictionary dictionary];
        paras[@"currentPage"] = @(self.pageIndex_OHT);
        paras[@"loginUserid"] = myselfUserId;//自己的id
        paras[@"userid"] = _otherID3;//TA 的id
        paras[@"type"]=@4;
    NSLog(@"参数::%@",paras);
    [HMHttpTool get:url params:paras success:^(id responseObj) {
        NSLog_JSON(@"👌L::%@",responseObj);


        if ([responseObj[@"status"] isEqual:@1]) {
            for (NSDictionary * dic in responseObj[@"data"]) {
                model_ht = [VLX_huatiModel infoListWithDict:dic];
                [self.huatiUserAry addObject:model_ht.member];
                [self.huatiAry_chuanzhi addObject:dic];//向下传值用
                [self.huatiAry addObject:model_ht];
                [self.huatiDynamicIDAry addObject: model_ht.dynamicId];
            }
            [self.tableView3 reloadData];
            [self.tableView3.mj_footer endRefreshing];
            [self.tableView3.mj_header endRefreshing];
        }

    } failure:^(NSError *error) {
        NSLog(@"✘::::%@",error);
        [self.tableView3.mj_footer endRefreshing];
        [self.tableView3.mj_header endRefreshing];
    }];


}

-(void)loadMoreDatas111{
    //消除尾部"没有更多数据"的状态
    [self.tableView3.mj_footer resetNoMoreData];


    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"currentPage"] = @(++self.pageIndex_OHT);
    params[@"loginUserid"] = myselfUserId;//自己的id
    params[@"userid"] = _otherID3;//TA 的id
    params[@"type"]=@4;
    NSString * url = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/list.json"];


    [HMHttpTool get:url params:params success:^(id responseObj) {

        if ([responseObj[@"status"] isEqual:@1]) {
            for (NSDictionary * dic in responseObj[@"data"]) {
                model_ht = [VLX_huatiModel infoListWithDict:dic];
                [self.huatiUserAry addObject:model_ht.member];
                [self.huatiAry_chuanzhi addObject:dic];//向下传值用
                [self.huatiAry addObject:model_ht];
                [self.huatiDynamicIDAry addObject: model_ht.dynamicId];
            }
            [self.tableView3 reloadData];
            [self.tableView3.mj_footer endRefreshing];
            [self.tableView3.mj_header endRefreshing];
            self.tableView3.mj_footer.state = MJRefreshStateNoMoreData;//在没有更多数据时候显示的


        }

    } failure:^(NSError *error) {
        [self.tableView3.mj_footer endRefreshing];
        [self.tableView3.mj_header endRefreshing];
    }];


}



@end

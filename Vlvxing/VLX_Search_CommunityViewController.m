//
//  VLX_Search_CommunityViewController.m
//  Vlvxing
//
//  Created by grm on 2017/10/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_Search_CommunityViewController.h"

#import "VLX_Community_DetailViewController.h"//详情页

#import "VLX_CommunityTBVW_Cell.h"
#import "VLX_newCommnuityModel.h"

@interface VLX_Search_CommunityViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSUInteger ttt;//用于点赞,
    NSString * myselfUserId;//本人的id
}
@property (nonatomic,weak)UITextField *searchField2;
@property (nonatomic,weak)UISearchBar *customSearchBar2;
@property (nonatomic,strong)VLX_newCommnuityModel * search_model;
@property (nonatomic,strong)UITableView * tableVW11;

@property (nonatomic,strong)NSMutableArray * mainDynamicDataArray_search;//主列表帖子数据,
@property (nonatomic,strong)NSMutableArray * mainDynamicDataAray_2_search;//主列表帖子数据,用于传值,
@property (nonatomic,strong)NSMutableArray * mainUserDataArray_search;//主列表用户数据,
@property (nonatomic,copy)NSMutableArray * idArray_search;//专门存放动态的ID
@property (nonatomic,assign) NSInteger pageIndex_search;//当前页

@end

@implementation VLX_Search_CommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    _mainDynamicDataArray_search = [NSMutableArray array];//主列表帖子数据,
    _mainDynamicDataAray_2_search = [NSMutableArray array];//主列表帖子数据,用于传值,
    _mainUserDataArray_search = [NSMutableArray array];//主列表用户数据,
    _idArray_search = [NSMutableArray array];//专门存放动态的ID


    [self setNav];
    [self createMainUI];

    
}
- (void)setNav{

    //左边按钮
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


    //中间
    UIView *BJView = [[UIView alloc]initWithFrame:CGRectMake(40, 33,self.view.frame.size.width-80,40)];
    BJView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = BJView;


    UISearchBar *customSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 7, ScaleWidth(240), 44-7*2)];
    customSearchBar.delegate = self;
    customSearchBar.placeholder = @"搜索关键字";
    customSearchBar.layer.cornerRadius=14;
    customSearchBar.layer.masksToBounds=YES;
    customSearchBar.layer.borderColor=rgba(201, 201, 206, 1).CGColor;
    customSearchBar.layer.borderWidth=1;
    customSearchBar.backgroundColor = [UIColor whiteColor];
    [BJView addSubview:customSearchBar];
    _customSearchBar2 = customSearchBar;
    // 设置圆角和边框颜色
    UITextField *searchField = [customSearchBar valueForKey:@"searchField"];
    if (searchField) {
        searchField.backgroundColor = [UIColor whiteColor];
        searchField.keyboardType = UIReturnKeyDefault;//默认键盘
    }
    _searchField2 = searchField;
}

-(void)tapLeftButton1{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)createMainUI{

    _tableVW11 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    self.tableVW11.delegate = self;
    self.tableVW11.dataSource = self;
    //去除多余分割线
    self.tableVW11.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.tableVW11];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainDynamicDataArray_search.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.mainDynamicDataArray_search[indexPath.row] CellHeight];//自动计算高度
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        static NSString *ID = @"cell1";
                VLX_CommunityTBVW_Cell * cell = [self.tableVW11 dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[VLX_CommunityTBVW_Cell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_mainDynamicDataArray_search.count > 0) {
            [cell FillWithModel:_mainDynamicDataArray_search[indexPath.row]];
            [cell.dianzanBt addTarget:self action:@selector(dianzanBt11:) forControlEvents:UIControlEventTouchUpInside];
            cell.dianzanBt.tag = indexPath.row;
        }
        return cell;

}

#pragma mark 点赞
-(void)dianzanBt11:(UIButton *)sender{
    VLX_CommunityTBVW_Cell *cell = [[VLX_CommunityTBVW_Cell alloc]init];

    UIButton * btn = [[UIButton alloc]init];
    btn = cell.dianzanBt;
    ttt = sender.tag;
    VLX_newCommnuityModel * model3 = _mainDynamicDataArray_search[ttt];//找到对应的行号
    if([model3.isFavor isEqual:@0]){//未点赞
        [btn setImage:[UIImage imageNamed:@"like_highlighted"] forState:UIControlStateNormal];
        model3.isFavor = @1;
        [MBProgressHUD showSuccess:@"点赞成功"];
        //        //一个cell刷新,刷新这一行
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:ttt inSection:0];
        [self.tableVW11 reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if([model3.isFavor isEqual:@1]){//已近点赞
        [btn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        model3.isFavor = @0;

        [MBProgressHUD showSuccess:@"取消点赞"];

        //一个cell刷新,刷新这一行
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:ttt inSection:0];
        [self.tableVW11 reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        VLX_Community_DetailViewController * vc = [[VLX_Community_DetailViewController alloc]init];
        [self.tableVW11 deselectRowAtIndexPath:indexPath animated:NO];
        vc.detailDic = self.mainDynamicDataAray_2_search[indexPath.row];
        vc.userDic   = self.mainUserDataArray_search[indexPath.row];
        vc.dynamic_id = self.idArray_search[indexPath.row];//帖子id
        vc.myselfUserId = myselfUserId;
        [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark 点击回车键
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //    NSLog(@"点击了回车键");
    NSLog(@"%@",_searchField2.text);
    [_searchField2 resignFirstResponder];


    self.pageIndex_search = 1;//1381;

    [self.mainUserDataArray_search removeAllObjects];
    [self.mainDynamicDataAray_2_search removeAllObjects];
    [self.mainDynamicDataArray_search removeAllObjects];
    [self.idArray_search removeAllObjects];


    NSString * url = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/list.json"];

    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"content"] = _searchField2.text;

    [HMHttpTool get:url params:para success:^(id responseObj) {
        NSLog_JSON(@"%@",responseObj);


        if ([responseObj[@"status"] isEqual:@1]) {

            for (NSDictionary * dic in responseObj[@"data"]) {
                _search_model = [VLX_newCommnuityModel infoListWithDict:dic];
                [self.mainUserDataArray_search addObject:_search_model.member];
                [self.mainDynamicDataAray_2_search addObject:dic];//向下传值用
                [self.mainDynamicDataArray_search addObject:_search_model];
                [self.idArray_search addObject: _search_model.dynamicId];
            }

            //请求成功后，一定要刷新界面
            [self.tableVW11 reloadData];
            // 让刷新控件停止刷新
            [self.tableVW11.mj_footer endRefreshing];
            [self.tableVW11.mj_header endRefreshing];
        }

    } failure:^(NSError *error) {
        [self.tableVW11.mj_footer endRefreshing];
        [self.tableVW11.mj_header endRefreshing];
        NSLog(@"%@",error);
    }];

}


@end

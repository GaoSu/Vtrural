//
//  VLXchooseAreaSearchVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/1.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXchooseAreaSearchVC.h"

@interface VLXchooseAreaSearchVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)VLXSearchKeyWordModel *keywordModel;
@end

@implementation VLXchooseAreaSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}
#pragma mark---数据
-(void)setSearchStr:(NSString *)searchStr
{
    _searchStr=searchStr;
    NSLog(@"~~~~~~~~%@",_searchStr);
    [self loadDataWithKeyWords];
}
-(void)loadDataWithKeyWords
{
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    //    dic[@"areaName"]=[ZYYCustomTool checkNullWithNSString:_searchTXT.text];//
    dic[@"areaName"]=@"北京";//
    NSString * url=[NSString stringWithFormat:@"%@/sysArea/sousuodiqu.json",ftpPath];
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        _keywordModel=[[VLXSearchKeyWordModel alloc] initWithDictionary:requestDic error:nil];
        if (_keywordModel.status.integerValue==1) {
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
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    titleLab.text=@"搜索地区";
    titleLab.font=[UIFont systemFontOfSize:19];
    titleLab.textColor=[UIColor hexStringToColor:@"#313131"];
    titleLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 64+44, kScreenWidth, kScreenHeight-64-44) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellID"];

}
#pragma mark
#pragma mark---事件
#pragma mark
#pragma mark---tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _keywordModel.data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    VLXSearchKeyWordDataModel *model=_keywordModel.data[indexPath.row];
    cell.textLabel.text=[ZYYCustomTool checkNullWithNSString:model.areaname];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.textColor=[UIColor hexStringToColor:@"#313131"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    VLXSearchKeyWordDataModel *model=_keywordModel.data[indexPath.row];


    [self dismissViewControllerAnimated:YES completion:^{
        if (_resultBlock) {
            _resultBlock(model);
        }
    }];
    NSLog(@"%@",model.areaname);
}
#pragma mark
#pragma mark---delegate
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

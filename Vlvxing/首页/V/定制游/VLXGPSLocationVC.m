//
//  VLXGPSLocationVC.m
//  Vlvxing
//
//  Created by Michael on 17/5/26.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXGPSLocationVC.h"
#import "VLXGPSModel.h"
@interface VLXGPSLocationVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSArray * dataArray;
@property(nonatomic,strong)NSMutableArray * selectedArray;
@property(nonatomic,strong)UISearchController * searchController;
@end

@implementation VLXGPSLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor hexStringToColor:@"f3f3f4"];
    self.view.size=CGSizeMake(108.5, ScaleHeight(458));
    self.selectedArray=[NSMutableArray array];
//    self.dataArray=@[@"GPS定位",@"亚洲",@"欧洲",@"北美洲",@"南美洲",@"非洲",@"大洋洲"];
    self.dataArray=@[@"GPS定位",@"国内",@"国外"];
    for (int i=0; i<_dataArray.count; i++) {
        VLXGPSModel * model=[[VLXGPSModel alloc]init];
        model.name=self.dataArray[i];
        model.select=NO;
        if (i==1) {
            model.select=YES;
        }
        [self.selectedArray addObject:model];
    }
    [self.view addSubview:self.tableview];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _dataArray.count;

}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    VLXGPSModel * model;
    if (self.selectedArray.count>0) {
        model=self.selectedArray[indexPath.row];
    }

    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    }
    cell.textLabel.text=model.name;
    cell.textLabel.font=[UIFont fontWithName:@"PingFang-SC-Bold" size:16];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (model.select) {
        cell.textLabel.textColor=orange_color;
        }else
        {
            cell.textLabel.textColor=[UIColor hexStringToColor:@"111111"];
        }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return;
    }
//点击事件
    for (VLXGPSModel * model in self.selectedArray) {
        model.select=NO;
    }
    VLXGPSModel * model=self.selectedArray[indexPath.row];
    model.select=YES;
    [self.tableview reloadData];
    if (_gpsBlock) {
        _gpsBlock(indexPath.row);
    }
}

-(UITableView * )tableview
{
    if (!_tableview) {
        _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, 100, ScaleHeight(458)) style:UITableViewStylePlain];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;

    }

    return _tableview;
}

@end

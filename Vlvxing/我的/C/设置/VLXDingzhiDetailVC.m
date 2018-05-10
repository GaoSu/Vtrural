//
//  VLXDingzhiDetailVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/5.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXDingzhiDetailVC.h"
#import "VLXDingzhiTitleCell.h"
#import "VLXDingzhiRequestCell.h"
@interface VLXDingzhiDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation VLXDingzhiDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //

    
    //
    [self createUI];
}
#pragma mark---数据
#pragma mark
#pragma mark---视图
-(void)createUI
{
    [self setNav];
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"VLXDingzhiTitleCell" bundle:nil] forCellReuseIdentifier:@"VLXDingzhiTitleCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VLXDingzhiRequestCell" bundle:nil] forCellReuseIdentifier:@"VLXDingzhiRequestCellID"];
}
- (void)setNav{
    
    self.title = @"定制详情";
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
#pragma mark
#pragma mark---事件
-(void)tapLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark
#pragma mark---delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }else if (section==1)
    {
        return 2;
    }else if (section==2)
    {
        return 3;
    }else if (section==3)
    {
        return 1;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section!=3) {
        VLXDingzhiTitleCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXDingzhiTitleCellID" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                [cell createUIWithTitle:@"出发城市" andContent:_model.departure];
            }else if (indexPath.row==1)
            {
                [cell createUIWithTitle:@"目的城市" andContent:_model.destination];
            }else if (indexPath.row==2)
            {
    
                [cell createUIWithTitle:@"出发日期" andContent:[[NSString stringWithFormat:@"%@",_model.time] RwnTimeExchange]];
            }
        }else if (indexPath.section==1)
        {
            if (indexPath.row==0) {
                [cell createUIWithTitle:@"出行天数" andContent:[NSString stringWithFormat:@"%@",_model.days]];
            }else if (indexPath.row==1)
            {
                [cell createUIWithTitle:@"出行人数" andContent:[NSString stringWithFormat:@"%@",_model.peoplecounts]];
            }
        }else if (indexPath.section==2)
        {
            if (indexPath.row==0) {
                [cell createUIWithTitle:@"姓名" andContent:_model.name];
            }else if (indexPath.row==1)
            {
                [cell createUIWithTitle:@"电话" andContent:_model.tel];
            }else if (indexPath.row==2)
            {
                
                [cell createUIWithTitle:@"邮箱" andContent:_model.mail];
            }
        }
        return cell;
    }else
    {
        VLXDingzhiRequestCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXDingzhiRequestCellID" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell createUIWithRequestStr:[ZYYCustomTool checkNullWithNSString:_model.requirement]];
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section!=3) {
        return 44;
    }
    return 140;
}
//头尾视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 8)];
    line.backgroundColor=backgroun_view_color;
    return line;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}
//
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

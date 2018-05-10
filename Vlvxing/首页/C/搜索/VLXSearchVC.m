//
//  VLXSearchVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXSearchVC.h"
#import "VLXSearchCell.h"
#import "VLXSearchKeyWordModel.h"
#import "VLXSearchResultVC.h"
typedef enum : NSUInteger {
    SearchNormal,//默认初始状态
    SearchKeyWords,//搜索关键字
//    SearchResult,//搜索结果

} SearchStatus;
@interface VLXSearchVC ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITextField *searchTXT;
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UICollectionView *collectionView;
//
@property (nonatomic,assign)SearchStatus searchStatus;//界面状态
@property (nonatomic,strong)UITableView *tableView;//
@property (nonatomic,strong)VLXSearchKeyWordModel *keywordModel;
//
@end

@implementation VLXSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化
    _dataArray=[NSMutableArray array];
    _searchStatus=SearchNormal;
    //
    [self createUI];
    [self loadData];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSLog(@"%f",_collectionView.collectionViewLayout.collectionViewContentSize.height);
//    CGFloat currentHeight=_collectionView.collectionViewLayout.collectionViewContentSize.height;
//    if (currentHeight<=kScreenHeight-64-CGRectGetHeight(_topView.frame)) {
//        _collectionView.frame=CGRectMake(0, CGRectGetHeight(_topView.frame), kScreenWidth, currentHeight);
//    }else
//    {
//        _collectionView.frame=CGRectMake(0, CGRectGetHeight(_topView.frame), kScreenWidth, kScreenHeight-64-CGRectGetHeight(_topView.frame));
//    }
    
}
#pragma mark---数据
-(void)loadData
{
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    _dataArray=[[defaults objectForKey:@"VLXSearch"] mutableCopy];
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
    }
    [self.collectionView reloadData];
}
-(void)saveSearchKey:(NSString *)searchStr//将搜索词存到userDefaults中
{
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    if ([NSString checkForNull:searchStr]) {
        [SVProgressHUD showErrorWithStatus:@"请输入搜索关键词!"];
        return;
    }else
    {
        [_dataArray addObject:searchStr];
        [defaults setObject:_dataArray forKey:@"VLXSearch"];
    }
    [self.collectionView reloadData];
}
-(void)loadDataWithKeyWords
{
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"areaName"]=[ZYYCustomTool checkNullWithNSString:_searchTXT.text];//
//    dic[@"areaName"]=@"北京";//
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
    
    [self setNav];
    //搜索界面
    [self createTopView];
    [self createCollectionView];
    //关键字查询界面
    [self createSearchTableView];
    //搜索结果界面
    //
}
-(void)createSearchTableView
{
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    //
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellID"];
    //
    _tableView.hidden=YES;
}
-(void)createTopView
{
    _topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    _topView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_topView];
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(12, 0, 80, 40)];
    titleLab.text=@"历史搜索";
    titleLab.font=[UIFont systemFontOfSize:16];
    titleLab.textAlignment=NSTextAlignmentLeft;
    titleLab.textColor=[UIColor hexStringToColor:@"#666666"];
    [_topView addSubview:titleLab];
    UIButton *clearBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame=CGRectMake(kScreenWidth-(40+12), 0, 40, 40);
    [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    clearBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [clearBtn setTitleColor:[UIColor hexStringToColor:@"#00baff"] forState:UIControlStateNormal];
    clearBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [clearBtn addTarget:self action:@selector(btnClickedToClear:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:clearBtn];
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 40-0.5, kScreenWidth, 0.5)];
    line.backgroundColor=separatorColor1;
    [_topView addSubview:line];
}
-(void)createCollectionView//用于图片
{
    //此处必须要有创见一个UICollectionViewFlowLayout的对象
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //同一行相邻两个cell的最小间距
    layout.minimumInteritemSpacing = 24;
    //最小两行之间的间距
    layout.minimumLineSpacing = 15;
//    CGFloat height=kScreenHeight-CGRectGetHeight(_topView.frame);
//    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_topView.frame), kScreenWidth, 50) collectionViewLayout:layout];
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_topView.frame), kScreenWidth, kScreenHeight-64-CGRectGetHeight(_topView.frame)) collectionViewLayout:layout];
    _collectionView.backgroundColor=[UIColor whiteColor];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.showsVerticalScrollIndicator=NO;
    _collectionView.showsHorizontalScrollIndicator=NO;
    _collectionView.bounces=YES;
    //这个是横向滑动
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    [self.view addSubview:_collectionView];
    //注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"VLXSearchCell" bundle:nil] forCellWithReuseIdentifier:@"VLXSearchCellID"];
}
- (void)setNav{
    
    self.view.backgroundColor=backgroun_view_color;
    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton:)];
    //右边按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 20);
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [rightBtn setTitleColor:[UIColor hexStringToColor:@"#666666"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    rightBtn.titleLabel.textAlignment=NSTextAlignmentRight;
    [rightBtn addTarget:self action:@selector(tapRightButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    //中间搜索框
    CGFloat titleWidth=kScreenWidth-60*2;
    UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, titleWidth, 30)];
    titleView.layer.cornerRadius=4;
    titleView.layer.masksToBounds=YES;
    titleView.layer.borderWidth=1;
    titleView.layer.borderColor=orange_color.CGColor;
    self.navigationItem.titleView=titleView;
    UIImageView *searchIcon=[[UIImageView alloc] initWithFrame:CGRectMake(11, (30-17)/2, 17, 17)];
    [searchIcon setImage:[UIImage imageNamed:@"search"]];
    [titleView addSubview:searchIcon];
    _searchTXT=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchIcon.frame)+7, 0, titleWidth-(CGRectGetMaxX(searchIcon.frame)+7), 30)];
    _searchTXT.borderStyle=UITextBorderStyleNone;
    _searchTXT.returnKeyType=UIReturnKeySearch;
    _searchTXT.font=[UIFont systemFontOfSize:14];
    _searchTXT.placeholder=@"目的地搜索";
    _searchTXT.delegate=self;
    [titleView addSubview:_searchTXT];
    //
     [self.searchTXT addTarget:self action:@selector(textfieldDidClick) forControlEvents:UIControlEventAllEditingEvents];
}
-(void)changeUIWithStatus:(SearchStatus)searchStatus
{
    if (_searchStatus==SearchNormal) {
        _topView.hidden=NO;
        _collectionView.hidden=NO;
        _tableView.hidden=YES;
    }else if (_searchStatus==SearchKeyWords)
    {
        _topView.hidden=YES;
        _collectionView.hidden=YES;
        _tableView.hidden=NO;
    }
}
#pragma mark
#pragma mark---事件
-(void)tapLeftButton:(UIButton *)sender
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tapRightButton:(UIButton *)sender
{
    NSLog(@"取消");
    _searchTXT.text=@"";
}
-(void)btnClickedToClear:(UIButton *)sender
{
    NSLog(@"清除");
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"确定清空搜索历史吗?" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确定");
        [defaults removeObjectForKey:@"VLXSearch"];
        [self loadData];
        
    }];
    UIAlertAction *alertB = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    [alertC addAction:alertA];
    [alertC addAction:alertB];
    [self presentViewController:alertC animated:YES completion:nil];
}
#pragma mark
#pragma mark---textfield 监听
-(void)textfieldDidClick
{
    
    if ([self.searchTXT.text isEqualToString:@""]||self.searchTXT.text==NULL) {
        _searchStatus=SearchNormal;
        
    }else
    {
//        MyLog(@"有变化了");
        NSLog(@"%@",_searchTXT.text);
        //隐藏collectionview
        _searchStatus=SearchKeyWords;
        [self loadDataWithKeyWords];
    }
    [self changeUIWithStatus:_searchStatus];
}
#pragma mark
#pragma mark---textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"搜索");
    [self saveSearchKey:textField.text];//保存关键词
    [textField resignFirstResponder];
    return YES;
}
#pragma mark
#pragma mark---collection delegate
//一共有多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每一组有多少个cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
//每一个cell是什么
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VLXSearchCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"VLXSearchCellID" forIndexPath:indexPath];
    if (_dataArray&&_dataArray.count>0) {
        cell.titleLab.text=_dataArray[indexPath.row];
    }
    
    return cell;
}

//每一个分组的上左下右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(14, 14, 14, 14);
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray&&_dataArray.count>0) {//动态计算每个cell的高度
        NSString *title=_dataArray[indexPath.row];
        return CGSizeMake( [title sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, 28)].width+20, 28);
    }
    return CGSizeZero;
    
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //改变界面
    _searchTXT.text=_dataArray[indexPath.row];
    _searchStatus=SearchKeyWords;
    [self changeUIWithStatus:_searchStatus];
    [self loadDataWithKeyWords];
    //
    [self saveSearchKey:_dataArray[indexPath.row]];//保存关键词
    NSLog(@"%ld",(long)indexPath.row);

}
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
    [self.searchTXT resignFirstResponder];
    VLXSearchResultVC *resultVC=[[VLXSearchResultVC alloc] init];
    VLXSearchKeyWordDataModel *model=_keywordModel.data[indexPath.row];
    resultVC.model=model;
    resultVC.cellType=_cellType;
    [self.navigationController pushViewController:resultVC animated:YES];
    
    NSLog(@"%@",model.areaname);
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

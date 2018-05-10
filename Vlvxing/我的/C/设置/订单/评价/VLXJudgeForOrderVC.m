//
//  VLXJudgeForOrderVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/8.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXJudgeForOrderVC.h"
#import "VLXJudgeHeaderView.h"
#import "CDZTableViewCell.h"
#import "CDZCollectionViewItem.h"
@interface VLXJudgeForOrderVC ()<UITableViewDelegate,UITableViewDataSource,CDZTableViewCellDelegate,YBImgPickerViewControllerDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)VLXJudgeHeaderView *headerView;
@property (nonatomic,strong)YBImgPickerViewController*picker;
@property (nonatomic,strong)NSMutableDictionary *picsDic;
@property (strong, nonatomic) NSMutableArray<CDZCollectionViewItem *>*itemsArray;
@property (nonatomic,assign)NSInteger judgeType;//评价的等级   1好评，2中评，3差评
//
@property (nonatomic,assign)NSInteger refreshTag;//刷新高度标识
@end

@implementation VLXJudgeForOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    _refreshTag=100;
    _judgeType=1;//默认好评
    //初始化
    
    _picsDic=[NSMutableDictionary dictionary];
    CDZCollectionViewItem *item = [CDZCollectionViewItem new];
    item.delBtnHidden = YES;
    _itemsArray = [NSMutableArray arrayWithObject:item];
    //
    //
    [self createUI];
}
#pragma mark---数据
#pragma mark
#pragma mark---视图
-(void)createUI
{
    __block VLXJudgeForOrderVC *blockSelf=self;
    [self setNav];
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    self.tableView.estimatedRowHeight = 100.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    //
    [self.tableView registerNib:[UINib nibWithNibName:@"CDZTableViewCell" bundle:nil] forCellReuseIdentifier:@"TableViewCell"];
    //头视图
    _headerView=[[VLXJudgeHeaderView alloc] initWithFrame:CGRectZero];
    _tableView.tableHeaderView=_headerView;
    _headerView.judgeBlock=^(NSInteger index)
    {
        NSLog(@"%ld",index);
        blockSelf.judgeType=index;
    };
    //尾视图
    UIView *bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    UIButton *postBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    postBtn.frame=CGRectMake(15, 0, kScreenWidth-15*2, 44);
    [postBtn setBackgroundColor:orange_color];
    [postBtn setTitle:@"提交" forState:UIControlStateNormal];
    postBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    postBtn.layer.cornerRadius=4;
    postBtn.layer.masksToBounds=YES;
    [postBtn addTarget:self action:@selector(btnClickedToJudge:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:postBtn];
    _tableView.tableFooterView=bottomView;
}
- (void)setNav{
    
    self.title = @"评价";
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
-(void)btnClickedToJudge:(UIButton *)sender
{
    NSLog(@"%@",_headerView.textView.text);
    if ([NSString checkForNull:_headerView.textView.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入评价内容"];
        return;
    }
    if (_itemsArray.count<=1) {
        [SVProgressHUD showInfoWithStatus:@"请添加评价图片"];
        return;
    }
    NSMutableArray *imagesArr=[NSMutableArray array];
    for (int i=0; i<_itemsArray.count-1; i++) {
        CDZCollectionViewItem *item=_itemsArray[i];
        [imagesArr addObject:item.image];
    }
    [SVProgressHUD showWithStatus:@"正在保存"];
    [[[UploadImageTool alloc] init] UploadImageArray:imagesArr upLoadProgress:^(float progress) {
        NSLog(@"%f",progress);
    } successUrlArrayBlock:^(NSArray *urlArray, int count) {
        NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
        dic[@"token"]=[NSString getDefaultToken];//
        dic[@"productId"]=[ZYYCustomTool checkNullWithNSString:_productId];//商品的id
        dic[@"orderId"]=[ZYYCustomTool checkNullWithNSString:_orderId];//订单id
        dic[@"level"]=[NSString stringWithFormat:@"%ld",_judgeType];//评价的等级   1好评，2中评，3差评
        dic[@"content"]=[NSString stringWithFormat:@"%@",_headerView.textView.text];//评价的内容
        dic[@"evaluatePic"]=[urlArray componentsJoinedByString:@","];//评价的图片（多张用”,”分开）
        
        NSString * url=[NSString stringWithFormat:@"%@/ProEvaluateController/auth/saveEvaluate.html",ftpPath];
        NSLog(@"评价的参数%@",dic);
        [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
            [SVProgressHUD dismiss];
            if ([requestDic[@"status"] integerValue]==1) {
                [SVProgressHUD showSuccessWithStatus:@"保存评价成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.navigationController popViewControllerAnimated:YES];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:msg];
            }
            
        } failure:^(NSString *errorInfo) {
            [SVProgressHUD dismiss];
            
        }];
    } failBlock:^(NSString *error, int count) {
        NSLog(@"%@",error);
    } progress:^(int count) {
        
    }];
    
//    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
//    
//    dic[@"token"]=[NSString getDefaultToken];//
//    dic[@"productId"]=[ZYYCustomTool checkNullWithNSString:_productId];
//    dic[@"orderId"]=[ZYYCustomTool checkNullWithNSString:_orderId];
//    dic[@"level"]=[NSString stringWithFormat:@"%ld",_judgeType];
//    dic[@"content"]=[NSString stringWithFormat:@"%@",_headerView.textView.text];
//    dic[@"evaluatePic"]=@"";
//    
//    
//    NSString * url=[NSString stringWithFormat:@"%@/ProEvaluateController/auth/saveEvaluate.html",ftpPath];
//    NSLog(@"%@",dic);
//    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
//        [SVProgressHUD dismiss];
//        if ([requestDic[@"status"] integerValue]==1) {
//            [SVProgressHUD showSuccessWithStatus:@"保存评价成功"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//        }
//        else
//        {
//            [SVProgressHUD showErrorWithStatus:msg];
//        }
//        
//    } failure:^(NSString *errorInfo) {
//        [SVProgressHUD dismiss];
//        
//    }];
}
-(void)openPhoto//打开相簿 用于照片
{
    NSLog(@"选照片");
    [_picsDic removeAllObjects];
    self.picker = [[YBImgPickerViewController alloc] initWithChoosenImgDic:_picsDic delegate:self];
    self.picker.maxCount = (int)(9-_itemsArray.count+1);
    [self.picker showInViewContrller:self.navigationController];
}
-(void)tapLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark
#pragma mark---delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    //数据
    if (_refreshTag==100) {
        [cell createUIWithImagesArray:_itemsArray];
    }
    //
    cell.delegate = self;
    __block VLXJudgeForOrderVC *blockSelf=self;
    cell.addBlock=^()
    {
        [blockSelf openPhoto];//打开相册
    };
    cell.deleteBlock=^(NSArray<CDZCollectionViewItem *> * itemArray)
    {
        blockSelf.itemsArray=[NSMutableArray arrayWithArray:itemArray];
    };
    return cell;
}
- (void)shouldReload{
    _refreshTag=0;
    [self.tableView reloadData];
}
#pragma mark
#pragma mark---YBImgPickerViewControllerDelegate
-(void)YBImagePickerDidFinishWithImages:(NSDictionary *)choosenImgDic
{
    NSLog(@"%@",choosenImgDic);
    //重置数组
//    CDZCollectionViewItem *item = [CDZCollectionViewItem new];
//    item.delBtnHidden = YES;
//    _itemsArray = [NSMutableArray arrayWithObject:item];
    //
    
    _picsDic=[NSMutableDictionary dictionaryWithDictionary:choosenImgDic];
//    NSArray *keys=_picsDic.allKeys;
    NSArray *values=_picsDic.allValues;
    for (int i=0; i<_picsDic.count; i++) {
        CDZCollectionViewItem *item=[[CDZCollectionViewItem alloc] init];
        item.image=values[i];
        [_itemsArray insertObject:item atIndex:self.itemsArray.count - 1];
        _refreshTag=100;
        
    }
    if (_itemsArray.count>9) {//如果9张图片，就把最后一张图片(加号按钮图片)删除
        [_itemsArray removeLastObject];
    }
    [self.tableView reloadData];
    NSLog(@"%@",_itemsArray);
}
#pragma mark
#pragma mark---scroll view delegate
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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

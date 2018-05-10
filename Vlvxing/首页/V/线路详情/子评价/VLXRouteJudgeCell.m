//
//  VLXRouteJudgeCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/24.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXRouteJudgeCell.h"
#import "VLXImageCollectionViewCell.h"
@interface VLXRouteJudgeCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewBottom;
//
@property (nonatomic,strong)NSArray *dataArray;
//
@end
@implementation VLXRouteJudgeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //
    _iconImageView.layer.cornerRadius=25/2;
    _iconImageView.layer.masksToBounds=YES;
    _nameLab.textColor=[UIColor hexStringToColor:@"#666666"];
    _dateLab.textColor=[UIColor hexStringToColor:@"#666666"];
    //
    [self createCollectionView];

    
}
#pragma mark---数据
//-(void)createUIWithData:(NSArray *)dataArray//设置数据源
//{
//    _desLab.text=@"createUIWithData";
//    _dataArray=dataArray;
//    
//    [_collectionView setNeedsLayout];
//    [_collectionView layoutIfNeeded];
//    [_collectionView reloadData];
//
//    
//    //    //重新刷新collectionView的高度
//    NSLog(@"%f",_collectionView.collectionViewLayout.collectionViewContentSize.height);
//    _collectionViewHeight.constant= _collectionView.collectionViewLayout.collectionViewContentSize.height;
//    _collectionViewBottom.constant=15;
//    
//}
-(void)createUIWithModel:(VLXHomeJudgeEvaluateModel *)model
{
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.userpic] placeholderImage:nil];
    _nameLab.text=[ZYYCustomTool checkNullWithNSString:model.usernick];
    _desLab.text=[ZYYCustomTool checkNullWithNSString:model.evaluatecontent];
    _dateLab.text=[[NSString stringWithFormat:@"%@",model.createtime] RwnTimeExchange];
    _dataArray=[model.evaluatepic componentsSeparatedByString:@","];

    [_collectionView setNeedsLayout];
    [_collectionView layoutIfNeeded];
    [_collectionView reloadData];


    //    //重新刷新collectionView的高度
    NSLog(@"%f",_collectionView.collectionViewLayout.collectionViewContentSize.height);
    _collectionViewHeight.constant= _collectionView.collectionViewLayout.collectionViewContentSize.height;
    _collectionViewBottom.constant=15;
    //

}



#pragma mark
#pragma mark---视图
-(void)createCollectionView
{
    //底部分割线样式
    _lineView.backgroundColor=separatorColor1;
    //
    //此处必须要有创见一个UICollectionViewFlowLayout的对象
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //同一行相邻两个cell的最小间距
    layout.minimumInteritemSpacing = 7.5;
    //最小两行之间的间距
    layout.minimumLineSpacing = 10;

    _collectionView.collectionViewLayout=layout;

    
    _collectionView.backgroundColor=[UIColor whiteColor];

    _collectionView.showsVerticalScrollIndicator=NO;
    _collectionView.showsHorizontalScrollIndicator=NO;

    
    _collectionView.bounces=NO;
    //这个垂直滑动
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    
    //注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"VLXImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"VLXImageCollectionViewCellID"];



}
#pragma mark
#pragma mark---事件
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
    VLXImageCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"VLXImageCollectionViewCellID" forIndexPath:indexPath];
    if (_dataArray&&_dataArray.count>indexPath.row) {
        [cell createUIWithImage:_dataArray[indexPath.row]];
    }
    return cell;
}

//每一个分组的上左下右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(82, 82);
    
}
//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
}
#pragma mark
#pragma mark---delegate
#pragma mark
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

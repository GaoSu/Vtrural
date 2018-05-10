//
//  VLXHomeHeaderCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/19.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXHomeHeaderCell.h"
#import "SDCycleScrollView.h"
#import "VLXWebViewVC.h"
@interface VLXHomeHeaderCell ()<SDCycleScrollViewDelegate>
//第一部分视图相关
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *topViewArray;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViewArray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titleLabArray;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *imageWidthArray;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *imageHeightArray;
//v头条相关
@property (weak, nonatomic) IBOutlet UIView *topNewsView;
@property (weak, nonatomic) IBOutlet UIView *newsScrollView;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;

//底部视图相关
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *bottomLabArray;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *bottomImageViewArray;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *bottomImageWidthArray;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *bottomImageHeightArray;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *bottomBgViewArray;




//
@end
@implementation VLXHomeHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor=backgroun_view_color;
    //上部分视图
    NSArray *imageArray=@[@"ios附近@3x",@"ios国内@3x",@"ios境外@3x",@"ios发现景点@3x"];
    NSArray *titleArray=@[@"附近",@"国内",@"境外",@"发现景点"];
    for (int i=0; i<imageArray.count; i++) {
        //得到图片的宽度
        UIImage *image=[UIImage imageNamed:imageArray[i]];
        NSLayoutConstraint *width=_imageWidthArray[i];
        NSLayoutConstraint *height=_imageHeightArray[i];
        width.constant=image.size.width;//修改图片的宽度
        height.constant=image.size.height;//修改图片的高度
        //设置图片
        UIImageView *imageView=_imageViewArray[i];
        [imageView setImage:image];
        //设置标题
        UILabel *titleLab=_titleLabArray[i];
        titleLab.text=titleArray[i];
        titleLab.textColor=[UIColor hexStringToColor:@"#7d7d7d"];
        //添加手势
        UIView *topView=_topViewArray[i];
        topView.tag=800+i;
        topView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopViewToEvent:)];
        [topView addGestureRecognizer:tap];
        
    }
    //中间v头条
    while (_newsScrollView.subviews.lastObject) {
        [_newsScrollView.subviews.lastObject removeFromSuperview];
    }
    //创建只上下滚动展示文字的轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, _newsScrollView.frame.size.width, _newsScrollView.frame.size.height) delegate:self placeholderImage:nil];
    cycleScrollView.backgroundColor = [UIColor whiteColor];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
    cycleScrollView.onlyDisplayText = YES;
    cycleScrollView.titleLabelTextFont=[UIFont systemFontOfSize:16];
    cycleScrollView.titleLabelBackgroundColor = [UIColor whiteColor];
    cycleScrollView.titleLabelTextColor = [UIColor hexStringToColor:@"#313131"];
//    cycleScrollView.titlesGroup=@[@"这个季节去丽江，来一场风花雪月的旅行",@"爱情来得太苦啊就大师傅",@"无敌是多打点的额 大法好"];
//    [self createUIWithData:];
    [_newsScrollView addSubview:cycleScrollView];
    _cycleScrollView=cycleScrollView;

    NSLog(@"%@~%@",NSStringFromCGRect(cycleScrollView.frame),NSStringFromCGRect(_newsScrollView.frame));
    
    //添加手势
    _topNewsView.userInteractionEnabled=YES;
    UITapGestureRecognizer *centerTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCenterToEvent:)];
    [_topNewsView addGestureRecognizer:centerTap];
    //下部分视图
    NSArray *bottomTitle=@[@"火车票",@"机票",@"定制游",@"用车"];
    NSArray *bottomImage=@[@"ios火车票@3x",@"ios机票@3x-",@"ios定制游@3x",@"ios用车@3x-"];//@[@"train",@"--Plane",@"dingzhi",@"car"];
    for (int j=0; j<bottomTitle.count; j++) {
        //设置背景颜色
        UIView *bgView=_bottomBgViewArray[j];
        bgView.tag=600+j;
//        if (j%2==0) {
//            bgView.backgroundColor=orange_color;
//        }else
//        {
//            bgView.backgroundColor=blue_color;
//        }
        
        
        //得到图片的宽度
        UIImage *image=[UIImage imageNamed:bottomImage[j]];
        NSLayoutConstraint *width=_bottomImageWidthArray[j];
        NSLayoutConstraint *height=_bottomImageHeightArray[j];
        width.constant=image.size.width;//修改图片的宽度
        height.constant=image.size.height;//修改图片的高度
        //设置图片
        UIImageView *imageView=_bottomImageViewArray[j];
        [imageView setImage:image];
        //设置标题
        UILabel *titleLab=_bottomLabArray[j];
        titleLab.text=bottomTitle[j];
        titleLab.textColor=[UIColor hexStringToColor:@"#7d7d7d"];

        //添加手势
        bgView.userInteractionEnabled=YES;
        UITapGestureRecognizer *bottomTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBottomViewToEvent:)];
        [bgView addGestureRecognizer:bottomTap];
        
    }
    
}
//
-(void)createUIWithData:(VLXVHeadModel *)vModel
{
    //v头条数据源
    NSMutableArray *titleArray=[NSMutableArray array];
    for (VLXVHeadDataModel *dataModel in vModel.data) {
        [titleArray addObject:dataModel.headname];
    }
    _cycleScrollView.titlesGroup=titleArray;

    
}
//
#pragma mark---事件
-(void)tapTopViewToEvent:(UITapGestureRecognizer *)tap
{
    NSLog(@"%ld",tap.view.tag-800);
    if (_topBlock) {
        _topBlock(tap.view.tag-800);
    }
}
-(void)tapCenterToEvent:(UITapGestureRecognizer *)tap
{
    NSLog(@"tapCenterToEvent");
    if (_centerBlock) {
        _centerBlock();
    }
}
-(void)tapBottomViewToEvent:(UITapGestureRecognizer *)tap
{
    NSLog(@"%ld",tap.view.tag);
    if (_bottomBlock) {
        _bottomBlock(tap.view.tag-600);
    }

}

#pragma mark
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

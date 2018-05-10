//
//  VLXDomesticHotCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXDomesticHotCell.h"
@interface VLXDomesticHotCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic,strong)NSArray *titleArray;

@end
@implementation VLXDomesticHotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLab.textColor=[UIColor hexStringToColor:@"#2c2c2c"];
}
-(void)createUIWithData:(NSArray *)dataArray andType:(NSInteger)type//1.国内  2.境外游
{

    NSMutableArray *titleArray=[NSMutableArray array];
    for (int i=0; i<dataArray.count; i++) {
        VLXHotDemesticDataModel *model=dataArray[i];
        [titleArray addObject:model.areaname];
    }
    [titleArray addObject:@"更多"];
    _titleArray=titleArray;
    //      总列数
    int totalColumns = 4;
    
    //       每一格的尺寸
    CGFloat cellW = ScaleWidth(80);
    CGFloat cellH = ScaleHeight(80);
    
    //    间隙
    CGFloat margin =(kScreenWidth - totalColumns * cellW) / (totalColumns + 1);
    
    //    根据格子个数创建对应的框框
    for(int index = 0; index< titleArray.count; index++) {
        
        UIImageView *iconImageView = [[UIImageView alloc ]init ];
//        [iconImageView setImage:[UIImage imageNamed:@"tiananmen2"]];
        // 计算行号  和   列号
        int row = index / totalColumns;
        int col = index % totalColumns;
        //根据行号和列号来确定 子控件的坐标
        CGFloat cellX = margin + col * (cellW + margin);
        CGFloat cellY = row * (cellH + 10)+44;
        iconImageView.frame = CGRectMake(cellX, cellY, cellW, cellH);
        // 添加到view 中  
        [self.contentView addSubview:iconImageView];
        iconImageView.layer.cornerRadius=4;
        iconImageView.layer.masksToBounds=YES;
        iconImageView.tag=200+index;
        //名称
        UILabel *cityLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellW, cellH)];
        cityLab.text=titleArray[index];
        cityLab.textColor=[UIColor whiteColor];
        cityLab.textAlignment=NSTextAlignmentCenter;
        cityLab.font=[UIFont systemFontOfSize:16];
        [iconImageView addSubview:cityLab];
        if (index==titleArray.count-1) {
            if (type==1) {
                [iconImageView setImage:[UIImage imageNamed:@"gengduo-bg"]];
            }else if (type==2)
            {
                [iconImageView setImage:[UIImage imageNamed:@"gengduo-bg2"]];
            }
            
        }else
        {
//            [iconImageView setImage:[UIImage imageNamed:@"tiananmen2"]];
            //
            VLXHotDemesticDataModel *model=dataArray[index];
            //
            [iconImageView sd_setImageWithURL:[NSURL URLWithString:[ZYYCustomTool checkNullWithNSString:model.pic]] placeholderImage:[UIImage imageNamed:@"tiananmen2"]];
        }
        //添加手势
        iconImageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToEvent:)];
        [iconImageView addGestureRecognizer:tap];
    }
}
#pragma mark---事件
-(void)tapToEvent:(UITapGestureRecognizer *)tap
{
    NSLog(@"%ld",tap.view.tag);
    if (tap.view.tag-200==_titleArray.count-1) {//表示点击了更多
        if (_hotBlock) {
            _hotBlock(tap.view.tag-200,YES);
        }
    }else
    {
        if (_hotBlock) {
            _hotBlock(tap.view.tag-200,NO);
        }
    }
//    if (_hotBlock) {
//        _hotBlock(tap.view.tag);
//    }
}
#pragma mark
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

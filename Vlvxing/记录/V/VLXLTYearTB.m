//
//  VLXLTYearTB.m
//  Vlvxing
//
//  Created by Michael on 17/5/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXLTYearTB.h"
#import "VLXLTYearTbCell.h"
@interface VLXLTYearTB()<UITableViewDelegate,UITableViewDataSource>

@end


@implementation VLXLTYearTB

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.tableview.delegate=self;
        self.tableview.dataSource=self;

        self.tableview.backgroundColor=[UIColor clearColor];
        self.tableview.showsVerticalScrollIndicator=NO;
        self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableview];


        //在这里创建header
        UIView * yearView=[[UIView alloc]initWithFrame:CGRectMake(0, ScaleHeight(338.5), frame.size.width, 48)];
        yearView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:yearView.bounds      byRoundingCorners:UIRectCornerTopRight     cornerRadii:CGSizeMake(25, 24)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = yearView.bounds;
        maskLayer.path = maskPath.CGPath;
        yearView.layer.mask = maskLayer;
//        [self.view addSubview:yearView];
        //
        yearView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClickedToEvent:)];
        [yearView addGestureRecognizer:tap];
        //
        //创建图片
        UIImageView * yearImage=[UIImageView new];
        yearImage.image=[UIImage imageNamed:@"year"];
        [yearView addSubview:yearImage];
        [yearImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(yearView.mas_centerX);
            make.right.mas_equalTo(-ScaleWidth(6.5));
            make.centerY.equalTo(yearView.mas_centerY);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];

        self.tableview.tableHeaderView=yearView;

    }

    return self;
}
#pragma mark---事件
-(void)tapClickedToEvent:(UITapGestureRecognizer *)tap
{
    if (_yearBlock) {
        _yearBlock();
    }
}

#pragma mark
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;//从今年开始,往以前数n个年份

}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *currentDate=[NSDate date];
    
    NSInteger num=[currentDate fs_year];
    

    VLXLTYearTbCell * cell=[VLXLTYearTbCell cellWithTableView:tableView];
    cell.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.yaerlabel.text=[NSString stringWithFormat:@"%ld",num-indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 31.5;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyLog(@"点击了年份");
    NSDate *currentDate=[NSDate date];
    
    NSInteger num=[currentDate fs_year];
    if ([self.delegate respondsToSelector:@selector(tbSelcteyear:)]) {
        [self.delegate tbSelcteyear:  num- indexPath.row];
    }
}
@end

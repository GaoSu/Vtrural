//
//  VLXMineUserCell.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/18.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface VLXMineUserCell : UITableViewCell

@property(nonatomic ,strong)UIView *lineView1;

@property (nonatomic,strong) UIButton *topTitleBt1;//顶端三个文字按钮,(关注,粉丝,话)
@property (nonatomic,strong) UIButton *topTitleBt2;//顶端三个文字按钮,(关注,粉丝,话)
@property (nonatomic,strong) UIButton *topTitleBt3;//顶端三个文字按钮,(关注,粉丝,话)

-(void)setcellValuewithDic:(NSDictionary * )dic;
@end

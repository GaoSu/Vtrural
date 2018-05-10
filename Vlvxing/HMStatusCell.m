//
//  HMStatusCell.m
//  XingJu
//
//  Created by apple on 14-7-14.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMStatusCell.h"
#import "HMStatusDetailView.h"
#import "HMStatusToolbar.h"
#import "HMStatusFrame.h"
#import "HMDynamic.h"
#import "HMStatus.h"

@interface HMStatusCell()


@end

@implementation HMStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    HMStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HMStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) { // 初始化子控件
        // 1.添加微博具体内容
        HMStatusDetailView *detailView = [[HMStatusDetailView alloc] init];
        [self.contentView addSubview:detailView];

//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dayin)];
//        [detailView addGestureRecognizer:tap];
        self.detailView = detailView;

        // 2.添加工具条
        HMStatusToolbar *toolbar = [[HMStatusToolbar alloc] init];
        [self.contentView addSubview:toolbar];
        self.toolbar = toolbar;
        
        // 3.cell的设置
        self.backgroundColor = [UIColor clearColor];
        
         self.contentView.clipsToBounds=YES;
    }
    return self;
}
//-(void)dayin{
//    NSLog(@"点击了");
//}
- (void)setStatusFrame:(HMStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
   
    // 1.微博具体内容的frame数据
    self.detailView.detailFrame = statusFrame.detailFrame;
    
    // 2.底部工具条的frame数据
    self.toolbar.frame = statusFrame.toolbarFrame;
    
    self.toolbar.dynamic = statusFrame.status.dynamic;
    
    self.contentView.clipsToBounds=YES;
}
@end

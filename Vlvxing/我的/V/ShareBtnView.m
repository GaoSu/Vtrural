//
//  ShareBtnView.m
//  ZuoXun
//
//  Created by handong001 on 17/4/27.
//  Copyright © 2017年 handong001. All rights reserved.
//

#import "ShareBtnView.h"

@implementation ShareBtnView
-(instancetype)init
{
    if(self=[super init])
    {
        self.frame=CGRectMake(15, ScreenHeight-221, ScreenWidth - 30,171);
        self.backgroundColor=[UIColor colorWithHexString:(@"ffffff")];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        
        [self addChidView];
    }
    return self;
}
#pragma mark--addChidView
-(void)addChidView
{
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 30-14-19,  14, 19, 19)];
    [closeBtn setImage:[UIImage imageNamed:@"guanbi-1"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(didCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    CGFloat maginOne=(ScreenWidth-90-90-90-26*2)/2;
    UIView*lineOne=[[UIView alloc]initWithFrame:CGRectMake(maginOne, 28, 90, 1)];
    lineOne.backgroundColor=[UIColor colorWithHexString:(@"D5D5D5")];
    [self addSubview:lineOne];
    
    UILabel*lable=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineOne.frame)+13, 22, 90, 13)];
    lable.textColor=[UIColor colorWithHexString:(@"999999")];
    lable.font=[UIFont systemFontOfSize:14];
    lable.text=@"选择账号分享";
    [self addSubview:lable];
    
    UIView*lineTwo=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lable.frame)+13, 28, 90, 1)];
    lineTwo.backgroundColor=[UIColor colorWithHexString:(@"D5D5D5")];
    [self addSubview:lineTwo];
    //
    NSArray*titleArr=@[@"QQ",@"微博",@"微信",@"朋友圈"];
    NSArray*titleImage=@[@"qq-blue",@"microblog-red",@"wechat-green",@"Friends-yellow"];
    CGFloat btnWidth=96/2;
    CGFloat margin=(self.frame.size.width-titleArr.count*btnWidth)/(titleArr.count+1);
    for (int i=0; i<titleArr.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(margin+(margin+btnWidth)*i, CGRectGetMaxY(lable.frame)+40, btnWidth, btnWidth);
        btn.tag=555+i;
        // btn.backgroundColor=[UIColor greenColor];
        btn.titleLabel.font=[UIFont systemFontOfSize:13];

        [btn setTitleColor:[UIColor colorWithHexString:(@"333333")] forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:titleImage[i]] forState:UIControlStateNormal];
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:9];
        [btn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }

    
}
#pragma mark--
-(void)clickShareBtn:(UIButton*)btn
{
    NSLog(@"%ld",btn.tag);
    if (_btnShareBlock) {
        _btnShareBlock(btn.tag);//555,QQ 556,新浪微博 557,微信 558,朋友圈
    }
    switch (btn.tag) {
        case 555:
        {
        }
            break;
        case 556:
        {
        }
            break;
        case 557:
        {
        }
            break;
        case 558:
        {
        }
            break;
        default:
            break;
    }
}

-(void)didCloseAction:(UIButton *)btn{
    if (_delegate && [_delegate respondsToSelector:@selector(didClickCloseBtn)]) {
        [_delegate didClickCloseBtn];
    }
}


@end

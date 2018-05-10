//
//  VLXOrderFooterView.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/5.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXOrderFooterView.h"
@interface VLXOrderFooterView ()
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,copy)NSString* price;
@end
@implementation VLXOrderFooterView
-(instancetype)initWithFrame:(CGRect)frame andType:(NSInteger )type andPrice:(NSString *)price//0 待支付 1 已支付，2已评价,3已取消
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        self.frame=CGRectMake(0, 0, kScreenWidth, 49);
        _price=price;
        _type=type;
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    if (_type==0) {
        //总价
        UILabel *priceLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, self.frame.size.height)];
        //可变字体
        NSString *priceStr=[NSString stringWithFormat:@" 总价：￥%@",_price];
        NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:priceStr];
        NSRange range=[priceStr rangeOfString:[NSString stringWithFormat:@"￥%@",_price]];
        [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(0, range.location)];//   总价：
        [attStr addAttributes:@{NSForegroundColorAttributeName:orange_color, NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} range:range];//价格 ￥%@
        priceLab.attributedText=attStr;
        //
        priceLab.textAlignment=NSTextAlignmentCenter;
        [self addSubview:priceLab];
        //取消订单 //立即支付
        CGFloat btnWidth=(kScreenWidth-125)/2;
        NSArray *titleArray=@[@"取消订单",@"立即支付"];
        NSArray *colorArray=@[blue_color,orange_color];
        for (int i=0; i<2; i++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(i*btnWidth+CGRectGetMaxX(priceLab.frame), 0, btnWidth, self.frame.size.height);
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont systemFontOfSize:19];
            btn.backgroundColor=colorArray[i];
            [btn addTarget:self action:@selector(btnClickedToEvent:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=100+i;
            [self addSubview:btn];
        }
    }else if (_type==1)
    {
        UIButton *judgeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        judgeBtn.frame=self.frame;
        [judgeBtn setTitle:@"去评价" forState:UIControlStateNormal];
        [judgeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        judgeBtn.titleLabel.font=[UIFont systemFontOfSize:19];
        [judgeBtn setBackgroundColor:blue_color];
        [judgeBtn addTarget:self action:@selector(btnClickedToEvent:) forControlEvents:UIControlEventTouchUpInside];
        judgeBtn.tag=200;
        [self addSubview:judgeBtn];
    }
}
-(void)btnClickedToEvent:(UIButton *)sender
{
    NSLog(@"%ld",sender.tag);
    if (sender.tag==100||sender.tag==101) {//取消订单 立即支付
        if (_btnBlock) {
            _btnBlock(sender.tag-100);
        }
    }else if (sender.tag==200)//评价
    {
        if (_btnBlock) {
            _btnBlock(2);
        }
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

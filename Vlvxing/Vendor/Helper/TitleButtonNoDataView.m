//
//  TitleButtonNoDataView.m
//  pinche
//
//  Created by handong on 16/12/8.
//  Copyright © 2016年 撼动科技006. All rights reserved.
//

#import "TitleButtonNoDataView.h"

@interface TitleButtonNoDataView ()
{
    UILabel *_noDataTitleLabel;
    UIButton *_noDataButton;
}
@end

@implementation TitleButtonNoDataView
- (instancetype)init{
    if (self = [super init]) {
        _noDataTitleLabel = [[UILabel alloc]init];
        [self addSubview:_noDataTitleLabel];
        _noDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_noDataButton];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _noDataTitleLabel = [[UILabel alloc]init];
        [self addSubview:_noDataTitleLabel];
        _noDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_noDataButton];
    }
    return self;
}
- (void)layoutSubviews{
    
    
    [super layoutSubviews];
    /**
     *  创建按钮
     */
    CGFloat noDataButtonW = self.frame.size.width * 0.5;
    CGFloat noDataButtonH = 45;
    
    CGFloat btnY=(self.frame.size.height-noDataButtonH)/2;
    CGFloat btnX=(self.frame.size.width-noDataButtonW)/2;
    
    _noDataButton.frame = CGRectMake(btnX, btnY, noDataButtonW, noDataButtonH);
//    _noDataButton.center = self.center;
    [_noDataButton setBackgroundImage:[UIImage imageNamed:@"按钮.png"] forState:UIControlStateNormal];
    [_noDataButton setTitle:@"点击重试" forState:UIControlStateNormal];
    [_noDataButton setTitleColor:[UIColor hexStringToColor:@"#666666"] forState:UIControlStateNormal];
    _noDataButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_noDataButton addTarget:self action:@selector(clickNoDataButton:) forControlEvents:UIControlEventTouchUpInside];
    _noDataButton.layer.cornerRadius = 5;
    
    
    //title
    
    CGFloat titleW = self.frame.size.width;
    CGFloat titleTextH = [_noDataTitleLabel.text boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    CGFloat titleH = titleTextH;
    CGFloat titleX = 0;
    CGFloat titleY = _noDataButton.frame.origin.y - 20 - titleH;
    _noDataTitleLabel.frame = CGRectMake(titleX, titleY, titleW, titleTextH);
    _noDataTitleLabel.textAlignment = NSTextAlignmentCenter;
    _noDataTitleLabel.textColor = [UIColor hexStringToColor:@"#666666"];
    
  
    
    _noDataTitleLabel.font = [UIFont systemFontOfSize:15];
    _noDataTitleLabel.numberOfLines = 0;
    
}

- (void)clickNoDataButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(titleButtonNoDataView:didClickButton:) ]) {
        [self.delegate titleButtonNoDataView:self didClickButton:sender];
    }
}
- (void)setTitleText:(NSString *)titleText{
    _noDataTitleLabel.text = titleText;
    [self layoutSubviews];
}
- (void)setNoDataButtonIsHidden:(BOOL)noDataButtonIsHidden{
    _noDataButton.hidden = noDataButtonIsHidden;
}
@end

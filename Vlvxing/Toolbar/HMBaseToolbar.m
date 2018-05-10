//
//  HMBaseToolbar.m
//  XingJu
//
//  Created by apple on 14-7-22.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMBaseToolbar.h"
#import "HMStatus.h"
#import "HMDynamic.h"
#import "HMAccountTool.h"

@interface HMBaseToolbar()
@property (nonatomic, strong) NSMutableArray *btns;
//地址
@property (nonatomic, weak) UIButton *repostsBtn;
//空
@property (nonatomic, weak) UIButton *kongBtn;
//浏览量
@property (nonatomic, weak) UIButton *commentsBtn;
//评论量
@property (nonatomic, weak) UIButton *attitudesBtn;
//点赞
@property (nonatomic ,weak) UIButton * dianzanBtn;

@end

@implementation HMBaseToolbar
- (NSMutableArray *)btns
{
    if (_btns == nil) {
        self.btns = [NSMutableArray array];
    }
    return _btns;
}

//初始化工具条时，初始化内部的按钮
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.repostsBtn = [self setupBtnWithIcon:@"dizhiii" selectImage:@"dizhiii" title:@"北京" tag:HMBaseToolbarCollection];

        self.kongBtn = [self setupBtnWithIcon:@"" selectImage:@"" title:@"" tag:HMBaseToolbarCollection];
        
        self.commentsBtn = [self setupBtnWithIcon:@"xianshi2" selectImage:nil title:@"浏览量:" tag:HMBaseToolbarCollection];
        
        self.attitudesBtn = [self setupBtnWithIcon:@"comment-0" selectImage:nil title:@"评论:" tag:HMBaseToolbarComment];

        self.dianzanBtn = [self setupBtnWithIcon:@"like" selectImage:@"like_highlighted" title:@"赞" tag:HMBaseToolbarLike];
    }
    return self;
}
/**
 *  添加按钮
 *
 *  @param icon  图标
 *  @param title 标题
 */
- (UIButton *)setupBtnWithIcon:(NSString *)icon selectImage:(NSString *)selectImage title:(NSString *)title tag:(HMBaseToolbarType)tag
{
    UIButton *btn = [[UIButton alloc] init];
    btn.tag = tag;
    
    [btn addTarget:self action:@selector(clickToolBarBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageWithName:selectImage] forState:UIControlStateSelected];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    // 设置高亮时的背景
    [btn setBackgroundImage:[UIImage resizedImage:@"common_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.adjustsImageWhenHighlighted = NO;
    
    // 设置间距
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    [self addSubview:btn];
    
    [self.btns addObject:btn];
    
    return btn;
}


//点击toolBar里面的按钮
- (void)clickToolBarBtn:(UIButton *)button
{
//    button.selected = !button.selected;
    
    //    HMFUNC;
    if ([self.delegate respondsToSelector:@selector(toolBar:didClickButtonType:button: dynamic:)]) {
        [self.delegate toolBar:self didClickButtonType:button.tag button:button dynamic:_dynamic];

    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    NSUInteger btnCount = self.btns.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = self.btns[i];
        btn.width = btnW;
        btn.height = btnH;
        btn.y = 0;
        btn.x = i * btnW;
    }
}

- (void)setDynamic:(HMDynamic *)dynamic
{
    _dynamic = dynamic;
    
    NSLog(@"%zd",dynamic.collectionCount);
    
    if (dynamic.collectionState == 0) {
        self.repostsBtn.selected = NO;
    }else if (dynamic.collectionState == 1){
        self.repostsBtn.selected = YES;
    }
    
    if (dynamic.likeState == 0) {
        self.attitudesBtn.selected = NO;
    }else{
        self.attitudesBtn.selected = YES;
    }
    
    [self setupBtnTitle:self.repostsBtn count:dynamic.collectionCount defaultTitle:@"北京"];

    NSLog_JSON(@"收藏数量--%zd",dynamic.collectionCount);

    [self setupBtnTitle:self.commentsBtn count:dynamic.commentCount defaultTitle:@"浏览量"];//
    
    [self setupBtnTitle:self.attitudesBtn count:dynamic.commentCount defaultTitle:@"评论"];

    [self setupBtnTitle:self.dianzanBtn count:dynamic.likeCount defaultTitle:@"赞"];


    NSLog_JSON(@"点赞数量--%zd",dynamic.likeCount);
    
}

/**
 *  设置按钮的文字
 *
 *  @param button       需要设置文字的按钮
 *  @param count        按钮显示的数字
 *  @param defaultTitle 数字为0时显示的默认文字
 */
- (void)setupBtnTitle:(UIButton *)button count:(NSUInteger)count defaultTitle:(NSString *)defaultTitle
{
    if (count >= 10000) { // [10000, 无限大)
        defaultTitle = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
        
//        NSLog_JSON(@"defaultTitle--%@,count--%zd",defaultTitle,count);
        
        // 用空串替换掉所有的.0
        defaultTitle = [defaultTitle stringByReplacingOccurrencesOfString:@".0" withString:@""];
    } else if (count > 0) { // (0, 10000)
        defaultTitle = [NSString stringWithFormat:@"%zd", count];
        
//        NSLog_JSON(@"count--(0, 10000)-%zd,defaultTitle-%@",count,defaultTitle);
        
    }
    
    [button setTitle:defaultTitle forState:UIControlStateNormal];
}
@end

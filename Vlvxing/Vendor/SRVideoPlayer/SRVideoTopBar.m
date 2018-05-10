//
//  SRVideoTopBar.m
//  SRVideoPlayer
//
//  Created by https://github.com/guowilling on 17/1/6.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRVideoTopBar.h"
#import "Masonry.h"

#define SRVideoPlayerImageName(fileName) [@"SRVideoPlayer.bundle" stringByAppendingPathComponent:fileName]

@interface SRVideoTopBar ()

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UILabel  *titleLabel;

@property (nonatomic, strong) UIButton *downloadBtn;

@end

@implementation SRVideoTopBar

- (UIButton *)closeBtn {
    
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.showsTouchWhenHighlighted = YES;
        [_closeBtn setImage:[UIImage imageNamed:SRVideoPlayerImageName(@"closegrm")] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:17.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (UIButton *)downloadBtn {
    
    if (!_downloadBtn) {
        _downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _downloadBtn.showsTouchWhenHighlighted = YES;
        [_downloadBtn setImage:[UIImage imageNamed:SRVideoPlayerImageName(@"download")] forState:UIControlStateNormal];
        [_downloadBtn addTarget:self action:@selector(downloadBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadBtn;
}

+ (instancetype)videoTopBar {
    
    return [[SRVideoTopBar alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        __weak typeof(self) weakSelf = self;
        
        [self addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(44);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.closeBtn.mas_right);
            make.right.equalTo(weakSelf.mas_right).offset(-44);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
//        [self addSubview:self.downloadBtn];
//        [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//            make.width.mas_equalTo(44);
//            make.height.mas_equalTo(44);
//        }];
    }
    return self;
}

- (void)closeBtnAction {
    
//    if ([_delegate respondsToSelector:@selector(videoTopBarDidClickCloseBtn)]) {
//        [_delegate videoTopBarDidClickCloseBtn];
//    }
}

- (void)downloadBtnAction {
    
    self.downloadBtn.userInteractionEnabled = NO;
    if ([_delegate respondsToSelector:@selector(videoTopBarDidClickDownloadBtn)]) {
        [_delegate videoTopBarDidClickDownloadBtn];
    }
}

- (void)setTitle:(NSString *)text {
    
    self.titleLabel.text = text;
}

@end

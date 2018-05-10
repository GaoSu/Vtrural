//
//  XWPicChooseAlterView.h
//  XWQY
//
//  Created by 撼动科技006 on 17/3/14.
//  Copyright © 2017年 XWQY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XWPicChooseAlterViewDelegate <NSObject>

-(void)clickBtnNumber:(int)type;//0为拍照上传  1为本地上传

@end
@interface XWPicChooseAlterView : UIView
@property(nonatomic,weak)id<XWPicChooseAlterViewDelegate>delegate;
@end

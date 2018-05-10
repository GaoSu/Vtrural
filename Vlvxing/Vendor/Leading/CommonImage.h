//
//  CommonImage.h
//  lvxingyongche
//
//  Created by Michael on 16/1/8.
//  Copyright © 2016年 handong001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonImage : UIImageView

-(id)initWithFrame:(CGRect)frame imageURL:(NSString *)imageURL;

-(id)initWithFrame:(CGRect)frame imageName:(NSString *)imageName;
@end

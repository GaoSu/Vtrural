//
//  CustomerInfoSectionView.h
//  Vlvxing
//
//  Created by grm on 2017/11/15.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomerInfoSectionViewDelegate;


@interface CustomerInfoSectionView : UIView

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *managerNameLabel;
@property(nonatomic,strong)UILabel *departmentLabel;
@property(nonatomic,strong)UILabel *addressLabel;

@property (assign, nonatomic) BOOL isOpen;
@property (nonatomic, assign) id <CustomerInfoSectionViewDelegate> delegate;
@property (nonatomic, assign) NSInteger section;
@property (strong, nonatomic) UIImageView *arrow;
-(void)toggleOpen:(id)sender;
-(void)toggleOpenWithUserAction:(BOOL)userAction;
- (void)initWithNameLabel:(NSString*)name ManagerNameLabel:(NSString*)managerName DepartmentLabel:(NSString*)department AddressLabel:(NSString*)address section:(NSInteger)sectionNumber delegate:(id <CustomerInfoSectionViewDelegate>)delegate;





@end


@protocol CustomerInfoSectionViewDelegate <NSObject>

@optional
-(void)sectionHeaderView:(CustomerInfoSectionView*)sectionHeaderView sectionOpened:(NSInteger)section;//开

-(void)sectionHeaderView:(CustomerInfoSectionView*)sectionHeaderView sectionClosed:(NSInteger)section;//关

@end


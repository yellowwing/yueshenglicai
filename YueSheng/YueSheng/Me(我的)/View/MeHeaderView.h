//
//  MeHeaderView.h
//  通信录
//
//  Created by yellow on 16/7/2.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MeHeaderView;
@protocol MeHeaderViewDelegate <NSObject>

@optional
-(void)meHeaderViewDidChangeIcon:(MeHeaderView*)headerView;

@end


@interface MeHeaderView : UIView

+(instancetype)headerView;

@property(nonatomic,copy)NSString *account;

@property(nonatomic,strong)UIImage *iconImage;

@property(nonatomic,copy)NSString *iconString;

@property(nonatomic,weak)id<MeHeaderViewDelegate>delegate;

@end

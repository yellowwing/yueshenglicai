//
//  MainPageView.h
//  YueSheng
//
//  Created by yellow on 16/7/15.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColumnView.h"
@class MainPageView,YWPageStatus,YWColumnStatus;

@protocol MainPageViewDelegate <NSObject>

@optional
-(void)mainPageView:(MainPageView*)mainPageView didChooseIndex:(NSInteger)index columnStatus:(YWColumnStatus *)columnStatus pageStatus:(YWPageStatus *)pageStatus;

-(void)mainPageViewDidClickCustomBtn:(MainPageView*)mainPageView;


@end
@interface MainPageView : UIView

+(instancetype)mainPageView;


@property(nonatomic,strong)NSArray *columnArray;

@property(nonatomic,strong)NSArray *pageStatusArray;

@property(nonatomic,weak)id<MainPageViewDelegate> delegate;

@end

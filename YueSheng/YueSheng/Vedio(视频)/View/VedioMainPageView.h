//
//  VedioMainPageView.h
//  YueSheng
//
//  Created by yellow on 16/7/23.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VedioMainPageView,YWVedioPageStatus,YWColumnStatus;
@protocol VedioMainPageViewDelegate <NSObject>

@optional

-(void)mainPageView:(VedioMainPageView*)mainPageView didChooseIndex:(NSInteger)index columnStatus:(YWColumnStatus *)columnStatus pageStatus:(YWVedioPageStatus *)pageStatus;

-(void)mainPageViewDidClickCustomBtn:(VedioMainPageView*)mainPageView;

@end
@interface VedioMainPageView : UIView

+(instancetype)mainPageView;


@property(nonatomic,strong)NSArray *columnArray;

@property(nonatomic,strong)NSArray *pageStatusArray;

@property(nonatomic,weak)id<VedioMainPageViewDelegate> delegate;

@end

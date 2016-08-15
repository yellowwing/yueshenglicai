//
//  StarMainPageView.h
//  YueSheng
//
//  Created by yellow on 16/7/26.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StarMainPageView,YWStarPageStatus,YWStarColumnStatus;
@protocol StarMainPageViewDelegate <NSObject>

@optional

-(void)mainPageView:(StarMainPageView*)mainPageView didChooseIndex:(NSInteger)index columnStatus:(YWStarColumnStatus *)columnStatus pageStatus:(YWStarPageStatus *)pageStatus;

-(void)mainPageViewDidClickCustomBtn:(StarMainPageView*)mainPageView;

@end

@interface StarMainPageView : UIView

+(instancetype)mainPageView;

@property(nonatomic,strong)NSArray *columnArray;

@property(nonatomic,strong)NSArray *pageStatusArray;

@property(nonatomic,weak)id<StarMainPageViewDelegate> delegate;

@end

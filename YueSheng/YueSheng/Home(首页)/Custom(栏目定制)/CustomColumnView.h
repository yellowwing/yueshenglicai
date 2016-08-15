//
//  CustomColumnView.h
//  YueSheng
//
//  Created by yellow on 16/7/20.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomColumnView;

@protocol CustomColumnViewDelegate <NSObject>

@optional
-(void)customColumnViewDidClickCustomBtn:(CustomColumnView*)customColumnView;

@end
@interface CustomColumnView : UIView


+(instancetype)customColumnView;

@property(nonatomic,assign)id<CustomColumnViewDelegate>delegate;

@property(nonatomic,strong)NSMutableArray *columnStatusArray;

@end

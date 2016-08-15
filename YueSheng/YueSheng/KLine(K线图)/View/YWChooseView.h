//
//  YWChooseView.h
//  通信录
//
//  Created by yellow on 16/7/13.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWChooseView;

@protocol YWChooseViewDelegate <NSObject>

@optional
-(void)chooseView:(YWChooseView*)choiceView didClickedButtonIndex:(NSInteger)index;

@end

@interface YWChooseView : UIView


@property (nonatomic, strong) NSArray *items;

/**
 *  一个segment的宽度
 */
//@property (nonatomic, assign) CGFloat segmentWidth;

/**
 *  设置当前选中的segment
 */
@property (nonatomic, assign) NSInteger selectedSegmentIndex;

@property(nonatomic,weak)id<YWChooseViewDelegate>delegate;


@end

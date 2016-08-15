//
//  YWSegementController.h
//  通信录
//
//  Created by yellow on 16/7/13.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWSegementControl;

@protocol YWSegementControlDelegate <NSObject>

@optional
-(void)segmentControl:(YWSegementControl*)segmentControl didClickedButtonIndex:(NSInteger)index;

@end

@interface YWSegementControl : UIView

@property(nonatomic,strong) NSArray *items;

/**
 *  设置当前选中的segment
 */
@property (nonatomic, assign) NSInteger selectedSegmentIndex;

@property(nonatomic,weak)id<YWSegementControlDelegate>delegate;

@end

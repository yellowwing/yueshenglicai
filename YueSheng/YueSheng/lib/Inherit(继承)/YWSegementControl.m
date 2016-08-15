//
//  YWSegementController.m
//  通信录
//
//  Created by yellow on 16/7/13.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWSegementControl.h"
#import "YWSegement.h"
#import "UIImage+YW.h"

@interface YWSegementControl()
@property (nonatomic, weak) YWSegement *selectedSegment;

@property(nonatomic,strong)NSMutableArray *btnArray;

@property(nonatomic,strong)NSMutableArray *lineArray;

@end

@implementation YWSegementControl

-(NSMutableArray *)btnArray{
    if (_btnArray == nil) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

-(NSMutableArray *)lineArray{
    if (_lineArray == nil) {
        _lineArray = [NSMutableArray array];
    }
    return _lineArray;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    
    // 1.移除以前创建的按钮
    [self.btnArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
      [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 2.添加新的按钮
    NSInteger count = items.count;
    for (int i = 0; i<count; i++) {
        YWSegement *segment = [[YWSegement alloc] init];
        
        // 设置tag
        segment.tag = i;
        
        // 设置文字
        [segment setTitle:items[i] forState:UIControlStateNormal];
        // 设置背景
        [segment setBackgroundImage:[UIImage imageWithColor:YWColorRGBA(255, 255, 255, 0.4)] forState:UIControlStateNormal];
        [segment setBackgroundImage:[UIImage imageWithColor:YWColorRGBA(20, 20, 20, 0.3)] forState:UIControlStateSelected];
        
        [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:segment];
        [self.btnArray addObject:segment];
        
        if (i != count - 1) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:line];
            [self.lineArray addObject:line];
        }
        
    }
}
- (void)segmentClick:(YWSegement *)segment
{
    if ([self.delegate respondsToSelector:@selector(segmentControl:didClickedButtonIndex:)]) {
        [self.delegate segmentControl:self didClickedButtonIndex:segment.tag];
    }
    
    self.selectedSegment.selected = NO;
    segment.selected = YES;
    self.selectedSegment = segment;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.btnArray.count;
    
    CGFloat lineW = 0.5;
    CGFloat lineH = self.bounds.size.height;
    
    CGFloat buttonW = self.bounds.size.width / count - lineW;
    CGFloat buttonH = self.bounds.size.height;
    for (NSInteger i = 0; i<count; i++) {
        YWSegement *button = self.btnArray[i];
        button.frame = CGRectMake(i * buttonW, 0, buttonW, buttonH);
        
        if (i != count - 1) {
             UIView *line = self.lineArray[i];
            line.frame = CGRectMake((i+1) * buttonW, 0, lineW, lineH);
        }
       
        
    }
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    NSInteger count = self.items.count;
    if (selectedSegmentIndex < 0 || selectedSegmentIndex >= count) return;
    
    // 取出对应位置的按钮
    YWSegement *segment = self.btnArray[selectedSegmentIndex];
    
    // 点击
    [self segmentClick:segment];
}

- (NSInteger)selectedSegmentIndex
{
    return self.selectedSegment.tag;
}

@end

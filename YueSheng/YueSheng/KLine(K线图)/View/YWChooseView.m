//
//  YWChooseView.m
//  通信录
//
//  Created by yellow on 16/7/13.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWChooseView.h"
#import "YWSegement.h"
#import "UIImage+YW.h"
//#import "YWTool.h"
@interface YWChooseView()
@property (nonatomic, weak) YWSegement *selectedSegment;
@property(nonatomic,weak)UIView *line;
@property(nonatomic,strong)NSMutableArray *btnArray;
@property(nonatomic,strong)NSMutableArray *seperatorArray;
@end

@implementation YWChooseView

-(NSMutableArray*)btnArray{
    if (_btnArray == nil) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

-(NSMutableArray*)seperatorArray{
    if (_seperatorArray == nil) {
        _seperatorArray = [NSMutableArray array];
    }
    return _seperatorArray;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self setup];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    return self;
}

-(void)setup{

    self.backgroundColor = YWColor(235, 235, 235);
    
    UIView *line = [[UIView alloc] init];
    
    [self addSubview: line];
    
    line.backgroundColor = [UIColor purpleColor];
    
    line.layer.cornerRadius = 5;
    
    self.line = line;
    
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    
    // 1.移除以前创建的按钮
    [self.btnArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 2.添加新的按钮
    NSInteger count = items.count;
    for (int i = 0; i<count; i++) {
        YWSegement *segment = [[YWSegement alloc] init];
        
        // 设置tag
        segment.tag = i;
        
        // 设置文字
        [segment setTitle:items[i] forState:UIControlStateNormal];
      
        //设置颜色
        [segment setBackgroundColor:YWColorRGBA(235, 235, 235, 1) forState:UIControlStateNormal];
        [segment setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [segment setTitleColor:[UIColor purpleColor] forState:UIControlStateSelected];
        
        
        if (i == 0) {
            segment.selected = YES;
            self.selectedSegment = segment;
        }

        [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:segment];
        [self.btnArray addObject:segment];
        
        if (i != count - 1) {
            
            UIView *seperator = [[UIView alloc] init];
            [self.seperatorArray addObject:seperator];
            [self addSubview:seperator];
            seperator.backgroundColor = [UIColor darkGrayColor];
            seperator.alpha = 0.8;
        }
        
        
    }
}

- (void)segmentClick:(YWSegement *)segment
{
    
    if ([self.delegate respondsToSelector:@selector(chooseView:didClickedButtonIndex:)]) {
        [self.delegate chooseView:self didClickedButtonIndex:segment.tag];
    }
    
    self.selectedSegment.selected = NO;
    segment.selected = YES;
    self.selectedSegment = segment;
    
    
    NSInteger count = self.btnArray.count;
    CGFloat lineW = self.bounds.size.width / count;
    CGPoint lineCenter = self.line.center;
    lineCenter.x = lineW/2 + lineW * segment.tag;
    [UIView animateWithDuration:0.2 animations:^{
        
        self.line.center = lineCenter;
        
    }];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.btnArray.count;
    
    
    CGFloat lineH = 2.5;
    CGFloat lineW = self.bounds.size.width / count;
    CGFloat lineX = self.selectedSegmentIndex * lineW;
    CGFloat lineY = self.bounds.size.height - lineH;
    self.line.frame = CGRectMake(lineX, lineY, lineW, lineH);
    
    CGFloat seperatorW = 0.5;
    CGFloat seperatorY = 5;
    CGFloat seperatorH = self.bounds.size.height - 10;
    
    CGFloat buttonW = lineW - seperatorW;
    CGFloat buttonH = self.bounds.size.height - lineH;
    for (NSInteger i = 0; i<count; i++) {
        YWSegement *button = self.btnArray[i];
        button.frame = CGRectMake(i * buttonW, 0, buttonW, buttonH);
        
        if (i != count - 1) {
            UIView *seperator = self.seperatorArray[i];
            CGFloat seperatorX = CGRectGetMaxX(button.frame);
            seperator.frame = CGRectMake(seperatorX, seperatorY, seperatorW, seperatorH);
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

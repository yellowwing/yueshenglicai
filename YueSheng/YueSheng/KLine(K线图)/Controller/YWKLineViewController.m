//
//  YWKLineViewController.m
//  通信录
//
//  Created by yellow on 16/7/12.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWKLineViewController.h"
#import "YWChooseView.h"
#import "YWHourlyView.h"
#import "YWKLineView.h"

@interface YWKLineViewController ()<YWChooseViewDelegate>
@property (weak, nonatomic) IBOutlet YWChooseView *chooseView;


@property(nonatomic,weak)YWHourlyView *hourlyView;

@property(nonatomic,weak)YWKLineView *kLineView;

@property(nonatomic,weak)UIView *fontView;

@end

#warning - 做模型
#warning - 做数据层tool
#warning - 调用接口加载数据
#warning - 做坐标转换
#warning - 绘图
#warning - 把加载好的数据转换成坐标，再给绘图view拿出点来画

@implementation YWKLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chooseView.items = @[@"分时",@"K线"];
    self.chooseView.delegate = self;
    
    CGFloat viewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat viewH = self.view.bounds.size.height - CGRectGetMaxY(self.chooseView.frame);
    CGFloat viewY = CGRectGetMaxY(self.chooseView.frame);
    
    YWKLineView *klineView = [YWKLineView kLineView];
    [self.view addSubview:klineView];
    klineView.frame = CGRectMake(0, viewY, viewW, viewH);
    self.kLineView = klineView;
    
    YWHourlyView *hourlyView = [YWHourlyView hourlyView];
    [self.view addSubview:hourlyView];
    hourlyView.frame = CGRectMake(0, viewY,viewW,viewH);
    self.hourlyView = hourlyView;
    
    //添加手势
    [self addSwipeGestureWithView:self.hourlyView direction:UISwipeGestureRecognizerDirectionLeft selector:@selector(hourlyViewSwipe:)];
    [self addSwipeGestureWithView:self.kLineView direction:UISwipeGestureRecognizerDirectionRight selector:@selector(klineViewSwipe:)];

}

#pragma mark - 添加手势
-(void)addSwipeGestureWithView:(UIView *)view direction:(UISwipeGestureRecognizerDirection)direction selector:(SEL)selector{
  UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:selector];
    swipeGesture.direction = direction;
    [view addGestureRecognizer:swipeGesture];

}


#pragma mark - 手势方法调用
-(void)klineViewSwipe:(UIGestureRecognizer *)gesture{

    self.chooseView.selectedSegmentIndex = 0;
    
    [self getOutAnimationOutView:self.kLineView toPoint:CGPointMake(self.chooseView.bounds.size.width, 0)];
    
    [self goInAnimationInView:self.hourlyView fromPoint:CGPointMake(-self.chooseView.bounds.size.width, 0)];
    
    self.fontView = self.hourlyView;
    
}

#pragma mark - 手势方法调用
-(void)hourlyViewSwipe:(UIGestureRecognizer *)gesture{

    self.chooseView.selectedSegmentIndex = 1;

    [self getOutAnimationOutView:self.hourlyView toPoint:CGPointMake(-self.chooseView.bounds.size.width, 0)];
    
    [self goInAnimationInView:self.kLineView fromPoint:CGPointMake(self.chooseView.bounds.size.width, 0)];

    self.fontView = self.kLineView;
    
}

#pragma mark - 平移动画
-(void)getOutAnimationOutView:(UIView *)outView toPoint:(CGPoint)toPoint{
    // 平移动画
    CABasicAnimation *move = [CABasicAnimation animation];
    move.keyPath = @"transform.translation";
   
    move.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    
    move.toValue = [NSValue valueWithCGPoint:toPoint];
    
    move.duration = 0.4;
    move.delegate = self;
    move.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [outView.layer addAnimation:move forKey:nil];

}

#pragma mark - 平移动画
-(void)goInAnimationInView:(UIView *)inView fromPoint:(CGPoint)fromPoint{
    // 平移动画
    CABasicAnimation *move = [CABasicAnimation animation];
    move.keyPath = @"transform.translation";
    
    move.fromValue = [NSValue valueWithCGPoint:fromPoint];
    
    move.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    move.duration = 0.4;
    move.delegate = self;
    move.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [inView.layer addAnimation:move forKey:nil];
    
}

#pragma mark - 动画代理
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    [self.view bringSubviewToFront:self.fontView];

}

#pragma mark - chooseView代理
-(void)chooseView:(YWChooseView *)choiceView didClickedButtonIndex:(NSInteger)index{
    
    if (index == 0) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.kLineView.alpha = 0;
            self.hourlyView.alpha = 1;
            
        } completion:^(BOOL finished) {
            
            [self.view bringSubviewToFront:self.hourlyView];
        }];
    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
            
            self.kLineView.alpha = 1;
            self.hourlyView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [self.view bringSubviewToFront:self.kLineView];
            
        }];
    }
}


@end

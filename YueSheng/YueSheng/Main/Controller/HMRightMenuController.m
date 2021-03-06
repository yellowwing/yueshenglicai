//
//  HMRightMenuController.m
//  原创网易新闻
//
//  Created by apple on 14-7-28.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMRightMenuController.h"
//#import "HMRightMenuCenterViewRow.h"

@interface HMRightMenuController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation HMRightMenuController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.填充中间的内容
//    [self setupCenterView];
    
    // 2.填充底部的内容
    [self setupBottomView];
}

/**
 *  填充中间的内容
 */
//- (void)setupCenterView
//{
//    HMRightMenuCenterViewRow *row =[self setupCenterViewRow:@"商城 能赚能花，土豪当家" icon:@"promoboard_icon_mall"];
//    [self setupCenterViewRow:@"活动 4.0发布会粉丝招募" icon:@"promoboard_icon_activities"];
//    [self setupCenterViewRow:@"应用 金币从来都是这送的" icon:@"promoboard_icon_apps"];
//    
//    self.centerView.height = self.centerView.subviews.count * row.height;
//}

//- (HMRightMenuCenterViewRow *)setupCenterViewRow:(NSString *)title icon:(NSString *)icon
//{
//    HMRightMenuCenterViewRow *row = [HMRightMenuCenterViewRow centerViewRow];
//    row.icon = icon;
//    row.title = title;
//    row.y = row.height * self.centerView.subviews.count;
//    [self.centerView addSubview:row];
//    return row;
//}

/**
 *  填充底部的内容
 */
- (void)setupBottomView
{
    
}

- (void)didShow
{
    // 让头像旋转
//    [UIView animateWithDuration:1.0 animations:^{
//        self.iconView.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
//    } completion:^(BOOL finished) {
//        self.iconView.image = [UIImage imageNamed:@"user_defaultgift"];
//        
//        [UIView animateWithDuration:1.0 animations:^{
//            self.iconView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
//        }];
//    }];
//    CATransition
//    CATransition *anim = [CATransition animation];
//    anim.duration = 1.0;
//    anim.type = @"rippleEffect";
//    [self.iconView.layer addAnimation:anim forKey:nil];
    
    [UIView transitionWithView:self.iconView duration:0.8 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.iconView.image = [UIImage imageNamed:@"user_defaultgift"];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView transitionWithView:self.iconView duration:0.8 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                self.iconView.image = [UIImage imageNamed:@"default_avatar"];
            } completion:nil];
        });
    }];
}

@end

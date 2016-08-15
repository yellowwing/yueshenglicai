//
//  YWNavigationController.m
//  通信录
//
//  Created by yellow on 16/6/28.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWNavigationController.h"

@interface YWNavigationController ()

@end

@implementation YWNavigationController

//系统在第一次使用这个类的时候调用
+(void)initialize{
    
    //1.设置导航栏主题
    [self setupNavBarTheme];
    
    //2.设置导航栏按钮主题
    [self setupBarButtonItemTheme];
    
}


//1.设置导航栏主题
+(void)setupNavBarTheme{
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:[UIColor colorWithRed:34/255.0 green:74/255.0 blue:239/255.0 alpha:1]];
       [navBar setTintColor:[UIColor whiteColor]];
    
    //设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [navBar setTitleTextAttributes:textAttrs];
}

//2.设置导航栏按钮主题
+(void)setupBarButtonItemTheme{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
}

//重写pushViewController
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //左边返回按钮不显示文字
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"";
    viewController.navigationItem.backBarButtonItem = barButtonItem;
    
    //push的时候隐藏tabbar
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


@end

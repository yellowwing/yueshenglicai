//
//  YWRootViewController.m
//  YueSheng
//
//  Created by yellow on 16/8/3.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWRootViewController.h"
#import "HMLeftMenu.h"
#import "YWTabBarController.h"
#import "YWNavigationController.h"
#import "YWStockViewController.h"
#import "HMRightMenuController.h"

#define HMNavShowAnimDuration 0.25
#define HMCoverTag 100

#define HMLeftMenuW 150
#define HMLeftMenuH 300
#define HMLeftMenuY 64

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface YWRootViewController ()<HMLeftMenuDelegate>

/**
 *  正在显示的导航控制器
 */
@property (nonatomic, weak) UIViewController *showingController;
@property (nonatomic, strong) HMRightMenuController *rightMenuVc;

@property (nonatomic, weak) HMLeftMenu *leftMenu;
@end

@implementation YWRootViewController
/**
 *  添加右菜单
 */
- (void)setupRightMenu
{
    HMRightMenuController *rightMenuVc = [[HMRightMenuController alloc] init];
    
    
    [self.view insertSubview:rightMenuVc.view atIndex:1];
    WS(weakSelf);
    [rightMenuVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(64,  self.view.width - rightMenuVc.view.width, 64, 0));
        
    }];
    
    self.rightMenuVc = rightMenuVc;
    //监听跳转通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightMenuClick) name:@"RightMenuNotification" object:nil];
    
}

/**
 *  添加左菜单
 */
- (void)setupLeftMenu
{
    // 2.添加左菜单
    HMLeftMenu *leftMenu = [[HMLeftMenu alloc] init];
    leftMenu.delegate = self;
    [self.view insertSubview:leftMenu atIndex:1];
    WS(weakSelf);
    [leftMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(64, 0, 150, self.view.frame.size.width/2));
        
    }];
    
    //监听跳转通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftMenuClick:) name:@"LeftMenuNotification" object:nil];
    
    self.leftMenu = leftMenu;
}

/**
 *  创建子控制器
 */
- (void)setupAllChildVcs
{
    // 1.创建子控制器
    // 1.1.新闻控制器
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    YWTabBarController *tabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"tabBarVC"];
    
    [self setupVc:tabBarVC];
    
    UIViewController *stockVC = [storyboard instantiateViewControllerWithIdentifier:@"StockVC"];
    
    [self setupVc:stockVC];
    
    UIViewController *reviewVC = [storyboard instantiateViewControllerWithIdentifier:@"ReviewVC"];
    
    [self setupVc:reviewVC];
    
    UIViewController *broadcastVC = [storyboard instantiateViewControllerWithIdentifier:@"BroadcastVC"];
    
    [self setupVc:broadcastVC];
    
    UIViewController *marketVC = [storyboard instantiateViewControllerWithIdentifier:@"MarketVC"];
    
    [self setupVc:marketVC];
    
    UIViewController *lettersVC = [storyboard instantiateViewControllerWithIdentifier:@"LettersVC"];
    
    [self setupVc:lettersVC];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 1.创建子控制器
    [self setupAllChildVcs];
    
    // 2.添加左菜单
    [self setupLeftMenu];
    
    // 3.添加右菜单
    [self setupRightMenu];
    
 }

-(void)leftMenuClick:(NSNotification *)notification{
  
    self.leftMenu.hidden = NO;
    self.rightMenuVc.view.hidden = YES;
        
    [UIView animateWithDuration:HMNavShowAnimDuration animations:^{
        // 取出正在显示的导航控制器的view
        UIView *showingView = self.showingController.view;
        
        CGFloat leftMenuWidth = [UIScreen mainScreen].bounds.size.width/2;
        
        // 缩放比例
        CGFloat navH = [UIScreen mainScreen].bounds.size.height - 2 * 60;
        CGFloat scale = navH / [UIScreen mainScreen].bounds.size.height;
        
        // 菜单左边的间距
        CGFloat leftMenuMargin = [UIScreen mainScreen].bounds.size.width * (1 - scale) * 0.5;
        CGFloat translateX = leftMenuWidth - leftMenuMargin;
        
        CGFloat topMargin = [UIScreen mainScreen].bounds.size.height * (1 - scale) * 0.5;
        CGFloat translateY = topMargin - 60;
        
        // 缩放
        CGAffineTransform scaleForm = CGAffineTransformMakeScale(scale, scale);
        // 平移
        CGAffineTransform translateForm = CGAffineTransformTranslate(scaleForm, translateX / scale, -translateY / scale);
        
        showingView.transform = translateForm;
        
        // 添加一个遮盖
        UIButton *cover = [[UIButton alloc] init];
        cover.tag = HMCoverTag;
        [cover addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchUpInside];
        cover.frame = showingView.bounds;
        [showingView addSubview:cover];
    }];


}

- (void)rightMenuClick
{
    self.leftMenu.hidden = YES;
    self.rightMenuVc.view.hidden = NO;
    
    [UIView animateWithDuration:HMNavShowAnimDuration animations:^{
        // 取出正在显示的导航控制器的view
        UIView *showingView = self.showingController.view;
        
        // 缩放比例
        CGFloat navH = [UIScreen mainScreen].bounds.size.height - 2 * 60;
        CGFloat scale = navH / [UIScreen mainScreen].bounds.size.height;
        
        // 菜单左边的间距
        CGFloat leftMenuMargin = [UIScreen mainScreen].bounds.size.width * (1 - scale) * 0.5;
        CGFloat translateX = leftMenuMargin - self.rightMenuVc.view.width;
        
        CGFloat topMargin = [UIScreen mainScreen].bounds.size.height * (1 - scale) * 0.5;
        CGFloat translateY = 60 - topMargin;
        
        // 缩放
        CGAffineTransform scaleForm = CGAffineTransformMakeScale(scale, scale);
        // 平移
        CGAffineTransform translateForm = CGAffineTransformTranslate(scaleForm, translateX / scale, translateY / scale);
        
        showingView.transform = translateForm;
        
        // 添加一个遮盖
        UIButton *cover = [[UIButton alloc] init];
        cover.tag = HMCoverTag;
        [cover addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchUpInside];
        cover.frame = showingView.bounds;
        [showingView addSubview:cover];
    } completion:^(BOOL finished) {
        [self.rightMenuVc didShow];
    }];
}


- (void)coverClick:(UIButton *)cover
{
    [UIView animateWithDuration:HMNavShowAnimDuration animations:^{
        self.showingController.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [cover removeFromSuperview];
    }];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/**
 *  初始化一个控制器
 *
 *  @param vc      需要初始化的控制器
 *  @param title   控制器的标题
 */
- (void)setupVc:(UIViewController *)vc
{
    // 如果两个控制器互为父子关系，那么它们的view也应该互为父子关系
    [self addChildViewController:vc];
}

#pragma mark - HMLeftMenuDelegate
- (void)leftMenu:(HMLeftMenu *)menu didSelectedButtonFromIndex:(int)fromIndex toIndex:(int)toIndex
{
    // 0.移除旧控制器的view
    UIViewController *oldVC = self.childViewControllers[fromIndex];
    [oldVC.view removeFromSuperview];
    
    // 1.显示新控制器的view
    UIViewController *newVC = self.childViewControllers[toIndex];
    [self.view addSubview:newVC.view];
    
    // 设置新控制的transform跟旧控制器一样
    newVC.view.transform = oldVC.view.transform;
    
    // 设置阴影
    newVC.view.layer.shadowColor = [UIColor blackColor].CGColor;
    newVC.view.layer.shadowOffset = CGSizeMake(-6, 0);
    newVC.view.layer.shadowOpacity = 0.2;
    
    // 2.设置当前正在显示的控制器
    self.showingController = newVC;
    
    // 3.点击遮盖
    [self coverClick:[newVC.view viewWithTag:HMCoverTag]];
}


@end

//
//  YWTabBarController.m
//  通信录
//
//  Created by yellow on 16/6/29.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWTabBarController.h"
#import "MeViewController.h"
#import "VedioViewController.h"
#import "StarViewController.h"
#import "HomeViewController.h"
#import "MyTabBar.h"
#import "MyTabBarButton.h"
#import "LoginViewController.h"
#import "YWNavigationController.h"
@interface YWTabBarController ()<MyTabBarDelegate>

//首页
@property (nonatomic, strong) HomeViewController *homeVC;

//视频
@property (nonatomic, strong) VedioViewController *vedioVC;

//明星
@property (nonatomic, strong) StarViewController *starVC;

//我的
@property (nonatomic, strong) MeViewController *meVC;

@end

@implementation YWTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化自定义的tabBar
    [self setupTabBar];
    
    
    //初始化所有子控制器
    [self setupAllChildViewControllers];
    
    
}

- (void)tabBar:(MyTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to{
    
    if (to == 3) {
        //从本地查看是否登录
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL isLogin = [defaults boolForKey:loginID];
        if (isLogin) {//已经登录
            self.selectedIndex = to;
        
            
        }else{//未登录
            YWNavigationController *nav = [[YWNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil]];
            [self presentViewController:nav animated:YES completion:^{
                
            }];
        }
        return;
    }
    

    
    
    self.selectedIndex = to;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
    //去掉系统自己创建的barItem
    for (UIView *child in self.tabBar.subviews) {
        
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

- (void)setupTabBar{
    MyTabBar *myTabBar = [[MyTabBar alloc] init];
    myTabBar.frame = self.tabBar.bounds;
    [self.tabBar addSubview:myTabBar];
    myTabBar.delegate = self;
    self.myTabBar = myTabBar;
    myTabBar.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    myTabBar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

-(void)setupAllChildViewControllers{
    
    //因为这是用storyboard，所以不能再创建控制器，只能从sotryboard根据标示拿出控制器
    //从sotryboard根据标示拿出控制器
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    HomeViewController *home = [storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
    [self setupChildViewController:home title:@"首页" imageName:@"main_info_blur" selectedImageName:@"main_info_focus"];
    self.homeVC = home;
    
    VedioViewController *vedio = [storyboard instantiateViewControllerWithIdentifier:@"vedioVC"];
    [self setupChildViewController:vedio title:@"视频" imageName:@"main_vedio_blur" selectedImageName:@"main_vedio_focus"];
    self.vedioVC = vedio;
    
    StarViewController *star = [storyboard instantiateViewControllerWithIdentifier:@"starVC"];
    [self setupChildViewController:star title:@"明星" imageName:@"main_star_blur" selectedImageName:@"main_star_focus"];
    self.starVC = star;
    
    MeViewController *me = [storyboard instantiateViewControllerWithIdentifier:@"meVC"];
    [self setupChildViewController:me title:@"我的" imageName:@"main_my_blur" selectedImageName:@"main_my_focus"];
    self.meVC = me;

    
}


-(void)setupChildViewController:(UIViewController*)childVc title:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName{
    
    //因为这是用storyboard，所以不用写addChildViewController方法
    
    //1.设置tabBarItem的内容
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //2.tabBar的方法，在这方法里会添加按钮到tabBar
    [self.myTabBar addTabBarButtonWithItem:childVc.tabBarItem];
    
    
}




@end

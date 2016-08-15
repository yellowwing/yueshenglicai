//
//  MeViewController.m
//  YueSheng
//
//  Created by yellow on 16/7/15.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "MeViewController.h"
#import "MJSettingArrowItem.h"
#import "MJSettingSwitchItem.h"
#import "MJSettingGroup.h"
#import "MJSettingItem.h"
#import "MeHeaderView.h"
#import "MyTabBar.h"
#import "MyTabBarButton.h"
#import "YWTabBarController.h"
#import "ChangePasswordController.h"
#import "IconStatus.h"
#import "IconParam.h"
#import "IconTool.h"
#import "UserParam.h"
#import "YWUploadParam.h"
@interface MeViewController ()<UIActionSheetDelegate,MeHeaderViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImageView *_bgView;
}
@property(nonatomic,weak)MeHeaderView *headerView;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //左边返回按钮不显示文字
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = barButtonItem;
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    self.tableView.tableFooterView = [UIView new];
    
    // 1.添加背景图片
    _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headimg"]];
    CGFloat bgW = self.view.frame.size.width;
    _bgView.bounds = CGRectMake(0, 0, bgW, 200 + bgW/2);
    _bgView.layer.position = CGPointMake(bgW * 0.5, - bgW / 4);
    _bgView.layer.anchorPoint = CGPointMake(0.5, 0);
    _bgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.tableView addSubview:_bgView];
    [self.tableView insertSubview:_bgView atIndex:0];
    
    MeHeaderView *header = [MeHeaderView headerView];
    self.headerView = header;
    header.delegate = self;
    self.tableView.tableHeaderView = header;
    
    [self setupGroup0];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *account = [defaults objectForKey:accountID];
    header.account = account;
    
    NSString *icon = [defaults objectForKey:iconUrl];
    header.iconString = icon;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAccount:) name:@"ChangeAccountNotification" object:nil];
}

-(void)changeAccount:(NSNotification *)notification{

    
    NSString *account = notification.userInfo[@"context"];
    
    self.headerView.account = account;
    
    NSString *icon = notification.userInfo[@"icon"];
    
    self.headerView.iconString = icon;

}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


-(void)setupGroup0{
    
    MJSettingItem *modification = [MJSettingArrowItem itemWithIcon:@"left01" title:@"修改登录密码" destVcClass:[ChangePasswordController class]];
    
    MJSettingItem *setting = [MJSettingArrowItem  itemWithIcon:@"left04" title:@"设置"];
    
    MJSettingItem *about = [MJSettingArrowItem itemWithIcon:@"left07" title:@"关于"];
    
    MJSettingItem *logout = [MJSettingArrowItem itemWithIcon:@"left06" title:@"注销登录"];
    logout.option = ^{
        
        [self setupActionSheet];
        
    };
    
    MJSettingGroup *group = [[MJSettingGroup alloc] init];
    group.items = @[modification,setting,about,logout];
    [self.data addObject:group];
    
}

-(void)setupActionSheet{
    
    //2.1.创建列表对象
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"是否要退出登录？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认退出" otherButtonTitles: nil];
    as.tag = 1;
    
    //2.1.1.可以设置列表样式
    as.actionSheetStyle = UIActionSheetStyleDefault;
    //如果是在toolbar里面show，试试其他样式
    
    
    //2.2.指定在某个视图之中显示列表
    [as showInView:self.view];
    
    
}

-(void)quit{
    
    //保存账号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:NO forKey:loginID];
    
    [defaults setObject:nil forKey:uidID];
    
    [defaults setObject:nil forKey:accountID];
    
    [defaults setObject:nil forKey:iconUrl];
    
    [defaults synchronize];
    
    //跳到首页
    MyTabBar *tabBar = ((YWTabBarController*)(self.tabBarController)).myTabBar;
    MyTabBarButton *button = tabBar.barItemArr[0];
    [tabBar buttonClick:button];
}

//点击列表按钮后执行的代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            [self quit];
        }
    }
    else
    {
        if (buttonIndex == 0) {
         //从相册获取
            [self openPhotoLibrary];
            
        }else if(buttonIndex == 1){
         //从相机获取
            [self openCamera];
        
        }
    }
    
}
/**
 *  打开相机
 */
- (void)openCamera
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
}

/**
 *  打开相册
 */
- (void)openPhotoLibrary
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - 图片选择控制器的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 1.销毁picker控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 2.图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.headerView.iconImage = image;
    
    //3.调用接口
    
    [IconTool composeWithImage:image success:^(NSString *imgUrl) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:imgUrl forKey:iconUrl];
        
        [defaults synchronize];
        

          [MBProgressHUD showSuccess:@"上传头像成功"];
        
    } failure:^(NSError *error) {
        
        
        [MBProgressHUD showError:@"上传头像失败"];
    }];
    

}

#pragma mark - 取消选择图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) return;
    
    // 1.向上的阻力系数（值越大，阻力越大，向上的力越大）
    CGFloat upFactor = 0.5;
    
    // 2.到什么位置开始放大
    CGFloat upMin = - (_bgView.frame.size.height / 6) / (1 - upFactor);
    
    // 3.还没到特定位置，就网上挪动
    if (offsetY >= upMin) {
        _bgView.transform = CGAffineTransformMakeTranslation(0, offsetY * upFactor);
    } else {
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, offsetY - upMin * (1 - upFactor));
        CGFloat s = 1 + (upMin - offsetY) * 0.005;
        _bgView.transform = CGAffineTransformScale(transform, s, s);
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)meHeaderViewDidChangeIcon:(MeHeaderView *)headerView{

    //2.1.创建列表对象
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"获取新头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册获取",@"从相机获取" ,nil];
    
    as.tag = 2;
    
    //2.1.1.可以设置列表样式
    as.actionSheetStyle = UIActionSheetStyleDefault;
    //如果是在toolbar里面show，试试其他样式
    
    
    //2.2.指定在某个视图之中显示列表
    [as showInView:self.view];
}

@end

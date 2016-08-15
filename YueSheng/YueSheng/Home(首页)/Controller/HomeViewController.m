//
//  HomeViewController.m
//  YueSheng
//
//  Created by yellow on 16/7/15.
//  Copyright © 2016年 yellow. All rights reserved.
// 首页要和栏目条配合使用

#import "HomeViewController.h"
#import "MainPageView.h"
#import "ColumnView.h"
#import "YWColumnTool.h"
#import "YWColumnStatus.h"

#import "YWHomeTool.h"
#import "YWHomeStatus.h"
#import "YWHomeParam.h"
#import "YWHomeResult.h"
#import "YWPagePictureStatus.h"
#import "YWPageStatus.h"
#import "CustomColumnView.h"
#import "InfomationController.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface HomeViewController ()<MainPageViewDelegate,CustomColumnViewDelegate>


@property(nonatomic,weak)MainPageView *mainPageView;

@property(nonatomic,strong)NSMutableArray *pageStatusArray;

@property(nonatomic,weak)CustomColumnView *customColumnView;

@end

@implementation HomeViewController

-(NSMutableArray*)pageStatusArray{

    if (_pageStatusArray == nil) {
        _pageStatusArray = [NSMutableArray array];
    }
    return _pageStatusArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
#warning - 做栏目定制
#warning - 看svn或者git视频并自己搭建
#warning - 要加载栏目条数据成功才添加下拉刷新控件，假如不成功要添加点击按钮提醒加载失败点击重新加载，不然会崩的
    
    //创建视图
    [self setupMainPageView];
    
    //调用栏目接口 为collectionView赋予数据
    [self loadColumnData];
    
    //添加遮盖
//    [GiFHUD setGifWithImageName:@"pika.gif"];
    
    //创建栏目定制
    [self setupCustomView];
  
    
    //监听跳转通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeToInfomation:) name:@"HomeToInfomation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeToPicture:) name:@"HomeToPicture" object:nil];
    
}

-(void)setupMainPageView{
    WS(weakSelf);
    
    MainPageView *mainPageView = [MainPageView  mainPageView];
    self.mainPageView = mainPageView;
    mainPageView.delegate = self;
    [self.view addSubview:mainPageView];
    [mainPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
        
    }];


}

-(void)setupCustomView{
    
    WS(weakSelf);
    //创建栏目定制
    CustomColumnView *customColumnView = [CustomColumnView customColumnView];
    CGFloat edgeH = [UIScreen mainScreen].bounds.size.height - 64;
    self.customColumnView = customColumnView;
    [self.view addSubview:customColumnView];
    customColumnView.delegate = self;
    
    [customColumnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(64, 0, edgeH, 0));
        
        /* 等价于
         make.top.equalTo(sv).with.offset(10);
         make.left.equalTo(sv).with.offset(10);
         make.bottom.equalTo(sv).with.offset(-10);
         make.right.equalTo(sv).with.offset(-10);
         */
        
        /* 也等价于
         make.top.left.bottom.and.right.equalTo(sv).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
         */
    }];
    self.customColumnView.hidden = YES;

}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)homeToPicture:(NSNotification *)notification{

    YWPagePictureStatus *status = notification.userInfo[@"context"];
    
    [self performSegueWithIdentifier:@"HomeToInfomation" sender:@{@"status":status,@"isPicture":@(YES)}];

}

-(void)homeToInfomation:(NSNotification *)notification{

    YWHomeStatus *status = notification.userInfo[@"context"];
    
    [self performSegueWithIdentifier:@"HomeToInfomation" sender:@{@"status":status,@"isPicture":@(NO)}];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
#warning - 到时还是分开两个控制器比较好
    UIViewController *controller = segue.destinationViewController;
    if (![controller isKindOfClass:[InfomationController class]]) return;
    
    BOOL isPicture = ((NSNumber*)sender[@"isPicture"]).boolValue;
    
    if (isPicture) {
        YWPagePictureStatus *status = sender[@"status"];
 
            InfomationController *infoVC = (InfomationController*)controller;
            
            infoVC.isLoadPagePicture = YES;
            
            infoVC.pictureStatus = status;
        }

    else{
        YWHomeStatus *status = sender[@"status"];
        
        UIViewController *controller = segue.destinationViewController;
        
            InfomationController *infoVC = (InfomationController*)controller;
            
            infoVC.isLoadPagePicture = NO;
            
            infoVC.status = status;
    }
}



-(void)loadFirstPageData:(NSString *)sstid{
    
    //加载第一页不需要传值
    YWHomeParam *param = [[YWHomeParam alloc] init];
    
    [YWHomeTool homeStatusesWithParameters:param success:^(YWHomeResult *result) {
    
    [MBProgressHUD hideHUDForView:self.view];
//    [GiFHUD dismiss];
        
    YWPageStatus *pageStatus = self.pageStatusArray[0];
    pageStatus.isLoad = YES;
    pageStatus.statuses = result.NewsInfo;
    pageStatus.pictureStatuses = result.PagePicture;
    
    //这些参数要留下保存
    param.sstid = sstid;
    param.pageindex = @"1";
    param.pagesize = @"15";
    pageStatus.param = param;
    
    self.mainPageView.pageStatusArray = self.pageStatusArray;
    
    
} failure:^(NSError *error) {
    [MBProgressHUD hideHUDForView:self.view];
//      [GiFHUD dismiss];
      [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
}];
    
}

-(void)loadColumnData{
    
    [MBProgressHUD showMessage:nil toView:self.view];
//    [GiFHUD show];
    
    [YWColumnTool columnStatusesWithBtid:@"C879A54D-7605-4619-A0F8-3F2516D87C05" success:^(NSArray *statuses) {
        
        if (statuses.count == 0) return ;
        
        YWColumnStatus *columnStatus = statuses[0];
        
        self.mainPageView.columnArray = statuses;//把模型数组交给mainPageView的里面来刷新
        
        //加载完columnStatus后，columnArray的个数就会确定，这时要创建columnArray个数一样多的YWPageStatus模型,并加到self.pageStatusArray里
        for (NSInteger i = 0; i < statuses.count; i++) {
            YWPageStatus *pageStatus = [[YWPageStatus alloc] init];
            pageStatus.isLoad = NO;
            pageStatus.statuses = [NSArray array];
            pageStatus.pictureStatuses = [NSArray array];
            [self.pageStatusArray addObject:pageStatus];
        }
        
        //第一次进来要先加载pageView的第一个数据
        [self loadFirstPageData:columnStatus.StID];
        
        //赋予自制栏目数据
        self.customColumnView.columnStatusArray = (NSMutableArray*)statuses;
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
//        [GiFHUD dismiss];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];

}


-(void)mainPageView:(MainPageView *)mainPageView didChooseIndex:(NSInteger)index columnStatus:(YWColumnStatus *)columnStatus pageStatus:(YWPageStatus *)pageStatus{
    
    [MBProgressHUD showMessage:nil toView:self.view];
//    [GiFHUD show];
    YWHomeParam *param = [[YWHomeParam alloc] init];
    param.sstid = columnStatus.StID;
    
    param.pageindex = @"1";
    param.pagesize = @"15";
    
    [YWHomeTool homeStatusesWithParameters:param success:^(YWHomeResult *result) {
        
        [MBProgressHUD hideHUDForView:self.view];
//        [GiFHUD dismiss];
        
        YWPageStatus *pageStatus = self.pageStatusArray[index];
        pageStatus.isLoad = YES;
        pageStatus.statuses = result.NewsInfo;
        pageStatus.pictureStatuses = result.PagePicture;
        pageStatus.param = param;
        
        self.mainPageView.pageStatusArray = self.pageStatusArray;
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
//        [GiFHUD dismiss];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];


}

#pragma mark - 自制栏目展开
-(void)mainPageViewDidClickCustomBtn:(MainPageView *)mainPageView{
    
    self.customColumnView.hidden = NO;
    
 WS(weakSelf);
    [self.customColumnView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).with.offset(0);
        
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view layoutIfNeeded];
        [self.customColumnView layoutIfNeeded];
    }];
    
}

#pragma mark - 自制栏目收起
-(void)customColumnViewDidClickCustomBtn:(CustomColumnView *)customColumnView{

    CGFloat edgeH = [UIScreen mainScreen].bounds.size.height - 64;
    WS(weakSelf);
    [self.customColumnView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).with.offset(-edgeH);
        
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        [self.customColumnView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        self.customColumnView.hidden = YES;
    }];

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self customColumnViewDidClickCustomBtn:nil];

}

@end

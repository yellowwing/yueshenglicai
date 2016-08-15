//
//  StarViewController.m
//  YueSheng
//
//  Created by yellow on 16/7/15.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "StarViewController.h"
#import "CustomColumnView.h"
#import "StarMainPageView.h"

#import "YWStarColumnTool.h"
#import "YWStarColumnStatus.h"
#import "YWStarColumnResult.h"

#import "YWStarPageStatus.h"
#import "YWStarParam.h"
#import "YWStarResult.h"
#import "YWStarStatus.h"
#import "YWStarTool.h"
#import "ArticleListController.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
@interface StarViewController ()<StarMainPageViewDelegate,CustomColumnViewDelegate>

@property(nonatomic,weak)StarMainPageView *mainPageView;

@property(nonatomic,strong)NSMutableArray *pageStatusArray;

@property(nonatomic,weak)CustomColumnView *customColumnView;

@end

@implementation StarViewController

-(NSMutableArray*)pageStatusArray{
    
    if (_pageStatusArray == nil) {
        _pageStatusArray = [NSMutableArray array];
    }
    return _pageStatusArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //要加多这一句才走cellForItem方法
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //添加遮盖
//    [GiFHUD setGifWithImageName:@"pika.gif"];
    
    //建立视图
    [self setupMainPageView];
    
    //调用栏目接口 为collectionView赋予数据
    [self loadColumnData];
    
    //监听跳转通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(starToDetal:) name:@"StarToDetal" object:nil];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)starToDetal:(NSNotification *)notification{
    
    YWStarStatus *status = notification.userInfo[@"context"];
    
    [self performSegueWithIdentifier:@"StarToDetal" sender:@{@"status":status}];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    UIViewController *controller = segue.destinationViewController;
           YWStarStatus *status = sender[@"status"];
        
        ArticleListController *vc = (ArticleListController*)controller;
        
        vc.starStatus = status;

}



-(void)setupMainPageView{
    WS(weakSelf);
    
    StarMainPageView *mainPageView = [StarMainPageView  mainPageView];
    self.mainPageView = mainPageView;
    mainPageView.delegate = self;
    [self.view addSubview:mainPageView];
    [mainPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
        
    }];
    
}

-(void)loadFirstPageData:(NSString *)sstid{
    //加载第一页也要传值，且要传足三个参数
    YWStarParam *param = [[YWStarParam alloc] init];
    param.St_Id = sstid;
    param.pageIndex = @"1";
    param.pageSize = @"15";
    
    [YWStarTool starStatusesWithParameters:param success:^(YWStarResult *result) {
        [MBProgressHUD hideHUDForView:self.view];
//        [GiFHUD dismiss];
        
        //取出第一组模型交给mainPageView刷新
        YWStarPageStatus *pageStatus = self.pageStatusArray[0];
        pageStatus.isLoad = YES;
        pageStatus.statuses = result.StarList;
        //这些参数要留下保存
        pageStatus.param = param;
        
        self.mainPageView.pageStatusArray = self.pageStatusArray;
        
        
    } failure:^(NSError *error) {
//        [GiFHUD dismiss];
        [MBProgressHUD hideHUDForView:self.view];
//        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
    
}

-(void)loadColumnData{
    
//    [GiFHUD show];
    [MBProgressHUD showMessage:nil toView:self.view];
    
    [YWStarColumnTool columnStatusesWithsuccess:^(NSArray *statuses) {
        if (statuses.count == 0) return ;
        
        YWStarColumnStatus *columnStatus = statuses[0];
        self.mainPageView.columnArray = statuses;//把模型数组交给mainPageView的里面来刷新
        //加载完columnStatus后，columnArray的个数就会确定，这时要创建columnArray个数一样多的YWPageStatus模型,并加到self.pageStatusArray里
        for (NSInteger i = 0; i < statuses.count; i++) {
            YWStarPageStatus *pageStatus = [[YWStarPageStatus alloc] init];
            pageStatus.isLoad = NO;
            pageStatus.statuses = [NSArray array];
            [self.pageStatusArray addObject:pageStatus];
        }
        
        //第一次进来要先加载pageView的第一个数据
        [self loadFirstPageData:columnStatus.St_Id];
        
        //赋予自制栏目数据
        self.customColumnView.columnStatusArray = statuses;
        
        
    } failure:^(NSError *error) {
        
        
    }];

}

-(void)mainPageView:(StarMainPageView *)mainPageView didChooseIndex:(NSInteger)index columnStatus:(YWStarColumnStatus *)columnStatus pageStatus:(YWStarPageStatus *)pageStatus{
    
        [MBProgressHUD showMessage:nil toView:self.view];
//    [GiFHUD show];
    YWStarParam *param = [[YWStarParam alloc] init];
    param.St_Id = columnStatus.St_Id;
    
    param.pageIndex = @"1";
    param.pageSize = @"15";
    
    [YWStarTool starStatusesWithParameters:param success:^(YWStarResult *result) {
        
                [MBProgressHUD hideHUDForView:self.view];
//        [GiFHUD dismiss];
        
        YWStarPageStatus *pageStatus = self.pageStatusArray[index];
        pageStatus.isLoad = YES;
        pageStatus.statuses = result.StarList;
        pageStatus.param = param;
        
        self.mainPageView.pageStatusArray = self.pageStatusArray;
        
    } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view];
//        [GiFHUD dismiss];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
    
    
}


@end

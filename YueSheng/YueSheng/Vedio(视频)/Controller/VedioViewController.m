//
//  VedioViewController.m
//  YueSheng
//
//  Created by yellow on 16/7/15.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "VedioViewController.h"
#import "VedioMainPageView.h"
#import "YWColumnTool.h"
#import "YWColumnStatus.h"
#import "YWVedioResult.h"
#import "YWVedioParam.h"
#import "YWVedioStatus.h"
#import "YWVedioPageStatus.h"
#import "YWVedioTool.h"
#import "CustomColumnView.h"
#import "InfomationController.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface VedioViewController ()<VedioMainPageViewDelegate,CustomColumnViewDelegate>

@property(nonatomic,weak)VedioMainPageView *mainPageView;

@property(nonatomic,strong)NSMutableArray *pageStatusArray;

@property(nonatomic,weak)CustomColumnView *customColumnView;

@end

@implementation VedioViewController

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
    
    //建立视图
    [self setupMainPageView];
    
    //调用栏目接口 为collectionView赋予数据
    [self loadColumnData];

    //添加遮盖
//    [GiFHUD setGifWithImageName:@"pika.gif"];
    
    //创建栏目定制
    [self setupCustomView];
    
    //监听跳转通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vedioToInfomation:) name:@"VedioToInfomation" object:nil];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)vedioToInfomation:(NSNotification *)notification{
    
    YWVedioStatus *status = notification.userInfo[@"context"];
    
    [self performSegueWithIdentifier:@"VedioToInfomation" sender:@{@"status":status,@"isPicture":@(NO)}];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
#warning - 到时还是分开两个控制器比较好,这里方便测试把vedio和home暂时公用
    UIViewController *controller = segue.destinationViewController;
    if (![controller isKindOfClass:[InfomationController class]]) return;
    

    YWVedioStatus *status = sender[@"status"];
    
    YWHomeStatus *homeStatus = [[YWHomeStatus alloc] init];
    
    homeStatus.NiId = status.NiId;
    homeStatus.NiTitle = status.NiTitle;
    homeStatus.NiImg = status.NiImg;
    homeStatus.NiContent = status.NiContent;
    homeStatus.NiSource = status.NiSource;
    homeStatus.NiAuthor = status.NiAuthor;
    homeStatus.NiTime = status.NiTime;
    homeStatus.NiNumber = status.NiNumber;
        
        InfomationController *infoVC = (InfomationController*)controller;
        
        infoVC.isLoadPagePicture = NO;
        
        infoVC.status = homeStatus;
   
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
        
         }];
    self.customColumnView.hidden = YES;
    
}

-(void)loadFirstPageData:(NSString *)sstid{
    //加载第一页不需要传值
    YWVedioParam *param = [[YWVedioParam alloc] init];
    
    [YWVedioTool vedioStatusesWithParameters:param success:^(YWVedioResult *result) {
        
//        [GiFHUD dismiss];
        [MBProgressHUD hideHUDForView:self.view];
        YWVedioPageStatus *pageStatus = self.pageStatusArray[0];
        pageStatus.isLoad = YES;
        pageStatus.statuses = result.NewsInfo;
        
        //这些参数要留下保存
        param.sstid = sstid;
        param.pageindex = @"1";
        param.pagesize = @"15";
        pageStatus.param = param;
        
        self.mainPageView.pageStatusArray = self.pageStatusArray;
        
        
    } failure:^(NSError *error) {
//        [GiFHUD dismiss];
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];

}

-(void)loadColumnData{
    
//    [GiFHUD show];
    [MBProgressHUD showMessage:nil toView:self.view];
    [YWColumnTool columnStatusesWithBtid:@"2C430AF1-FD0E-433D-B40D-F51BDB99FEC0" success:^(NSArray *statuses) {
        
        if (statuses.count == 0) return ;
        
        YWColumnStatus *columnStatus = statuses[0];
        self.mainPageView.columnArray = statuses;//把模型数组交给mainPageView的里面来刷新
        //加载完columnStatus后，columnArray的个数就会确定，这时要创建columnArray个数一样多的YWPageStatus模型,并加到self.pageStatusArray里
        for (NSInteger i = 0; i < statuses.count; i++) {
            YWVedioPageStatus *pageStatus = [[YWVedioPageStatus alloc] init];
            pageStatus.isLoad = NO;
            pageStatus.statuses = [NSArray array];
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


-(void)setupMainPageView{
    WS(weakSelf);
    
    VedioMainPageView *mainPageView = [VedioMainPageView  mainPageView];
    self.mainPageView = mainPageView;
    mainPageView.delegate = self;
    [self.view addSubview:mainPageView];
    [mainPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
        
    }];

}

-(void)mainPageView:(VedioMainPageView *)mainPageView didChooseIndex:(NSInteger)index columnStatus:(YWColumnStatus *)columnStatus pageStatus:(YWVedioPageStatus *)pageStatus{
    
        [MBProgressHUD showMessage:nil toView:self.view];
//    [GiFHUD show];
    YWVedioParam *param = [[YWVedioParam alloc] init];
    param.sstid = columnStatus.StID;
    
    param.pageindex = @"1";
    param.pagesize = @"15";
    
    [YWVedioTool vedioStatusesWithParameters:param success:^(YWVedioResult *result) {
        
                [MBProgressHUD hideHUDForView:self.view];
//        [GiFHUD dismiss];
        
        YWVedioPageStatus *pageStatus = self.pageStatusArray[index];
        pageStatus.isLoad = YES;
        pageStatus.statuses = result.NewsInfo;
        pageStatus.param = param;
        
        self.mainPageView.pageStatusArray = self.pageStatusArray;
        
    } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view];
//        [GiFHUD dismiss];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
    
    
}

#pragma mark - 自制栏目展开
-(void)mainPageViewDidClickCustomBtn:(VedioMainPageView *)mainPageView{
    
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

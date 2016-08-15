//
//  MarketController.m
//  YueSheng
//
//  Created by yellow on 16/8/3.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "MarketController.h"
#import "MarketTool.h"
#import "MarketResult.h"
#import "MarketParam.h"
#import "MarketStatus.h"
#import "MarketCell.h"
#import "MarketDetailController.h"
@interface MarketController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *statusArray;
@property(nonatomic,copy)NSString *pageIndex;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MarketController

#warning - 要先判断有没有登录，没有登录的先去登录
#warning - 若已经登录了就判断有没有支付的权限（微信支付），若已经支付了就加载闪电行情接口
#warning - 跳去登录还是是否隐藏支付界面还是是否隐藏tableView

-(NSMutableArray*)statusArray{
    if (_statusArray == nil) {
        _statusArray = [NSMutableArray array];
    }
    return _statusArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 135;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.tableFooterView = [UIView new];
    
    
    // 添加下拉刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(loadData)];
    
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    [self.tableView headerBeginRefreshing];
}

-(void)loadMoreData{

    MarketParam *param = [[MarketParam alloc] init];
    NSInteger pageindex = self.pageIndex.integerValue;
    pageindex++;
    param.pageIndex = [NSString stringWithFormat:@"%ld",pageindex];
    
    [MarketTool marketStatusesWithParameters:param success:^(MarketResult *result) {
        
        [self.tableView footerEndRefreshing];
         self.pageIndex = [NSString stringWithFormat:@"%ld",pageindex];
        
        [self.statusArray addObjectsFromArray:result.news];

        if (result.news.count == 0) {
            [MBProgressHUD showMessage:@"已经没有更多数据了" toView:self.view];
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self.tableView footerEndRefreshing];
        
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
        
    }];

}

-(void)loadData{
    MarketParam *param = [[MarketParam alloc] init];
    param.pageIndex = @"1";
    
    self.pageIndex = @"1";
    
    [MarketTool marketStatusesWithParameters:param success:^(MarketResult *result) {
        
        [self.tableView headerEndRefreshing];
        
        self.statusArray = (NSMutableArray*)result.news;
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self.tableView headerEndRefreshing];
        
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
        
    }];

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.statusArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1.创建cell
    MarketCell *cell = [MarketCell cellWithTableView:tableView];
    
    // 2.给cell传递模型数据
    cell.status = self.statusArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    MarketStatus *status = self.statusArray[indexPath.row];
    
 [self performSegueWithIdentifier:@"MarketToDetail" sender:@{@"status":status}];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    MarketDetailController *controller = segue.destinationViewController;
    
    MarketStatus *status = sender[@"status"];
    
    controller.status = status;
    
}



@end

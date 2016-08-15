//
//  YWStockViewController.m
//  通信录
//
//  Created by yellow on 16/7/12.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWStockViewController.h"
#import "YWStockCell.h"
#import "YWStockStatus.h"
#import "MJRefresh.h"
#import "YWStockTool.h"
#import "MBProgressHUD+MJ.h"

@interface YWStockViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *stockArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic,assign)BOOL finishLoading;
@end

@implementation YWStockViewController

-(NSMutableArray*)stockArray{
    if (_stockArray == nil) {
            _stockArray = [NSMutableArray array];
        }
    return _stockArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.finishLoading = YES;
    
    self.tableView.tableFooterView = [UIView new];
    
    // 添加下拉刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewStatus)];
    
#warning - 写入数据库因为数据太多用很长时间，用多线程又会崩溃，所以只能叫后台做分页功能要么不写入数据库
    [self.tableView headerBeginRefreshing];
//    [self loadFirstData];
   
}


-(void)loadFirstData{
    
    [MBProgressHUD showMessage:nil toView:self.view];

    [YWStockTool stockStatusesFirstWithSuccess:^(NSArray *statuses) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        self.stockArray = (NSMutableArray*)statuses;
        
        // 刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];

}


-(void)loadNewStatus{
    
//    if (self.finishLoading == NO) {
//        return;
//    }
//    
//    self.finishLoading = NO;
    
    [YWStockTool stockStatusesWithSuccess:^(NSArray *statuses) {
        
        [self.tableView headerEndRefreshing];
        
        self.stockArray = (NSMutableArray*)statuses;
        
        // 刷新表格
        [self.tableView reloadData];
        
//        self.finishLoading = YES;

    } failure:^(NSError *error) {
        
//        self.finishLoading = YES;
        
        [self.tableView headerEndRefreshing];
        
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stockArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    YWStockCell *cell = [YWStockCell cellWithTableView:tableView];
    
    cell.status = self.stockArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

 [self performSegueWithIdentifier:@"StockToKLine" sender:nil];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    UIViewController *vc = segue.destinationViewController;
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    YWStockStatus *status = self.stockArray[indexPath.row];
    vc.title = status.Stock_Name;
    
}

@end

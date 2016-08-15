//
//  MainPageViewCell.m
//  YueSheng
//
//  Created by yellow on 16/7/15.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "MainPageViewCell.h"
#import "YWHomeStatus.h"
#import "YWHomeCell.h"
#import "YWPageStatus.h"
#import "YWHomeTool.h"
#import "YWHomeResult.h"
#import "HomeHeaderView.h"
@interface MainPageViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation MainPageViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置每一行cell的高度
    self.tableView.rowHeight = 90;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    // 添加下拉刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(loadHomeData)];
    // 添加上拉加载更多控件
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}

#pragma mark - 加载数据
-(void)loadHomeData{
    
    self.status.param.pageindex = @"1";
    
    [YWHomeTool homeStatusesWithParameters:self.status.param success:^(YWHomeResult *result) {
        
        [self.tableView headerEndRefreshing];
      
        self.status.statuses = result.NewsInfo;
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
         [self.tableView headerEndRefreshing];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];

}

-(void)loadMoreData{
    
    NSInteger pageindex = self.status.param.pageindex.integerValue;
    
    pageindex++;
    
    self.status.param.pageindex = [NSString stringWithFormat:@"%ld",(long)pageindex];
    
    [YWHomeTool homeStatusesWithParameters:self.status.param success:^(YWHomeResult *result) {
        
        [self.tableView footerEndRefreshing];
        
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self.status.statuses];
        
        [mutableArray addObjectsFromArray:result.NewsInfo];
        
        self.status.statuses = mutableArray;
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
         [self.tableView footerEndRefreshing];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];


}

#pragma mark - 数据源方法
/**
 *  一共有多少行数据
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.status.statuses.count;
}

/**
 *  每一行显示怎样的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    YWHomeCell *cell = [YWHomeCell cellWithTableView:tableView];
    
    // 2.给cell传递模型数据
    cell.status = self.status.statuses[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    YWHomeStatus *status = self.status.statuses[indexPath.row];
    
//    在这里发送通知，通知控制器跳到下一个页面，并传模型
    NSNotification *notification=[NSNotification notificationWithName:@"HomeToInfomation" object:self userInfo:@{@"context":status}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}


-(void)setStatus:(YWPageStatus *)status{

    _status = status;
    
    if (status.pictureStatuses.count) {
//增加头部
        HomeHeaderView *header = [HomeHeaderView headerView];
        header.newses = status.pictureStatuses;
        self.tableView.tableHeaderView = header;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
        [self.tableView reloadData];
}



@end

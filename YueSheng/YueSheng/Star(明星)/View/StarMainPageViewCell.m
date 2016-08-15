//
//  StarMainPageViewCell.m
//  YueSheng
//
//  Created by yellow on 16/7/26.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "StarMainPageViewCell.h"
#import "YWStarStatus.h"
#import "YWStarCell.h"
#import "YWStarPageStatus.h"
#import "YWStarTool.h"
#import "YWStarResult.h"


@interface StarMainPageViewCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation StarMainPageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //xib还要加多这句，estimatedRowHeight和xib的cell高度是一样的
    self.tableView.estimatedRowHeight = 258;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    // 添加下拉刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    // 添加上拉加载更多控件
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}

#pragma mark - 加载数据
-(void)loadNewData{
    
    self.status.param.pageIndex = @"1";
    
    [YWStarTool starStatusesWithParameters:self.status.param success:^(YWStarResult *result) {
        
        [self.tableView headerEndRefreshing];
        
        self.status.statuses = result.StarList;
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self.tableView headerEndRefreshing];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
    
}

-(void)loadMoreData{
    
    NSInteger pageindex = self.status.param.pageIndex.integerValue;
    
    pageindex++;
    
    self.status.param.pageIndex = [NSString stringWithFormat:@"%ld",(long)pageindex];
    
    [YWStarTool starStatusesWithParameters:self.status.param success:^(YWStarResult *result) {
        
        [self.tableView footerEndRefreshing];
        
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self.status.statuses];
        
        [mutableArray addObjectsFromArray:result.StarList];
        
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
     YWStarCell *cell = [YWStarCell cellWithTableView:tableView];
    
    // 2.给cell传递模型数据
    cell.status = self.status.statuses[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YWStarStatus *status = self.status.statuses[indexPath.row];
    
    //    在这里发送通知，通知控制器跳到下一个页面，并传模型
    NSNotification *notification=[NSNotification notificationWithName:@"StarToDetal" object:self userInfo:@{@"context":status}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

-(void)setStatus:(YWStarPageStatus *)status{
    
    _status = status;
    
    [self.tableView reloadData];
    
}


@end

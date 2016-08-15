//
//  ReviewDetailController.m
//  YueSheng
//
//  Created by yellow on 16/8/4.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ReviewDetailController.h"
#import "ReviewListStatus.h"
#import "ReviewListResult.h"
#import "ReviewListCell.h"
#import "ReviewListTool.h"
#import "ReviewListParam.h"
#import "ReviewDetailStatus.h"
#import "ReviewDetailHeaderView.h"
#import "ReviewDetailTool.h"
#import "ReviewDetailParam.h"
#import "ReviewListHeader.h"
#import "MusicController.h"

#define NAVBAR_CHANGE_POINT 50

@interface ReviewDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSArray *reviewListArray;

@property(nonatomic,copy)NSString *pageIndex;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property(nonatomic,weak)ReviewDetailHeaderView *headerView;

@property(nonatomic,strong)NSMutableArray *musicListArray;

@end

@implementation ReviewDetailController


-(NSMutableArray *)musicListArray{
    if (_musicListArray == nil) {
        _musicListArray = [NSMutableArray array];
    }
    return _musicListArray;
}


-(NSArray*)reviewListArray{
    
    if (_reviewListArray == nil) {
        _reviewListArray = [NSArray array];
    }
    return _reviewListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.clipsToBounds = YES;
    
    //一开始清空navigationBar背景色
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    ReviewDetailHeaderView *header = [ReviewDetailHeaderView headerView];
    self.headerView = header;
    self.tableView.tableHeaderView = header;
    
    [self loadListData];
    
    // 添加上拉加载更多控件
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}

-(void)loadMoreData{
    
    NSInteger pageindex = self.pageIndex.integerValue;
    
    pageindex++;
    
    ReviewListParam *param = [[ReviewListParam alloc] init];
    param.dbname = self.status.RadP_Name;
    param.pagesize = @"10";
    param.pageindex = [NSString stringWithFormat:@"%ld",pageindex];
    
    [ReviewListTool reviewListWithParameters:param success:^(ReviewListResult *result) {
        
        [self.tableView footerEndRefreshing];
        self.pageIndex = [NSString stringWithFormat:@"%ld",pageindex];
        
        NSMutableArray *sectionArray2 = self.reviewListArray[1];
        [sectionArray2 addObjectsFromArray:result.list];
        [self.tableView reloadData];
        
        [self.musicListArray addObjectsFromArray:result.list];
        
    } failure:^(NSError *error) {
        [self.tableView footerEndRefreshing];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
    
}


-(void)loadListData{
    
    [MBProgressHUD showMessage:nil toView:self.view];
    
    ReviewListParam *param = [[ReviewListParam alloc] init];
    param.dbname = self.status.RadP_Name;
    param.pagesize = @"15";
    param.pageindex = @"1";
    
    self.pageIndex = @"1";
    
    [ReviewListTool reviewListWithParameters:param success:^(ReviewListResult *result) {
        
        NSMutableArray *sectionArray1 = [NSMutableArray array];
        
        NSMutableArray *sectionArray2 = [NSMutableArray array];
        
        self.musicListArray = (NSMutableArray*)(result.list);
        
        if (result.list.count == 0) {//一个数据都没有
            return ;
        }
       else if (result.list.count == 1) {//只有一个数据
           [sectionArray1 addObject:result.list[0]];
        }
       else{//有2个数据以上
           [sectionArray1 addObject:result.list[0]];
           sectionArray2 = [NSMutableArray arrayWithArray:result.list];
           [sectionArray2 removeObjectAtIndex:0];
       }
        
        self.reviewListArray = @[sectionArray1,sectionArray2];
        [self.tableView reloadData];
        
        [self loadHeadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];

}


-(void)loadHeadData{
    
    ReviewDetailParam *param = [[ReviewDetailParam alloc] init];
    param.RadP_Id = self.status.RadP_Id;
    
    [ReviewDetailTool reviewDetailStatusesWithParameters:param success:^(ReviewDetailStatus *status) {
        [MBProgressHUD hideHUDForView:self.view];
        self.headerView.status = status;
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.reviewListArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *array = self.reviewListArray[section];
    
    return array.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *array = self.reviewListArray[indexPath.section];
    
    // 1.创建cell
    ReviewListCell *cell = [ReviewListCell cellWithTableView:tableView];
    
    // 2.给cell传递模型数据
    cell.status = array[indexPath.row];
    
    return cell;
    

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    [self scrollViewDidScroll:self.tableView];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 0){
        
        //3.滚动tableView时，改变navigationBar的颜色渐变
        UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > NAVBAR_CHANGE_POINT) {
            CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        } else {
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        }
        
    }else{
        // 1.向上的阻力系数（值越大，阻力越大，向上的力越大）
        CGFloat upFactor = 0.5;
        
        // 2.到什么位置开始放大
        CGFloat upMin = - (self.bgView.frame.size.height / 20) / (1 - upFactor);
        
        // 3.还没到特定位置，就网上挪动
        if (offsetY >= upMin) {
        } else {
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 0);
            CGFloat s = 1 + (upMin - offsetY) * 0.005;
            self.bgView.transform = CGAffineTransformScale(transform, s, s);
        }
    }
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ReviewListHeader *header = [ReviewListHeader sectionHeader];
    
    if (section == 0) {
        header.title = @"最近一期";
    }
    else{
    header.title = @"往期回顾";
    }
    
    return header;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *sectionArray = self.reviewListArray[indexPath.section];
    
    ReviewListStatus *status = sectionArray[indexPath.row];
    
    [self performSegueWithIdentifier:@"ListToMusic" sender:@{@"status":status}];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    MusicController *controller = segue.destinationViewController;
    
    ReviewListStatus *status = sender[@"status"];
    
    controller.status = status;
    
    controller.statusArray = self.musicListArray;
    
    controller.detailStatus = self.headerView.status;
}



@end

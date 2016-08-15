//
//  ArticleController.m
//  YueSheng
//
//  Created by yellow on 16/7/27.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ArticleListController.h"
#import "ArticleListStatus.h"
#import "ArticleListParam.h"
#import "ArticleListResult.h"
#import "ArticleListTool.h"
#import "StarInfoStatus.h"
#import "ArticleListCell.h"
#import "ArticleListHeaderView.h"
#import "ArticleDetailController.h"
#import "UINavigationBar+Awesome.h"
#import "ArticlePraiseStatus.h"
#import "ArticlePraiseParam.h"

#define NAVBAR_CHANGE_POINT 50

@interface ArticleListController ()<UITableViewDelegate,UITableViewDataSource,ArticleListCellDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSArray *articleListArray;

@property(nonatomic,copy)NSString *pageIndex;


@end

@implementation ArticleListController

-(NSArray*)articleListArray{

    if (_articleListArray == nil) {
        _articleListArray = [NSArray array];
    }
    return _articleListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgView.clipsToBounds = YES;
    
    //1.一开始清空navigationBar背景色
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    //xib还要加多这句，estimatedRowHeight和xib的cell高度是一样的
    self.tableView.estimatedRowHeight = 204;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 添加上拉加载更多控件
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    [self loadArticleData];
  
}

-(void)loadMoreData{
    
    NSInteger pageindex = self.pageIndex.integerValue;
    
    pageindex++;
    
    ArticleListParam *param = [[ArticleListParam alloc] init];
    param.Sif_Id = self.starStatus.Sif_Id;
    param.pageSize = @"15";
    param.pageIndex = [NSString stringWithFormat:@"%ld",pageindex];
    
    [ArticleListTool articleStatusesWithParameters:param success:^(ArticleListResult *result) {
         [self.tableView footerEndRefreshing];
        
        if (result.Status.integerValue == -1 || result.StarNewsList.count == 0) {
            [MBProgressHUD showError:@"已无更多"];
            return ;
        }
        else{

         self.pageIndex = [NSString stringWithFormat:@"%ld",pageindex];
        
        }
        
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self.articleListArray];
        [mutableArray addObjectsFromArray:result.StarNewsList];
        
        self.articleListArray = mutableArray;
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
         [self.tableView footerEndRefreshing];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
    
}


-(void)loadArticleData{

    [MBProgressHUD showMessage:@"加载中" toView:self.view];

    ArticleListParam *param = [[ArticleListParam alloc] init];
    param.Sif_Id = self.starStatus.Sif_Id;
    param.pageSize = @"15";
    param.pageIndex = @"1";
    
    self.pageIndex = @"1";
    
[ArticleListTool articleStatusesWithParameters:param success:^(ArticleListResult *result) {
    
    [MBProgressHUD hideHUDForView:self.view];
    
    //创建头部
    ArticleListHeaderView *header = [ArticleListHeaderView headerView];
    
    self.tableView.tableHeaderView = header;
    
    header.status = result.StarInfo;
    
    self.articleListArray = result.StarNewsList;
    
    [self.tableView reloadData];
    
} failure:^(NSError *error) {
    
    [MBProgressHUD hideHUDForView:self.view];
    [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
}];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articleListArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1.创建cell
    ArticleListCell *cell = [ArticleListCell cellWithTableView:tableView];
    
    // 2.给cell传递模型数据
    cell.status = self.articleListArray[indexPath.row];
    
    cell.delegate = self;
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ArticleListStatus *status = self.articleListArray[indexPath.row];
    
       [self performSegueWithIdentifier:@"ArticleListToDetail" sender:@{@"status":status,@"comment":@(NO)}];
    

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    UIViewController *controller = segue.destinationViewController;
    
    ArticleListStatus *status = sender[@"status"];
    
    BOOL isComment = ((NSNumber*)sender[@"comment"]).integerValue;

    ArticleDetailController *vc = (ArticleDetailController*)controller;
    
    vc.isComment = isComment;
    
    vc.status = status;
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
        //设置Cell的动画效果为3D效果
        //设置x和y的初始值为0.1；
        cell.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1);
        //x和y的最终值为1
        [UIView animateWithDuration:0.5 animations:^{
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
        }];
    
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

-(void)articleListCellDidClickPraiseBtn:(ArticleListCell *)articleListCell articleListStatus:(ArticleListStatus *)status{

    ArticlePraiseParam *param = [[ArticlePraiseParam alloc] init];
    param.Sn_Id = status.Sn_Id;
    
    [ArticleListTool praiseArticleStatusesWithParameters:param success:^(ArticlePraiseStatus *status) {
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];

}

-(void)articleListCellDidClickCommentBtn:(ArticleListCell *)articleListCell articleListStatus:(ArticleListStatus *)status{

    
    [self performSegueWithIdentifier:@"ArticleListToDetail" sender:@{@"status":status,@"comment":@(YES)}];


}


//2.下面两个是当当前view消失和出现时就改变navigationBar颜色
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.bgView.hidden = YES;
    
    [self.navigationController.navigationBar lt_reset];
    
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.bgView.hidden = NO;
    
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

@end

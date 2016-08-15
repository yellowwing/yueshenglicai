//
//  ReviewController.m
//  YueSheng
//
//  Created by yellow on 16/8/3.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ReviewController.h"
#import "YWSegementControl.h"
#import "ReviewStatus.h"
#import "ReviewParam.h"
#import "ReviewCell.h"
#import "ReviewTool.h"
#import "ReviewDetailController.h"

#define w self.view.frame.size.width
#define h self.view.frame.size.height
@interface ReviewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,YWSegementControlDelegate>

@property (weak, nonatomic) IBOutlet YWSegementControl *segmentControl;

@property(nonatomic,weak)UIScrollView *scrollView;

@property(nonatomic,strong)NSArray *workdayArray;

@property(nonatomic,strong)NSArray *satArray;

@property(nonatomic,strong)NSArray *sunArray;

@property(nonatomic,strong)NSMutableArray *tableViewArray;

@property(nonatomic,assign)BOOL isLoadSaturday;

@property(nonatomic,assign)BOOL isLoadSunday;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@end

@implementation ReviewController

-(NSMutableArray *)tableViewArray{

    if (_tableViewArray == nil) {
        _tableViewArray = [NSMutableArray array];
    }
    return _tableViewArray;
}

-(NSArray*)workdayArray{
    if (_workdayArray == nil) {
        _workdayArray = [NSArray array];
    }
    return _workdayArray;
}

-(NSArray*)satArray{
    if (_satArray == nil) {
        _satArray = [NSArray array];
    }
    return _satArray;
}
-(NSArray*)sunArray{
    if (_sunArray == nil) {
        _sunArray = [NSArray array];
    }
    return _sunArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //一开始清空navigationBar背景色
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.bgView.clipsToBounds = YES;
    self.segmentControl.layer.cornerRadius = 8;
    self.segmentControl.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.segmentControl.layer.borderWidth = 1;
    self.segmentControl.clipsToBounds = YES;
    self.segmentControl.items = @[@"周一至周五",@"周六",@"周日"];
    self.segmentControl.selectedSegmentIndex = 0;
    self.segmentControl.delegate = self;
    
    [self setupScroViewWithButtonArray:self.segmentControl.items];

    [self setupTableViewWithButtonArray:self.segmentControl.items];
    
    
    UITableView *tableView = self.tableViewArray[0];
    [tableView headerBeginRefreshing];
    
}

-(void)segmentControl:(YWSegementControl *)segmentControl didClickedButtonIndex:(NSInteger)index{
    [self.scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * index, 0) animated:YES];
    
    if (self.isLoadSaturday == NO && index == 1) {
        
        UITableView *tableView = self.tableViewArray[1];
        [tableView headerBeginRefreshing];
        self.isLoadSaturday = YES;
    }
    
    if (self.isLoadSunday == NO && index == 2) {
        
        UITableView *tableView = self.tableViewArray[2];
        [tableView headerBeginRefreshing];
        self.isLoadSunday = YES;
    }

}

-(void)loadWorkDayData{
    
    
    UITableView *tableView = self.tableViewArray[0];
    
    ReviewParam *param = [[ReviewParam alloc] init];
    param.WeekDate = @"1-5";
    
    [ReviewTool reviewStatusesWithParameters:param success:^(NSArray *statusArray) {
        
        self.workdayArray = statusArray;
        
        [tableView headerEndRefreshing];
        [tableView reloadData];
        
        
    } failure:^(NSError *error) {
        
        [tableView headerEndRefreshing];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];

}

-(void)loadSaturDayData{
    
    UITableView *tableView = self.tableViewArray[1];
    
    ReviewParam *param = [[ReviewParam alloc] init];
    param.WeekDate = @"6";
    
    [ReviewTool reviewStatusesWithParameters:param success:^(NSArray *statusArray) {
        
        self.satArray = statusArray;
        
        [tableView headerEndRefreshing];
        [tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [tableView headerEndRefreshing];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
    
}

-(void)loadSunDayData{
    
    UITableView *tableView = self.tableViewArray[2];
    
    ReviewParam *param = [[ReviewParam alloc] init];
    param.WeekDate = @"7";
    
    [ReviewTool reviewStatusesWithParameters:param success:^(NSArray *statusArray) {
        
        self.sunArray = statusArray;
        
        [tableView headerEndRefreshing];
        [tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [tableView headerEndRefreshing];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
    
}


-(void)setupTableViewWithButtonArray:(NSArray *)buttonArray{
    for (NSInteger i = 0; i<buttonArray.count; i++) {
        //建立tableView
        CGFloat padding = 6;
        CGFloat tabX = i * w + padding;
        CGFloat tabY = 2*padding;
        CGFloat tabW = w - 2 * padding;
        CGFloat tabH = CGRectGetHeight(self.scrollView.frame) - 2*padding;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(tabX, tabY, tabW,tabH) style:UITableViewStylePlain];
        tableView.tag = i;
        [self.scrollView addSubview:tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.layer.cornerRadius = 1;
        tableView.rowHeight = 50;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableViewArray addObject:tableView];
        // 添加下拉刷新控件
        if (i == 0) {
            [tableView addHeaderWithTarget:self action:@selector(loadWorkDayData)];
        }
        else if (i == 1){
         [tableView addHeaderWithTarget:self action:@selector(loadSaturDayData)];
        }
        else if (i == 2){
          [tableView addHeaderWithTarget:self action:@selector(loadSunDayData)];
        }
    }
}


-(void)setupScroViewWithButtonArray:(NSArray *)buttonArray{
    //因为这里用scrollView,所以我不用autolayout了，直接frame
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    CGFloat scrollX = 0;
    CGFloat scrollY = CGRectGetMaxY(self.segmentControl.frame);
    CGFloat scrollW = w;
    CGFloat scrollH = h - CGRectGetMaxY(self.segmentControl.frame);
    scrollView.frame = CGRectMake(scrollX, scrollY, scrollW, scrollH);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(w*buttonArray.count, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.tag = 1000;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor clearColor];

}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 0:
        {
            return self.workdayArray.count;
        }
            break;
        case 1:
        {
           return self.satArray.count;
        }
            break;
        case 2:
        {
            return self.sunArray.count;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 0:
        {
            ReviewCell *cell = [ReviewCell cellWithTableView:tableView];
            cell.status = self.workdayArray[indexPath.row];
            return cell;
            
        }
            break;
        case 1:
        {
            ReviewCell *cell = [ReviewCell cellWithTableView:tableView];
            cell.status = self.satArray[indexPath.row];
            return cell;
        }
            break;
        case 2:
        {
            ReviewCell *cell = [ReviewCell cellWithTableView:tableView];
            cell.status = self.sunArray[indexPath.row];
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (scrollView.tag == 1000) {
        CGPoint scrollViewP = scrollView.contentOffset;
        
        NSInteger index = scrollViewP.x/w;
        
        self.segmentControl.selectedSegmentIndex = index;
        
        if (self.isLoadSaturday == NO && index == 1) {
            
            UITableView *tableView = self.tableViewArray[1];
            [tableView headerBeginRefreshing];
            self.isLoadSaturday = YES;
        }
        
        if (self.isLoadSunday == NO && index == 2) {
            
            UITableView *tableView = self.tableViewArray[2];
            [tableView headerBeginRefreshing];
            self.isLoadSunday = YES;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (tableView.tag) {
        case 0:
        {
            ReviewStatus *status = self.workdayArray[indexPath.row];
            
            [self performSegueWithIdentifier:@"ReviewToDetail" sender:@{@"status":status}];
        }
            break;
        case 1:
        {
            ReviewStatus *status = self.satArray[indexPath.row];
            
            [self performSegueWithIdentifier:@"ReviewToDetail" sender:@{@"status":status}];
        }
            break;
        case 2:
        {
            ReviewStatus *status = self.sunArray[indexPath.row];
            
            [self performSegueWithIdentifier:@"ReviewToDetail" sender:@{@"status":status}];
        }
            break;
            
        default:
            break;
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    ReviewDetailController *controller = segue.destinationViewController;
    
    ReviewStatus *status = sender[@"status"];
    
    controller.status = status;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    
}
@end

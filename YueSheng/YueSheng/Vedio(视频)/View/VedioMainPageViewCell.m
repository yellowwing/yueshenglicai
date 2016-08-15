//
//  VedioMainPageViewCell.m
//  YueSheng
//
//  Created by yellow on 16/7/25.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "VedioMainPageViewCell.h"
#import "YWVedioStatus.h"
#import "VedioCell.h"
#import "YWVedioPageStatus.h"
#import "YWVedioTool.h"
#import "YWVedioResult.h"

#define vedioID @"vedio"

@interface VedioMainPageViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation VedioMainPageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"VedioCell" bundle:nil] forCellWithReuseIdentifier:vedioID];
    
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreData)];
}

-(void)loadNewData{
    
self.status.param.pageindex = @"1";
    
[YWVedioTool vedioStatusesWithParameters:self.status.param success:^(YWVedioResult *result) {
    [self.collectionView headerEndRefreshing];
    
    self.status.statuses = result.NewsInfo;
    
    [self.collectionView reloadData];
    
    } failure:^(NSError *error) {
        
        [self.collectionView headerEndRefreshing];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
        
    }];

}

-(void)loadMoreData{

    NSInteger pageindex = self.status.param.pageindex.integerValue;
    
    pageindex++;
    
    self.status.param.pageindex = [NSString stringWithFormat:@"%ld",(long)pageindex];
    
    [YWVedioTool vedioStatusesWithParameters:self.status.param success:^(YWVedioResult *result) {
        
        [self.collectionView footerEndRefreshing];
        
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self.status.statuses];
        
        [mutableArray addObjectsFromArray:result.NewsInfo];
        
        self.status.statuses = mutableArray;
        
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        [self.collectionView footerEndRefreshing];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];

}

//定义每个UICollectionViewCell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = ([UIScreen mainScreen].bounds.size.width - 34)/2;
        return CGSizeMake(cellWidth, 130);

}

//定义每个UICollectionView的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(12, 12, 12, 12);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.status.statuses.count;

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    VedioCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:vedioID forIndexPath:indexPath];
    
    cell.status = self.status.statuses[indexPath.item];
    
    return cell;

}

-(void)setStatus:(YWVedioPageStatus *)status{

    _status = status;
    
    [self.collectionView reloadData];

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YWVedioStatus *status = self.status.statuses[indexPath.item];
    
    //    在这里发送通知，通知控制器跳到下一个页面，并传模型
    NSNotification *notification=[NSNotification notificationWithName:@"VedioToInfomation" object:self userInfo:@{@"context":status}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

@end

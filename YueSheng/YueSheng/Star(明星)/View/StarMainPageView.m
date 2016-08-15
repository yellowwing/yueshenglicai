//
//  StarMainPageView.m
//  YueSheng
//
//  Created by yellow on 16/7/26.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "StarMainPageView.h"
#import "StarColumnCell.h"
#import "YWStarPageStatus.h"
#import "YWStarTool.h"
#import "YWStarResult.h"
#import "StarMainPageViewCell.h"


#define pageID @"starpage"

#define columnID @"starcolumn"
@interface StarMainPageView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *columnView;
@property (weak, nonatomic) IBOutlet UICollectionView *pageView;

- (IBAction)customBtnClick;
@property(nonatomic,strong)NSIndexPath *selectedIndexPath;
@end

@implementation StarMainPageView

-(void)setColumnArray:(NSArray *)columnArray{
    
    _columnArray = columnArray;
    
    [self.columnView reloadData];
    [self.pageView reloadData];
    
}


-(void)setPageStatusArray:(NSArray *)pageStatusArray{
    
    _pageStatusArray = pageStatusArray;
    
    [self.columnView reloadData];
    [self.pageView reloadData];
    
}

+(instancetype)mainPageView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"StarMainPageView" owner:nil options:nil].lastObject;
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.columnArray = [NSArray array];
        
        self.pageStatusArray = [NSArray array];
        
        self.selectedIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.columnView registerNib:[UINib nibWithNibName:@"StarColumnCell" bundle:nil] forCellWithReuseIdentifier:columnID];
    self.columnView.tag = 1;
    self.columnView.backgroundColor = YWColorRGBA(0, 0, 0, 0.05);
    
    
    [self.pageView registerNib:[UINib nibWithNibName:@"StarMainPageViewCell" bundle:nil] forCellWithReuseIdentifier:pageID];
    self.pageView.tag = 2;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.columnArray.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag == 1) {
        
        StarColumnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:columnID forIndexPath:indexPath];
        
        cell.status = self.columnArray[indexPath.item];
        
        return cell;
    }
    else{
        
        StarMainPageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:pageID forIndexPath:indexPath];
        
        if (self.pageStatusArray.count) {
            YWStarPageStatus *pageStatus = self.pageStatusArray[indexPath.item];
            cell.status = pageStatus;
        }
        
        
        return cell;
    }
    
}
//定义每个UICollectionViewCell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView.tag == 1) {
        return CGSizeMake(80, self.columnView.bounds.size.height);
        
    }
    else{
        
        return CGSizeMake(self.bounds.size.width, self.bounds.size.height - self.columnView.bounds.size.height);
    }
    
}

//定义每个UICollectionView的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    if (collectionView.tag == 2) {
        
        return UIEdgeInsetsMake(0, 0, 15, 0);
    }else{
        
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

#pragma mark - 上面collectionView控制下面的
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 1) {
        
        [self.pageView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        
        YWStarColumnStatus* selectedStatus = self.columnArray[self.selectedIndexPath.item];
        selectedStatus.selected = NO;
        
        YWStarColumnStatus* status = self.columnArray[indexPath.item];
        status.selected = YES;
        
        self.selectedIndexPath = indexPath;
        
        [self.columnView reloadData];
        
        YWStarPageStatus *pageStatus = self.pageStatusArray[indexPath.item];
        if (pageStatus.isLoad == NO) {
            if ([self.delegate respondsToSelector:@selector(mainPageView:didChooseIndex:columnStatus:pageStatus:)]) {
                [self.delegate mainPageView:self didChooseIndex:indexPath.item columnStatus:status pageStatus:pageStatus];
            }
        }
        
        
    }
    
}

#pragma mark - 下面collectionView控制上面的
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 2) {
        
        NSInteger index  = scrollView.contentOffset.x / self.bounds.size.width;
        
        NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
        
        [self.columnView scrollToItemAtIndexPath:currentIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        
        YWStarColumnStatus* selectedStatus = self.columnArray[self.selectedIndexPath.item];
        selectedStatus.selected = NO;
        
        YWStarColumnStatus* status = self.columnArray[currentIndexPath.item];
        status.selected = YES;
        
        self.selectedIndexPath = currentIndexPath;
        
        [self.columnView reloadData];
        
        
        YWStarPageStatus *pageStatus = self.pageStatusArray[index];
        if (pageStatus.isLoad == NO) {
            if ([self.delegate respondsToSelector:@selector(mainPageView:didChooseIndex:columnStatus:pageStatus:)]) {
                [self.delegate mainPageView:self didChooseIndex:index columnStatus:status pageStatus:pageStatus];
            }
        }
        
    }
    
}


- (IBAction)customBtnClick {
    if ([self.delegate respondsToSelector:@selector(mainPageViewDidClickCustomBtn:)]) {
        [self.delegate mainPageViewDidClickCustomBtn:self];
    }

}
@end

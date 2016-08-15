//
//  CustomColumnView.m
//  YueSheng
//
//  Created by yellow on 16/7/20.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "CustomColumnView.h"
#import "YWColumnStatus.h"
#import "CustomColumnViewCell.h"
#import "CustomHeaderView.h"
//#import "XWDragCellCollectionView.h"

#define customID @"custom"
#define headerID @"customHeader"

@interface CustomColumnView ()<UICollectionViewDelegate,UICollectionViewDataSource>
- (IBAction)finishClick;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic,strong)NSMutableArray *moreColumnArray;

@property(nonatomic,strong)NSArray *sectionArray;

@end

@implementation CustomColumnView


#warning - 代理改变控制器栏目

#warning - 看git 做git 做微信支付


-(NSArray*)sectionArray{
    if (_sectionArray == nil) {
        _sectionArray = [NSArray array];
    }

    return _sectionArray;
}

+(instancetype)customColumnView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"CustomColumnView" owner:nil options:nil].lastObject;
    
}

-(void)setColumnStatusArray:(NSMutableArray *)columnStatusArray{

    _columnStatusArray = columnStatusArray;
    
    YWColumnStatus *tempStatus = [[YWColumnStatus alloc] init];
    tempStatus.StName = @"测试" ;
    [self.moreColumnArray addObject:tempStatus];
    YWColumnStatus *tempStatus2 = [[YWColumnStatus alloc] init];
    tempStatus2.StName = @"测试2" ;
    [self.moreColumnArray addObject:tempStatus2];
    YWColumnStatus *tempStatus3 = [[YWColumnStatus alloc] init];
    tempStatus3.StName = @"测试3" ;
    [self.moreColumnArray addObject:tempStatus3];
    
    self.sectionArray = @[self.columnStatusArray,self.moreColumnArray];
    
    [self.collectionView reloadData];

}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        _columnStatusArray = [NSMutableArray array];
        
        self.moreColumnArray = [NSMutableArray array];
        
        self.sectionArray = [NSArray array];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
  [self.collectionView registerNib:[UINib nibWithNibName:@"CustomColumnViewCell" bundle:nil] forCellWithReuseIdentifier:customID];
    
    //注册创建header
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    
    
    //此处给其增加拖拽手势，用此手势触发cell移动效果
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlepanGesture:)];
    [_collectionView addGestureRecognizer:panGesture];
}

//从缓存池拿出footer或者header
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *resuableview = nil;
    
        if (kind == UICollectionElementKindSectionFooter) {
            
            return nil;
            
        }
        else if (kind == UICollectionElementKindSectionHeader){
            
            CustomHeaderView *headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
            
            resuableview = headerview;
            
        }
        
        return resuableview;

}

//header 大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    if (section == 1) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 40);
    }
    else{
        return CGSizeMake(0, 0);
    }
}



- (IBAction)finishClick {
    
    if ([self.delegate respondsToSelector:@selector(customColumnViewDidClickCustomBtn:)]) {
        [self.delegate customColumnViewDidClickCustomBtn:self];
    }
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sectionArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSArray *sec = self.sectionArray[section];
    return sec.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        
    CustomColumnViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:customID forIndexPath:indexPath];
    
    NSArray *sec = self.sectionArray[indexPath.section];
    
    cell.status = sec[indexPath.item];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YWColumnStatus *status = self.sectionArray[indexPath.section][indexPath.item];
    YWLog(@"点击了%@",status.StName);
    
    if (indexPath.section == 0) {//第0组的要移到第1组后
        NSMutableArray *sorceArray = self.sectionArray[indexPath.section];
        NSMutableArray *destinationArray = self.sectionArray[1];
        id objc = [sorceArray objectAtIndex:indexPath.item];
        //从资源数组中移除该数据
        [sorceArray removeObject:objc];
        //将数据插入到资源数组中的目标位置上
        [destinationArray addObject:objc];
        
        [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:destinationArray.count-1 inSection:1]];
    }
    else{//第一组后要移到第0组后
    
        NSMutableArray *sorceArray = self.sectionArray[indexPath.section];
        NSMutableArray *destinationArray = self.sectionArray[0];
        id objc = [sorceArray objectAtIndex:indexPath.item];
        //从资源数组中移除该数据
        [sorceArray removeObject:objc];
        //将数据插入到资源数组中的目标位置上
        [destinationArray addObject:objc];
        
        
        [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:destinationArray.count-1 inSection:0]];
        
    }
}


- (void)handlepanGesture:(UIPanGestureRecognizer *)panGesture {
    //判断手势状态
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[panGesture locationInView:self.collectionView]];
            if (indexPath == nil) {
                break;
            }
            
            //在路径上则开始移动该路径上的cell
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            //移动过程当中随时更新cell位置
            [self.collectionView updateInteractiveMovementTargetPosition:[panGesture locationInView:self.collectionView]];
            
        }
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [self.collectionView endInteractiveMovement];
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}

//是否允许移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    
        //返回YES允许其item移动
        return YES;
}

// 用来改变模型
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    
        NSMutableArray *sorceArray = self.sectionArray[sourceIndexPath.section];
        NSMutableArray *destinationArray = self.sectionArray[destinationIndexPath.section];
        id objc = [sorceArray objectAtIndex:sourceIndexPath.item];
        //从资源数组中移除该数据
        [sorceArray removeObject:objc];
        //将数据插入到资源数组中的目标位置上
        [destinationArray insertObject:objc atIndex:destinationIndexPath.item];
    
}

@end

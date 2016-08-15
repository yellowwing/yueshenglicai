//
//  ArticleListCell.h
//  YueSheng
//
//  Created by yellow on 16/7/27.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleListStatus.h"

@class ArticleListCell;

@protocol ArticleListCellDelegate <NSObject>

@optional
-(void)articleListCellDidClickPraiseBtn:(ArticleListCell*)articleListCell articleListStatus:(ArticleListStatus *)status;

-(void)articleListCellDidClickCommentBtn:(ArticleListCell*)articleListCell articleListStatus:(ArticleListStatus *)status;

@end

@interface ArticleListCell : UITableViewCell

@property(nonatomic,strong)ArticleListStatus *status;


/**
 *  通过一个tableView来创建一个cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;



@property(nonatomic,weak)id<ArticleListCellDelegate> delegate;

@end

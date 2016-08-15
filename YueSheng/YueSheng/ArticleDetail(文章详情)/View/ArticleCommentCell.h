//
//  ArticleCommentCell.h
//  YueSheng
//
//  Created by yellow on 16/7/28.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleCommentStatus.h"
@interface ArticleCommentCell : UITableViewCell

@property(nonatomic,strong)ArticleCommentStatus *status;

/**
 *  通过一个tableView来创建一个cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

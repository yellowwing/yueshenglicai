//
//  ArticleDetailCell.h
//  YueSheng
//
//  Created by yellow on 16/7/28.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleDetailStatus.h"
@interface ArticleDetailCell : UITableViewCell

@property(nonatomic,strong)ArticleDetailStatus *status;

/**
 *  通过一个tableView来创建一个cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

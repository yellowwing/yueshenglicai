//
//  YWHomeCell.h
//  YueSheng
//
//  Created by yellow on 16/7/18.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWHomeStatus;

@interface YWHomeCell : UITableViewCell

/**
 *  通过一个tableView来创建一个cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *  首页模型
 */
@property (nonatomic, strong) YWHomeStatus *status;

@end

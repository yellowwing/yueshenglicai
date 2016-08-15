//
//  YWStarCell.h
//  YueSheng
//
//  Created by yellow on 16/7/26.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWStarStatus;
@interface YWStarCell : UITableViewCell


/**
 *  通过一个tableView来创建一个cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *  模型
 */
@property (nonatomic, strong) YWStarStatus *status;

@end

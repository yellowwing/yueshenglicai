//
//  MarketCell.h
//  YueSheng
//
//  Created by yellow on 16/8/9.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketStatus.h"
@interface MarketCell : UITableViewCell

@property(nonatomic,strong)MarketStatus *status;

/**
 *  通过一个tableView来创建一个cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

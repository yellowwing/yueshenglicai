//
//  YWStockCell.h
//  通信录
//
//  Created by yellow on 16/7/12.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YWStockStatus;
@interface YWStockCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YWStockStatus *status;


@end

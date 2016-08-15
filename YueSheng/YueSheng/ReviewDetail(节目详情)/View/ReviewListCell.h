//
//  ReviewListCell.h
//  YueSheng
//
//  Created by yellow on 16/8/5.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewListStatus.h"

@interface ReviewListCell : UITableViewCell

@property(nonatomic,strong)ReviewListStatus *status;

/**
 *  通过一个tableView来创建一个cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end

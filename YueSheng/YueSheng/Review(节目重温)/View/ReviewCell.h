//
//  ReviewCell.h
//  YueSheng
//
//  Created by yellow on 16/8/4.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewStatus.h"
@interface ReviewCell : UITableViewCell
@property(nonatomic,strong)ReviewStatus *status;


/**
 *  通过一个tableView来创建一个cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

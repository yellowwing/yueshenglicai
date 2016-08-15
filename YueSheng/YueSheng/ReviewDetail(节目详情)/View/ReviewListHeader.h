//
//  ReviewListHeader.h
//  YueSheng
//
//  Created by yellow on 16/8/5.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewListHeader : UITableViewHeaderFooterView

@property(nonatomic,copy)NSString *title;

+(instancetype)sectionHeader;

@end

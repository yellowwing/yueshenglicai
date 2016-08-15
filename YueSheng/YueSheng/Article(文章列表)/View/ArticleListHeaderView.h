//
//  ArticleListHeaderView.h
//  YueSheng
//
//  Created by yellow on 16/7/28.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarInfoStatus.h"
@interface ArticleListHeaderView : UIView

+(instancetype)headerView;

@property(nonatomic,strong)StarInfoStatus *status;

@end

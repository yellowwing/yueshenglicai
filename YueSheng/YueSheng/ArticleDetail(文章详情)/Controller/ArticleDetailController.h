//
//  ArticleDetailController.h
//  YueSheng
//
//  Created by yellow on 16/7/28.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleListStatus.h"
@interface ArticleDetailController : UIViewController

@property(nonatomic,assign)BOOL isComment;

@property(nonatomic,strong)ArticleListStatus *status;

@end

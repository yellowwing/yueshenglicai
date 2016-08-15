//
//  ArticleDetailResult.h
//  YueSheng
//
//  Created by yellow on 16/7/28.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleDetailStatus.h"
#import "ArticleCommentStatus.h"
@interface ArticleDetailResult : NSObject

@property(nonatomic,strong)ArticleDetailStatus *StarNews;

@property(nonatomic,strong)NSArray *CommentList;

@end

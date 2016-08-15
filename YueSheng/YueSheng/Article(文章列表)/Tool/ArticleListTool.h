//
//  ArticleListTool.h
//  YueSheng
//
//  Created by yellow on 16/7/27.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleListParam.h"
#import "ArticleListResult.h"
#import "ArticleListStatus.h"

#import "ArticlePraiseParam.h"
#import "ArticlePraiseStatus.h"

@interface ArticleListTool : NSObject

/**
 *  @param param   请求参数,请求参数应该由外面决定
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)articleStatusesWithParameters:(ArticleListParam *)param success:(void(^)(ArticleListResult *result))success failure:(void(^)(NSError *error))failure;
/**
 *  点赞
 *  @param param   请求参数,请求参数应该由外面决定
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)praiseArticleStatusesWithParameters:(ArticlePraiseParam *)param success:(void(^)(ArticlePraiseStatus *status))success failure:(void(^)(NSError *error))failure;
@end

//
//  ArticleListTool.m
//  YueSheng
//
//  Created by yellow on 16/7/27.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ArticleListTool.h"

@implementation ArticleListTool
+(void)articleStatusesWithParameters:(ArticleListParam *)param success:(void (^)(ArticleListResult *))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@AppJson/Star/Get_Star_News_List.ashx",domainURL];
    
    [YWHttpTool GET:url parameters:param.keyValues success:^(id responseObject) {
        
        //转大模型
        ArticleListResult *result = [ArticleListResult objectWithKeyValues:responseObject];
        
        if (result.Status.integerValue != -1) {
            //转小模型
            result.StarNewsList = [ArticleListStatus objectArrayWithKeyValuesArray:result.StarNewsList] ;
        }
        
        // 传递了block
        if (success) {
            success(result);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

+ (void)praiseArticleStatusesWithParameters:(ArticlePraiseParam *)param success:(void(^)(ArticlePraiseStatus *status))success failure:(void(^)(NSError *error))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@AppJson/Star/AddSn_Praise.ashx",domainURL];
    
    [YWHttpTool GET:url parameters:param.keyValues success:^(id responseObject) {
        
        //转大模型
        ArticlePraiseStatus *status = [ArticlePraiseStatus objectWithKeyValues:responseObject];
        
        // 传递了block
        if (success) {
            success(status);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
    
}

@end

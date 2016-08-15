//
//  ArticleDetailTool.m
//  YueSheng
//
//  Created by yellow on 16/7/28.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ArticleDetailTool.h"

@implementation ArticleDetailTool
+(void)detailArticleStatusesWithParameters:(ArticleDetailParam *)param success:(void (^)(ArticleDetailResult *))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@AppJson/Star/GetStar_News_Comment_List.ashx",domainURL];
    
    [YWHttpTool GET:url parameters:param.keyValues success:^(id responseObject) {
        
        //转大模型
        ArticleDetailResult *result = [ArticleDetailResult objectWithKeyValues:responseObject];
        
        //转小模型
        result.CommentList = [ArticleCommentStatus objectArrayWithKeyValuesArray:result.CommentList] ;
     
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


@end

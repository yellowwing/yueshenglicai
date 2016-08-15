//
//  YWVedioTool.m
//  YueSheng
//
//  Created by yellow on 16/7/25.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWVedioTool.h"
#import "YWVedioStatus.h"

@implementation YWVedioTool
+(void)vedioStatusesWithParameters:(YWVedioParam *)param success:(void (^)(YWVedioResult *))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@AppJson/index/getvideoindex.ashx",domainURL];
    
    [YWHttpTool GET:url parameters:param.keyValues success:^(id responseObject) {
        
        //转大模型
        YWVedioResult *result = [YWVedioResult objectWithKeyValues:responseObject];
        
        //转小模型
        result.NewsInfo = [YWVedioStatus objectArrayWithKeyValuesArray:result.NewsInfo] ;
        
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

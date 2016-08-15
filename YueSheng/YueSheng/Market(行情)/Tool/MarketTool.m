//
//  MarketTool.m
//  YueSheng
//
//  Created by yellow on 16/8/9.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "MarketTool.h"

@implementation MarketTool
+(void)marketStatusesWithParameters:(MarketParam *)param success:(void (^)(MarketResult *))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@AppJson/news/getsdqb.ashx",domainURL];
    
    [YWHttpTool GET:url parameters:param.keyValues success:^(id responseObject) {
        
        //转大模型
        MarketResult *result = [MarketResult objectWithKeyValues:responseObject];
        
        //转小模型
        result.news = [MarketStatus objectArrayWithKeyValuesArray:result.news] ;
        
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

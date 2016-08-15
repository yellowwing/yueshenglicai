//
//  ReviewListTool.m
//  YueSheng
//
//  Created by yellow on 16/8/5.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ReviewListTool.h"

@implementation ReviewListTool
+(void)reviewListWithParameters:(ReviewListParam *)param success:(void (^)(ReviewListResult *))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@AppJson/program/GetByDbName.ashx",domainURL];
    
    [YWHttpTool GET:url parameters:param.keyValues success:^(id responseObject) {
        
        //转大模型
        ReviewListResult *result = [ReviewListResult objectWithKeyValues:responseObject];
        
        //转小模型
        result.list = [ReviewListStatus objectArrayWithKeyValuesArray:result.list] ;
        
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

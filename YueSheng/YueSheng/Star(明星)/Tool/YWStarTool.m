//
//  YWStarTool.m
//  YueSheng
//
//  Created by yellow on 16/7/26.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWStarTool.h"
#import "YWStarStatus.h"

@implementation YWStarTool

+(void)starStatusesWithParameters:(YWStarParam *)param success:(void (^)(YWStarResult *))success failure:(void (^)(NSError *))failure{

    NSString *url = [NSString stringWithFormat:@"%@AppJson/Star/Get_Star.ashx",domainURL];
    
    [YWHttpTool GET:url parameters:param.keyValues success:^(id responseObject) {
        
        //转大模型
        YWStarResult *result = [YWStarResult objectWithKeyValues:responseObject];
        
        //转小模型
        result.StarList = [YWStarStatus objectArrayWithKeyValuesArray:result.StarList] ;
     
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

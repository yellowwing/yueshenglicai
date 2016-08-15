//
//  ReviewTool.m
//  YueSheng
//
//  Created by yellow on 16/8/4.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ReviewTool.h"

@implementation ReviewTool
+(void)reviewStatusesWithParameters:(ReviewParam *)param success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@AppJson/program/Get_ProgramList.ashx",domainURL];
    
    [YWHttpTool GET:url parameters:param.keyValues success:^(id responseObject) {
        
            NSArray *statusArray = [ReviewStatus objectArrayWithKeyValuesArray:responseObject] ;
   
        // 传递了block
        if (success) {
            success(statusArray);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}


@end

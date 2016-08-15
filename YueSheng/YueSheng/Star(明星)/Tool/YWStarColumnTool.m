//
//  YWStarColumnTool.m
//  YueSheng
//
//  Created by yellow on 16/7/26.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWStarColumnTool.h"

#import "YWStarColumnParam.h"
#import "YWStarColumnResult.h"
#import "YWStarColumnStatus.h"

@implementation YWStarColumnTool

+(void)columnStatusesWithsuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    
    YWStarColumnParam *param = [[YWStarColumnParam alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"%@AppJson/Star/Get_Star_Type.ashx",domainURL];
    
    [YWHttpTool GET:url parameters:param.keyValues success:^(id responseObject) {
        
        //转模型
        NSArray *statusArray = [YWStarColumnStatus objectArrayWithKeyValuesArray:responseObject] ;
        
        //默认选中第一个
        if (statusArray.count) {
            YWStarColumnStatus *status = statusArray[0];
            status.selected = YES;
            
        }
        
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

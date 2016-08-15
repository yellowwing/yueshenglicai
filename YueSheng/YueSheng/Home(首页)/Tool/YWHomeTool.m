//
//  YWHomeTool.m
//  YueSheng
//
//  Created by yellow on 16/7/18.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWHomeTool.h"
#import "YWHomeStatus.h"
#import "YWPagePictureStatus.h"

@implementation YWHomeTool

+(void)homeStatusesWithParameters:(YWHomeParam *)param success:(void (^)(YWHomeResult *))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@AppJson/index/GetHomePage.ashx",domainURL];
    
    [YWHttpTool GET:url parameters:param.keyValues success:^(id responseObject) {
        
        //转大模型
        YWHomeResult *result = [YWHomeResult objectWithKeyValues:responseObject];
        
        //转小模型
        result.NewsInfo = [YWHomeStatus objectArrayWithKeyValuesArray:result.NewsInfo] ;
        
        result.PagePicture = [YWPagePictureStatus objectArrayWithKeyValuesArray:result.PagePicture];
        
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

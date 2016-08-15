//
//  PostCommentTool.m
//  YueSheng
//
//  Created by yellow on 16/8/3.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "PostCommentTool.h"

@implementation PostCommentTool
+ (void)postCommentStatusesWithParameters:(PostCommentParam *)param success:(void(^)(PostCommentStatus *status))success failure:(void(^)(NSError *error))failure{

    NSString *url = [NSString stringWithFormat:@"%@AppJson/Star/PostStar_News_Comment.ashx",domainURL];
    
    [YWHttpTool Post:url parameters:param.keyValues success:^(id responseObject) {
        
        //转大模型
        PostCommentStatus *status = [PostCommentStatus objectWithKeyValues:responseObject];
        
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

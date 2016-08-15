//
//  IconTool.h
//  YueSheng
//
//  Created by yellow on 16/8/2.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconTool : NSObject

/**
 *  上传头像
 *
 *  @param status   发送微博文字内容
 *  @param image    发送微博图片内容
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
+ (void)composeWithImage:(UIImage *)image success:(void(^)(NSString *imgUrl))success failure:(void(^)(NSError *error))failure;

@end

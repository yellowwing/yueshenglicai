//
//  IconTool.m
//  YueSheng
//
//  Created by yellow on 16/8/2.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "IconTool.h"
//#import "IconParam.h"
#import "IconStatus.h"
#import "UserParam.h"
#import "YWUploadParam.h"
@implementation IconTool

+(void)composeWithImage:(UIImage *)image success:(void (^)(NSString *imgUrl))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@AppJson/Users_AppJson/PostUsers_Info_Img.ashx",domainURL];

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:uidID];
    
    UserParam *userParam = [[UserParam alloc] init];
    userParam.Ui_Id = uid;
    
    // 创建上传的模型
    YWUploadParam *uploadP = [[YWUploadParam alloc] init];
    uploadP.data = UIImagePNGRepresentation(image);
    uploadP.name = @"Ui_Img";
    uploadP.fileName = @"image.png";
    uploadP.mimeType = @"image/png";
    
[YWHttpTool Upload:url parameters:userParam.keyValues uploadParam:uploadP success:^(id responseObject) {
    
    NSString *imgUrl = responseObject[@"imgUrl"];
    
    if (success) {
        success(imgUrl);
    }

    
} failure:^(NSError *error) {
    
    if (failure) {
        failure(error);
    }
}];
    
    

}

@end

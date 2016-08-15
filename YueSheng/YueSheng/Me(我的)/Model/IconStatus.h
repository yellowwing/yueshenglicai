//
//  IconStatus.h
//  YueSheng
//
//  Created by yellow on 16/8/2.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconStatus : NSObject

//上传成功
@property(nonatomic,copy)NSString *imgUrl;

//上传失败
@property(nonatomic,copy)NSString *Status;

@property(nonatomic,copy)NSString *msg;


@end

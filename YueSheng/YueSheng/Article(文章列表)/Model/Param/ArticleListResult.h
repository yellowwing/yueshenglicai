//
//  ArticleListResult.h
//  YueSheng
//
//  Created by yellow on 16/7/27.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StarInfoStatus.h"
@interface ArticleListResult : NSObject

@property(nonatomic,strong)StarInfoStatus *StarInfo;

@property(nonatomic,strong)NSArray *StarNewsList;


//因为后台返回成功与失败的格式不一样或者没有result字段让我判断是否成功，所以我要加多两个字段接收万一返回失败的情况
@property(nonatomic,copy)NSString *Status;

@property(nonatomic,copy)NSString *msg;


@end

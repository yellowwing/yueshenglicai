//
//  YWPageStatus.h
//  YueSheng
//
//  Created by yellow on 16/7/19.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWHomeParam.h"
@interface YWPageStatus : NSObject

@property(nonatomic,assign)BOOL isLoad;

@property(nonatomic,strong)YWHomeParam *param;

@property (nonatomic, strong) NSArray *statuses;

@property(nonatomic,strong)NSArray *pictureStatuses;

@end

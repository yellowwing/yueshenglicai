//
//  YWStarPageStatus.h
//  YueSheng
//
//  Created by yellow on 16/7/26.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWStarParam.h"
@interface YWStarPageStatus : NSObject

@property(nonatomic,assign)BOOL isLoad;

@property(nonatomic,strong)YWStarParam *param;

@property (nonatomic, strong) NSArray *statuses;
@end

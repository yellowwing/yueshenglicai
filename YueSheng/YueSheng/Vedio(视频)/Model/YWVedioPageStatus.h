//
//  VedioPageStatus.h
//  YueSheng
//
//  Created by yellow on 16/7/25.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWVedioParam.h"
@interface YWVedioPageStatus : NSObject

@property(nonatomic,assign)BOOL isLoad;

@property(nonatomic,strong)YWVedioParam *param;

@property (nonatomic, strong) NSArray *statuses;


@end

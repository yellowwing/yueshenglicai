//
//  YWKLineView.m
//  通信录
//
//  Created by yellow on 16/7/14.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWKLineView.h"

@implementation YWKLineView

+(instancetype)kLineView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"YWKLineView" owner:nil options:nil].lastObject;
    
}


@end

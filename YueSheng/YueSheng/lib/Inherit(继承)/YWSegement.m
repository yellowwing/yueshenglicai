//
//  YWSegement.m
//  通信录
//
//  Created by yellow on 16/7/13.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWSegement.h"

@implementation YWSegement

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置文字颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted { }


@end

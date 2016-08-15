//
//  ReviewDetailHeaderView.h
//  YueSheng
//
//  Created by yellow on 16/8/5.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewDetailStatus.h"

@interface ReviewDetailHeaderView : UIView

+(instancetype)headerView;

@property(nonatomic,strong)ReviewDetailStatus *status;

@end

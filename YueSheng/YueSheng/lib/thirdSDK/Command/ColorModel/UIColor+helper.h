//
//  UIColor+helper.h
//  InvestmentExpress
//
//  Created by UncleLi on 16/1/11.
//  Copyright © 2016年 YSLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "colorModel.h"

@interface UIColor (helper)

+ (UIColor *) colorWithHexString: (NSString *)color withAlpha:(CGFloat)alpha;
+ (colorModel *) RGBWithHexString: (NSString *)color withAlpha:(CGFloat)alpha;

@end

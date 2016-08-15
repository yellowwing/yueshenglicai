//
//  ColumnView.m
//  YueSheng
//
//  Created by yellow on 16/7/15.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ColumnView.h"

@interface ColumnView ()

@end

@implementation ColumnView


 +(instancetype)columnView{
 
 return [[NSBundle mainBundle] loadNibNamed:@"ColumnView" owner:nil options:nil].lastObject;
     
 }

-(void)awakeFromNib{
    [super awakeFromNib];

}

@end

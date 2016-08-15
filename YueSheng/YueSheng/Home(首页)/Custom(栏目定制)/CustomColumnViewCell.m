//
//  CustomColumnViewCell.m
//  YueSheng
//
//  Created by yellow on 16/7/20.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "CustomColumnViewCell.h"

@interface CustomColumnViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *customLabel;


@end

@implementation CustomColumnViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.customLabel.layer.cornerRadius = 15;
    self.customLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.customLabel.layer.borderWidth = 0.3;
    self.customLabel.clipsToBounds = YES;
}

-(void)setStatus:(YWColumnStatus *)status{
    
    _status = status;
    
    self.customLabel.text = status.StName;
    
    
}

@end

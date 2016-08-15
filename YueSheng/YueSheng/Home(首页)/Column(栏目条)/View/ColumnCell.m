//
//  ColumnCell.m
//  YueSheng
//
//  Created by yellow on 16/7/15.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ColumnCell.h"

@interface ColumnCell ()
@property (weak, nonatomic) IBOutlet UILabel *columnLabel;

@end


@implementation ColumnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setStatus:(YWColumnStatus *)status{
    
    _status = status;
    
    self.columnLabel.text = status.StName;
    
    if (status.isSelected) {
        self.columnLabel.textColor = YWColor(34, 74, 239);
        self.columnLabel.font = [UIFont systemFontOfSize:15];
    }
    else{
        self.columnLabel.textColor = [UIColor blackColor];
        self.columnLabel.font = [UIFont systemFontOfSize:13];

    }
    
    
}

@end

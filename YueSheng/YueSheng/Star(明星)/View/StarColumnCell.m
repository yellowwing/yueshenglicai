//
//  StarColumnCell.m
//  YueSheng
//
//  Created by yellow on 16/7/26.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "StarColumnCell.h"

@interface StarColumnCell ()
@property (weak, nonatomic) IBOutlet UILabel *columnLabel;

@end

@implementation StarColumnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


-(void)setStatus:(YWStarColumnStatus *)status{
    
    _status = status;
    
    self.columnLabel.text = status.St_Name;
    
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

//
//  YWStockCell.m
//  通信录
//
//  Created by yellow on 16/7/12.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWStockCell.h"
#import "YWStockStatus.h"
@interface YWStockCell ()
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *abbreviationLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation YWStockCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"stock";
    YWStockCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YWStockCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)setStatus:(YWStockStatus *)status{
    
    _status = status;
    self.codeLabel.text = status.Stock_Code;
    self.nameLabel.text = status.Stock_Name;
    self.abbreviationLabel.text = status.Stock_Abbreviation;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

@end

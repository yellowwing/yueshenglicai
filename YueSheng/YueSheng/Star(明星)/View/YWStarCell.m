//
//  YWStarCell.m
//  YueSheng
//
//  Created by yellow on 16/7/26.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWStarCell.h"
#import "YWStarStatus.h"
@interface YWStarCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation YWStarCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"star";
    YWStarCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YWStarCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)setStatus:(YWStarStatus *)status{

    _status = status;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:status.Sif_Img] placeholderImage:[UIImage imageNamed:@"占位图片.jpg"]];
    
    self.nameLabel.text = status.Sif_Name;
    
    self.contentLabel.text = status.content;
    
    self.timeLabel.text = status.Sn_Time;


}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconView.layer.cornerRadius = self.iconView.bounds.size.width/2;
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconView.clipsToBounds = YES;
    
}

-(void)setFrame:(CGRect)frame{
    
    CGFloat hPadding = 10;
    CGFloat wPadding = 0;
    frame.origin.y += hPadding;
    frame.size.height -= hPadding;
    frame.origin.x += wPadding;
    frame.size.width -= 2*wPadding;
    [super setFrame:frame];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{

}

@end

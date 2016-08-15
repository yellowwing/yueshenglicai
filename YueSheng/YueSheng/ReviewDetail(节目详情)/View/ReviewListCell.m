//
//  ReviewListCell.m
//  YueSheng
//
//  Created by yellow on 16/8/5.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ReviewListCell.h"

@interface ReviewListCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end


@implementation ReviewListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"reviewList";
    ReviewListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReviewListCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)setStatus:(ReviewListStatus *)status{
    _status = status;
    self.titleLabel.text = status.title;
    self.timeLabel.text = status.time;

}

-(void)setFrame:(CGRect)frame{
    
    CGFloat hPadding = 0;
    CGFloat wPadding = 10;
    frame.origin.y += hPadding;
    frame.size.height -= hPadding;
    frame.origin.x += wPadding;
    frame.size.width -= 2*wPadding;
    [super setFrame:frame];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
}

@end

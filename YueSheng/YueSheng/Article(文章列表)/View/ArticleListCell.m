//
//  ArticleListCell.m
//  YueSheng
//
//  Created by yellow on 16/7/27.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ArticleListCell.h"

@interface ArticleListCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;



- (IBAction)commentClick;
- (IBAction)praiseClick;

@end


@implementation ArticleListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"articleList";
    ArticleListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ArticleListCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)setStatus:(ArticleListStatus *)status{
    
    _status = status;
    
    self.titleLabel.text = status.Sn_Title;
    
    self.timeLabel.text = status.Sn_Time;
    
    self.contentLabel.text = status.Sn_Content;
    
    NSString *commentString;
    if ([status.ComNumber isEqualToString:@"0"]|| status.ComNumber == nil || [status.ComNumber isEqualToString:@""]) {
        commentString = @"评论";
    }else{
        commentString = [NSString stringWithFormat:@"评论%@",status.ComNumber];
    }
    
    [self.commentBtn setTitle:commentString forState:UIControlStateNormal];
    
    if (self.status.isPraised) {
        self.praiseBtn.selected = YES;
    }
    else{
        self.praiseBtn.selected = NO;
    
    }
    
    
}

-(void)setFrame:(CGRect)frame{
    
    CGFloat hPadding = 10;
    CGFloat wPadding = 10;
    frame.origin.y += hPadding;
    frame.size.height -= hPadding;
    frame.origin.x += wPadding;
    frame.size.width -= 2*wPadding;
    [super setFrame:frame];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{

}
- (IBAction)commentClick {

    if ([self.delegate respondsToSelector:@selector(articleListCellDidClickCommentBtn:articleListStatus:)]) {
        [self.delegate articleListCellDidClickCommentBtn:self articleListStatus:self.status];
    }
    
}

- (IBAction)praiseClick {
    
    //因为外面controller有负责动画，不能reloadData，不然有冲突，只能在这里改变模型和样式
    self.status.isPraised = YES;
    
    self.praiseBtn.selected = YES;
    
    if ([self.delegate respondsToSelector:@selector(articleListCellDidClickPraiseBtn:articleListStatus:)]) {
        [self.delegate articleListCellDidClickPraiseBtn:self articleListStatus:self.status];
    }
    
    
}
@end

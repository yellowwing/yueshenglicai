//
//  VedioCell.m
//  YueSheng
//
//  Created by yellow on 16/7/25.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "VedioCell.h"
#import "YWVedioStatus.h"
@interface VedioCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation VedioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 2;
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.clipsToBounds = YES;
    
    self.iconView.userInteractionEnabled = YES;
    self.contentLabel.userInteractionEnabled = YES;
    
}

-(void)setStatus:(YWVedioStatus *)status{

    _status = status;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:status.NiImg] placeholderImage:[UIImage imageNamed:@"占位图片.jpg"]];
    self.contentLabel.text = status.NiTitle;


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}
@end

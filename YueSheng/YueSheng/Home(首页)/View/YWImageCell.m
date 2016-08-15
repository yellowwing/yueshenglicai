//
//  YWImageCell.m
//  通信录
//
//  Created by yellow on 16/7/2.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "YWImageCell.h"

@interface YWImageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end


@implementation YWImageCell

-(void)awakeFromNib{
    [super awakeFromNib];

    self.iconView.clipsToBounds = YES;
    
}

-(void)setStatus:(YWPagePictureStatus *)status{

    _status = status;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:status.Img] placeholderImage:[UIImage imageNamed:@"占位图片.jpg"]];
    
    
    

}

@end

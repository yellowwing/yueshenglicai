//
//  MeHeaderView.m
//  通信录
//
//  Created by yellow on 16/7/2.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "MeHeaderView.h"

@interface MeHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@end

@implementation MeHeaderView

+(instancetype)headerView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"MeHeaderView" owner:nil options:nil].lastObject;
    
}

-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.icon.layer.cornerRadius = self.icon.bounds.size.width/2;
    self.icon.clipsToBounds = YES;
    self.icon.layer.borderColor = [UIColor whiteColor].CGColor;
    self.icon.layer.borderWidth = 3;
    self.icon.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeIcon)];
    [self.icon addGestureRecognizer:tap];
    
}

-(void)changeIcon{

    if ([self.delegate respondsToSelector:@selector(meHeaderViewDidChangeIcon:)]) {
        [self.delegate meHeaderViewDidChangeIcon:self];
    }

}

-(void)setIconImage:(UIImage *)iconImage{
    self.icon.image = iconImage;
}

-(void)setAccount:(NSString *)account{
    _account = [account copy];
    self.accountLabel.text = account;

}

-(void)setIconString:(NSString *)iconString{
    _iconString = [iconString copy];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:iconString] placeholderImage:[UIImage imageNamed:@"占位图片.jpg"]];

}

@end

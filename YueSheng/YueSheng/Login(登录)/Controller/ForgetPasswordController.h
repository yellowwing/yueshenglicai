//
//  ForgetPasswordController.h
//  YueSheng
//
//  Created by yellow on 16/7/30.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ForgetPasswordController;
@protocol ForgetPasswordControllerDelegate <NSObject>

@optional
-(void)forgetPasswordController:(ForgetPasswordController*)forgetPasswordController didChangeWithPhoneNumber:(NSString *)phone password:(NSString *)password;

@end

@interface ForgetPasswordController : UIViewController

@property(nonatomic,weak)id <ForgetPasswordControllerDelegate>delegate;

@end

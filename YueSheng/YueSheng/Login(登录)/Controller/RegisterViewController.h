//
//  RegisterViewController.h
//  YueSheng
//
//  Created by yellow on 16/7/30.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RegisterViewController;
@protocol RegisterViewControllerDelegate <NSObject>

@optional
-(void)registerViewController:(RegisterViewController*)registerViewController didRegisterWithPhoneNumber:(NSString *)phone password:(NSString *)password;

@end


@interface RegisterViewController : UIViewController

@property(nonatomic,weak)id <RegisterViewControllerDelegate>delegate;

@end

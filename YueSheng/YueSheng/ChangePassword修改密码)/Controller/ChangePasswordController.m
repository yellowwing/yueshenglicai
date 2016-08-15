//
//  ChangePasswordController.m
//  YueSheng
//
//  Created by yellow on 16/8/2.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ChangePasswordController.h"
#import "NSString+Password.h"
#import "ChangePasswordStatus.h"
#import "ChangePasswordTool.h"
#import "ChangePasswordParam.h"

@interface ChangePasswordController ()
@property (weak, nonatomic) IBOutlet UIView *orignPasswordView;
@property (weak, nonatomic) IBOutlet UITextField *orignPasswordField;
@property (weak, nonatomic) IBOutlet UIView *changedPasswordView;
@property (weak, nonatomic) IBOutlet UITextField *changedPasswordField;
@property (weak, nonatomic) IBOutlet UIView *againPasswordView;
@property (weak, nonatomic) IBOutlet UITextField *againPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

- (IBAction)confirmClick;


@property (nonatomic, copy) NSString *orignPwd;

@property (nonatomic, copy) NSString *changedPwd;

@end

@implementation ChangePasswordController

- (NSString *)orignPwd
{
    return [self.orignPasswordField.text MD5];
}

- (NSString *)changedPwd
{
    return [self.changedPasswordField.text MD5];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.orignPasswordView.layer.cornerRadius = 5;
    self.changedPasswordView.layer.cornerRadius = 5;
    self.againPasswordView.layer.cornerRadius = 5;
    self.confirmBtn.layer.cornerRadius = 5;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

- (IBAction)confirmClick {
    
    if (![self.changedPasswordField.text isEqualToString:self.againPasswordField.text]) {
        [MBProgressHUD showError:@"新密码前后不一致"];
        return;
    }
    
    [self confirmChange];
}

-(void)confirmChange{

    [MBProgressHUD showMessage:nil toView:self.view];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:uidID];
    
    ChangePasswordParam *param = [[ChangePasswordParam alloc] init];
    param.Ui_Id = uid;
    param.oldPassword = self.orignPwd;//传给后台传用md5加密过的
    param.newsPassword = self.changedPwd;
    
    [ChangePasswordTool changePasswordStatusesWithParameters:param success:^(ChangePasswordStatus *status) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if ([status.Status isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:@"修改密码成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            
            [MBProgressHUD showError:status.msg];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
        
    }];


}

@end

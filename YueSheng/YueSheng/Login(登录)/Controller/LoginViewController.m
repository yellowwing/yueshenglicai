//
//  LoginViewController.m
//  YueSheng
//
//  Created by yellow on 16/7/30.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordController.h"
#import "LoginStatus.h"
#import "LoginParam.h"
#import "LoginTool.h"
#import "NSString+Password.h"

@interface LoginViewController ()<RegisterViewControllerDelegate,ForgetPasswordControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic, copy) NSString *registerPwd;

- (IBAction)registerClick;

- (IBAction)loginClick;

- (IBAction)forgetClick;
@end

@implementation LoginViewController

- (NSString *)registerPwd
{
    return [self.passwordField.text MD5];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    
    [self setupLeftItem];
    
    self.nameView.layer.cornerRadius = 5;
    self.passwordView.layer.cornerRadius = 5;
    self.loginBtn.layer.cornerRadius = 5;
    
}

-(void)setupLeftItem{
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)dismiss{
    
    [self dismissViewControllerAnimated:YES completion:^{
                
    }];
}

- (IBAction)registerClick {
    
  RegisterViewController *registerController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    registerController.delegate = self;
    [self.navigationController pushViewController:registerController animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
    
}

- (IBAction)loginClick {
    
    NSString *phoneNumber = self.nameField.text;
    if (phoneNumber.length == 0) {
        [MBProgressHUD showError:@"请正确填写帐号"];
        return;
    }
    if(![RegularTools validateMobile:phoneNumber]) {
        [MBProgressHUD showError:@"手机号码格式不正确"];
        return;
    }
    if (self.passwordField.text.length < 6 || self.passwordField.text.length >16) {
        [MBProgressHUD showError:@"密码请输入6-16位"];
        return;
        
    }
    
    [MBProgressHUD showMessage:nil toView:self.view];
    
    LoginParam *param = [[LoginParam alloc] init];
    param.account = self.nameField.text;
    param.password = self.registerPwd;//传给后台传用md5加密过的
    
    [LoginTool loginStatusesWithParameters:param success:^(LoginStatus *status) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if ([status.Status isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:@"登录成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            //保存账号
#warning - 到时要弄一个个人信息模型把这些个人信息封装起来
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:loginID];
            [defaults setObject:self.nameField.text forKey:accountID];
            [defaults setObject:status.Ui_Id forKey:uidID];
            
            [defaults setObject:status.Ui_Img forKey:iconUrl];
            
            [defaults synchronize];
           
//发送通知accountID改变“我的”帐号
            NSNotification *notification=[NSNotification notificationWithName:@"ChangeAccountNotification" object:self userInfo:@{@"context":self.nameField.text,@"icon":status.Ui_Img}];
            
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        else{
            [MBProgressHUD showError:status.msg];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
        
    }];

}

- (IBAction)forgetClick {
    ForgetPasswordController *forgetController = [[ForgetPasswordController alloc] initWithNibName:@"ForgetPasswordController" bundle:nil];
    forgetController.delegate = self;
    [self.navigationController pushViewController:forgetController animated:YES];
}

-(void)forgetPasswordController:(ForgetPasswordController *)forgetPasswordController didChangeWithPhoneNumber:(NSString *)phone password:(NSString *)password{
    
    self.nameField.text = phone;
    self.passwordField.text = password;

}

-(void)registerViewController:(RegisterViewController *)registerViewController didRegisterWithPhoneNumber:(NSString *)phone password:(NSString *)password{
    self.nameField.text = phone;
    self.passwordField.text = password;

}
@end

//
//  RegisterViewController.m
//  YueSheng
//
//  Created by yellow on 16/7/30.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "RegisterViewController.h"
#import "CheckCodeStatus.h"
#import "CheckCodeParam.h"
#import "CheckCodeTool.h"
#import "NSString+Password.h"
#import "RegisterStatus.h"
#import "RegisterTool.h"
#import "RegisterParam.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

- (IBAction)getCodeClick;
- (IBAction)registerClick;

@property(nonatomic,copy)NSString *checkCode;

@property(nonatomic,copy)NSString *phoneNumber;
/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;

@property(nonatomic,assign)NSInteger number;

@property (nonatomic, copy) NSString *registerPwd;

@end

@implementation RegisterViewController

- (NSString *)registerPwd
{
    return [self.passwordField.text MD5];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.codeBtn.layer.cornerRadius = 5;
    self.nameView.layer.cornerRadius = 5;
    self.codeView.layer.cornerRadius = 5;
    self.passwordView.layer.cornerRadius = 5;
    self.registerBtn.layer.cornerRadius = 5;
    self.number = 60;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

- (IBAction)getCodeClick {
    NSString *phoneNumber = self.nameField.text;
    
    if (phoneNumber.length == 0) {
       [MBProgressHUD showError:@"手机号码不能为空"];
        return;
    }
    if(![RegularTools validateMobile:phoneNumber]) {
        [MBProgressHUD showError:@"手机号码格式不正确"];
        return;
    }
    
    [self getCheckCode];
    [self btnEndPressed];

}

-(void)getCheckCode{
    CheckCodeParam *param = [[CheckCodeParam alloc] init];
    param.phone = self.nameField.text;
    param.type = @"0";
    self.phoneNumber = self.nameField.text;
    
    [CheckCodeTool checkCodeStatusesWithParameters:param success:^(CheckCodeStatus *status) {
        
        if ([status.Status isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:@"已发送"];
            
            self.checkCode = [NSString stringWithFormat:@"%@",status.msg];
            YWLog(@"%@",self.checkCode);
        }
        else{
            [MBProgressHUD showError:status.msg];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
        
    }];

}

- (IBAction)registerClick {
    
    if (![self.nameField.text isEqualToString:self.phoneNumber] || ![self.codeField.text isEqualToString:self.checkCode]) {
        
        YWLog(@"%@,%@ - %@,%@",self.nameField.text,self.phoneNumber,self.codeField.text,self.checkCode);
        
        
        [MBProgressHUD showError:@"手机号码与验证码不匹配"];
        return;
    }
    if (self.passwordField.text.length < 6 || self.passwordField.text.length >16) {
        [MBProgressHUD showError:@"密码请输入6-16位"];
        return;

    }
    
    [self goRegister];
    
}

-(void)goRegister{
    
    [MBProgressHUD showMessage:nil toView:self.view];
    
    RegisterParam *param = [[RegisterParam alloc] init];
    param.phone = self.nameField.text;
    param.password = self.registerPwd;//传给后台传用md5加密过的
  
    
    [RegisterTool registerStatusesWithParameters:param success:^(RegisterStatus *status) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if ([status.Status isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:@"注册成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
            if ([self.delegate respondsToSelector:@selector(registerViewController:didRegisterWithPhoneNumber:password:)]) {
                [self.delegate registerViewController:self didRegisterWithPhoneNumber:self.nameField.text password:self.passwordField.text];
            }
            
        }
        else{
            [MBProgressHUD showError:status.msg];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
        
    }];


}

-(void)btnEndPressed{
    
    self.codeBtn.enabled = NO;
    [self addTimer];
    
}

-(void)btnGetActivity{
    self.codeBtn.enabled = YES;
    self.number = 60;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"验证码"] forState:UIControlStateNormal];
}


/**
 *  添加定时器
 */
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(minusOne) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)minusOne{
    
    self.number -- ;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds",self.number] forState:UIControlStateNormal];
    
    if (self.number == 0) {
        
        [self btnGetActivity];
        
        [self removeTimer];
    }
    
}

@end

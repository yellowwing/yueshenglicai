//
//  ForgetPasswordController.m
//  YueSheng
//
//  Created by yellow on 16/7/30.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "ForgetPasswordController.h"
#import "ForgetStatus.h"
#import "ForgetParam.h"
#import "ForgetTool.h"
#import "NSString+Password.h"
#import "CheckCodeStatus.h"
#import "CheckCodeParam.h"
#import "CheckCodeTool.h"

@interface ForgetPasswordController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
- (IBAction)codeClick;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIView *againView;

@property (weak, nonatomic) IBOutlet UITextField *againField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)confirmClick;

@property(nonatomic,weak)UITextField *textField;

@property(nonatomic,assign)CGFloat duration;

@property(nonatomic,copy)NSString *checkCode;

@property(nonatomic,copy)NSString *phoneNumber;
/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;

@property(nonatomic,assign)NSInteger number;

@property (nonatomic, copy) NSString *registerPwd;

@end

@implementation ForgetPasswordController

- (NSString *)registerPwd
{
    return [self.passwordField.text MD5];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找回密码";
    self.nameView.layer.cornerRadius = 5;
    self.codeBtn.layer.cornerRadius = 5;
    self.codeView.layer.cornerRadius = 5;
    self.passwordView.layer.cornerRadius = 5;
    self.againView.layer.cornerRadius = 5;
    self.confirmBtn.layer.cornerRadius = 5;
    
    // 监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.nameField.delegate = self;
    self.codeField.delegate = self;
    self.passwordField.delegate = self;
    self.againField.delegate = self;
    
    self.number = 60;
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  当键盘改变了frame(位置和尺寸)的时候调用
 */
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 设置窗口的颜色
    self.view.window.backgroundColor = self.view.backgroundColor;
    
    // 0.取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
    self.duration = duration;
    
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (CGRectGetMaxY(self.textField.superview.frame) < keyboardFrame.origin.y) {
        return;
    }
    
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = CGRectGetMaxY(self.textField.superview.frame)-keyboardFrame.origin.y - 84;
    
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.textField = textField;

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:self.duration animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
    
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

- (IBAction)codeClick {
    
    NSString *phoneNumber = self.nameField.text;
    
    if (phoneNumber.length == 0) {
        [MBProgressHUD showError:@"手机号码不能为空"];
        return;
    }
    else  if(![RegularTools validateMobile:phoneNumber]) {
        [MBProgressHUD showError:@"手机号码格式不正确"];
        return;
    }
    
    [self getCheckCode];
    [self btnEndPressed];
    
    
}
-(void)getCheckCode{
    CheckCodeParam *param = [[CheckCodeParam alloc] init];
    param.phone = self.nameField.text;
    param.type = @"1";
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

- (IBAction)confirmClick {
    
    if (![self.nameField.text isEqualToString:self.phoneNumber] || ![self.codeField.text isEqualToString:self.checkCode]) {
        
        YWLog(@"%@,%@ - %@,%@",self.nameField.text,self.phoneNumber,self.codeField.text,self.checkCode);
        
        
        [MBProgressHUD showError:@"手机号码与验证码不匹配"];
        return;
    }
    if (self.passwordField.text.length < 6 || self.passwordField.text.length >16) {
        [MBProgressHUD showError:@"密码请输入6-16位"];
        return;
        
    }
    if (![self.passwordField.text isEqualToString:self.againField.text]) {
        [MBProgressHUD showError:@"密码不一致"];
        return;
    }
    
    
    [self goConfirm];

}

-(void)goConfirm{

    [MBProgressHUD showMessage:nil toView:self.view];
    
    ForgetParam *param = [[ForgetParam alloc] init];
    param.Ui_Account = self.nameField.text;
    param.Ui_Password = self.registerPwd;//传给后台传用md5加密过的
    
    
    [ForgetTool forgetStatusesWithParameters:param success:^(ForgetStatus *status) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if ([status.Status isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
            if ([self.delegate respondsToSelector:@selector(forgetPasswordController:didChangeWithPhoneNumber:password:)]) {
                [self.delegate forgetPasswordController:self didChangeWithPhoneNumber:self.nameField.text password:self.passwordField.text];
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

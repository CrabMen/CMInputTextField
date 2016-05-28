//
//  ViewController.m
//  CMInputTextField
//
//  Created by CrabMan on 16/5/28.
//  Copyright © 2016年 CrabMan. All rights reserved.
//

#import "ViewController.h"
#import "CMInputTextField.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CMInputTextField *textField = [[CMInputTextField alloc]initWithFrame:CGRectMake(100, 100, 200, 40)];
    
   
    
   // textField.backgroundColor = [UIColor lightGrayColor];
    textField.InputTextFieldStyle = CMInputTextFieldPhoneNumStyle;
    textField.borderStyle = UITextBorderStyleLine;
    textField.placeholder = @"手机号";
    [self.view addSubview:textField];
    
    CMInputTextField *BankCardTextField = [[CMInputTextField alloc]initWithFrame:CGRectMake(100, 200, 200, 40)];
    
    BankCardTextField.InputTextFieldStyle = CMInputTextFieldBankCardNumStyle;
    BankCardTextField.borderStyle = UITextBorderStyleLine;
    BankCardTextField.placeholder = @"银行卡号";
    [self.view addSubview:BankCardTextField];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

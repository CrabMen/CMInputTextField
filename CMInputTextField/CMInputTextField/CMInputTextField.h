//
//  CMInputTextField.h
//  CMInputTextField
//
//  Created by CrabMan on 16/5/28.
//  Copyright © 2016年 CrabMan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    CMInputTextFieldBankCardNumStyle,
    
    CMInputTextFieldPhoneNumStyle,

} CMInputTextFieldStyle;

@interface CMInputTextField : UITextField

@property (nonatomic,assign) CMInputTextFieldStyle InputTextFieldStyle ;

@end

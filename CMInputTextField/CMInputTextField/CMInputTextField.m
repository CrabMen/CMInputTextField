//
//  CMInputTextField.m
//  CMInputTextField
//
//  Created by CrabMan on 16/5/28.
//  Copyright © 2016年 CrabMan. All rights reserved.
//

#import "CMInputTextField.h"

@interface CMInputTextField () <UITextFieldDelegate>
{
    NSString *previousTextFieldContent;
    UITextRange *previousTextRange;
}
@end

@implementation CMInputTextField

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.delegate = self;
        
        [self addTarget:self action:@selector(reformatAsBankCardNumber:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}


- (void)reformatAsBankCardNumber:(UITextField *)textField {

    NSLog(@"起始输入框内容:%@",textField.text);
    /*获取指针的位置，（从文本开始 到文本选定内容光标的起始位置）
    
    selectedTextRange作为textField的属性，表示 文档中选定文本的范围包含[start,end)两个值，通过实验我们可以发现，在没有文字被选取时，start代表当前光标的位置，而end＝0；当有区域被选择时，start和end分别是选择的头和尾的光标位置，从0开始，并且不包含end，例如选择了0～3的位置，则start＝0，end＝4。
     */
    NSUInteger cursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    
    NSString *cardNumWithoutSpaces = [self removeNonDigits:textField.text andPreserveCursorPosition:&cursorPosition];
     NSLog(@"没有空格的内容:%@",cardNumWithoutSpaces);
    //当输入框长度大于19时将输入框内容还原为之前的
    if (self.InputTextFieldStyle==CMInputTextFieldBankCardNumStyle&&cardNumWithoutSpaces.length > 19) {
        
        [textField setText:previousTextFieldContent];
        
        textField.selectedTextRange = previousTextRange;
        
        return;
        
    }
    
    if (self.InputTextFieldStyle==CMInputTextFieldPhoneNumStyle&&cardNumWithoutSpaces.length > 11) {
        
        [textField setText:previousTextFieldContent];
        
        textField.selectedTextRange = previousTextRange;
        
        return;
        
    }
    
    
    
    
    
    NSString *cardNumWithSpaces = [self insertSpacesIntoString:cardNumWithoutSpaces andPreserveCursorPosition:&cursorPosition];
    
    
    //将textField的内容设置为修改过的
    textField.text = cardNumWithSpaces;
    
    NSLog(@"加入空格的内容:%@",textField.text);
    
   UITextPosition *textPosition = [textField positionFromPosition:textField.beginningOfDocument offset:cursorPosition];
    
    
    [textField setSelectedTextRange:[textField textRangeFromPosition:textPosition toPosition:textPosition]];

    
    NSLog(@"输入框内容:%@",textField.text);
    
    
}

/**
 移除非数字字符串并设置指针位置并保存
 reanson:第三方输入法的数字键盘可以调用文字键盘
 方法第二个参数必须加*，更改的时候更改的是reformatAsBankCardNumber方法中cursorPosition的值
 */
- (NSString *)removeNonDigits:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
   
    NSMutableString *characterString = [NSMutableString new];
    //这段代码可以防止光标移动的bug
    NSUInteger originalCursorPosition = *cursorPosition;
    for (NSUInteger i = 0; i < string.length; i++) {
        unichar character = [string characterAtIndex:i];
        
        // 方法isdigit属于C语言方法：判断字符是否为数字
        if (isdigit(character)) {
            
            [characterString appendString:[NSString stringWithCharacters:&character length:1]];
        } else {
            //光标左移
            if (i < originalCursorPosition) {
                (*cursorPosition)--;
            }
        
        }
        
    }
    
    
    return characterString;
}


/**
 为string添加空格
 */
- (NSString *)insertSpacesIntoString:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSUInteger originalCursorPosition = *cursorPosition;
    NSMutableString *stringWithSpaces = [NSMutableString new];
    

    for (NSUInteger i = 0; i < string.length; i++) {
        //如果输入为银行卡号每四位加一个空格
        if ((i > 0) && ((i % 4) == 0)&& (self.InputTextFieldStyle==CMInputTextFieldBankCardNumStyle)) {
            [stringWithSpaces appendString:@" "];
            
            if (i < originalCursorPosition) {
                (*cursorPosition)++;
            }
            
        }
        
        //如果输入为手机号首3位，然后4位加空格
        if ((i > 0) &&((i == 3) || (i == 7))&& (self.InputTextFieldStyle==CMInputTextFieldPhoneNumStyle)) {
            [stringWithSpaces appendString:@" "];
            
            if (i < *cursorPosition) {
                (*cursorPosition)++;
            }
            
        }
       
        
        unichar characterToAdd = [string characterAtIndex:i];
        
        [stringWithSpaces appendString:[NSString stringWithCharacters:&characterToAdd length:1]];
        
    }
    
    return stringWithSpaces;
}


#pragma mark --- UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//在textField内容改变之前记录textField的当前状态
    previousTextFieldContent = textField.text;
    previousTextRange = textField.selectedTextRange;
    
    return YES;

}




@end

//
//  ViewController.m
//  4位一空格的Nsstring的类别
//
//  Created by Teplot_03 on 16/7/19.
//  Copyright © 2016年 Teplot_03. All rights reserved.
//

#import "ViewController.h"
#import "NSString+NumberFormate.h"
#import "UITextField+ExtentRange.h"

@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextField *tf = [[UITextField alloc] init];
    
    tf.backgroundColor = [UIColor lightGrayColor];
    
    tf.frame = CGRectMake(20, 30, 200, 40);
    
    tf.delegate = self;
    
    [self.view addSubview:tf];
    
    
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //判断是否为删除符
    if ([string isEqualToString:@""]) {
        
        //现在是要获取textField的光标前一个字符
        NSRange selectedRange = [textField selectedRange];
        
        NSRange lastCharRange = NSMakeRange(selectedRange.location-1, 1);
        
        NSString *lastChar = [textField.text substringWithRange:lastCharRange];
        //如果光标前一位是空格，那么为什么删除了两个字符
        if ([lastChar isEqualToString:@" "]) {

            NSRange lastLastRange = NSMakeRange(lastCharRange.location-1, 1);
            NSMutableString *mutString = [NSMutableString stringWithString:textField.text];
            [mutString deleteCharactersInRange:lastLastRange];
            textField.text = [mutString orderWithCreditOrder];
            
            [textField setSelectedRange:NSMakeRange(lastLastRange.location, 0)];
            
            return NO;
        }
        else {
            //如果前边一位不是空格，那么要删除前一位字符，并且再排序
            NSRange currentRange = [textField selectedRange];
            NSMutableString *oString = [NSMutableString stringWithString:textField.text];
            [oString replaceCharactersInRange:lastCharRange withString:@""];
            
            textField.text = [oString orderWithCreditOrder];
            NSRange afterDeleteRange = NSMakeRange(currentRange.location-1, currentRange.length);
            [textField setSelectedRange:afterDeleteRange];
            
            //删除操作完成后
            //如果删除之后前边的一位字符是空格，那么光标前移一位
            if (afterDeleteRange.location>textField.text.length) {
                [textField setSelectedRange:NSMakeRange(textField.text.length, 0)];
                return NO;
            }
            NSString *pointerLastChar = [textField.text substringWithRange:NSMakeRange(afterDeleteRange.location-1, 1)];
            if ([pointerLastChar isEqualToString:@" "]) {
                [textField setSelectedRange:NSMakeRange(afterDeleteRange.location-1, 0)];
            }
            return NO;
        }
        
    }
    
    //如果不是是删除符
    //1.先获取当前光标位置
    NSRange selectedRange = [textField selectedRange];
    //2.将添加的字符添加到对应的光标位置
    
    NSMutableString *orgString = [NSMutableString stringWithString:textField.text];
    [orgString insertString:string atIndex:selectedRange.location];
    
    NSString *newString = [orgString orderWithCreditOrder];
    textField.text = newString;
    
    //这里要判断前边是空格还是字符(selectedRange)
    NSString *lastChar = [orgString substringWithRange:NSMakeRange(selectedRange.location-1, 1)];
    NSString *nextChar;
    if (orgString.length>selectedRange.location+1) {
        nextChar = [orgString substringWithRange:NSMakeRange(selectedRange.location+1, 1)];
    }
    else {
        nextChar = nil;
    }
    
    BOOL lastIsSpace = [lastChar isEqualToString:@" "];
    BOOL nextIsSpace = [nextChar isEqualToString:@" "];
    
    //判断在加入字符之前，光标后是不是空格
    if (nextIsSpace) {
        NSRange newRange = NSMakeRange(selectedRange.location+2, selectedRange.length);
        
        [textField setSelectedRange:newRange];
    }
    else {
        //如果是空格就直接＋1
        //如果是字符判断是不是需要➕空格
        
        BOOL needAddSpace = newString.length%5 == 1 && newString.length!=1;
        
        NSRange newRange = NSMakeRange(selectedRange.location+( lastIsSpace?1:(needAddSpace?2:1)), selectedRange.length);
        
        [textField setSelectedRange:newRange];
    }
    
    
    
    
    return NO;
}

@end

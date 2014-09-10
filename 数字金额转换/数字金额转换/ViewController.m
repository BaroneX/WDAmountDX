//
//  ViewController.m
//  数字金额转换
//
//  Created by Blake on 9/9/14.
//  Copyright (c) 2014 BLAKE. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>
{
    
    IBOutlet UITextField* myTf;
    IBOutlet UILabel* myLabel;
    
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    myTf.delegate = self;
    
    [myTf addTarget:self action:@selector(change:) forControlEvents:UIControlEventEditingChanged];
    
    myLabel.adjustsFontSizeToFitWidth = YES;
    
}


-(void)change:(UITextField*)tf{
    
    myLabel.text = [self getCnMoneyByString:[tf.text stringByReplacingOccurrencesOfString:@"," withString:@""]];
    
    if ([tf.text rangeOfString:@"."].length) {
        NSArray* arr = [tf.text componentsSeparatedByString:@"."];
         tf.text = [NSString stringWithFormat:@"%@.%@",[self AddComma:[arr firstObject]],[arr lastObject]];
    }else
    
    tf.text = [self AddComma:tf.text];
}
- (NSString *)AddComma:(NSString *)string{//添加逗号
    
    NSString *str=[string stringByReplacingOccurrencesOfString:@"," withString:@""];
    int numl=[str length];
    
    if (numl>3&&numl<7) {
        return [NSString stringWithFormat:@"%@,%@",
                [str substringWithRange:NSMakeRange(0,numl-3)],
                [str substringWithRange:NSMakeRange(numl-3,3)]];
    }else if (numl>6){
        return [NSString stringWithFormat:@"%@,%@,%@",
                [str substringWithRange:NSMakeRange(0,numl-6)],
                [str substringWithRange:NSMakeRange(numl-6,3)],
                [str substringWithRange:NSMakeRange(numl-3,3)]];
    }else{
        return str;
    }
    
}

/**
 *
 *  @param string 阿拉伯数字格式字符串
 *
 *  @return 返回一个大写金额
 *
 */

-(NSString*)getCnMoneyByString:(NSString*)string{
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    numberFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    [numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
    [numberFormatter setMinimumFractionDigits:2];
    [numberFormatter setMaximumFractionDigits:6];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehaviorDefault];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[string doubleValue]]];
    //通过NSNumberFormatter转换为大写的数字格式 eg:一千二百三十四
    
    //替换大写数字转为金额
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"一" withString:@"壹"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"二" withString:@"贰"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"三" withString:@"叁"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"四" withString:@"肆"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"五" withString:@"伍"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"六" withString:@"陆"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"七" withString:@"柒"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"八" withString:@"捌"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"九" withString:@"玖"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"〇" withString:@"零"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"千" withString:@"仟"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"百" withString:@"佰"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"十" withString:@"拾"];
    
    //对小数点后部分单独处理
    if ([formattedNumberString rangeOfString:@"点"].length>0) {
        
        NSArray* arr = [formattedNumberString componentsSeparatedByString:@"点"];
        
        NSMutableString* lastStr = [[arr lastObject] mutableCopy];
        
        if (lastStr.length>=2) {
            
            [lastStr insertString:@"分" atIndex:lastStr.length];
            
        }
        if (![[lastStr substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"零"])
        {
            
            [lastStr insertString:@"角" atIndex:1];
        }
        
        formattedNumberString = [[arr firstObject] stringByAppendingFormat:@"元%@",lastStr];
        
    }else{
        formattedNumberString = [formattedNumberString stringByAppendingString:@"元"];
    }
    
    return formattedNumberString;
    
}

@end

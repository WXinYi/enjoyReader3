//
//  KeyboardFromPerfInfo.h
//  Anhao
//
//  Created by 马晓良 on 15/5/7.
//  Copyright (c) 2015年 lianchuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyboardFromPerfInfoDelegate <NSObject>

- (void) numberKeyboardInputAnother:(NSInteger) number;
- (void) numberKeyboardBackspaceAnother;
- (void) changeKeyboardTypeAnother;
- (void) appendingStringAnother;
@end

@interface KeyboardFromPerfInfo : UIView
{
    NSArray *arrLetter;
    NSTimer *connectionTimer;  //timer对象

}
@property (nonatomic, strong) NSString *needSymbol;
@property (nonatomic,assign) id<KeyboardFromPerfInfoDelegate> delegate;
@end
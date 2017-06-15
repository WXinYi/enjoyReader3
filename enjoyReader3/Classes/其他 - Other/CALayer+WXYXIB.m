//
//  CALayer+WXYXIB.m
//  enjoyReader3
//
//  Created by 王馨仪 on 16/8/9.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "CALayer+WXYXIB.h"
#import <UIKit/UIKit.h>
@implementation CALayer (WXYXIB)


- (void)setBorderColorWithUIColor:(UIColor *)color

{
    
    self.borderColor = color.CGColor;
    
}
@end

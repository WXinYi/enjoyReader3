//
//  NSDate+NSDate_E_Date.h
//  WFReader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NSDate_E_Date)

/*
 是否是今天
 */
- (BOOL)isToday;

/*
 时间差
 */
- (NSInteger) minutesAfterDate : (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;


@end

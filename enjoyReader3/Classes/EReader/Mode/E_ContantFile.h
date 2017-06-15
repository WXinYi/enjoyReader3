//
//  E_ContantFile.h
//  WFReader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#ifndef WFReader_E_ContantFile_h
#define WFReader_E_ContantFile_h

#define OPEN @"open"
#define SAVEPAGE @"savePage"
#define SAVETHEME @"saveTheme"
#define offSet_x 20
#define offSet_y 40
#define FONT_SIZE @"FONT_SIZE"
#define kBottomBarH 100

#define FilePath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define epubBookName @"倚天屠龙记"
#define kScreenW [UIScreen mainScreen].bounds.size.width


#define DELAYEXECUTE(delayTime,func) (dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{func;}))

#endif

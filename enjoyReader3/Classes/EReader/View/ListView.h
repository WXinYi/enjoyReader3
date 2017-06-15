//
//  E_ListView.h
//  WFReader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonManager.h"
#import "Mark.h"

@protocol E_ListViewDelegate <NSObject>

- (void)clickMark:(Mark *)eMark;
- (void)clickChapter:(NSInteger)chaperIndex;
- (void)removeE_ListView;

@end

@interface ListView : UIView<UITableViewDataSource,UITableViewDelegate>{
   
    UISegmentedControl *_segmentControl;
    NSInteger dataCount;
    NSMutableArray *_dataSource;
    CGFloat  _panStartX;
    BOOL    _isMenu;
    BOOL    _isMark;
    BOOL    _isNote;
    UIButton *otherBtn;
    UIButton *toTail;
    NSMutableArray *listarray;
    NSMutableArray * titleArr;

}
@property (nonatomic,assign)id<E_ListViewDelegate>delegate;

@property (nonatomic,strong)UITableView *listView;

@end

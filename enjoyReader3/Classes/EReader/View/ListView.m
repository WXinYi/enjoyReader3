//
//  E_ListView.m
//  WFReader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "ListView.h"
#import "ReaderDataSource.h"
#import "MarkTableViewCell.h"


@implementation ListView

- (id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:234/255.0 alpha:1.0];
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
        dataCount = [ReaderDataSource shareInstance].totalChapter;
        listarray = [[Chapter shareInstance] getListChapterArray];
        titleArr = [[Chapter shareInstance] getTitleArr];
        [self configListView];
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEListView:)];
        [self addGestureRecognizer:panGes];
        
    }
    return self;
}

- (void)panEListView:(UIPanGestureRecognizer *)recongnizer{
    CGPoint touchPoint = [recongnizer locationInView:self];
    switch (recongnizer.state) {
        case UIGestureRecognizerStateBegan:{
            _panStartX = touchPoint.x;
           }
            break;
            
        case UIGestureRecognizerStateChanged:{
            CGFloat offSetX = touchPoint.x - _panStartX;
            CGRect newFrame = self.frame;
            //NSLog(@"offSetX == %f",offSetX);
            newFrame.origin.x += offSetX;
            if (newFrame.origin.x >= 0){//试图向上滑动 阻止
               
                newFrame.origin.x = 0;
                self.frame = newFrame;
                return;
            }else{
                self.frame = newFrame;
            }
            
        
        }
            
            break;
            
        case UIGestureRecognizerStateEnded:{
            
            float duringTime = (self.frame.size.width + self.frame.origin.x)/self.frame.size.width * 0.25;
            if (self.frame.origin.x < 0) {
                [UIView animateWithDuration:duringTime animations:^{
                    self.frame = CGRectMake(-self.frame.size.width , 0,  self.frame.size.width, self.frame.size.height);
                } completion:^(BOOL finished) {
                    [_delegate removeE_ListView];
                }];
                
            }
        }
            break;
            
        case UIGestureRecognizerStateCancelled:
            
            break;
            
        default:
            break;
    }


}



- (void)configListView{
    
    _isMenu = YES;
    _isMark = NO;
    _isNote = NO;
    
    [self configListViewHeader];
   
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.frame.size.width, self.frame.size.height - 80 - 60)];
    [_listView reloadData];
    _listView.delegate = self;
    _listView.dataSource = self;
    _listView.backgroundColor = [UIColor clearColor];
    [_listView reloadData];
    
    if (dataCount != 1) {
        NSIndexPath *scrollIndePath;
        if ([CommonManager Manager_getChapterBefore:[[BookInfo siged] getBookID]] >  dataCount) {
            
            scrollIndePath= [NSIndexPath indexPathForRow:dataCount-1 inSection:0];
            
        }else{
            
            scrollIndePath= [NSIndexPath indexPathForRow:[CommonManager Manager_getChapterBefore:[[BookInfo siged] getBookID]] inSection:0];
        }
        [[self listView] scrollToRowAtIndexPath:scrollIndePath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    
    [self addSubview:_listView];
    
    toTail = [UIButton buttonWithType:0];
    toTail.frame = CGRectMake(70, self.frame.size.height - 40, self.frame.size.width - 140, 20);
    toTail.layer.borderWidth = 1.0;
    toTail.layer.cornerRadius = 2.0;
    toTail.titleLabel.font = [UIFont systemFontOfSize:16];
    [toTail setTitleColor:THEMECOLOR forState:0];
    [toTail setTitle:@"滑至底部" forState:0];
    [toTail addTarget:self action:@selector(toTail) forControlEvents:UIControlEventTouchUpInside];
    toTail.layer.borderColor = THEMECOLOR.CGColor;
    
    [self addSubview:toTail];

    toTail.hidden = NO;
    
    otherBtn = [UIButton buttonWithType:0];
    otherBtn.frame = CGRectMake(70, self.frame.size.height - 40, self.frame.size.width - 140, 20);
    otherBtn.layer.borderWidth = 1.0;
    otherBtn.layer.cornerRadius = 2.0;
    otherBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [otherBtn setTitleColor:THEMECOLOR forState:0];
    [otherBtn setTitle:@"编辑" forState:0];
    [otherBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    otherBtn.layer.borderColor = THEMECOLOR.CGColor;
    
    [self addSubview:otherBtn];
    
    otherBtn.hidden =YES;
    

    
    
}
-(void)toTail{
    
    if (!toTail.selected) {
        NSIndexPath *scrollIndePath =[NSIndexPath indexPathForRow:dataCount-1 inSection:0];
        
        [[self listView] scrollToRowAtIndexPath:scrollIndePath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [toTail setTitle:@"滑至顶部" forState:0];


    }else{
        NSIndexPath *scrollIndePath =[NSIndexPath indexPathForRow:0 inSection:0];
        
        [[self listView] scrollToRowAtIndexPath:scrollIndePath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [toTail setTitle:@"滑至底部" forState:0];
    
    }
    toTail.selected = !toTail.selected;

}
-(void)deleteClick{
    if ([_listView isEditing]==YES) {
        [otherBtn setTitle:@"编辑" forState:0];
        [_listView setEditing:NO animated:YES];

    }else{
      [otherBtn setTitle:@"结束编辑" forState:0];
        [_listView setEditing:YES animated:YES];

    }


   
}
- (void)configListViewHeader{

    NSArray *segmentedArray = @[@"目录",@"书签"];
    
    _segmentControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    
    _segmentControl.frame = CGRectMake(15, 30, self.bounds.size.width - 30 , 40);
    
    _segmentControl.selectedSegmentIndex = 0;
    
    _segmentControl.tintColor = COLOR(165, 11, 11, 1.0);

    [self addSubview:_segmentControl];
    
    [_segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    
    [_segmentControl setTitleTextAttributes:dict forState:0];
    
    
    
}

- (void)segmentAction:(UISegmentedControl *)sender{
    
    NSInteger index = sender.selectedSegmentIndex;
    switch (index) {
        case 0:{
                _isMenu = YES;
                _isMark = NO;
                _isNote = NO;
                dataCount = [ReaderDataSource shareInstance].totalChapter;//总章节数
                [_listView reloadData];
            
            if (dataCount != 1) {
                NSIndexPath *scrollIndePath;
                if ([CommonManager Manager_getChapterBefore:[[BookInfo siged] getBookID]] > dataCount) {
                    
                    scrollIndePath= [NSIndexPath indexPathForRow:dataCount-2 inSection:0];
                    
                }else{
                    
                    scrollIndePath= [NSIndexPath indexPathForRow:[CommonManager Manager_getChapterBefore:[[BookInfo siged] getBookID]] inSection:0];
                }
                [[self listView] scrollToRowAtIndexPath:scrollIndePath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            
//            
//                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:[CommonManager Manager_getChapterBefore:[[BookInfo siged] getBookID]] inSection:0];
//                [_listView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            otherBtn.hidden =YES;
            toTail.hidden = NO;
            }
            break;
        case 1:{
                _isMenu = NO;
                _isMark = YES;
                _isNote = NO;
            otherBtn.hidden =NO;
            toTail.hidden = YES;
                _dataSource = [CommonManager Manager_getMark];
                [_listView reloadData];
            }
            break;

            
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (_isMark) {
        return 100;
    }
    
    return 45;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_isMark) {
        return _dataSource.count;
    }
    return dataCount;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isMark) {
        [_delegate clickMark:[_dataSource objectAtIndex:indexPath.row]];
        return;
    }
    
    [_delegate clickChapter:indexPath.row];

    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //目录
    if (_isMenu == YES) {
        static NSString *cellStr = @"menuCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            }
        
        //颜色数组
        cell.textLabel.textColor = [WXYClassMethodsViewController colorWithHexString:listarray[indexPath.row]];

        
        NSInteger IndexPathcount;
        if ([CommonManager Manager_getChapterBefore:[[BookInfo siged] getBookID]] > dataCount) {
            
            IndexPathcount= dataCount-2;
            
        }else{
            
            IndexPathcount= [CommonManager Manager_getChapterBefore:[[BookInfo siged] getBookID]];
        }
        
        if (indexPath.row ==IndexPathcount) {
            
            cell.textLabel.textColor = THEMECOLOR;
            
        }
        
        cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:234/255.0 alpha:1.0];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",titleArr[indexPath.row]];
        
        return cell;

    }else{
        
        //书签列表
        static NSString *cellStr = @"markCell";
        
        MarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
         cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:234/255.0 alpha:1.0];
        
        if (cell == nil) {
            
            cell = [[MarkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            
        }
        cell.backgroundColor = [UIColor clearColor];
        
        cell.chapterLbl.text = [NSString stringWithFormat:@"第%@章",[(Mark *)[_dataSource objectAtIndex:indexPath.row] markChapter]];
        
        cell.timeLbl.text    = [(Mark *)[_dataSource objectAtIndex:indexPath.row] markTime];
        
        cell.contentLbl.text = [(Mark *)[_dataSource objectAtIndex:indexPath.row] markContent];
        
        return cell;
    
    }
    
    return nil;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isMark) {
        
        return UITableViewCellEditingStyleDelete;
    }
    
    else
        
    return UITableViewCellEditingStyleNone;
    
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//}

-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"移除书签" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
                NSUInteger row = [indexPath row];
        
                [_dataSource removeObjectAtIndex:row];
        
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_dataSource] forKey:[NSString stringWithFormat:@"%@epubBookName",[[BookInfo siged] getBookID]]];
                
            }];
    
    rowAction.backgroundColor = HighColor;
    NSArray *arr = @[rowAction];
    
    return arr;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

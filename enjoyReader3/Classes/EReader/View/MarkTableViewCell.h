//
//  E_MarkTableViewCell.h
//  WFReader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *chapterLbl; //书签标题
@property (nonatomic,strong) UILabel *timeLbl;   //添加书签时的时间
@property (nonatomic,strong) UILabel *contentLbl;//书签内容

@end

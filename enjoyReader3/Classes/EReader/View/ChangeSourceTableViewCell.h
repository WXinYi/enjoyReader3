//
//  ChangeSourceTableViewCell.h
//  EnjoyReader
//
//  Created by 王馨仪 on 16/6/13.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeSourceTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *SourceName;
@property (strong, nonatomic) IBOutlet UILabel *last_chapter;
@property (strong, nonatomic) IBOutlet UILabel *updated;
@property (strong, nonatomic) IBOutlet UILabel *nowSource;

@end

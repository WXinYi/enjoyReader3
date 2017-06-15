//
//  SystemSetCell.m
//  EnjoyReader
//
//  Created by 王馨仪 on 16/6/15.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "SystemSetCell.h"

@implementation SystemSetCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

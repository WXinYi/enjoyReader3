//
//  E_MarkTableViewCell.m
//  WFReader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "MarkTableViewCell.h"
#import "E_ContantFile.h"

@implementation MarkTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _chapterLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 20)];
        _chapterLbl.textColor = THEMECOLOR;
        _chapterLbl.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_chapterLbl];
        
       
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW*3/4 - 150, 5, 110, 20)];
        _timeLbl.textColor = THEMECOLOR;
        _timeLbl.textAlignment = NSTextAlignmentRight;
        _timeLbl.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLbl];
        
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 28, kScreenW*3/4 - 50, 60)];
        _contentLbl.numberOfLines = 3;
        _contentLbl.font = [UIFont systemFontOfSize:16];
        _contentLbl.textColor = [UIColor blackColor];
        [self.contentView addSubview:_contentLbl];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

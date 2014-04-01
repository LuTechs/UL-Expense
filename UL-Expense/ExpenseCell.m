//
//  ExpenseCell.m
//  UL-Expense
//
//  Created by Leng Ung on 25/02/13.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import "ExpenseCell.h"

@implementation ExpenseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

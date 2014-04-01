//
//  AmountCell.h
//  UL-Expense
//
//  Created by Leng Ung on 28/01/13.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AmountCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *amountTitleLabel;

@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@end

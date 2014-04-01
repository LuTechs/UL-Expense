//
//  ExpenseCell.h
//  UL-Expense
//
//  Created by Leng Ung on 25/02/13.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *amoutLabel;
@property (strong, nonatomic) IBOutlet UILabel *paymentTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *expenseType;

@end

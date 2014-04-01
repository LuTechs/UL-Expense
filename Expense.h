//
//  Expense.h
//  UL-Expense
//
//  Created by Leng Ung on 22/11/2013.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExpenseTotal, ExpenseType, PaymentType;

@interface Expense : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * expenseDescription;
@property (nonatomic, retain) ExpenseType *expenseToExpenseType;
@property (nonatomic, retain) PaymentType *expenseToPaymentType;
@property (nonatomic, retain) ExpenseTotal *expenseToExpenseTotal;

@end

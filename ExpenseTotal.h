//
//  ExpenseTotal.h
//  UL-Expense
//
//  Created by Leng Ung on 22/11/2013.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Expense;

@interface ExpenseTotal : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) NSSet *expenseTotaltoExpense;
@end

@interface ExpenseTotal (CoreDataGeneratedAccessors)

- (void)addExpenseTotaltoExpenseObject:(Expense *)value;
- (void)removeExpenseTotaltoExpenseObject:(Expense *)value;
- (void)addExpenseTotaltoExpense:(NSSet *)values;
- (void)removeExpenseTotaltoExpense:(NSSet *)values;

@end

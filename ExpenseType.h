//
//  ExpenseType.h
//  UL-Expense
//
//  Created by Leng Ung on 22/11/2013.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Expense;

@interface ExpenseType : NSManagedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *expenseTypeToExpense;
@end

@interface ExpenseType (CoreDataGeneratedAccessors)

- (void)addExpenseTypeToExpenseObject:(Expense *)value;
- (void)removeExpenseTypeToExpenseObject:(Expense *)value;
- (void)addExpenseTypeToExpense:(NSSet *)values;
- (void)removeExpenseTypeToExpense:(NSSet *)values;

@end

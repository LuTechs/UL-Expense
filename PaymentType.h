//
//  PaymentType.h
//  UL-Expense
//
//  Created by Leng Ung on 22/11/2013.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Expense;

@interface PaymentType : NSManagedObject

@property (nonatomic, retain) NSString * paymentMethod;
@property (nonatomic, retain) NSSet *paymentTypeToExpense;
@end

@interface PaymentType (CoreDataGeneratedAccessors)

- (void)addPaymentTypeToExpenseObject:(Expense *)value;
- (void)removePaymentTypeToExpenseObject:(Expense *)value;
- (void)addPaymentTypeToExpense:(NSSet *)values;
- (void)removePaymentTypeToExpense:(NSSet *)values;

@end

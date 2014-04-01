//
//  AddTypeofExpenseViewController.h
//  UL-Expense
//
//  Created by Leng Ung on 29/01/13.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpenseType.h"
#import "Util.h"

@protocol AddExpenseDelegate
@required
-(void) addExpenseDidSave:(ExpenseType *) expenseType DidUpdate:(BOOL)status;
@end

@interface AddExpenseViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *typeofExpenseTextField;
@property (weak, nonatomic) IBOutlet UILabel *labelError;
- (IBAction)barButtonSave:(id)sender;
- (IBAction)barButtonCancel:(id)sender;

@property (nonatomic,weak) id delegate;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,strong) ExpenseType *expenseType;
-(BOOL) checkExist;

@end

//
//  TypeofExpenseViewController.h
//  UL-Expense
//
//  Created by Leng Ung on 29/01/13.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpenseType.h"
#import "AddExpenseViewController.h"

@protocol ListExpenseDelegate
  @required
-(void) ListExpenseDidSelected:(ExpenseType *) expenseType;
@end
@interface ListExpenseTableViewController : UIViewController<NSFetchedResultsControllerDelegate, UITableViewDataSource,UITableViewDelegate,AddExpenseDelegate  >{
    BOOL update;
    ExpenseType *lastSelectedExpense;
    
}


@property (nonatomic,strong)NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;


@property (nonatomic,weak) id delegate;

- (IBAction)doneButton:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *expenseTableView;
@property(strong,nonatomic) ExpenseType *expenseType;

@end

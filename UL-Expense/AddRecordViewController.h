//
//  AddRecordViewController.h
//  UL-Expense
//
//  Created by Leng Ung on 28/01/13.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupDatePicker.h"
#import "ListExpenseTableViewController.h"
#import "PaymentTypeViewController.h"
#import "AmountCell.h"
#import "DataCell.h"
#import "DescriptionCell.h"
#import "Expense.h"
#import "ExpenseTotal.h"



@protocol AddRecordDelegate
@required
-(void) AddRecordDidSave: (BOOL)status;
-(void) AddRecordDidCancel:(Expense *)expense Status:(BOOL) status;
@end

@interface AddRecordViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, ListExpenseDelegate>


@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) PopupDatePicker *popupDatePicker;

@property(nonatomic,strong) ExpenseType *expenseType;
@property (nonatomic,strong) PaymentType *paymentType;
@property(nonatomic,strong) Expense *expense;
@property(nonatomic) BOOL status;
@property(nonatomic,weak) id delegate;
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,strong) IBOutlet UITableView *addRecordTableView;
- (IBAction)saveButton:(id)sender;
- (IBAction)cancelButton:(id)sender;

@end

//
//  RecordViewController.h
//  UL-Expense
//
//  Created by Leng Ung on 24/01/13.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddRecordViewController.h"
#import "ExpenseCell.h"
#import "Expense.h"
#import "ExpenseTotal.h"


@interface RecordViewController : UIViewController<AddRecordDelegate,NSFetchedResultsControllerDelegate, UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) IBOutlet UITableView *recordViewTableView;
@property (strong,nonatomic) NSMutableArray *totalEachSection;
@property(strong,nonatomic) Expense *selectedExpense;

@end

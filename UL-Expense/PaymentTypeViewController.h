//
//  PaymentTypeViewController.h
//  UL-Expense
//
//  Created by Leng Ung on 3/02/13.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentType.h"
#import "AddPaymentTypeViewController.h"

@protocol PaymentTypeDelegate
@required
-(void) paymentTypeDidSelected:(PaymentType *) paymentType;
@end

@interface PaymentTypeViewController : UIViewController<NSFetchedResultsControllerDelegate, UITableViewDataSource,UITableViewDelegate,AddPaymentTypeDelegate>{
    BOOL update;
    PaymentType *lastSelectedPayment;
    
}

@property (nonatomic,strong)NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;


@property (nonatomic,weak) id delegate;

- (IBAction)doneButton:(id)sender;

@property(nonatomic,strong)IBOutlet UITableView *paymentTypeTableView;
@property(nonatomic,strong) PaymentType *paymentType;

@end

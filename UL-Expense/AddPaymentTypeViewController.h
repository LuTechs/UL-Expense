//
//  AddPaymentTypeViewController.h
//  UL-Expense
//
//  Created by Leng Ung on 3/02/13.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentType.h"
#import "Util.h"

@protocol AddPaymentTypeDelegate

@required
-(void) addPaymentTypeDidSave:(PaymentType *) paymentType DidUpdate:(BOOL)status;
@end

@interface AddPaymentTypeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *paymentTypeTextField;
@property (weak, nonatomic) IBOutlet UILabel *labelError;
- (IBAction)barButtonCancel:(id)sender;

- (IBAction)barButtonSave:(id)sender;

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,strong) PaymentType *paymentType;
@property (nonatomic,weak) id delegate;

-(BOOL) checkExist;
@end

//
//  AddPaymentTypeViewController.m
//  UL-Expense
//
//  Created by Leng Ung on 3/02/13.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import "AddPaymentTypeViewController.h"

@interface AddPaymentTypeViewController ()

@end

@implementation AddPaymentTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.paymentTypeTextField.text=self.paymentType.paymentMethod;
    self.paymentTypeTextField.delegate=self;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self.labelError setText:@""];
}

- (IBAction)barButtonCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)barButtonSave:(id)sender {
    BOOL status;
    if([self.paymentTypeTextField.text isEqualToString:@""]|| self.paymentTypeTextField.text==nil){
        
        [self.labelError setText:@"Empty Field"];
        return;
    }
    
    if (![self checkExist]) {
        return;
    }
    
    if(self.paymentType==nil){
        _paymentType=[NSEntityDescription insertNewObjectForEntityForName:@"PaymentType" inManagedObjectContext:self.managedObjectContext   ];
        self.paymentType.paymentMethod=self.paymentTypeTextField.text;
        status=NO;
    }else{
        self.paymentType.paymentMethod=self.paymentTypeTextField.text;
        status=YES;
    }
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.delegate  addPaymentTypeDidSave:self.paymentType DidUpdate:status];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL) checkExist{
    if([self paymentType]){
        if ([[self.paymentType paymentMethod] isEqualToString:[self.paymentTypeTextField text]]) {
            return  YES;
        }
    }
    NSPredicate *predicate=[ NSPredicate predicateWithFormat:@"paymentMethod=%@",self.paymentTypeTextField.text];
    PaymentType *pt=(PaymentType *)[Util getObject:@"PaymentType" Predicate:predicate managedObject:self.managedObjectContext];
    if(pt!=nil){
        [self.labelError setText:@"This payment type already exist"];
        return NO;
    }
    [self.labelError setText:@""];
    return YES;
}
@end

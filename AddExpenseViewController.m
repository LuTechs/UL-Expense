//
//  AddTypeofExpenseViewController.m
//  UL-Expense
//
//  Created by Leng Ung on 29/01/13.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import "AddExpenseViewController.h"

@interface AddExpenseViewController ()

@end

@implementation AddExpenseViewController

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
    self.typeofExpenseTextField.text=self.expenseType.type;
    [self.typeofExpenseTextField setDelegate:self];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)barButtonSave:(id)sender {
    
    BOOL status;
    if([self.typeofExpenseTextField.text isEqualToString:@""]|| self.typeofExpenseTextField.text==nil){
        
        [self.labelError setText:@"Empty Field"];
        return;
    }
    
    if (![self checkExist]) {
        return;
    }
    
    if(self.expenseType==nil){
        _expenseType=[NSEntityDescription insertNewObjectForEntityForName:@"ExpenseType" inManagedObjectContext:self.managedObjectContext   ];
        self.expenseType.type=self.typeofExpenseTextField.text;
        status=NO;
    }else{
        self.expenseType.type=self.typeofExpenseTextField.text;
        status=YES;
    }
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.delegate addExpenseDidSave:self.expenseType DidUpdate:status];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)barButtonCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self.labelError setText:@""];
}

-(BOOL) checkExist{
    if([self expenseType]){
        if ([[self.expenseType type] isEqualToString:[self.typeofExpenseTextField text]]) {
            return  YES;
        }
    }
    NSPredicate *predicate=[ NSPredicate predicateWithFormat:@"type=%@",self.typeofExpenseTextField.text];
    ExpenseType *et=(ExpenseType *)[Util getObject:@"ExpenseType" Predicate:predicate managedObject:self.managedObjectContext];
    if(et!=nil){
        [self.labelError setText:@"This expense type already exist"];
        return NO;
    }
    [self.labelError setText:@""];
    return YES;
}
@end

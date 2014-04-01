//
//  SettingViewController.m
//  UL-Expense
//
//  Created by Leng Ung on 22/11/2013.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import "SettingViewController.h"
#import "Expense.h"
#import "ExpenseTotal.h"
#import "ExpenseType.h"
#import "PaymentType.h"
#import "AFHTTPRequestOperationManager.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

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
    [self.indicatorBacktup setHidden:YES];
    [self.indicatorRestore setHidden:YES];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)buttonBackup:(id)sender {
    [self.indicatorBacktup setHidden:NO];
    [self.indicatorBacktup startAnimating];
    [self backupToServer];
    
}

- (IBAction)buttonRestore:(id)sender {
    [self.indicatorRestore setHidden:NO];
    [self.indicatorRestore startAnimating];
    [self deleteAllObjects:@"ExpenseType"];
    [self deleteAllObjects:@"PaymentType"];
    [self deleteAllObjects:@"ExpenseTotal"];
    [self deleteAllObjects:@"Expense"];
    [self restore];
}

#pragma mark backupToServer
-(void) backupToServer{
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Expense"];
    
    NSError *error = nil;
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    NSMutableArray *js=[[NSMutableArray alloc]init];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (error == nil) {
        for (id object in results) {
            Expense * e=(Expense*) object;
            NSMutableDictionary *d=[[NSMutableDictionary alloc]init];
            [d setObject:e.amount forKey:@"amount"];
            [d setObject:e.expenseToExpenseType.type forKey:@"type"];
            [d setObject:e.expenseToPaymentType.paymentMethod forKey:@"paymentmethod"];
            [d setObject: e.expenseDescription forKey:@"description"];
            [d setObject:[dateFormatter stringFromDate: e.date] forKey:@"date"];
            [d setObject:e.expenseToExpenseTotal.total forKey:@"total"];
            [js addObject:d];
            d=nil;
        }
    }
    
    NSError *jsonError = nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:js options:0 error:&jsonError];
    if (jsonError!=nil) {
        NSLog(@"JSON error: %@", error);
    } else {
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        // NSLog(@"JSON OUTPUT: %@",JSONString);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *params = [NSDictionary dictionaryWithObject:JSONString forKey:@"json"];
        [manager POST:@"http://virakin.com/ul-soft/json.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //            NSLog(@"JSON: %@", responseObject);
            [self.indicatorBacktup stopAnimating];
            [self.indicatorBacktup setHidden:YES];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Backup Sucessful" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil ];
            [alert show];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
        }];}
}


#pragma mark Delete All Object

- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
    	[_managedObjectContext deleteObject:managedObject];
    	//NSLog(@"%@ object deleted",entityDescription);
    }
    if (![_managedObjectContext save:&error]) {
    	NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}

#pragma mark Get Object
-(NSManagedObject *) getObject:(NSString *) entityName Predicate:(NSPredicate *) predicate{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"%@",error);
    }
    if ([fetchedObjects count]==0) {
        
        return  nil;
    }
    return fetchedObjects[0];
}
#pragma mark Insert Object
-(NSManagedObject  *) insertObject:(NSString *) entityName value:(NSString *) value forKey:(NSString *)key{
    
    NSManagedObject *object=[NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [object setValue:value forKey:key ];
    
    NSError *error=nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error! %@", error);
    }
    return object;
}
#pragma mark save object
-(void) saveObject:(id) object{
    
    NSString *pString=[NSString stringWithFormat:@"type==[c]'%@'",(NSString *)[object valueForKey:@"type"]];
    NSPredicate *predicate=[ NSPredicate predicateWithFormat:pString];
    ExpenseType *et=(ExpenseType *)[self getObject:@"ExpenseType" Predicate:predicate];
    if (et==nil) {
        et=(ExpenseType *)[self insertObject:@"ExpenseType" value:[object valueForKey:@"type"] forKey:@"type"];
    }
    
    NSString *pString2=[NSString stringWithFormat:@"paymentMethod==[c]'%@'",[object valueForKey:@"paymentmethod"]];
    NSPredicate *predicatePayment=[NSPredicate predicateWithFormat:pString2];
    PaymentType *pt=(PaymentType *) [self getObject:@"PaymentType" Predicate:predicatePayment];
    if (pt==nil) {
        pt=(PaymentType *)[self insertObject:@"PaymentType" value:[object valueForKey:@"paymentmethod"] forKey:@"paymentMethod"];
    }
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[dateFormatter dateFromString:[object valueForKey:@"date"]];
    NSPredicate *predicateTotal=[ NSPredicate predicateWithFormat:@"date=%@",d];
    ExpenseTotal *expenseTotal=(ExpenseTotal *)[self getObject:@"ExpenseTotal" Predicate:predicateTotal];
    if (expenseTotal==nil) {
        expenseTotal=[NSEntityDescription insertNewObjectForEntityForName:@"ExpenseTotal"inManagedObjectContext:self.managedObjectContext];
        [expenseTotal setDate:d];
        [expenseTotal setTotal: [object valueForKey:@"total"]];
        NSError *error=nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Error! %@", error);
        }
    }

    Expense *e=[NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:self.managedObjectContext];
    [e setDate:d];
    [e setAmount:[object valueForKey:@"amount"]];
    [e setExpenseDescription:[object valueForKey:@"description"]];
    [e setExpenseToExpenseType:et];
    [e setExpenseToPaymentType:pt];
    [e setExpenseToExpenseTotal:expenseTotal];
    NSError *error=nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error! %@", error);
    }
    
}
#pragma mark restore

-(void) restore{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://virakin.com/ul-soft/data.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"JSON: %@", responseObject);
        
        NSArray *jsonArray = (NSArray *) responseObject;
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        for (id object in jsonArray) {
            [self saveObject:object];
        }
        [self.indicatorRestore stopAnimating];
        [self.indicatorRestore setHidden:YES];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Restore Sucessful" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil ];
        [alert show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}



@end

//
//  AddRecordViewController.m
//  UL-Expense
//
//  Created by Leng Ung on 28/01/13.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import "AddRecordViewController.h"



@interface AddRecordViewController ()

@end

@implementation AddRecordViewController

@synthesize  popupDatePicker=_popupDatePicker;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize expenseType=_expenseType;
@synthesize paymentType=_paymentType;
@synthesize expense=_expense;
@synthesize addRecordTableView=_addRecordTableView;
@synthesize status=_status;
@synthesize date=_date;

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
    _popupDatePicker=[[PopupDatePicker alloc]init];
    _popupDatePicker.delegate=self;
    
//    TypeofExpenseViewController *typeofExpenseViewController=[[TypeofExpenseViewController alloc]init];
//    [typeofExpenseViewController setManagedObjectContext:self.managedObjectContext];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *c=nil;
    switch ([indexPath row]) {
        case 0:
        {
            AmountCell *cell=(AmountCell *)[tableView dequeueReusableCellWithIdentifier:@"AmountCell" forIndexPath:indexPath];
            if (!cell) {
                cell = [[AmountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AmountCell"];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            if(self.status){
                cell.amountTextField.text=[_expense.amount stringValue];
            }
            return  cell;
        }
            break;
     
        case 1:{
            DataCell *cell=(DataCell *) [tableView dequeueReusableCellWithIdentifier:@"CustomDataCell" forIndexPath:indexPath];
            if(!cell){
                cell=[[DataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomDataCell"];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.titleLabel.text=@"Expense Type";
            if(self.status){
                cell.valueLabel.text=_expenseType.type;
            }else{
                cell.valueLabel.text=@"Other";
            }
            return  cell;

        }
            break;
        case 2:{
            DataCell *cell=(DataCell *) [tableView dequeueReusableCellWithIdentifier:@"CustomDataCell" forIndexPath:indexPath];
            if(!cell){
                cell=[[DataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomDataCell"];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.titleLabel.text=@"Payment Type";
            if(self.status){
                cell.valueLabel.text=_paymentType.paymentMethod;
            }else{
                cell.valueLabel.text=@"Other";
            }
            return  cell;

        }
            break;
        case 3:{
            DataCell *cell=(DataCell *) [tableView dequeueReusableCellWithIdentifier:@"CustomDataCell" forIndexPath:indexPath];
            if(!cell){
                cell=[[DataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomDataCell"];
            }
            cell.titleLabel.text=@"Date";
            NSDate *date=nil;
            if(self.status){
                date=_expense.date;
            }else{
                date=[NSDate date];
            }
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"dd-MMM-YYYY"];
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.valueLabel.text=[dateFormatter stringFromDate:date];
            

            return  cell;

        }
            break;
            
        case 4:{
            DescriptionCell *cell=(DescriptionCell *) [tableView dequeueReusableCellWithIdentifier:@"DescriptionCell" forIndexPath:indexPath];
            if(!cell){
                cell=[[DescriptionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DescriptionCell"];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            if(self.status){
                cell.descriptionTextField.text=_expense.expenseDescription;
            }
            
            return  cell;

        }
            break;
    }
    return c;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if([indexPath row]==3){
     
        [self.popupDatePicker showFromView:self.view];
    }
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    if([indexPath row]==1){
        
        if(_expenseType==nil){
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            // Edit the entity name as appropriate.
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExpenseType" inManagedObjectContext:self.managedObjectContext];
            [fetchRequest setEntity:entity];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type== [c]'Other'"];
            [fetchRequest setPredicate:predicate];
            
            NSError *error = nil;
            NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            if (fetchedObjects == nil) {
                NSLog(@"%@",error);
            }
            
            if([fetchedObjects count]==0){
                _expenseType=(ExpenseType *)[NSEntityDescription insertNewObjectForEntityForName:@"ExpenseType" inManagedObjectContext:self.managedObjectContext];
                _expenseType.type=@"Other";
                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"Error! %@", error);
                }
                
            }else{
                _expenseType=(ExpenseType *)fetchedObjects[0];
                
            }
        }
        [self performSegueWithIdentifier:@"SelectExpense" sender:self];
    }
    else if([indexPath row]==2){
        if(_paymentType==nil){
        
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            // Edit the entity name as appropriate.
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"PaymentType" inManagedObjectContext:self.managedObjectContext];
            [fetchRequest setEntity:entity];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"paymentMethod== [c]'Other'"];
            [fetchRequest setPredicate:predicate];
            
            NSError *error = nil;
            NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            if (fetchedObjects == nil) {
                NSLog(@"%@",error);
            }
            
            if([fetchedObjects count]==0){
                _paymentType=(PaymentType *)[NSEntityDescription insertNewObjectForEntityForName:@"PaymentType" inManagedObjectContext:self.managedObjectContext];
               _paymentType.paymentMethod=@"Other";
                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"Error! %@", error);
                }
                
            }else{
                _paymentType=(PaymentType *)fetchedObjects[0];
                
            }
        }
        [self performSegueWithIdentifier:@"SelectPayment" sender:self];

    
    }
    
}


#pragma mark popupDatePickerDidSelectDate Delegate

- (void)popupDatePickerDidSelectedDate:(NSDate *)date{
    [self.popupDatePicker hide];
    NSIndexPath *indexpath=[NSIndexPath indexPathForItem:3 inSection:0];
    DataCell *cell=(DataCell *)[self.addRecordTableView cellForRowAtIndexPath:indexpath];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc ]init];
    [dateFormatter setDateFormat:@"dd MMM YYYY"];
    _date=date;
    cell.valueLabel.text=[dateFormatter stringFromDate:date];
    
  
}


#pragma mark typeOfExpenseDidSelected Delegate

-(void) ListExpenseDidSelected:(ExpenseType *) expenseType{
    _expenseType=expenseType;
    NSIndexPath *indexpath=[NSIndexPath indexPathForItem:1 inSection:0];
    DataCell *cell=(DataCell *)[self.addRecordTableView cellForRowAtIndexPath:indexpath];
    if(_expenseType==nil){
        cell.valueLabel.text=@"Other";
    }else{
        cell.valueLabel.text=_expenseType.type;
        }
    [self dismissViewControllerAnimated:YES completion:nil];
    
   
}

#pragma mark paymentTypeDidSelected
-(void) paymentTypeDidSelected:(PaymentType *) paymentType{

    _paymentType=paymentType;
    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:2 inSection:0];
    DataCell *cell=(DataCell *)[self.addRecordTableView cellForRowAtIndexPath:indexPath];
    if(_paymentType==nil){
        cell.valueLabel.text=@"Other";
    }else{
        cell.valueLabel.text=_paymentType.paymentMethod;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Segue
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"SelectExpense"]) {
        
        ListExpenseTableViewController *tevc=(ListExpenseTableViewController *) [segue destinationViewController];
        tevc.delegate=self;
        [tevc setManagedObjectContext:self.managedObjectContext];
        [tevc setExpenseType:_expenseType];
        
    }
    else if ([[segue identifier]isEqualToString:@"SelectPayment"]){
    
        PaymentTypeViewController *pt=(PaymentTypeViewController *)[segue destinationViewController];
        pt.delegate=self;
        [pt setManagedObjectContext:self.managedObjectContext];
        [pt setPaymentType:_paymentType];
        
        
    }
    
}

#pragma mark Button Action

- (IBAction)saveButton:(id)sender {
   
    AmountCell *amountCell=(AmountCell *)[_addRecordTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    if ([amountCell.amountTextField.text isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"You must enter expense amount" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if(self.status){
        [self updateRecord];
    }else{
    
        [self saveRecord];
    }
    
    
    [self.delegate AddRecordDidSave:self.status];

    
}
-(void) saveRecord{
    AmountCell *amountCell=(AmountCell *)[_addRecordTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    
    DescriptionCell *descriptionCell=(DescriptionCell *)[_addRecordTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:0]];
    NSNumberFormatter *numberFormatter=[[NSNumberFormatter alloc]init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    if(_expenseType==nil){
        NSPredicate *predicate=[ NSPredicate predicateWithFormat:@"type==[c]'other'"];
        _expenseType=(ExpenseType *)[self getObject:@"ExpenseType" Predicate:predicate];
    }
    
    if(_paymentType==nil){
        NSPredicate *predicate=[ NSPredicate predicateWithFormat:@"paymentMethod==[c]'other'"];
        _paymentType=(PaymentType *) [self getObject:@"PaymentType" Predicate:predicate];
    }
    
    _expense.amount=[numberFormatter numberFromString:amountCell.amountTextField.text];
    
    if(_date==nil){
        
        NSDate *now=[NSDate date];
        _date=now;
    }
    
    /*NSTimeInterval oldInterval = [ _date timeIntervalSinceReferenceDate];
    double secondsSinceMidnight = fmod(oldInterval,86400.0);
    _date = [NSDate dateWithTimeIntervalSinceReferenceDate:(oldInterval - secondsSinceMidnight)];
    _expense.date=_date;
     */
   // NSDate *date = [NSDate date];
    NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *parts = [[NSCalendar currentCalendar] components:componentFlags fromDate:_date];
    NSDateComponents *midnightComponents = [[NSDateComponents alloc] init];
    [midnightComponents setDay:[parts day]];
    [midnightComponents setMonth:[parts month]];
    [midnightComponents setYear:[parts year]];
    NSCalendar *cal = [NSCalendar currentCalendar];
    _date = [cal dateFromComponents:midnightComponents];
    _expense.date=_date;
                       
    
    _expense.expenseDescription=descriptionCell.descriptionTextField.text;
    
    _expense.expenseToExpenseType=_expenseType;
    _expense.expenseToPaymentType=_paymentType;
    
  
    _expense.expenseToExpenseTotal=(ExpenseTotal    *)[self updateExpenseTotal:@0.0];


}

-(void) updateRecord{
    AmountCell *amountCell=(AmountCell *)[_addRecordTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    DescriptionCell *descriptionCell=(DescriptionCell *)[_addRecordTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:0]];
    NSNumberFormatter *numberFormatter=[[NSNumberFormatter alloc]init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    _expense.expenseDescription=descriptionCell.descriptionTextField.text;
    _expense.expenseToExpenseType=_expenseType;
    _expense.expenseToPaymentType=_paymentType;
    /*
    NSTimeInterval oldInterval = [ _date timeIntervalSinceReferenceDate];
    double secondsSinceMidnight = fmod(oldInterval,86400.0);
    _date = [NSDate dateWithTimeIntervalSinceReferenceDate:(oldInterval - secondsSinceMidnight)];
     */
    
   // NSDate *date = [NSDate date];
    // Setup Time 00:00:00
    NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *parts = [[NSCalendar currentCalendar] components:componentFlags fromDate:_date];
    NSDateComponents *midnightComponents = [[NSDateComponents alloc] init];
    [midnightComponents setDay:[parts day]];
    [midnightComponents setMonth:[parts month]];
    [midnightComponents setYear:[parts year]];
    NSCalendar *cal = [NSCalendar currentCalendar];
    _date = [cal dateFromComponents:midnightComponents];
    
    NSNumber *oldValue=_expense.amount;

    if (![_date isEqualToDate:_expense.date]) {
        NSPredicate *predicate=[ NSPredicate predicateWithFormat:@"date=%@",_expense.date];
        ExpenseTotal *expenseTotal=(ExpenseTotal *)[self getObject:@"ExpenseTotal" Predicate:predicate];
        NSNumber *total=@([expenseTotal.total floatValue]-[_expense.amount floatValue]) ;
        expenseTotal.total=total;
    
        
        _expense.amount=[numberFormatter numberFromString:amountCell.amountTextField.text];
        _expense.expenseToExpenseTotal=(ExpenseTotal *) [self updateExpenseTotal:oldValue];
        
    }else{
        
        _expense.amount=[numberFormatter numberFromString:amountCell.amountTextField.text];
        _expense.expenseToExpenseTotal=(ExpenseTotal *)[self updateExpenseTotal:oldValue];
    }
    _expense.date=_date;
    

}


- (IBAction)cancelButton:(id)sender {
    [self.delegate AddRecordDidCancel:_expense Status:self.status];
    
}

-(void) textFieldDidBeginEditing:(UITextField *)textFieldView {
    [textFieldView selectAll:self];
        _addRecordTableView.contentInset =  UIEdgeInsetsMake(0, 0, 220, 0);
        [self.addRecordTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]atScrollPosition:UITableViewScrollPositionTop  animated:YES];
    
}

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
        
        if([entityName isEqualToString:@"ExpenseType"] ){
            return [self insertObject:@"ExpenseType" value:@"Other" forKey:@"type"];
            
            
        }else if ([entityName   isEqualToString:@"PaymentType"]){
            return [self insertObject:@"PaymentType" value:@"Other" forKey:@"paymentMethod"];
        }else{
            return nil;
        }
    }
    return fetchedObjects[0];
}
-(NSManagedObject  *) insertObject:(NSString *) entityName value:(NSString *) value forKey:(NSString *)key{

        NSManagedObject *object=[NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [object setValue:value forKey:key ];
    
        NSError *error=nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Error! %@", error);
        }
    return object;
}
-(NSManagedObject *) updateExpenseTotal:(NSNumber *) oldValue{
    NSPredicate *predicate=[ NSPredicate predicateWithFormat:@"date=%@",_date];
    ExpenseTotal *expenseTotal=(ExpenseTotal *)[self getObject:@"ExpenseTotal" Predicate:predicate];
    
    if(expenseTotal==nil){
        expenseTotal=[NSEntityDescription   insertNewObjectForEntityForName:@"ExpenseTotal" inManagedObjectContext:self.managedObjectContext];
        expenseTotal.date=_date;
        expenseTotal.total=_expense.amount;
    }else{
        NSNumber *total=@([expenseTotal.total floatValue]+[_expense.amount floatValue]-[oldValue floatValue ]) ;
        expenseTotal.date=_date;
        expenseTotal.total=total;
    }
    
    return expenseTotal;
}
@end

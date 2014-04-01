//
//  RecordViewController.m
//  UL-Expense
//
//  Created by Leng Ung on 24/01/13.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()
@end

@implementation RecordViewController

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

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Segue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"AddRecord"]) {
        
        
        AddRecordViewController *arvc=(AddRecordViewController *)[segue destinationViewController];
        [arvc setManagedObjectContext:self.managedObjectContext];
        arvc.delegate=self;
        Expense *expense=(Expense *)[NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:self.managedObjectContext];
        arvc.expense=expense;
    }else if([[segue identifier]isEqualToString:@"SelectRecord"]) {
        AddRecordViewController  *arvc=(AddRecordViewController *)[segue destinationViewController ];
        [arvc setManagedObjectContext:self.managedObjectContext];
        arvc.delegate=self;
        arvc.expense=_selectedExpense;
        arvc.expenseType=_selectedExpense.expenseToExpenseType;
        arvc.paymentType=_selectedExpense.expenseToPaymentType;
        arvc.date=_selectedExpense.date;
        arvc.status=YES;
        
    }
}

#pragma mark AddRecordDelegate
-(void) AddRecordDidSave:(BOOL)status{
    
    
    NSError *error = nil;
    NSManagedObjectContext *context = self.managedObjectContext;
    if (![context save:&error]) {
        NSLog(@"Error! %@", error);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) AddRecordDidCancel:(Expense *)expense Status:(BOOL)status{
    if(!status){
        NSManagedObjectContext *context = self.managedObjectContext;
        [context deleteObject:expense];
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpenseCell" forIndexPath:indexPath];
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExpenseCell"];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [self updateExpenseTotal:indexPath];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    _selectedExpense=[self.fetchedResultsController  objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"SelectRecord" sender:self];
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)] ;
    
    NSString *dateString=[[self.fetchedResultsController sections][section] name];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZ"];
    NSDate *date = [formatter dateFromString:dateString];
    
    [formatter setDateFormat:@"d MMMM yyyy"];
    NSString *formattedDateStr = [formatter stringFromDate:date];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.frame = CGRectMake(10,5,200,20);
    headerLabel.text = formattedDateStr;
   
    headerLabel.textColor = [UIColor whiteColor];
    
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    totalLabel.backgroundColor = [UIColor clearColor];
    totalLabel.textColor = [UIColor blueColor];
    
    NSPredicate *predicate=[ NSPredicate predicateWithFormat:@"date=%@",date];
    ExpenseTotal *expenseTotal=(ExpenseTotal *)[self getObject:@"ExpenseTotal" Predicate:predicate];
    
    totalLabel.text = [ NSString stringWithFormat:@" %@ $",expenseTotal.total];
    totalLabel.font = [UIFont systemFontOfSize:18];
    totalLabel.frame = CGRectMake(230,5,230,20);
    
    [headerView setBackgroundColor:[UIColor grayColor]];
    [headerView addSubview:headerLabel];
    [headerView addSubview:totalLabel];
    
    return  headerView;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Expense *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    ExpenseCell *expenseCell=(ExpenseCell *) cell;
    expenseCell.expenseType.text= object.expenseToExpenseType.type;
    expenseCell.amoutLabel.text=[ NSString stringWithFormat:@"%@ $",object.amount];
    expenseCell.paymentTypeLabel.text=object.expenseToPaymentType.paymentMethod;
    
 

}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expense" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                                   ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"date" cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
	
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.recordViewTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.recordViewTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
     
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.recordViewTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
           
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.recordViewTableView;
   
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
           
            [tableView reloadData];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            [tableView reloadData];
            break;
            
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];
          
            break;
    }
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.recordViewTableView endUpdates];
    
}

-(void) updateExpenseTotal:(NSIndexPath *)indexPath{
    Expense *expense=(Expense *)[_fetchedResultsController objectAtIndexPath:indexPath];
    
    NSPredicate *predicate=[ NSPredicate predicateWithFormat:@"date=%@",expense.date];
    ExpenseTotal *expenseTotal=(ExpenseTotal *)[self getObject:@"ExpenseTotal" Predicate:predicate];
    NSNumber *total=@([expenseTotal.total floatValue]-[expense.amount floatValue]) ;
    if([total floatValue]<=0){
        [self.managedObjectContext deleteObject:expenseTotal];
    }else{
        expenseTotal.total=total;
        }
    NSError *error;
    if(![self.managedObjectContext save:&error]){
        NSLog(@"%@",error);
    }
    
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
  
    return fetchedObjects[0];
}


@end

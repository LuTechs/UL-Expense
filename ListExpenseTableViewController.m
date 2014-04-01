//
//  TypeofExpenseViewController.m
//  UL-Expense
//
//  Created by Leng Ung on 29/01/13.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import "ListExpenseTableViewController.h"

@interface ListExpenseTableViewController ()

@end

@implementation ListExpenseTableViewController

@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize expenseType=_expenseType;


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
	// Do any additional setup after loading the view
    
}
-(void) viewDidAppear:(BOOL)animated{
    
    
    [self markedUnmarked:self.expenseType];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataCell" forIndexPath:indexPath];
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DataCell"];
    }
    
    ExpenseType *expenseType =(ExpenseType *) [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text=expenseType.type;
    UIFont *myFont = [ UIFont fontWithName: @"System" size: 17.0 ];
    cell.textLabel.font=myFont;
    
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

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    _expenseType=(ExpenseType *)[self.fetchedResultsController objectAtIndexPath:indexPath  ];
    update=YES;
    [self performSegueWithIdentifier:@"AddExpenseType" sender:self];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpenseType *e=(ExpenseType *)[self.fetchedResultsController objectAtIndexPath:indexPath ];
    [self markedUnmarked:e];
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"type"] description];
}



#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExpenseType" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"type"
                                                                   ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
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
    [self.expenseTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.expenseTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.expenseTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.expenseTableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.expenseTableView endUpdates];
  
}




#pragma mark Segue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{


    if([segue.identifier isEqualToString:@"AddExpenseType"]){
        AddExpenseViewController *aevc=(AddExpenseViewController *)[segue destinationViewController];
        if(!update){
            _expenseType=nil;
        }else{
            update=NO;
        }
        aevc.delegate=self;
        [aevc setManagedObjectContext:self.managedObjectContext ];
        [aevc setExpenseType:self.expenseType];
        
    }


}


#pragma mark addExpenseDidsave:DidUpdate Delegate

-(void) addExpenseDidSave:(ExpenseType *)expenseType DidUpdate:(BOOL)status{
        _expenseType=expenseType;
    [self markedUnmarked:self.expenseType];
    
}


-(void) markedUnmarked:(ExpenseType *) expense{
    
    if(expense==nil)return;
    
    if (lastSelectedExpense!=nil) {
        NSIndexPath *lastSelectedIndex=[self.fetchedResultsController indexPathForObject:lastSelectedExpense ];
        UITableViewCell *lastSelectedCell=[self.expenseTableView cellForRowAtIndexPath:lastSelectedIndex];
        NSManagedObject *lastSelectedobject=[self.fetchedResultsController objectAtIndexPath:lastSelectedIndex];
        lastSelectedCell.textLabel.text =[NSString stringWithFormat:@"   %@",[lastSelectedobject valueForKey:@"type"]];
    }
    
    lastSelectedExpense=expense;
    NSIndexPath *indexPath=[self.fetchedResultsController   indexPathForObject:expense];
    NSManagedObject *object=[self.fetchedResultsController objectAtIndexPath:indexPath];
    UITableViewCell *cell=[self.expenseTableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text =[NSString stringWithFormat:@"\u2713 %@",[object valueForKey:@"type"]];
    _expenseType=(ExpenseType *)object;
    
    
}

- (IBAction)doneButton:(id)sender {
    
    [self.delegate ListExpenseDidSelected:self.expenseType ];
}
@end

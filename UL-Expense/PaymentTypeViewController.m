//
//  PaymentTypeViewController.m
//  UL-Expense
//
//  Created by Leng Ung on 3/02/13.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import "PaymentTypeViewController.h"

@interface PaymentTypeViewController ()

@end

@implementation PaymentTypeViewController
@synthesize paymentType=_paymentType;
@synthesize fetchedResultsController=_fetchedResultsController;

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

-(void) viewDidAppear:(BOOL)animated{
    [self markedUnmarked:self.paymentType];
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
    
    PaymentType *paymentType=(PaymentType *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text=paymentType.paymentMethod;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaymentType *p=(PaymentType *)[self.fetchedResultsController objectAtIndexPath:indexPath ];
    [self markedUnmarked:p];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    _paymentType=(PaymentType *)[self.fetchedResultsController objectAtIndexPath:indexPath  ];
    update=YES;
    [self performSegueWithIdentifier:@"AddPaymentType" sender:self];
    
}
#pragma mark -Configure Cell Method;
-(void) configureCell:(UITableViewCell *) cell atIndexPath:(NSIndexPath *) indexPath{
    
    NSManagedObjectContext *object=[self.fetchedResultsController   objectAtIndexPath:indexPath ];
    cell.textLabel.text =[NSString stringWithFormat:@"   %@",[object valueForKey:@"paymentMethod"]];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PaymentType" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"paymentMethod" ascending:YES];
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
    [self.paymentTypeTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.paymentTypeTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.paymentTypeTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.paymentTypeTableView;
    
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
    [self.paymentTypeTableView endUpdates];
    
}





#pragma mark Segue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"AddPaymentType"]){
        AddPaymentTypeViewController  *apvc=(AddPaymentTypeViewController *)[segue destinationViewController];
        if(!update){
            _paymentType=nil;
        }else{
            update=NO;
        }
        apvc.delegate=self;
        [apvc setManagedObjectContext:self.managedObjectContext ];
        [apvc setPaymentType:self.paymentType];
        
    }
    
    
}

#pragma mark addTypeofExpenseDidsave:DidUpdate Delegate

-(void)addPaymentTypeDidSave:(PaymentType *)paymentType DidUpdate:(BOOL)status{
    
    _paymentType=paymentType;
    [self markedUnmarked:self.paymentType];
    
    
}
#pragma markedUnmarked
-(void) markedUnmarked:(PaymentType *) payment{
    
    if(payment==nil)return;
    
    if (lastSelectedPayment!=nil) {
        NSIndexPath *lastSelectedIndex=[self.fetchedResultsController indexPathForObject:lastSelectedPayment ];
        UITableViewCell *lastSelectedCell=[self.paymentTypeTableView cellForRowAtIndexPath:lastSelectedIndex];
        NSManagedObject *lastSelectedobject=[self.fetchedResultsController objectAtIndexPath:lastSelectedIndex];
        lastSelectedCell.textLabel.text =[NSString stringWithFormat:@"   %@",[lastSelectedobject valueForKey:@"paymentMethod"]];
    }
    
    lastSelectedPayment=payment;
    NSIndexPath *indexPath=[self.fetchedResultsController   indexPathForObject:payment];
    NSManagedObject *object=[self.fetchedResultsController objectAtIndexPath:indexPath];
    UITableViewCell *cell=[self.paymentTypeTableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text =[NSString stringWithFormat:@"\u2713 %@",[object valueForKey:@"paymentMethod"]];
    _paymentType=(PaymentType *)object;
    
    
}

- (IBAction)doneButton:(id)sender {
    
    [self.delegate paymentTypeDidSelected:_paymentType ];
}



@end

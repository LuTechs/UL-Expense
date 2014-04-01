//
//  Util.m
//  UL-Expense
//
//  Created by LENG UNG on 28/03/13.
//  Copyright (c) 2013 LENG UNG. All rights reserved.
//

#import "Util.h"

@implementation Util

+(NSManagedObject *) getObject:(NSString *) entityName Predicate:(NSPredicate *) predicate managedObject:(NSManagedObjectContext *)managedObject{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObject];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObject executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"%@",error);
        return nil;
    }
    if([ fetchedObjects count]<=0){
        return nil;
    }
    return [fetchedObjects objectAtIndex:0];
}
@end

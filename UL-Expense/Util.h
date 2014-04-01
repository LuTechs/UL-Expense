//
//  Util.h
//  UL-Expense
//
//  Created by LENG UNG on 28/03/13.
//  Copyright (c) 2013 LENG UNG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+(NSManagedObject *) getObject:(NSString *) entityName Predicate:(NSPredicate *) predicate managedObject:(NSManagedObjectContext *)managedObject;
@end

//
//  AGTBaseManagedObject.h
//  HackerBooksPro
//
//  Created by Fernando Rodríguez Romero on 24/04/15.
//  Copyright (c) 2015 Agbo. All rights reserved.
//

@import CoreData;

@interface AGTBaseManagedObject : NSManagedObject

// All Mogenerated classes have this thingy
+ (NSString*)entityName;

/**
 Creates a unique object for a single property. This is going to cause a 
 bunch of fetches, so be careful
 */
+(id)uniqueObjectWithValue:(id)value
                    forKey:(NSString *)key
    inManagedObjectContext:(NSManagedObjectContext *)context;

@end

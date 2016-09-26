//
//  AGTBaseManagedObject.m
//  HackerBooksPro
//
//  Created by Fernando Rodríguez Romero on 24/04/15.
//  Copyright (c) 2015 Agbo. All rights reserved.
//

#import "AGTBaseManagedObject.h"
#import "Tag.h"

@implementation AGTBaseManagedObject

+(id)uniqueObjectWithValue:(id)value
                    forKey:(NSString *)key
    inManagedObjectContext:(NSManagedObjectContext *)context{
    
    // Nos aseguramos que el contexto no sea nil para evitar errores
    // chorras
    NSParameterAssert(context);

    // Buscamos un objeto que tenga el valor único para la propiedad
    // especificada
    NSFetchRequest *req = [NSFetchRequest
                           fetchRequestWithEntityName:[self entityName]];
    
    req.predicate = [NSPredicate predicateWithFormat:
                     [key stringByAppendingString:@" == %@"], value];
    req.fetchLimit = 1;
    
    // Hacemos la búsqueda
    NSError *err;
    NSArray *objs = [context executeFetchRequest:req
                                           error:&err];
    
    if (!objs) {
        // error
        NSLog(@"Error searching for %@s with a key = %@ and value = %@\n\n%@\n%@",
              [self entityName], key, value, err, err.userInfo );
        return nil;
    }
    
    NSManagedObject * obj = [objs lastObject];
    if (!obj) {
        // No habia nada y hay que crear
        obj = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                            inManagedObjectContext:context];
        [obj setValue:value
               forKey:key];
    }

    return obj;
}

+ (NSString*)entityName{
    [NSException raise:@"SubClassResponsability" format:@"This method souldbe implemented by some subclass, not %@", [self class]];
    return nil;
}

@end

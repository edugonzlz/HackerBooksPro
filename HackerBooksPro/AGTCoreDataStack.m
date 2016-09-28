//
//  AGTCoreDataStack.m
//
//  Created by Fernando Rodríguez Romero on 1/24/13.
//  Copyright (c) 2013 Agbo. All rights reserved.
//

@import CoreData;

#import "AGTCoreDataStack.h"


@interface AGTCoreDataStack ()
@property (strong, nonatomic, readonly) NSManagedObjectModel *model;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *storeCoordinator;
@property (strong, nonatomic) NSURL *modelURL;
@property (strong, nonatomic) NSURL *dbURL;
@property (strong, nonatomic) NSManagedObjectContext *persistingContext;
@property (strong, nonatomic) NSManagedObjectContext *backgroundContext;

@end

@implementation AGTCoreDataStack


#pragma mark -  Properties
// When using a readonly property with a custom getter, auto-synthesize
// is disabled.
// See http://www.cocoaosx.com/2012/12/04/auto-synthesize-property-reglas-excepciones/
// (in Spanish)
@synthesize model=_model;
@synthesize storeCoordinator=_storeCoordinator;
@synthesize context=_context;









#pragma mark - Class Methods
// Returns the URL to the application's Documents directory.
+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+(AGTCoreDataStack *) coreDataStackWithModelName:(NSString *)aModelName
                               databaseFilename:(NSString*) aDBName{
    
    NSURL *url = nil;
    
    if (aDBName) {
        url = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:aDBName];
    }else{
        url = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:aModelName];
    }
    
    return [self coreDataStackWithModelName:aModelName
                                databaseURL:url];
}

+(AGTCoreDataStack *) coreDataStackWithModelName:(NSString *)aModelName{
    
    return [self coreDataStackWithModelName:aModelName
                           databaseFilename:nil];
}

+(AGTCoreDataStack *) coreDataStackWithModelName:(NSString *)aModelName
                                    databaseURL:(NSURL*) aDBURL{
    return [[self alloc] initWithModelName: aModelName databaseURL:aDBURL];
    
}

#pragma mark - Init

-(id) initWithModelName:(NSString *)aModelName
            databaseURL:(NSURL*) aDBURL{
    
    if (self = [super init]) {
        self.modelURL = [[NSBundle mainBundle] URLForResource:aModelName
                                                withExtension:@"momd"];
        self.dbURL = aDBURL;
        
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:_modelURL];
        _storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        // Add the contexts
        _persistingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _persistingContext.persistentStoreCoordinator = _storeCoordinator;
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.parentContext = _persistingContext;
        _backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _backgroundContext.parentContext = _context;
        
        
        // Add the sqlite store
        NSError *err = nil;
        if (![_storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                        configuration:nil
                                                  URL:_dbURL
                                              options:nil
                                                     error:&err]){
            NSLog(@"Error while creating SQLite at %@.\n\r%@", _dbURL, err);
            return nil;
        }
        
        
        
        
    }
    
    return self;
    
}



#pragma mark - Others

// deletes all objects in the db. This won't delete the files, just leva empty tables.
-(void) zapAllData{
    
    NSError *err;
    if (![_storeCoordinator destroyPersistentStoreAtURL:self.dbURL
                                          withType:NSSQLiteStoreType
                                           options:nil
                                                 error:&err]){
        
        NSLog(@"%@", err);
    }
    
    if (![_storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                    configuration:nil
                                              URL:self.dbURL
                                          options:nil
                                                 error:&err]){
        NSLog(@"%@", err);
    }
    
}


-(void) saveWithErrorBlock: (void(^)(NSError *error))errorBlock{

    __block NSError *err = nil;
    [_context performBlockAndWait:^{


        // If a context is nil, saving it should also be considered an
        // error, as being nil might be the result of a previous error
        // while creating the db.
        if (!_context) {
            err = [NSError errorWithDomain:@"AGTCoreDataStack"
                                      code:1
                                  userInfo:@{NSLocalizedDescriptionKey :
                                                 @"Attempted to save a nil NSManagedObjectContext. This AGTCoreDataStack has no context - probably there was an earlier error trying to access the CoreData database file."}];
            errorBlock(err);


        }else if (self.context.hasChanges) {
            if (![self.context save:&err]) {
                if (errorBlock != nil) {
                    errorBlock(err);
                }
                
                // Now save in the background
                [self.persistingContext performBlock:^{
                    if(![self.persistingContext save:&err]){
                        if (errorBlock != nil){
                            errorBlock(err);
                        }
                    }
                }];
            }
        }

    }];
    
    
}



-(NSArray *) executeFetchRequest:(NSFetchRequest *)req
                      errorBlock:(void(^)(NSError *error)) errorBlock{
    
    NSError *err;
    NSArray *res = [self.context executeFetchRequest:req
                                               error:&err];
    
    if (res == nil) {
        // la cagamos
        if (errorBlock != nil) {
            errorBlock(err);
        }
        
    }
    return res;
}

-(void) performBackgroundTask:(void(^)(NSManagedObjectContext *worker))task{
    
    
    [self.backgroundContext performBlock:^{
        
        task(self.backgroundContext);
        
        // Save to the parent context
        NSError *err;
        if (![self.backgroundContext save:&err]){
            NSLog(@"%@", err);
        }
        
    }];
}


@end

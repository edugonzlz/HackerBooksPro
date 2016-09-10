// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tag.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class Book;

@interface TagID : NSManagedObjectID {}
@end

@interface _Tag : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TagID *objectID;

@property (nonatomic, strong) NSString* name;

@property (nonatomic, strong) NSSet<Book*> *books;
- (NSMutableSet<Book*>*)booksSet;

@end

@interface _Tag (BooksCoreDataGeneratedAccessors)
- (void)addBooks:(NSSet<Book*>*)value_;
- (void)removeBooks:(NSSet<Book*>*)value_;
- (void)addBooksObject:(Book*)value_;
- (void)removeBooksObject:(Book*)value_;

@end

@interface _Tag (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSMutableSet<Book*>*)primitiveBooks;
- (void)setPrimitiveBooks:(NSMutableSet<Book*>*)value;

@end

@interface TagAttributes: NSObject 
+ (NSString *)name;
@end

@interface TagRelationships: NSObject
+ (NSString *)books;
@end

NS_ASSUME_NONNULL_END

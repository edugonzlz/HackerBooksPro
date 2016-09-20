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

@class BookTag;

@interface TagID : NSManagedObjectID {}
@end

@interface _Tag : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TagID *objectID;

@property (nonatomic, strong) NSString* name;

@property (nonatomic, strong, nullable) NSSet<BookTag*> *bookTags;
- (nullable NSMutableSet<BookTag*>*)bookTagsSet;

@end

@interface _Tag (BookTagsCoreDataGeneratedAccessors)
- (void)addBookTags:(NSSet<BookTag*>*)value_;
- (void)removeBookTags:(NSSet<BookTag*>*)value_;
- (void)addBookTagsObject:(BookTag*)value_;
- (void)removeBookTagsObject:(BookTag*)value_;

@end

@interface _Tag (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSMutableSet<BookTag*>*)primitiveBookTags;
- (void)setPrimitiveBookTags:(NSMutableSet<BookTag*>*)value;

@end

@interface TagAttributes: NSObject 
+ (NSString *)name;
@end

@interface TagRelationships: NSObject
+ (NSString *)bookTags;
@end

NS_ASSUME_NONNULL_END

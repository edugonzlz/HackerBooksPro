// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BookTag.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class Book;
@class Tag;

@interface BookTagID : NSManagedObjectID {}
@end

@interface _BookTag : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BookTagID *objectID;

@property (nonatomic, strong) Book *book;

@property (nonatomic, strong) Tag *tag;

@end

@interface _BookTag (CoreDataGeneratedPrimitiveAccessors)

- (Book*)primitiveBook;
- (void)setPrimitiveBook:(Book*)value;

- (Tag*)primitiveTag;
- (void)setPrimitiveTag:(Tag*)value;

@end

@interface BookTagRelationships: NSObject
+ (NSString *)book;
+ (NSString *)tag;
@end

NS_ASSUME_NONNULL_END

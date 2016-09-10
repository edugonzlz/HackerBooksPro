// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PhotoCover.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class Book;

@interface PhotoCoverID : NSManagedObjectID {}
@end

@interface _PhotoCover : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PhotoCoverID *objectID;

@property (nonatomic, strong, nullable) NSData* imageData;

@property (nonatomic, strong) NSString* imageURL;

@property (nonatomic, strong) Book *book;

@end

@interface _PhotoCover (CoreDataGeneratedPrimitiveAccessors)

- (NSData*)primitiveImageData;
- (void)setPrimitiveImageData:(NSData*)value;

- (NSString*)primitiveImageURL;
- (void)setPrimitiveImageURL:(NSString*)value;

- (Book*)primitiveBook;
- (void)setPrimitiveBook:(Book*)value;

@end

@interface PhotoCoverAttributes: NSObject 
+ (NSString *)imageData;
+ (NSString *)imageURL;
@end

@interface PhotoCoverRelationships: NSObject
+ (NSString *)book;
@end

NS_ASSUME_NONNULL_END

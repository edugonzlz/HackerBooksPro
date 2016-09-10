// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Note.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class Book;
@class Location;
@class PhotoNote;

@interface NoteID : NSManagedObjectID {}
@end

@interface _Note : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) NoteID *objectID;

@property (nonatomic, strong) NSDate* creationDate;

@property (nonatomic, strong) NSDate* modificationDate;

@property (nonatomic, strong, nullable) NSString* text;

@property (nonatomic, strong) Book *book;

@property (nonatomic, strong, nullable) Location *location;

@property (nonatomic, strong) PhotoNote *photo;

@end

@interface _Note (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCreationDate;
- (void)setPrimitiveCreationDate:(NSDate*)value;

- (NSDate*)primitiveModificationDate;
- (void)setPrimitiveModificationDate:(NSDate*)value;

- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;

- (Book*)primitiveBook;
- (void)setPrimitiveBook:(Book*)value;

- (Location*)primitiveLocation;
- (void)setPrimitiveLocation:(Location*)value;

- (PhotoNote*)primitivePhoto;
- (void)setPrimitivePhoto:(PhotoNote*)value;

@end

@interface NoteAttributes: NSObject 
+ (NSString *)creationDate;
+ (NSString *)modificationDate;
+ (NSString *)text;
@end

@interface NoteRelationships: NSObject
+ (NSString *)book;
+ (NSString *)location;
+ (NSString *)photo;
@end

NS_ASSUME_NONNULL_END

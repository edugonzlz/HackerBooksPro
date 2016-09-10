// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Location.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class Note;

@interface LocationID : NSManagedObjectID {}
@end

@interface _Location : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) LocationID *objectID;

@property (nonatomic, strong) NSString* latitude;

@property (nonatomic, strong) NSString* longitude;

@property (nonatomic, strong) Note *note;

@end

@interface _Location (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSString*)value;

- (NSString*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSString*)value;

- (Note*)primitiveNote;
- (void)setPrimitiveNote:(Note*)value;

@end

@interface LocationAttributes: NSObject 
+ (NSString *)latitude;
+ (NSString *)longitude;
@end

@interface LocationRelationships: NSObject
+ (NSString *)note;
@end

NS_ASSUME_NONNULL_END

// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PhotoNote.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class Note;

@interface PhotoNoteID : NSManagedObjectID {}
@end

@interface _PhotoNote : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PhotoNoteID *objectID;

@property (nonatomic, strong, nullable) NSData* imageData;

@property (nonatomic, strong) NSSet<Note*> *notes;
- (NSMutableSet<Note*>*)notesSet;

@end

@interface _PhotoNote (NotesCoreDataGeneratedAccessors)
- (void)addNotes:(NSSet<Note*>*)value_;
- (void)removeNotes:(NSSet<Note*>*)value_;
- (void)addNotesObject:(Note*)value_;
- (void)removeNotesObject:(Note*)value_;

@end

@interface _PhotoNote (CoreDataGeneratedPrimitiveAccessors)

- (NSData*)primitiveImageData;
- (void)setPrimitiveImageData:(NSData*)value;

- (NSMutableSet<Note*>*)primitiveNotes;
- (void)setPrimitiveNotes:(NSMutableSet<Note*>*)value;

@end

@interface PhotoNoteAttributes: NSObject 
+ (NSString *)imageData;
@end

@interface PhotoNoteRelationships: NSObject
+ (NSString *)notes;
@end

NS_ASSUME_NONNULL_END

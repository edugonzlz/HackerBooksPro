// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Book.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class Author;
@class BookTag;
@class Note;
@class Pdf;
@class PhotoCover;

@interface BookID : NSManagedObjectID {}
@end

@interface _Book : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BookID *objectID;

@property (nonatomic, strong) NSString* author;

@property (nonatomic, strong, nullable) NSNumber* isFavorite;

@property (atomic) BOOL isFavoriteValue;
- (BOOL)isFavoriteValue;
- (void)setIsFavoriteValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber* isFinished;

@property (atomic) BOOL isFinishedValue;
- (BOOL)isFinishedValue;
- (void)setIsFinishedValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber* isRecent;

@property (atomic) BOOL isRecentValue;
- (BOOL)isRecentValue;
- (void)setIsRecentValue:(BOOL)value_;

@property (nonatomic, strong) NSString* title;

@property (nonatomic, strong) NSSet<Author*> *authors;
- (NSMutableSet<Author*>*)authorsSet;

@property (nonatomic, strong) NSSet<BookTag*> *bookTags;
- (NSMutableSet<BookTag*>*)bookTagsSet;

@property (nonatomic, strong, nullable) NSSet<Note*> *notes;
- (nullable NSMutableSet<Note*>*)notesSet;

@property (nonatomic, strong) Pdf *pdf;

@property (nonatomic, strong) PhotoCover *photoCover;

@end

@interface _Book (AuthorsCoreDataGeneratedAccessors)
- (void)addAuthors:(NSSet<Author*>*)value_;
- (void)removeAuthors:(NSSet<Author*>*)value_;
- (void)addAuthorsObject:(Author*)value_;
- (void)removeAuthorsObject:(Author*)value_;

@end

@interface _Book (BookTagsCoreDataGeneratedAccessors)
- (void)addBookTags:(NSSet<BookTag*>*)value_;
- (void)removeBookTags:(NSSet<BookTag*>*)value_;
- (void)addBookTagsObject:(BookTag*)value_;
- (void)removeBookTagsObject:(BookTag*)value_;

@end

@interface _Book (NotesCoreDataGeneratedAccessors)
- (void)addNotes:(NSSet<Note*>*)value_;
- (void)removeNotes:(NSSet<Note*>*)value_;
- (void)addNotesObject:(Note*)value_;
- (void)removeNotesObject:(Note*)value_;

@end

@interface _Book (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAuthor;
- (void)setPrimitiveAuthor:(NSString*)value;

- (NSNumber*)primitiveIsFavorite;
- (void)setPrimitiveIsFavorite:(NSNumber*)value;

- (BOOL)primitiveIsFavoriteValue;
- (void)setPrimitiveIsFavoriteValue:(BOOL)value_;

- (NSNumber*)primitiveIsFinished;
- (void)setPrimitiveIsFinished:(NSNumber*)value;

- (BOOL)primitiveIsFinishedValue;
- (void)setPrimitiveIsFinishedValue:(BOOL)value_;

- (NSNumber*)primitiveIsRecent;
- (void)setPrimitiveIsRecent:(NSNumber*)value;

- (BOOL)primitiveIsRecentValue;
- (void)setPrimitiveIsRecentValue:(BOOL)value_;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSMutableSet<Author*>*)primitiveAuthors;
- (void)setPrimitiveAuthors:(NSMutableSet<Author*>*)value;

- (NSMutableSet<BookTag*>*)primitiveBookTags;
- (void)setPrimitiveBookTags:(NSMutableSet<BookTag*>*)value;

- (NSMutableSet<Note*>*)primitiveNotes;
- (void)setPrimitiveNotes:(NSMutableSet<Note*>*)value;

- (Pdf*)primitivePdf;
- (void)setPrimitivePdf:(Pdf*)value;

- (PhotoCover*)primitivePhotoCover;
- (void)setPrimitivePhotoCover:(PhotoCover*)value;

@end

@interface BookAttributes: NSObject 
+ (NSString *)author;
+ (NSString *)isFavorite;
+ (NSString *)isFinished;
+ (NSString *)isRecent;
+ (NSString *)title;
@end

@interface BookRelationships: NSObject
+ (NSString *)authors;
+ (NSString *)bookTags;
+ (NSString *)notes;
+ (NSString *)pdf;
+ (NSString *)photoCover;
@end

NS_ASSUME_NONNULL_END

// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Pdf.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class Book;

@interface PdfID : NSManagedObjectID {}
@end

@interface _Pdf : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PdfID *objectID;

@property (nonatomic, strong, nullable) NSData* pdfData;

@property (nonatomic, strong) NSString* pdfURL;

@property (nonatomic, strong) Book *book;

@end

@interface _Pdf (CoreDataGeneratedPrimitiveAccessors)

- (NSData*)primitivePdfData;
- (void)setPrimitivePdfData:(NSData*)value;

- (NSString*)primitivePdfURL;
- (void)setPrimitivePdfURL:(NSString*)value;

- (Book*)primitiveBook;
- (void)setPrimitiveBook:(Book*)value;

@end

@interface PdfAttributes: NSObject 
+ (NSString *)pdfData;
+ (NSString *)pdfURL;
@end

@interface PdfRelationships: NSObject
+ (NSString *)book;
@end

NS_ASSUME_NONNULL_END

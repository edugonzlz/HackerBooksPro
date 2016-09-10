// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Pdf.m instead.

#import "_Pdf.h"

@implementation PdfID
@end

@implementation _Pdf

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Pdf" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Pdf";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Pdf" inManagedObjectContext:moc_];
}

- (PdfID*)objectID {
	return (PdfID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic pdfData;

@dynamic pdfURL;

@dynamic book;

@end

@implementation PdfAttributes 
+ (NSString *)pdfData {
	return @"pdfData";
}
+ (NSString *)pdfURL {
	return @"pdfURL";
}
@end

@implementation PdfRelationships 
+ (NSString *)book {
	return @"book";
}
@end


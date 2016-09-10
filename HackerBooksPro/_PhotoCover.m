// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PhotoCover.m instead.

#import "_PhotoCover.h"

@implementation PhotoCoverID
@end

@implementation _PhotoCover

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PhotoCover" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PhotoCover";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PhotoCover" inManagedObjectContext:moc_];
}

- (PhotoCoverID*)objectID {
	return (PhotoCoverID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic imageData;

@dynamic imageURL;

@dynamic book;

@end

@implementation PhotoCoverAttributes 
+ (NSString *)imageData {
	return @"imageData";
}
+ (NSString *)imageURL {
	return @"imageURL";
}
@end

@implementation PhotoCoverRelationships 
+ (NSString *)book {
	return @"book";
}
@end


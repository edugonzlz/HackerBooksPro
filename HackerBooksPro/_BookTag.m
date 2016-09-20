// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BookTag.m instead.

#import "_BookTag.h"

@implementation BookTagID
@end

@implementation _BookTag

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BookTag" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BookTag";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BookTag" inManagedObjectContext:moc_];
}

- (BookTagID*)objectID {
	return (BookTagID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic book;

@dynamic tag;

@end

@implementation BookTagRelationships 
+ (NSString *)book {
	return @"book";
}
+ (NSString *)tag {
	return @"tag";
}
@end


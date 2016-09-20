// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tag.m instead.

#import "_Tag.h"

@implementation TagID
@end

@implementation _Tag

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Tag";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:moc_];
}

- (TagID*)objectID {
	return (TagID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic name;

@dynamic bookTags;

- (NSMutableSet<BookTag*>*)bookTagsSet {
	[self willAccessValueForKey:@"bookTags"];

	NSMutableSet<BookTag*> *result = (NSMutableSet<BookTag*>*)[self mutableSetValueForKey:@"bookTags"];

	[self didAccessValueForKey:@"bookTags"];
	return result;
}

@end

@implementation TagAttributes 
+ (NSString *)name {
	return @"name";
}
@end

@implementation TagRelationships 
+ (NSString *)bookTags {
	return @"bookTags";
}
@end


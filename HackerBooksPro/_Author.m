// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Author.m instead.

#import "_Author.h"

@implementation AuthorID
@end

@implementation _Author

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Author" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Author";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Author" inManagedObjectContext:moc_];
}

- (AuthorID*)objectID {
	return (AuthorID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic name;

@dynamic books;

- (NSMutableSet<Book*>*)booksSet {
	[self willAccessValueForKey:@"books"];

	NSMutableSet<Book*> *result = (NSMutableSet<Book*>*)[self mutableSetValueForKey:@"books"];

	[self didAccessValueForKey:@"books"];
	return result;
}

@end

@implementation AuthorAttributes 
+ (NSString *)name {
	return @"name";
}
@end

@implementation AuthorRelationships 
+ (NSString *)books {
	return @"books";
}
@end


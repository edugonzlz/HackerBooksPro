// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Book.m instead.

#import "_Book.h"

@implementation BookID
@end

@implementation _Book

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Book";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Book" inManagedObjectContext:moc_];
}

- (BookID*)objectID {
	return (BookID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"isFavoriteValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isFavorite"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isFinishedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isFinished"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isRecentValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isRecent"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic author;

@dynamic isFavorite;

- (BOOL)isFavoriteValue {
	NSNumber *result = [self isFavorite];
	return [result boolValue];
}

- (void)setIsFavoriteValue:(BOOL)value_ {
	[self setIsFavorite:@(value_)];
}

- (BOOL)primitiveIsFavoriteValue {
	NSNumber *result = [self primitiveIsFavorite];
	return [result boolValue];
}

- (void)setPrimitiveIsFavoriteValue:(BOOL)value_ {
	[self setPrimitiveIsFavorite:@(value_)];
}

@dynamic isFinished;

- (BOOL)isFinishedValue {
	NSNumber *result = [self isFinished];
	return [result boolValue];
}

- (void)setIsFinishedValue:(BOOL)value_ {
	[self setIsFinished:@(value_)];
}

- (BOOL)primitiveIsFinishedValue {
	NSNumber *result = [self primitiveIsFinished];
	return [result boolValue];
}

- (void)setPrimitiveIsFinishedValue:(BOOL)value_ {
	[self setPrimitiveIsFinished:@(value_)];
}

@dynamic isRecent;

- (BOOL)isRecentValue {
	NSNumber *result = [self isRecent];
	return [result boolValue];
}

- (void)setIsRecentValue:(BOOL)value_ {
	[self setIsRecent:@(value_)];
}

- (BOOL)primitiveIsRecentValue {
	NSNumber *result = [self primitiveIsRecent];
	return [result boolValue];
}

- (void)setPrimitiveIsRecentValue:(BOOL)value_ {
	[self setPrimitiveIsRecent:@(value_)];
}

@dynamic title;

@dynamic authors;

- (NSMutableSet<Author*>*)authorsSet {
	[self willAccessValueForKey:@"authors"];

	NSMutableSet<Author*> *result = (NSMutableSet<Author*>*)[self mutableSetValueForKey:@"authors"];

	[self didAccessValueForKey:@"authors"];
	return result;
}

@dynamic bookTags;

- (NSMutableSet<BookTag*>*)bookTagsSet {
	[self willAccessValueForKey:@"bookTags"];

	NSMutableSet<BookTag*> *result = (NSMutableSet<BookTag*>*)[self mutableSetValueForKey:@"bookTags"];

	[self didAccessValueForKey:@"bookTags"];
	return result;
}

@dynamic notes;

- (NSMutableSet<Note*>*)notesSet {
	[self willAccessValueForKey:@"notes"];

	NSMutableSet<Note*> *result = (NSMutableSet<Note*>*)[self mutableSetValueForKey:@"notes"];

	[self didAccessValueForKey:@"notes"];
	return result;
}

@dynamic pdf;

@dynamic photoCover;

@end

@implementation BookAttributes 
+ (NSString *)author {
	return @"author";
}
+ (NSString *)isFavorite {
	return @"isFavorite";
}
+ (NSString *)isFinished {
	return @"isFinished";
}
+ (NSString *)isRecent {
	return @"isRecent";
}
+ (NSString *)title {
	return @"title";
}
@end

@implementation BookRelationships 
+ (NSString *)authors {
	return @"authors";
}
+ (NSString *)bookTags {
	return @"bookTags";
}
+ (NSString *)notes {
	return @"notes";
}
+ (NSString *)pdf {
	return @"pdf";
}
+ (NSString *)photoCover {
	return @"photoCover";
}
@end


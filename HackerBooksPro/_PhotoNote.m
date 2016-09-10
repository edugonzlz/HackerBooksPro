// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PhotoNote.m instead.

#import "_PhotoNote.h"

@implementation PhotoNoteID
@end

@implementation _PhotoNote

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PhotoNote" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PhotoNote";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PhotoNote" inManagedObjectContext:moc_];
}

- (PhotoNoteID*)objectID {
	return (PhotoNoteID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic imageData;

@dynamic notes;

- (NSMutableSet<Note*>*)notesSet {
	[self willAccessValueForKey:@"notes"];

	NSMutableSet<Note*> *result = (NSMutableSet<Note*>*)[self mutableSetValueForKey:@"notes"];

	[self didAccessValueForKey:@"notes"];
	return result;
}

@end

@implementation PhotoNoteAttributes 
+ (NSString *)imageData {
	return @"imageData";
}
@end

@implementation PhotoNoteRelationships 
+ (NSString *)notes {
	return @"notes";
}
@end


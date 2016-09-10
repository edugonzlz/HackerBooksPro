#import "_PhotoNote.h"
#import "Note.h"
#import <UIKit/UIKit.h>

@interface PhotoNote : _PhotoNote

@property (nonatomic, strong) UIImage *image;

+(instancetype)photoNoteWithNote:(Note *)note inContext:(NSManagedObjectContext *)context;

+(instancetype)photoNoteWithNote:(Note *)note image:(UIImage *)image inContext:(NSManagedObjectContext *)context;

@end

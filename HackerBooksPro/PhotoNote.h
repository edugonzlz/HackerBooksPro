#import "_PhotoNote.h"
#import <UIKit/UIKit.h>

@interface PhotoNote : _PhotoNote

@property (nonatomic, strong) UIImage *image;

+(instancetype)photoNoteForNote:(Note *)note;

+(instancetype)photoNoteForNote:(Note *)note withImage:(UIImage *)image;

@end

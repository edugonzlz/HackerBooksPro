#import "_PhotoCover.h"
#import "Book.h"
#import <UIKit/UIKit.h>

@interface PhotoCover : _PhotoCover

@property (nonatomic, strong) UIImage *image;

+(instancetype)photoCoverWithURL:(NSString *)photoCoverURL inContext:(NSManagedObjectContext *)context;
+(instancetype)photoCoverWithURL:(NSString *)photoCoverURL forBook:(Book *)book inContext:(NSManagedObjectContext *)context;

@end

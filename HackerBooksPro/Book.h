#import "_Book.h"

@interface Book : _Book

@property (nonatomic, strong, readonly) NSString *tagsString;

+(instancetype)bookWithTitle:(NSString *)title
                      authors:(NSArray *)authors
                        tags:(NSArray *)tags
                    coverURL:(NSString *)coverURL
                      pdfURL:(NSString *)pdfURL
                     inContext:(NSManagedObjectContext *)context;

+(instancetype)bookWithDict:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context;


@end

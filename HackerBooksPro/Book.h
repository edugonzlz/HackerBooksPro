#import "_Book.h"

@interface Book : _Book

@property (nonatomic, strong) NSString *tagsString;

+(instancetype)bookWithTitle:(NSString *)title
                      author:(NSString *)author
                        tags:(NSString *)tags
                    coverURL:(NSString *)coverURL
                      pdfURL:(NSString *)pdfURL
                     inContext:(NSManagedObjectContext *)context;

-(instancetype)initWithTitle:(NSString *)title
                      author:(NSString *)author
                        tags:(NSString *)tags
                    coverURL:(NSString *)coverURL
                      pdfURL:(NSString *)pdfURL
                   inContext:(NSManagedObjectContext *)context;

-(instancetype)initWithDict:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context;

@end

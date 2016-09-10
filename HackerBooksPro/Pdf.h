#import "_Pdf.h"

@interface Pdf : _Pdf

+(instancetype)pdfWithURL:(NSString *)pdfURL inContext:(NSManagedObjectContext *)context;

@end

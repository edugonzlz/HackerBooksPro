#import "_Pdf.h"
#import "Book.h"

@interface Pdf : _Pdf

@property (nonatomic, strong) NSData *pdf;

+(instancetype)pdfWithURL:(NSString *)pdfURL forBook:(Book *)book;

@end

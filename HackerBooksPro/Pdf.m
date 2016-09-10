#import "Pdf.h"

@interface Pdf ()

// Private interface goes here.

@end

@implementation Pdf

+(instancetype)pdfWithURL:(NSString *)pdfURL inContext:(NSManagedObjectContext *)context{

    Pdf *pdf = [NSEntityDescription insertNewObjectForEntityForName:[Pdf entityName]
                                             inManagedObjectContext:context];

// TODO: - enviar a segundo plano
    pdf.pdfData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pdfURL]];

    return pdf;
}

+(instancetype)pdfWithURL:(NSString *)pdfURL forBook:(Book *)book inContext:(NSManagedObjectContext *)context{

    Pdf *pdf = [Pdf pdfWithURL:pdfURL
                      inContext:context];
    pdf.book = book;
    
    return pdf;
}
@end

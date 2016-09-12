#import "Pdf.h"

@interface Pdf ()

// Private interface goes here.

@end

@implementation Pdf

-(void)setPdf:(NSData *)pdf{

    self.pdfData = pdf;
}
-(NSData *)pdf{

    // TODO: - gestionar en el getter de pdfData y enviar a segundo plano
    self.pdfData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.pdfURL]];

    return self.pdfData;

}

+(instancetype)pdfWithURL:(NSString *)pdfURL inContext:(NSManagedObjectContext *)context{

    Pdf *pdf = [NSEntityDescription insertNewObjectForEntityForName:[Pdf entityName]
                                             inManagedObjectContext:context];

    pdf.pdfURL = pdfURL;

    return pdf;
}

+(instancetype)pdfWithURL:(NSString *)pdfURL forBook:(Book *)book inContext:(NSManagedObjectContext *)context{

    Pdf *pdf = [Pdf pdfWithURL:pdfURL
                      inContext:context];
    pdf.book = book;
    
    return pdf;
}
@end

#import "Pdf.h"
#import <UIKit/UIKit.h>

@interface Pdf ()

// Private interface goes here.

@end

@implementation Pdf

-(void)setPdf:(NSData *)pdf{

    self.pdfData = pdf;
}
-(NSData *)pdf{

    if (!self.pdfData) {

        dispatch_queue_t download = dispatch_queue_create("pdf", 0);

        dispatch_async(download, ^{

            self.pdfData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.pdfURL]];

        });

        // TODO: - si pdf es nil enviar una imagen por defecto????
        return [NSData dataWithContentsOfFile:@""];
    }

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

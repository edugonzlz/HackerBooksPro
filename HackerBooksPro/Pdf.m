#import "Pdf.h"
#import <UIKit/UIKit.h>
#import "Book.h"

@interface Pdf ()

// Private interface goes here.

@end

@implementation Pdf

-(void)setPdf:(NSData *)pdf{

    self.pdfData = pdf;
}
-(NSData *)pdf{

    if (!self.pdfData) {

    // TODO: - usar mejor NSURLSession para indicar el progreso???

        dispatch_queue_t download = dispatch_queue_create("pdf", 0);

        dispatch_async(download, ^{

            self.pdfData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.pdfURL]];
        });

        // TODO: - si pdf es nil enviar una imagen por defecto????
        return nil;
    }

    return self.pdfData;
}

+(instancetype)pdfWithURL:(NSString *)pdfURL forBook:(Book *)book{

    Pdf *pdf = [NSEntityDescription insertNewObjectForEntityForName:[Pdf entityName]
                                             inManagedObjectContext:book.managedObjectContext];

    pdf.pdfURL = pdfURL;
    pdf.book = book;
    
    return pdf;
}
@end

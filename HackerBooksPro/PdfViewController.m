//
//  PdfViewController.m
//  HackerBooksPro
//
//  Created by Edu González on 14/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import "PdfViewController.h"
#import "Pdf.h"

@interface PdfViewController ()

@end

@implementation PdfViewController


-(id)initWithModel:(Book *)model{

    if (self == [super initWithNibName:nil bundle:nil]) {
        _model = model;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self syncModelWithView];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{

    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{

    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;

    self.title = @"";
}

-(void)syncModelWithView{

    self.title = @"Loading PDF...";
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];

    self.browser.delegate = self;

    if(self.model.pdf.pdfData == nil){

        dispatch_queue_t download = dispatch_queue_create("pdf", 0);
        dispatch_async(download, ^{

            self.model.pdf.pdfData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.pdf.pdfURL]];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadPdf];
            });
            
        });
        
    } else {

        [self loadPdf];
    }
}

-(void)loadPdf{

    [self.browser loadData:self.model.pdf.pdfData
                  MIMEType:@"application/pdf"
          textEncodingName:@"utf-8"
                   baseURL:[NSURL URLWithString:self.model.pdf.pdfURL]];
}

@end
//
//  PdfViewController.m
//  HackerBooksPro
//
//  Created by Edu González on 14/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import "PdfViewController.h"
#import "Pdf.h"
#import "NoteViewController.h"
#import "Book.h"

@interface PdfViewController ()

@end

@implementation PdfViewController


-(id)initWithModel:(Book *)model{

    if (self = [super initWithNibName:nil bundle:nil]) {
        _model = model;
    }
    return self;
}

// MARK: - lifecycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    // Notificacion cuando se selecciona book en SplitView
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didSelectedBook:)
                                                name:@"lastBookSelected"
                                              object:nil];
    [self syncModelWithView];

    UIBarButtonItem *addNote = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(addNote:)];
    self.navigationItem.rightBarButtonItem = addNote;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// MARK: - WebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{

    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{

    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;

    self.title = @"";
}

// MARK: - Utils
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
-(void)addNote:(id)sender{

    NoteViewController *nVC = [[NoteViewController alloc]initNewNoteForBook:self.model];

    [self.navigationController pushViewController:nVC animated:true];
}

-(void)didSelectedBook:(NSNotification *)notification{

    Book *book = [notification.userInfo objectForKey:@"lastBookSelected"];
    self.model = book;
    [self syncModelWithView];
}

@end

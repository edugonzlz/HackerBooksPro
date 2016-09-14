//
//  PdfViewController.h
//  HackerBooksPro
//
//  Created by Edu González on 14/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface PdfViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIWebView *browser;
@property (nonatomic, strong) Book *model;

-(id)initWithModel:(Book *)model;

@end

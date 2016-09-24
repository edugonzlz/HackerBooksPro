//
//  LibraryTableViewController.h
//  HackerBooksPro
//
//  Created by Edu González on 13/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGTCoreDataTableViewController.h"
@class Book;

@interface LibraryTableViewController : AGTCoreDataTableViewController <UISearchBarDelegate>

@property (nonatomic, strong) NSManagedObjectContext *context;

-(id)initWithContext:(NSManagedObjectContext *)context;

-(Book *)lastSelectedBook;

@end

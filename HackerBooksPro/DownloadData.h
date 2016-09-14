//
//  DownloadData.h
//  HackerBooksPro
//
//  Created by Edu González on 14/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGTSimpleCoreDataStack.h"

@interface DownloadData : NSObject

@property (nonatomic, strong) AGTSimpleCoreDataStack *model;

-(void)downloadData;

@end

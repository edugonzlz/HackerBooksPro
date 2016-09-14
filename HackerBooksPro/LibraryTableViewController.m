//
//  LibraryTableViewController.m
//  HackerBooksPro
//
//  Created by Edu González on 13/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import "LibraryTableViewController.h"
#import "Book.h"
#import "PhotoCover.h"
#import "Tag.h"
#import "BookViewController.h"

@implementation LibraryTableViewController

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    NSString *cellId = @"bookCell";
    //book
    Book *book = [self.fetchedResultsController objectAtIndexPath:indexPath];

    //celda
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:cellId];
    }

    cell.textLabel.text = book.title;
    cell.imageView.image = book.photoCover.image;
    cell.detailTextLabel.text = book.tagsString;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    Book *book = [self.fetchedResultsController objectAtIndexPath:indexPath];

    BookViewController *bVC = [[BookViewController alloc]init];

    bVC.model = book;

    [self.navigationController pushViewController:bVC animated:true];

}

@end

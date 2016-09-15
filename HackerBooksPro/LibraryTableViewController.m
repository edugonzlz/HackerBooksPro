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

    BookViewController *bVC = [[BookViewController alloc]initWithModel:book];

    [self saveLastBookSelected: book];

    [self.navigationController pushViewController:bVC animated:true];
}

-(void)saveLastBookSelected:(Book *)book{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    BookID *bookId = [book objectID];
    [defaults setValue:bookId forKey:@"lastSelectedBook"];

    [defaults synchronize];
}

-(Book *)lastSelectedBook{

    // TODO: - que hacer cuando aun no se ha guardado ningun ultimo seleccionado
    // estamos obteniendo bien el contexto y haciendo bien la busqueda?
    // En el caso de que usemos un splitView en un ipad, cargar el ultimo book en la vista de detalle
    BookID *bookID = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastSelectedBook"];
//    if (!bookID) {
//    }

        NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Book entityName]];
        req.predicate = [NSPredicate predicateWithFormat:@"objectID == %@", bookID];
        NSFetchedResultsController *results = [[NSFetchedResultsController alloc]initWithFetchRequest:req
                                                                                 managedObjectContext:self.fetchedResultsController.managedObjectContext
                                                                                   sectionNameKeyPath:nil
                                                                                            cacheName:nil];
        Book *book = (Book *)results;
        return book;
}

@end

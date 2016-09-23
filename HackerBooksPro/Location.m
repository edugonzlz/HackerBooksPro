#import "Location.h"
#import "Note.h"

@import AddressBookUI;
//@import Contacts; Usar si uso CNPostalAddressFormatter

@interface Location () 

@property (strong, nonatomic)Note *note;

@end

@implementation Location

@synthesize  note = _note;

// MARK: - Inits
+(instancetype)locationForNote:(Note *)note withCLLocation:(CLLocation *)location{


    // Comprobamos la existencia de la localizacion con un margen del 0.001 de error
    // Usamos lf (long float) para compara con double
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Location entityName]];
    NSPredicate *latitude = [NSPredicate predicateWithFormat:@"abs(latitude) - abs(%lf) < 0.001", location.coordinate.latitude];
    NSPredicate *longitude = [NSPredicate predicateWithFormat:@"abs(longitude) - abs(%lf) < 0.001", location.coordinate.longitude];
    req.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[latitude, longitude]];

    NSError *error;
    NSArray *res = [note.managedObjectContext executeFetchRequest:req
                                                            error:&error];

    // Si no hay un error continuamos
    NSAssert(res, @"Error buscando Localizaciones existentes");

        if ([res count]) {

            // Ya existe una localizacion, la relacionamos
            Location *existingLoc = [res lastObject];
            [existingLoc addNotesObject:note];

            existingLoc.note = note;

            return existingLoc;

        } else {

            //No existe, la creamos
            Location *loc = [NSEntityDescription insertNewObjectForEntityForName:[Location entityName]
                                                          inManagedObjectContext:note.managedObjectContext];
            loc.latitudeValue = location.coordinate.latitude;
            loc.longitudeValue = location.coordinate.longitude;
            [loc addNotesObject:note];

            [loc addressFromCLLocation:location];

            NSLog(@"lat: %f, long: %f , direccion: %@", loc.latitudeValue, loc.longitudeValue, loc.adress);

            loc.note = note;

            return loc;
        }
}

-(void)addressFromCLLocation:(CLLocation *)location{

    // Damos una direccion fisica a la localizacion por coordenadas
    CLGeocoder *coder = [[CLGeocoder alloc]init];
    [coder reverseGeocodeLocation:location
                completionHandler:^(NSArray *placemarks, NSError *error) {

                    if (error) {
                        NSLog(@"Error calculando la direccion: %@", error);
                    }else{
                        // usar CNPostalAddressFormatter ??
                        self.adress = ABCreateStringWithAddressDictionary([[placemarks lastObject] addressDictionary], YES);
                        NSLog(@"La direccion humana es %@", self.adress);
                    }
                }];
}


// MARK: - MKAnnotationDelegate
// TODO: - parece que si la nota no tiene texto, la chincheta no presenta el callout
-(NSString *)title{

    NSString *text = self.note.text;
    if ([self.note.text isEqualToString:@""] ) {
        text = @"Note";
    }
    return text;
}
-(NSString *)subtitle{
    NSArray *addressArr = [self.adress componentsSeparatedByString:@"\n"];
    NSMutableString *address = [NSMutableString stringWithFormat:@""];
    for (NSString *comp in addressArr) {
        [address appendFormat:@" %@", comp];
    }
    return address;
}
-(CLLocationCoordinate2D)coordinate{

    return CLLocationCoordinate2DMake(self.latitudeValue, self.longitudeValue);
}

@end

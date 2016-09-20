#import "Location.h"
#import "Note.h"

@interface Location ()

// Private interface goes here.

@end

@implementation Location

+(instancetype)locationForNote:(Note *)note
                      latitude:(double)latitude
                     longitude:(double)longitude{

    Location *loc = [Location locationForNote:note];

    [loc addNotesObject:note];
    loc.latitudeValue = latitude;
    loc.longitudeValue = longitude;
// TODO: - calcular direccion y asignar

    return loc;
}

+(instancetype)locationForNote:(Note *)note{

    Location *loc = [NSEntityDescription insertNewObjectForEntityForName:[Location entityName]
                                                  inManagedObjectContext:note.managedObjectContext];

    // TODO: - añadir longitud y latitud por defecto o nil si no existen
    // Calcular aqui nuestra localizacion y asignar
    return loc;
}


@end

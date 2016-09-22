#import "Location.h"
#import "Note.h"

@import AddressBookUI;
@import Contacts;

@interface Location () <CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation Location

@synthesize locationManager = _locationManager;

// MARK: - Inits
+(instancetype)locationForNote:(Note *)note withCLLocation:(CLLocation *)location{

    Location *loc = [NSEntityDescription insertNewObjectForEntityForName:[Location entityName]
                                                  inManagedObjectContext:note.managedObjectContext];
    loc.latitudeValue = location.coordinate.latitude;
    loc.longitudeValue = location.coordinate.longitude;
    [loc addNotesObject:note];

    [loc addressFromCLLocation:location];

    NSLog(@"lat: %f, long: %f , direccion: %@", loc.latitudeValue, loc.longitudeValue, loc.adress);

    return loc;
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
                        NSLog(@"Address is %@", self.adress);
                    }
                }];
}



















// TODO: - Limpiar todo esto si decido no pasar la responsabilidad a Location de localizarse

-(instancetype)initLocationForNote:(Note *)note;{


    // Configurar locationManager
    [self setupLocationManager];

    // Esperar a que el delegado obtenga la localizacion

    // Cuando tengamos localizacion inicializar

    Location *loc = [NSEntityDescription insertNewObjectForEntityForName:[Location entityName]
                                                  inManagedObjectContext:note.managedObjectContext];

    return loc;
}




// MARK: -  CLLocationManagerDelegate
-(void) locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{

    // paramos el location manager, porque consume mucha bateria
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;

    // Cogemos la última localizacion, que debe de ser la mas precisa
    CLLocation *location = [locations lastObject];
}

// MARK: - Utils
-(void)setupLocationManager{

    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ( ((status == kCLAuthorizationStatusAuthorizedAlways) || (status == kCLAuthorizationStatusNotDetermined))
        && [CLLocationManager locationServicesEnabled]) {

        // Tenemos acceso a localización
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
    }
    
}



@end

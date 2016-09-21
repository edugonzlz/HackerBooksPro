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

    // Damos una direccion fisica a la localizacion por coordenadas
    CLGeocoder *coder = [[CLGeocoder alloc]init];
    [coder reverseGeocodeLocation:location
                completionHandler:^(NSArray *placemarks, NSError *error) {

                    if (error) {
                        NSLog(@"Error calculando la direccion: %@", error);
                    }else{
                        // usar CNPostalAddressFormatter ??
                        loc.adress = ABCreateStringWithAddressDictionary([[placemarks lastObject] addressDictionary], YES);
                        NSLog(@"Address is %@", loc.adress);
                    }
                }];

    return loc;
}

+(instancetype)locationForNote:(Note *)note{

    Location *loc = [NSEntityDescription insertNewObjectForEntityForName:[Location entityName]
                                                  inManagedObjectContext:note.managedObjectContext];

    [loc addNotesObject:note];

    [loc calculateLocation];

    NSLog(@"lat: %f, long: %f", loc.latitudeValue, loc.longitudeValue);

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

    self.latitudeValue = location.coordinate.latitude;
    self.longitudeValue = location.coordinate.longitude;

    [self reverseLocation:location];

}

// MARK: - Utils
-(void)calculateLocation{

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
-(void)reverseLocation:(CLLocation *)location{

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

@end

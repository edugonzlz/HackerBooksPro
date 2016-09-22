#import "Note.h"
#import "PhotoNote.h"
#import "Location.h"
#import "Book.h"

@interface Note () <CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;

+(NSArray *)observableKeyNames;

@end

@implementation Note

@synthesize locationManager = _locationManager;

+(NSArray *)observableKeyNames{
    return @[@"text", @"creationDate", @"photo.imageData"];
}

+(instancetype)noteForBook:(Book *)book inContext:(NSManagedObjectContext *)context{

    Note *note = [NSEntityDescription insertNewObjectForEntityForName:[Note entityName]
                                               inManagedObjectContext:context];

    // TODO: - sumar a la fecha [NSTimeZone systemTimeZone]
    note.book = book;
    note.creationDate = [NSDate date];
    note.modificationDate = [NSDate date];

    PhotoNote *photo = [PhotoNote photoNoteForNote:note];
    note.photo = photo;

    return note;
}

// MARK: - Lifecycle
-(void)awakeFromInsert{
    [super awakeFromInsert];

    [self setupKVO];

    [self setupLocationManager];
}
-(void)awakeFromFetch{
    [super awakeFromFetch];

    [self setupKVO];
}
-(void)willTurnIntoFault{
    [super willTurnIntoFault];

    [self tearDownKVO];
}

// MARK: - KVO
-(void)setupKVO{
    for (NSString *key in [Note observableKeyNames]) {
        [self addObserver:self
               forKeyPath:key
                  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionOld
                  context:NULL];
    }
}

-(void)tearDownKVO{
    for (NSString *key in [Note observableKeyNames]) {
        [self removeObserver:self
                  forKeyPath:key];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{

    // Cuando nos informen del cambio de las propiedades indicadas cambiamos la fecha de modificacion
    self.modificationDate = [NSDate date];
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

        // Queremos los datos ahora. Asi que paramos el proceso despues de un tiempo
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [self tearDownLocationManager];
        });
    }

    NSLog(@"Configurado el Location Manager");
    
}

-(void)tearDownLocationManager{

    // paramos el location manager, porque consume mucha bateria
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
}

// MARK: -  CLLocationManagerDelegate
-(void) locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{

    [self tearDownLocationManager];

    // solo creamos una location si la nota no la tiene
    if (self.location != nil) {

        // Cogemos la última localizacion, que debe de ser la mas precisa
        CLLocation *location = [locations lastObject];

        // Creamos una location
        self.location = [Location locationForNote:self withCLLocation:location];
        NSLog(@"Creada Location entity");
    } else {
        NSLog(@"Segun Fernando no deberiamos estar aqui");
    }

}

@end

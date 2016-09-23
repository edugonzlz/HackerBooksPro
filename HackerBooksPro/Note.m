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
    
    // Montamos el chiringo solo si no tenemos ya una localizacion
    if (!self.location) {
        [self setupLocationManager];
    }
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

        // Arrancamos localizacion
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];

        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];

        // hasta que no demos permisos el manager no envia nada el delegado
        // Si estuviera denied or restricted, habria que invitar al usuario
        // con un alert a ir a Settings y activar la localizacion

        if ((status == kCLAuthorizationStatusNotDetermined)
            && [CLLocationManager locationServicesEnabled]) {

            [self.locationManager requestWhenInUseAuthorization];
        }
}

-(void)tearDownLocationManager{

    // paramos el location manager, porque consume mucha bateria
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
}

// MARK: -  CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations{

    // Queremos los datos ahora.
    // Asi que paramos el proceso despues de un tiempo si no hemos conseguido resultados
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self tearDownLocationManager];
    });

    // Cogemos la última localizacion, que debe de ser la mas precisa
    CLLocation *location = [locations lastObject];

    // solo creamos una location si la nota no la tiene
    if (self.location == nil) {

        self.location = [Location locationForNote:self withCLLocation:location];

    } else {

    // TODO: - ya tenemos una localizacion, pero parece que nos mandan otras 4 actualizaciones
        NSLog(@"ya esta localizada la nota");
    }
    
}

@end

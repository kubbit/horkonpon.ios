//
//  Gertakaria.h
//  HorKonpon
//
//  Copyright (c) 2014 Kubbit Information Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Gertakaria : NSObject

@property (nonatomic, copy) NSString* argazkia;
@property (nonatomic, copy) NSString* fitxategiIzena;
@property (nonatomic, copy) NSNumber* latitudea;
@property (nonatomic, copy) NSNumber* longitudea;
@property (nonatomic, copy) NSNumber* zehaztasuna;
@property (nonatomic, copy) NSString* herria;
@property (nonatomic, copy) NSString* izena;
@property (nonatomic, copy) NSString* telefonoa;
@property (nonatomic, copy) NSString* posta;
@property (nonatomic, copy) NSString* oharrak;
@property (nonatomic) BOOL ohartarazi;
@property (nonatomic, copy) NSString* hizkuntza;

- (void) gehituArgazkia:(UIImage*)pArgazkia;
- (BOOL) validate;
- (NSString*) asJSON;

@end

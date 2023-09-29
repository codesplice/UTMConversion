import Foundation
import CoreLocation

public extension CLLocationCoordinate2D {
    
    
    /**
     Calculates the UTM coordinate of the receiver
     
     - Parameter datum: The datum to use, defaults to WGS84 which should be fine for most applications
     
     */
    func utmCoordinate(datum: UTMDatum = UTMDatum.wgs84) -> UTMCoordinate {
        let zone = self.zone
        return TMCoordinate(coordinate: self, centralMeridian: zone.centralMeridian, datum: datum).utmCoordinate(zone: zone, hemisphere: hemisphere)
    }
    
    
    /**
     The UTM grid zone
     */
    var zone: UTMGridZone {
        return UTMGridZone(floor((longitude + 180.0) / 6)) + 1;
    }
    
    /**
     The UTM hemisphere
     */
    var hemisphere: UTMHemisphere {
        return latitude < 0 ? .southern : .northern
    }
    
}

public extension Array<CLLocationCoordinate2D> {
    
    /**
     Converts an array of `CLLocationCoordinate2D`s to an array of UTM Coordinates in the same UTM Zone.
     
     - Warning: Some coordinates may fall outside the zone and exhibit greater distortion - only use in instances where
        the collection of coordinates are known to be in close proximity and the same zone is required for 2D geometry calculations
     
     - Parameter datum: The datum to use, defaults to WGS84 which should be fine for most applications
     
     */
    func utmCoordinate(datum: UTMDatum = UTMDatum.wgs84) -> [UTMCoordinate] {
        guard let first = self.first else { return [] }
        let zone = first.zone
        let hemisphere = first.hemisphere
        return self.map {
            TMCoordinate(coordinate: $0,
                         centralMeridian: zone.centralMeridian,
                         datum: datum)
            .utmCoordinate(zone: zone, hemisphere: hemisphere)
        }
    }
}

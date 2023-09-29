import CoreLocation
import Foundation

public extension CLLocation {
    
    /**
        Calculates the UTM coordinate of the receiver
     
        - Parameter datum: The datum to use, defaults to WGS84 which should be fine for most applications
     
     */
    func utmCoordinate(datum: UTMDatum = UTMDatum.wgs84) -> UTMCoordinate {
        let coordinate = self.coordinate
        let zone = coordinate.zone
        return TMCoordinate(coordinate: coordinate, centralMeridian: zone.centralMeridian, datum: datum).utmCoordinate(zone: zone, hemisphere: coordinate.hemisphere)
    }
    
}

public extension Array<CLLocation> {
    
    /**
     Converts an array of `CLLocation`s to an array of UTM Coordinates in the same UTM Zone.
     
     - Warning: Some coordinates may fall outside the zone and exhibit greater distortion - only use in instances where
        the collection of coordinates are known to be in close proximity and the same zone is required for 2D geometry calculations
     
     - Parameter datum: The datum to use, defaults to WGS84 which should be fine for most applications
     
     */
    func utmCoordinate(datum: UTMDatum = UTMDatum.wgs84) -> [UTMCoordinate] {
        guard let first = self.first else { return [] }
        let zone = first.coordinate.zone
        let hemisphere = first.coordinate.hemisphere
        return self.map {
            TMCoordinate(coordinate: $0.coordinate,
                         centralMeridian: zone.centralMeridian,
                         datum: datum)
            .utmCoordinate(zone: zone, hemisphere: hemisphere)
        }
    }
}

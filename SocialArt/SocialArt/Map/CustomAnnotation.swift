//
//  CustomAnnotation.swift
//  SocialArt
//
//  Created by Ayca Akman on 20.10.2023.
//

import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: UIImage?

    init(coordinate: CLLocationCoordinate2D, title: String?, image: UIImage?) {
        self.coordinate = coordinate
        self.title = title
        self.image = image
        super.init()
    }
}

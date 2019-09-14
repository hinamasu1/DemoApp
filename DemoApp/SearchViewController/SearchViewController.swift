import UIKit
import MapKit

class SearchViewController:UIViewController {

    @IBOutlet weak var mapView:MKMapView!
    let locationManager = CLLocationManager()
    var searchController:UISearchController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation()

        let searchResultViewController = storyboard!.instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
        searchResultViewController.mapView = self.mapView
        self.searchController = UISearchController(searchResultsController:searchResultViewController)
        self.searchController?.searchResultsUpdater = searchResultViewController

        let searchBar = self.searchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for plaace"
        navigationItem.titleView = self.searchController!.searchBar

        self.searchController?.hidesNavigationBarDuringPresentation = false
        self.searchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true

        return
    }

}

extension SearchViewController:CLLocationManagerDelegate {

    func locationManager(_ manager:CLLocationManager,didChangeAuthorization status:CLAuthorizationStatus) {

        if status == .authorizedWhenInUse {
            self.locationManager.requestLocation()
        }

        return
    }

    func locationManager(_ manager:CLLocationManager,didUpdateLocations locations:[CLLocation]) {
        
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta:0.05,longitudeDelta:0.05)
            let region = MKCoordinateRegion(center:location.coordinate,span:span)
            self.mapView.setRegion(region,animated:true)
        }

        return
    }


    func locationManager(_ manager:CLLocationManager,didFailWithError error:Error) {

        print("error:: \(error)")

        return
    }

}

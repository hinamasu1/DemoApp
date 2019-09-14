import UIKit
import MapKit

class SearchResultViewController:UITableViewController {

    var matchingItems:[MKMapItem] = []
    var mapView:MKMapView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension SearchResultViewController {

    override func tableView(_ tableView:UITableView,numberOfRowsInSection section:Int) -> Int {

        return self.matchingItems.count
    }

    override func tableView(_ tableView:UITableView,cellForRowAt indexPath:IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = ""

        return cell
    }

}

extension SearchResultViewController:UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {

        guard let mapView = self.mapView,
              let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request:request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }

        return
    }

}

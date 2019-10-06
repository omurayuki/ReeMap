import CoreLocation
import FloatingPanel
import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol TappedSearchBarDelegate: NSObject {
    
    func tappedSearchBar()
}

extension NoteListViewController: VCInjectable {
    
    typealias UI = NoteListUIProtocol
    typealias Routing = NoteListRoutingProtocol
    typealias ViewModel = NoteListViewModel
    typealias DataSource = TableViewDataSource<NoteListTableViewCell, Place>
    
    func setupConfig() {
        ui.tableView.dataSource = dataSource
        ui.tableView.delegate = self
        ui.searchBar.delegate = self
    }
}

class NoteListViewController: UIViewController {
    
    var ui: NoteListUIProtocol! { didSet { ui.viewController = self } }
    var routing: NoteListRoutingProtocol? { didSet { routing?.viewController = self } }
    var viewModel: NoteListViewModel?
    var disposeBag: DisposeBag!
    
    weak var delegate: TappedSearchBarDelegate!
    private var places: [Place]?
    private var placesForDeletion: [Place]?
    private var searchResultPlaces: [Place]?
    private var placeForEditing: (note: String, address: String, noteId: String)?
    
    var didAcceptPlaces: [Place]? {
        didSet {
            guard let places = didAcceptPlaces else { return }
            dataSource.listItems = places
            self.places = places
            ui.animateReload()
        }
    }
    
    private(set) lazy var dataSource: DataSource = {
        DataSource(cellReuseIdentifier: String(describing: NoteListTableViewCell.self),
                   listItems: [],
                   cellConfigurationHandler: { cell, item, _ in
            cell.didPlaceUpdated = item
        })
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
        bindUI()
        setupConfig()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ui.hideHeader()
    }
}

extension NoteListViewController {
    
    private func bindUI() {
        ui.header.editBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                guard let place = self.placeForEditing else { return }
                self.routing?.showCreateMemoPage(note: place.note,
                                                 address: place.address,
                                                 noteId: place.noteId)
                self.ui.hideHeader()
            }).disposed(by: disposeBag)
    }
    
    private func getPlacemark(location: CLLocation, place: Place) {
        viewModel?.getPlacemarks(location: location)
            .subscribe(onSuccess: { [unowned self] placemark in
                self.ui.changeTableAlpha(0.9)
                self.placeForEditing = (place.content, self.getStreetAddress(placemark: placemark), place.documentId)
                self.ui.showHeader(content: place.content, address: self.getStreetAddress(placemark: placemark))
            }, onError: { [unowned self] _ in
                self.showError(message: R.string.localizable.attention_could_not_load_location())
            }).disposed(by: disposeBag)
    }
    
    private func deleteRows(indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [unowned self] in
            guard let places = self.placesForDeletion else { return }
            self.viewModel?.deleteNote(place: places[indexPath.row])
                .subscribe(onSuccess: { [unowned self] _ in
                    self.ui.hideHeader()
                    }, onError: { [unowned self] _ in
                        self.showError(message: R.string.localizable.could_not_delete())
                }).disposed(by: self.disposeBag)
        })
    }
}

extension NoteListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ui.tableView.visibleCells.forEach { $0.isUserInteractionEnabled = false }
        let place = dataSource.listItems[indexPath.row]
        let location = CLLocation(latitude: place.latitude, longitude: place.longitude)
        getPlacemark(location: location, place: place)
        //// Cellのレンダリングが終わらない間に次のCellをタップすると、挙動がおかしくなる
        //// 一旦DispatchQueueで制御している理由は、completionでも制御できるが処理が複雑になるので
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [unowned self] in
            self.ui.tableView.visibleCells.forEach { $0.isUserInteractionEnabled = true }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .normal, title: R.string.localizable.delete()) { [unowned self] _, _ in
            //// didEndEditingRowAtで使用するため、一旦コピー
            self.placesForDeletion = self.dataSource.listItems
            self.dataSource.listItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.deleteRows(indexPath: indexPath)
        }
        deleteButton.backgroundColor = .red
        return [deleteButton]
    }
}

extension NoteListViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        delegate.tappedSearchBar()
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        searchResultPlaces = places?
            .filter { $0.content.contains(text) }
            .compactMap { $0 }
        guard let places = searchResultPlaces else { return }
        dataSource.listItems = places
        ui.animateReload()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.endEditing(true)
        guard let text = searchBar.text else { return false }
        if text.isEmpty {
            dataSource.listItems = places ?? []
            ui.animateReload()
        }
        ui.hideHeader()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        dataSource.listItems = places ?? []
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
}

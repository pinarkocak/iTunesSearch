//
//  ResultListTableViewController.swift
//  iTunesSearch
//
//  Created by Pınar Koçak on 25.02.2022.
//

import Foundation
import UIKit

public class ResultListTableViewController: UITableViewController {
    
    //MARK: Private Properties
    
    private var pagingIdx: Int = 0
    private var pagingSize: Int = 30
    private var viewModel: ResultListViewModel!
    private var isFirstCalling: Bool = true
    @IBOutlet var searchBar: UISearchBar!
    
    //MARK: Public Methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailViewController, let detailToSend = sender as? ResultViewModel {
            vc.selectedObj = detailToSend
        }
    }
    
    //MARK: Private Methods
    
    private func setupUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    private func getItems() {
        let searchKey = searchBar.text
        iTunesAPIAccess().getResults(firstCall: isFirstCalling, pagingIndex: pagingIdx, pagingSize: pagingSize, term: searchKey ?? "") { results in
            if let results = results {
                self.pagingIdx += 1
                self.pagingSize += self.pagingSize
                self.isFirstCalling = false
                self.viewModel = ResultListViewModel(results: results)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: TableView Delegates
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel == nil ? 0 : self.viewModel.numberOfSections
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as? ResultTableViewCell else { fatalError("not found") }
        
        let resultViewModel = self.viewModel.resultAtIndex(indexPath.row, indexPath.section)
        
        cell.titleLabel?.text = resultViewModel.trackName.isEmpty ? resultViewModel.collectionName : resultViewModel.trackName
        cell.artistLabel?.text = resultViewModel.artistName
        cell.priceLabel?.isHidden = true
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detail = self.viewModel.resultAtIndex(indexPath.row, indexPath.section)
        performSegue(withIdentifier: "showDetail", sender: detail)
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView : UITextView = UITextView()
        sectionHeaderView.textColor = UIColor.white
        sectionHeaderView.text = self.viewModel.getSectionTitle()[section].uppercased()
        sectionHeaderView.font = UIFont(name: "Courier", size: 20)
        sectionHeaderView.textContainerInset = UIEdgeInsets(top: 8, left: 15, bottom: 7, right: 15)
        sectionHeaderView.isUserInteractionEnabled = false
        sectionHeaderView.backgroundColor = UIColor.darkGray
        return sectionHeaderView
    }
    
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > (tableView.contentSize.height - scrollView.frame.height - 100), iTunesAPIAccess().hasMore() {
            //Fetch More Data
            getItems()
        }
    }
}


extension ResultListTableViewController: UISearchBarDelegate {
    
    //MARK: SearchBar Delegates
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.viewModel = nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: { [weak self] in
            self?.tableView.reloadData()
        })
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.pagingIdx = 0
        self.pagingSize = 20
        self.isFirstCalling = true
        getItems()
    }
}

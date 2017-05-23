//
//  TestViewController.swift
//  YuMoya
//
//  Created by Tsung Han Yu on 2017/3/23.
//  Copyright © 2017年 Tsung Han Yu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TestViewController: UIViewController {
    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var changeStatus: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    
    let viewModel = GitHubViewModel()
    var models: [GitHubModel] = []
    
    
    fileprivate let bag = DisposeBag()
    
    typealias SectionTableModel = SectionModel<String, GitHubModel>
    let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
        
        dataSource.configureCell = { (_, tv, indexPath, element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = element.name
            cell.detailTextLabel?.text = ""
            if let star = element.stargazers_count {
                cell.detailTextLabel?.text = "🌟: \(star)"
            }
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? WebViewController
            else { return }
        if let url = sender as? String {
            vc.urlStr = url
        }
    }
    
    
    
}

// MARK: - RxCode
extension TestViewController {
    
    func setupData() {
        let rxTF = textField.rx.text
            .throttle(0.8, scheduler: MainScheduler.instance)
            .filter { $0!.characters.count > 2 }
        
        Observable
            .combineLatest(rxTF, changeStatus.rx.value)
            { (input, status) -> Void in
                self.netWork(input!, status: status)
            }
            .subscribe()
            .addDisposableTo(bag)
    }
    
    func setupView() {
        changeStatus.rx.value
            .map { $0 ? "User" : "Repo" }
            .bindTo(label.rx.text)
            .addDisposableTo(bag)
        
        tableView.rx.itemSelected
            .map { indexPath in
                return (indexPath, self.dataSource[indexPath])
            }
            .subscribe(onNext: { indexPath, model in
                self.performSegue(withIdentifier: "webSegue", sender: model.html_url)
                print("Tapped `\(model)` @ \(indexPath)")
            })
            .disposed(by: bag)
    }
}


// MARK: - Helper
extension TestViewController {
    
    fileprivate func netWork(_ input:String, status:Bool) {
        
        Observable.just(status)
            .flatMap { (status) -> Observable<[GitHubModel]> in
                print(input)
                if status {
                    return self.viewModel.getUserRepositories(input)
                }
                else {
                    return self.viewModel.getRepositories(input)
                }
            }
            //.shareReplay(1)
            .subscribe(onNext: { (models) in
                self.models = models
                self.tableView.dataSource = nil
                Observable.just([SectionTableModel(model: "", items: models)])
                    .bindTo(self.tableView.rx.items(dataSource: self.dataSource))
                    .addDisposableTo(self.bag)
            }, onError: { (error) in
                print(error)
            })
            .addDisposableTo(self.bag)
    }
    
}

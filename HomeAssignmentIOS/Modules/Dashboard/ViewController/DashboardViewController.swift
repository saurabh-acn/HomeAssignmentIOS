//
//  DashboardViewController.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 17/01/22.
//

import UIKit

class DashboardViewController: UIViewController {
    
    /// IBOutlet used
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerViewBackgroundView: UIView!
    @IBOutlet weak var accountBalance: UILabel!
    @IBOutlet weak var accountNumber: UILabel!
    @IBOutlet weak var accountHolder: UILabel!
    @IBOutlet weak var transferButton: RoundButton!
    
    /// Variables used
    private var dashboardViewModel: DashboardViewModel?
    var userTransactions: [UserTransaction] = []
    
    lazy var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action:
                         #selector(handleRefresh(_:)),
                         for: .valueChanged)
            refreshControl.tintColor = UIColor.black
            
            return refreshControl
        }()
    
    /// View Controller life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        dashboardViewModel = DashboardViewModel()
        tableView.addSubview(self.refreshControl)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        transferButton?.isHidden = true
        getBalance()
    }
    
    /// Funciton to setup UI
    private func setupUI() {
        navigationItem.setHidesBackButton(true, animated: true)
        addLogoutButton()
        setUpTableView()
    }
    
    /// To Setup TableView
    private func setUpTableView() {
        tableView?.register(UINib(nibName: Constants.transactionCell,
                                 bundle: nil),
                           forCellReuseIdentifier: Constants.transactionCell)
        tableView?.layer.masksToBounds = false
        tableView?.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        tableView?.layer.shadowOpacity = 1
        tableView?.layer.shadowRadius = 5
        tableView?.layer.shadowOffset = .init(width: 0, height: 5)
        
        headerViewBackgroundView?.clipsToBounds = true
        headerViewBackgroundView?.layer.cornerRadius = 20
        headerViewBackgroundView?.layer.maskedCorners = [.layerMaxXMinYCorner,
                                                        .layerMaxXMaxYCorner]
        headerViewBackgroundView?.dropShadow()
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        self.getBalance()
    }
    
    /// Function to navigate to tranfer view
    @IBAction func navigateTransferView(_ sender: Any) {
        transferButton?.selectedState = true
        guard let viewController = TransferViewController.initializeFromStoryboard() else { return }
        navigationController?.pushViewController(viewController,
                                                 animated: true)
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    /// Tableview delegates and datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        if userTransactions.count > 0 { return userTransactions.count }
        return 0
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if userTransactions[section].data.count > 0 { return userTransactions[section].data.count + 1 }
        return 0
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        if userTransactions.count > 0 && section == 0 {
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        if userTransactions.count > 0 && section == 0 {
            let headerView = UIView()
            let titleLabel = UILabel()
            headerView.backgroundColor = .clear
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.text = Constants.trasactionTitle
            titleLabel.font = UIFont.systemFont(ofSize: 15,
                                                weight: .bold)
            headerView.addSubview(titleLabel)
            
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor,
                                                constant: 0).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor,
                                                 constant: 0).isActive = true
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor,
                                            constant: 0).isActive = true
            titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.transactionCell,
                                                 for: indexPath) as! TransactionCell
        let row = indexPath.row - 1
        let transactionData = userTransactions[indexPath.section]
        if indexPath.row > 0 {
            if transactionData.data[row].transactionType == Constants.transactionTransfer {
                cell.name = transactionData.data[row].receipient?.accountHolder
                cell.amount = "-\(transactionData.data[row].amount)"
                cell.transactionId = transactionData.data[row].receipient?.accountNo
                cell.amountTextColor = false
            } else {
                cell.name = transactionData.data[row].sender?.accountHolder
                cell.amount = "\(transactionData.data[row].amount)"
                cell.transactionId = transactionData.data[row].sender?.accountNo
                cell.amountTextColor = true
            }
            cell.nameLabel.textColor = .black
        } else {
            cell.name = transactionData.title
            cell.nameLabel.textColor = .gray
            cell.amount = nil
            cell.transactionId = nil
        }
        return cell
    }

}

extension DashboardViewController {
    /// Function to get instance of viewController
    /// - Returns: Instance of viewController
    static func initializeFromStoryboard() -> DashboardViewController? {
        if let controller = UIStoryboard(name: Constants.main,
                                         bundle: nil).instantiateViewController(withIdentifier: Constants.dashboardVC) as? DashboardViewController {
            return controller
        } else { return nil }
    }
    
    /// Function to set default settig to transfer button
    func setDefaultButtonConfig() {
        transferButton?.isHidden = false
        transferButton?.selectedState = false
        transferButton?.layoutSubviews()
    }
}

extension DashboardViewController: EndpopintAPICall {
    /// Function to call api of transactions
    private func getTransactions() {
        userTransactions.removeAll()
        guard let viewModel = dashboardViewModel else { return }
        viewModel.getTransactions { [weak self] transactionArray, error in
            guard let self = self else { return }
            if error == nil {
                self.userTransactions = transactionArray
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.setDefaultButtonConfig()
                    Spinner.stop()
                }
            } else {
                DispatchQueue.main.async {
                    // Alert message
                    self.popupAlert(title: Constants.genericServerErrorMeesage,
                                    message: error,
                                    actionTitles: [Constants.ok], actions:[{ action1 in
                    }])
                    self.setDefaultButtonConfig()
                    Spinner.stop()
                }
            }
        }
    }
    
    /// Function to call api of balance
    private func getBalance() {
        guard let viewModel = dashboardViewModel else { return }
        Spinner.start(style: .large,
                      baseColor: .black)
        viewModel.getBalance { [weak self] balanceData, error in
            guard let self = self else { return }
            if error == nil {
                DispatchQueue.main.async {
                    self.accountBalance.text = "\(Constants.currencyType) \((balanceData?.balance ?? 0.0).formattedWithSeparator)"
                    self.accountNumber.text = balanceData?.accountNo ?? ""
                    self.accountHolder.text = UserDefaults.standard.string(forKey: Constants.username)
                    self.getTransactions()
                }
            } else {
                DispatchQueue.main.async {
                    self.popupAlert(title: Constants.genericServerErrorMeesage,
                                    message: error,
                                    actionTitles: [Constants.ok], actions:[{ action in
                    }])
                }
                self.getTransactions()
            }
        }
    }
}

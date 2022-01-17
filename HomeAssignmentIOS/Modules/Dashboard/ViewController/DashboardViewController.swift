//
//  DashboardViewController.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 17/01/22.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerViewBackgroundView: UIView!
    @IBOutlet weak var accountBalance: UILabel!
    @IBOutlet weak var accountNumber: UILabel!
    @IBOutlet weak var accountHolder: UILabel!
    @IBOutlet weak var transferButton: RoundButton!
    
    private var dashboardViewModel: DashboardViewModel?
    private var userTransactions: [UserTransaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dashboardViewModel = DashboardViewModel()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.transferButton.isHidden = true
        getBalance()
    }
    
    private func setupUI() {
        navigationItem.setHidesBackButton(true, animated: true)
        addLogoutButton()
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.register(UINib(nibName: "TransactionCell", bundle: nil), forCellReuseIdentifier: "TransactionCell")
        tableView.layer.masksToBounds = false
        tableView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor // any value you want
        tableView.layer.shadowOpacity = 1 // any value you want
        tableView.layer.shadowRadius = 5 // any value you want
        tableView.layer.shadowOffset = .init(width: 0, height: 5) // any value you want
        
        headerViewBackgroundView.clipsToBounds = true
        headerViewBackgroundView.layer.cornerRadius = 20
        headerViewBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        headerViewBackgroundView.dropShadow()
    }
    
    @IBAction func navigateTransferView(_ sender: Any) {
        transferButton.selectedState = true
        guard let viewController = TransferViewController.initializeFromStoryboard() else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if userTransactions.count > 0 { return userTransactions.count }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userTransactions[section].data.count > 0 { return userTransactions[section].data.count + 1 }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if userTransactions.count > 0 && section == 0 {
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if userTransactions.count > 0 && section == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
            titleLabel.text = "Your transaction history"
            titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            view.addSubview(titleLabel)
            view.backgroundColor = .clear
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
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
    static func initializeFromStoryboard() -> DashboardViewController? {
        if let controller = UIStoryboard(name: "Main",
                                         bundle: nil).instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController {
            return controller
        } else { return nil }
    }
}

extension DashboardViewController: EndpopintAPICall {
    private func getTransactions() {
        userTransactions.removeAll()
        guard let viewModel = dashboardViewModel else { return }
        viewModel.getTransactions { [weak self] transactionArray, error in
            guard let self = self else { return }
            if error == nil {
                self.userTransactions = transactionArray
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.transferButton.isHidden = false
                    Spinner.stop()
                }
            } else {
                DispatchQueue.main.async {
                    // Alert message
                    self.popupAlert(title: Constants.errorTitle, message: error, actionTitles: ["Ok"], actions:[{action1 in
                    }])
                    self.transferButton.isHidden = false
                    Spinner.stop()
                }
            }
        }
    }
    
    private func getBalance() {
        guard let viewModel = dashboardViewModel else { return }
        Spinner.start(style: .large, baseColor: .black)
        viewModel.getBalance { [weak self] balanceData, error in
            guard let self = self else { return }
            if error == nil {
                DispatchQueue.main.async {
                    self.accountBalance.text = "SGD \((balanceData?.balance ?? 0.0).formattedWithSeparator)"
                    self.accountNumber.text = balanceData?.accountNo ?? ""
                    self.accountHolder.text = UserDefaults.standard.string(forKey: Constants.username)
                    self.getTransactions()
                }
            } else {
                self.popupAlert(title: Constants.errorTitle, message: error, actionTitles: ["Ok"], actions:[{ action in
                }])
                self.getTransactions()
            }
        }
    }
}

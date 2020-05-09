import UIKit

public protocol NodeListTableViewControllerSelectDelegate: AnyObject
{
    func nodeClassSelected(controller: NodeListTableViewController, nodeDataClass : AnyClass, point: CGPoint) -> Void
}

public class NodeListTableViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource
{
    weak var delegate : NodeListTableViewControllerSelectDelegate?
    var tableViewDataSource : Dictionary<NodeType,Array<NodeData.Type>> = [:]
    var tableViewSectionDataSource : Array<NodeType> = []
    let tableView : UITableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
    
    override public func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Add a node"
        view.backgroundColor = UIColor.white
        
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let data : Array<NodeData.Type> = NodeInfoCacheManager.shared.getNodeClasses().map
        {
            return $0 as! NodeData.Type
        }
        
        tableViewDataSource = Dictionary(grouping: data, by: { nodeData in nodeData.nodeType() })
        tableViewSectionDataSource = Array(tableViewDataSource.keys)
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let selectedClass : NodeData.Type = tableViewDataSource[tableViewSectionDataSource[indexPath.section]]?[indexPath.row]
        {
            if let popoverPresentationController : UIPopoverPresentationController = self.navigationController!.presentationController as? UIPopoverPresentationController
            {
                delegate?.nodeClassSelected(controller: self, nodeDataClass: selectedClass, point: popoverPresentationController.sourceRect.origin)
            }
            self.presentingViewController?.dismiss(animated: true, completion: {})
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return tableViewSectionDataSource.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewSectionDataSource[section].rawValue
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableViewDataSource[tableViewSectionDataSource[section]]?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        if let selectedClass : NodeData.Type = tableViewDataSource[tableViewSectionDataSource[indexPath.section]]?[indexPath.row]
        {
            cell.textLabel?.text = selectedClass.defaultTitle
        }
        return cell
    }
    
    
    // MARK: - UIPopoverPresentationControllerDelegate
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

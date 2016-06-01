
require('UITableView,UIView,UIColor,UITableViewCell,NSIndexPath')

defineClass('Dome.ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>',{
			
			viewDidLoad: function() {
			
			console.log('js viewDidLoad begin')
			self.ORIGviewDidLoad()
			var mainView = self.super().view()
			
			mainView.setBackgroundColor(UIColor.redColor())
			
			var tableView = UITableView.alloc().initWithFrame({x:105, y:0, width:100, height:200})
			tableView.setDelegate(self)
			tableView.setDataSource(self)
			tableView.setBackgroundColor(UIColor.yellowColor())
			tableView.registerClass_forCellReuseIdentifier(UITableViewCell.class(),
														   "TableViewCell")
			mainView.addSubview(tableView)
			self.setTableView(tableView)
			tableView.reloadData()
			
			var subView = UIView.alloc().initWithFrame({x:0, y:0, width:100, height:200})
			subView.setBackgroundColor(UIColor.greenColor())
			console.log(mainView)
			console.log(subView)
			mainView.addSubview(subView)
			
			console.log('js viewDidLoad end')
			
			},
			
			tableView_numberOfRowsInSection: function(tableView, section){
			return 13
			},
			
			tableView_heightForRowAtIndexPath: function(tableView, indexPath){
			return 44
			},
			
			tableView_cellForRowAtIndexPath: function(tableView, indexPath){
			var cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell")
			cell.textLabel().setText("hahaha")
			return cell
			}
			
			})

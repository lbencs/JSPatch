require('UIViewController,UITableView,UIView,UIColor,UITableViewCell,NSIndexPath')
require('JPEngine').addExtensions(['JPMemory'])
require('JPEngine').addExtensions(['CATOperationQueue'])

defineClass('Dome.CATListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>', [
  'tableView'
], {
  init: function() {
    self = self.super().init();
    if (self) {
      //do some
      console.log("init CAtListViewController")
    }
    return self;
  },
			
  viewDidLoad: function() {
//    self.ORIGviewDidLoad();
    console.log('js viewDidLoad begin');
    self.makeup();
    var weakself = __weak(self);
    dispatch_after(1.0, function() {
        var strongself = __strong(weakself);
        strongself.showAlert();
      }),
	
	self.testJPMemory();
    self.testGCD();
			
    console.log('js viewDidLoad end');
  },

  testJPMemory: function() {
    console.log("test------JPMemory");
    var pError = malloc(sizeof("NSError"));
    self.testErrorPoint(pError);
    console.log("pError : start");
    console.log(pError)
    console.log("pError : end");
    var error = pval(pError);
    console.log("start");
    console.log(error);
    console.log("end");
    if (!error) {
      console.log("success");
    } else {
      console.log(error);
    }
    releaseTmpObj(pError)
    free(pError)
    console.log("test------JPMemory");
  },
  testErrorPoint: function(error) {
    var tmp = require('NSError').errorWithDomain_code_userInfo("test.com", 10012, null);
    var newErrorPointer = getPointer(tmp);
    memcpy(error, newErrorPointer, sizeof('id'))
  },
  testGCD: function() {
    var weakself = __weak(self);
			
	dispatch_after(10, function() {
      var strongself = __strong(weakself);
      strongself.showAlert();
    })
			
	dispatch_sync_main(function() {
		
	})
    _executeActionWhenUserInitiated(function() {
	_printStock()
      for (var i = 0; i < 100000; i++) {
        console.log(i)
      }
    })
  },
  makeup: function() {
    self.ORIGviewDidLoad()
    var mainView = self.super().view()
    mainView.setBackgroundColor(UIColor.redColor())
    var tableView = UITableView.alloc().initWithFrame({
      x: 0,
      y: 0,
      width: mainView.frame().width,
      height: mainView.frame().height
    })
    tableView.setDelegate(self)
    tableView.setDataSource(self)
    tableView.setBackgroundColor(UIColor.yellowColor())
    tableView.registerClass_forCellReuseIdentifier(UITableViewCell.class(), "TableViewCell")
    mainView.addSubview(tableView)
    self.setTableView(tableView)
    tableView.reloadData()
  },

  //UITableViewDelegate && UITableSource
  tableView_numberOfRowsInSection: function(tableView, section) {
    return 23
  },
  tableView_heightForRowAtIndexPath: function(tableView, indexPath) {
    return 44
  },
  tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
    var cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell")
    cell.textLabel().setText("hahaha")
    return cell
  },
  tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
    console.log("message");
    var nextVC = UIViewController.alloc().init();
    nextVC.setTitle("NextPage")
    nextVC.view().setBackgroundColor(UIColor.whiteColor());
    self.navigationController().pushViewController_animated(nextVC, true);
    console.log(nextVC);
  },
})

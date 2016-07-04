//autoConvertOCType(1)
//include('CommonDefine.js')
//include('DBDataSource.js')
//include('DBTimelineController.js')

defineClass('AppDelegate', {
  initRootViewController: function() {
    var tableViewCtrl = require('UIViewController').alloc().init()
    var navCtrl = require('UINavigationController').alloc().initWithRootViewController(tableViewCtrl);
    self.window().setRootViewController(navCtrl);
  }
})

autoConvertOCType(1)
include('CATListViewController.js')

defineClass('AppDelegate : UIResponder <UIApplicationDelegate>', {
            
            configRootViewController: function() {
            var vc = require('UIViewController').alloc().init();
            var navCtrl = require('UINavigationController').alloc().initWithRootViewController(vc);
            self.window().setRootViewController(navCtrl);
            },
            
            ttt: function() {
                console.log("message");
            },
            
            applicationDidBecomeActive: function(application) {
                console.log("----");
            },
            applicationWillResignActive: function(application) {
                console.log("----");
            },
            applicationDidEnterBackground: function(application) {
                console.log("----");
            },
            applicationWillEnterForeground: function(application) {
                console.log("----");
            },
            
    })



/*
include('CATListViewController.js')
defineClass('AppDelegate', {
            
            ttt: function() {
                console.log("message");
            },
            
            });


//defineClass('AppDelegate', {
//    
////            configRootViewController: function() {
////            
////                var viewController = require('UIViewController').alloc().init();
////            
////                viewController.setBackgroundColor(UIColor.whiteColor());
////            
////                var navigationController = require('UINavigationController').alloc().initWithRootViewController(viewController);
////            
////                self.window().setRootViewController(navigationController);
////            },
//            
//            ttt: function() {
//            
//            },
//            
//})
*/
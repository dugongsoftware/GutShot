using System;

using UIKit;

namespace poker6000
{
    public partial class ViewController : UIViewController
    {
        protected ViewController(IntPtr handle) : base(handle)
        {
            // Note: this .ctor should not contain any initialization logic.
        }

        public override void ViewDidLoad()
        {
            base.ViewDidLoad();
            // Perform any additional setup after loading the view, typically from a nib.


            string[] venues = { "Queens Arms", "Treasury" };
            ViewModels.VenueSource source = new ViewModels.VenueSource(venues);

            tblVenues.Source = source;
            
            

            
            
        }

        partial void BtnRegister_TouchUpInside(UIButton sender)
        {
            var alertController = UIAlertController.Create ("OK Alert", "This is a sample alert with an OK button.", UIAlertControllerStyle.Alert);

            //Add Action
            alertController.AddAction (UIAlertAction.Create ("Ok", UIAlertActionStyle.Default, null));
            //var alertController = UIAlertController.Create(title ?? string.Empty, string.Empty, UIAlertControllerStyle.ActionSheet);

            //alertController.PopoverPresentationController?.SetPresentationAnchor(uiViewObject);

            var window = new UIWindow();
            window.RootViewController = new UIViewController();
            
            PresentViewController (alertController, true, null);
        }

        public Action Do()
        {
            return null;
        }

        public override void DidReceiveMemoryWarning()
        {
            base.DidReceiveMemoryWarning();
            // Release any cached data, images, etc that aren't in use.
        }

        //partial void BtnRegister_TouchUpInside(UIButton sender)
        //{
        //    //var okAlertController = UIAlertController.Create ("Title", "The message", UIAlertControllerStyle.Alert);
        
        //    ////Add Action
        //    //okAlertController.AddAction (UIAlertAction.Create ("OK", UIAlertActionStyle.Default, (UIAlertAction obj) => {
        //    //    labRegistered.Text = "Run it up!";
        //    //}));
        
        //    //// Present Alert
        //    //PresentViewController (okAlertController, true, null);

        //    ////ShowViewController(okAlertController, null);
            
            
        //    var alert = UIAlertController.Create("Alert", "Backgroung is white!", UIAlertControllerStyle.Alert);
              
        //    alert.AddAction(UIAlertAction.Create("No", UIAlertActionStyle.Default, (UIAlertAction obj) =>  
        //    {  
        //        labRegistered.Text = "Choice : No";  
        //    }));  
            
        //    alert.AddAction(UIAlertAction.Create("Yes", UIAlertActionStyle.Default, (UIAlertAction obj) =>  
        //    {  
        //        labRegistered.Text = "Choice : Yes";
        //    }));

        //    //PresentViewController(alert, false, null);
        //}
    }
}

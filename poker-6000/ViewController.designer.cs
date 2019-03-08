// WARNING
//
// This file has been generated automatically by Visual Studio from the outlets and
// actions declared in your storyboard file.
// Manual changes to this file will not be maintained.
//
using Foundation;
using System;
using System.CodeDom.Compiler;

namespace poker6000
{
    [Register ("ViewController")]
    partial class ViewController
    {
        [Outlet]
        [GeneratedCode ("iOS Designer", "1.0")]
        UIKit.UIButton btnRegister { get; set; }

        [Outlet]
        [GeneratedCode ("iOS Designer", "1.0")]
        UIKit.UILabel labRegistered { get; set; }

        [Outlet]
        [GeneratedCode ("iOS Designer", "1.0")]
        UIKit.UILabel labType { get; set; }

        [Outlet]
        [GeneratedCode ("iOS Designer", "1.0")]
        UIKit.UITableView tblVenues { get; set; }

        [Action ("BtnRegister_TouchUpInside:")]
        [GeneratedCode ("iOS Designer", "1.0")]
        partial void BtnRegister_TouchUpInside (UIKit.UIButton sender);

        void ReleaseDesignerOutlets ()
        {
            if (btnRegister != null) {
                btnRegister.Dispose ();
                btnRegister = null;
            }

            if (labRegistered != null) {
                labRegistered.Dispose ();
                labRegistered = null;
            }

            if (labType != null) {
                labType.Dispose ();
                labType = null;
            }

            if (tblVenues != null) {
                tblVenues.Dispose ();
                tblVenues = null;
            }
        }
    }
}
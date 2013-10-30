---
title: "Custom Field control implemented as a User Control"
layout: post
topics: [ "SharePoint", "Programming" ]
---

When creating custom controls it is often must easier to create a control using the "User Control" development model instead of the "Server Control" model. [Server controls](http://msdn.microsoft.com/en-us/library/zt27tfhy.aspx) generally have a more "low level" feel and dictate that the developer build the control's rendering from scratch. Either by building a control tree or by constructing the rendered output in code.

Alternatively [user controls](http://msdn.microsoft.com/en-us/library/y6wb1a0e.aspx) have nice separation of code and presentation by virtue of having a markup file (.ascx) and a code behind file; much like a standard aspx page. User controls can be created and developed using the same standard approaches and processes that we all know and love from the aspx page model.

When implementing a custom field control for SharePoint, the development experience can be streamlined to a large degree by utilizing a user control. Traditionally field controls are created using the server control model but with a few tricks you can implement a custom field control with a user control.

First, here is the base class used for the field control. It has a virtual property used to set the user control path. A property override for the value of the field which is read from the user control. On initialization it loads the user control and sets the context.

{% highlight csharp linenos %}
using System;
using System.Web.UI;
using Microsoft.SharePoint.WebControls;

namespace MyProject.Web.UI.FieldControls
{
    public abstract class UserControlFieldBase : BaseFieldControl
    {

        private SPFieldUserControlBase _usercontrol;

        public virtual string UserControlPath { get; set; }

        public override object Value
        {
            get
            {
                return _usercontrol == null ? base.Value : _usercontrol.Value;
            }
            set
            {
                base.ItemFieldValue = value;
            }
        }

        public UserControlFieldBase() : base()
        {
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            UserControlPath = null;
        }

        protected override void CreateChildControls()
        {
            Controls.Clear();
            base.CreateChildControls();

            if (!string.IsNullOrEmpty(UserControlPath))
            {
            _usercontrol = (SPFieldUserControlBase)Page.LoadControl(UserControlPath);
            _usercontrol.FieldControl = this;

            Controls.Add(_usercontrol);
        }
    }
}
{% endhighlight %}

Here's an example field control subclass. This class simply specifies the user control path and let's the base class handle all the details of loading the user control and setting the context. This is the server control that you will embed into you page layouts.

{% highlight csharp linenos %}
using System.Web.UI;
namespace MyProject.Web.UI.FieldControls
{
    public class MyFieldContol : UserControlFieldBase
    {
        public override string UserControlPath
        {
            get
            {
            return "~/_controltemplates/MyFieldControl.ascx";
            }
        }
    }
}
{% endhighlight %}

Next, is the abstract base class for the user control. This class provides a property for a reference to the parent field control and an abstract property for the field value. The field control property is important because our user control will need to know all the information about the field it is attached to. This includes the SPField context and control mode among other things.

{% highlight csharp linenos %}
using System.Web.UI;

namespace MyProject.Web.UI.FieldControls
{
    public abstract class SPFieldUserControlBase : UserControl
    {
        protected SPFieldUserControlBase();

        public BaseFieldControl FieldControl { get; set; }
        public abstract object Value { get; }
    }
}
{% endhighlight %}

Lastly you can create a user control that inherits from the SPFieldUserControlBase class and implement the specific UI that is necessary for you field control to function. See my pervious post on how to create a custom field control for further direction on creating field controls from scratch.
This technique also you to have easiest possible development process while leveraging the SharePoint field control infrastructure. Any questions or comments, please let me know!

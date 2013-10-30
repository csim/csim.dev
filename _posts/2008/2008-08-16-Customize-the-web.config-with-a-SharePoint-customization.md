---
title: "Customize the web.config with a SharePoint XML customization"
layout: post
topics: [ "SharePoint" ]
---

It is possible to manipulate the web.config file globally by using a little known feature in SharePoint that allows developers to describe a set of changes by using an XML customization file. In fact, both SharePoint and MOSS use this mechanism to publish web.config changes when a web application is created.

### Create the customization file 
The customization file is used by SharePoint to apply changes to the web.config file when a web application is created. Any changes that are inside the customization file will be applied to all web applications globally. This method of customization does not work for cases where you would like to apply web.config changes to only a specific web application. 

In this case I am adding a custom HttpModule to the web.config file. The web.config node will be appended as a child to the configuration/system.web/httpModules node. The id attribute needs to be unique. Everything inside the add node will be appened as a child to the node specified in the path attribute. 

{% highlight xml linenos %}
<?xml version="1.0" encoding="utf-8" ?>
<actions>

	<add path="configuration/system.web/httpModules" 
		id="{8DD2A7B1-0223-4be8-B1B5-339B642EFB21}">
		<add name="MyHttpModule" 
		type="MyHttpModule, MyAssembly, Version=1.0.0.0, Culture=neutral, PublicKeyToken=a1df43608d33992f" />
	</add>

</actions>
{% endhighlight %}

### Copy the customization file to the web front-end 
The xml customization file needs to be placed the <sharepoint install root>\12\Config directory and it needs to be named webconfig.<custom name>.xml where <custom name> is a name specified to your customization. 

You can take a look at the 12\Config directory to see examples of web.config customizations that are applied by SharePoint and MOSS. You will see that you can not only add nodes to the web.config but also remove or update nodes that exist in the web.config file. 

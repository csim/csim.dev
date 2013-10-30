---
title: "How to add your last tweet to your blog"
layout: post
categories: [ "Programming" ]
---

I thought it would be nice to see my last tweet on my blog. It turns out that there is an easy way to do this using jquery and the twitter api. These instructions may not work for you if your blogging platform does not allow embedded JavaScript (wordpress.com does not).

To get the tweets for any user in JSON format you can visit http://api.twitter.com/1/statuses/user_timeline/username.json?callback=?

Where username is the twitter username.

Make sure that you first have jquery included in your page like this:

{% highlight xml linenos %}
	<script src="http://code.jquery.com/jquery-1.6.2.min.js"></script>
{% endhighlight %}

Then add this script to pull the last tweet for a username:

{% highlight javascript linenos %}
<script type="text/javascript">
    $(document).ready(function() {
	    var u = 'techhike';
	    var url = 'http://api.twitter.com/1/statuses/user_timeline/'
			    + u + '.json?callback=?';
	    $.getJSON(url, function(data) { 		
		    $("#tweet").html(data[0].text));
	    }); 
    });
</script>
{% endhighlight %}

Replace techhike with the twitter username that you are interested in.

Next add this markup to your page:

{% highlight html linenos %}
<div id="tweet"></div>
{% endhighlight %}

This will act as a container for your last tweet.

As an added bonus I decided to write a little javascript to convert URLs in the tweet to hyperlinks. This mimics the behavior on twitter.com. Also, I added a function that creates hyperlinks for twitter handles such as (@TechHike). This link points to the appropriate profile on twitter.com.

{% highlight csharp linenos %}
<script type="text/javascript">
    function urlize(input) {
	    var exp = /(\b(https?|ftp|file):\/\/([-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|]))/ig;
	    output = input.replace(exp,'<a href="$1">$3</a>');
	    return output;
    }
	
    function tweep(input) {
	    var exp = /(\@(\w+?)) /ig;
	    output = input.replace(exp,'<a href="http://www.twitter.com/$2">$1</a> ');
	    return output;
    }
</script>
{% endhighlight %}

The final javascript looks like this:

{% highlight javascript linenos %}
<script type="text/javascript">
    $(document).ready(function() { 	
	    var url = 'http://api.twitter.com/1/statuses/user_timeline/<username>.json?callback=?'
	    $.getJSON(url, function(data) { 		
		    $("#tweet").html(tweep(urlize(data[0].text))); 	
	    }); 
    });
</script>
{% endhighlight %}

Cheers!

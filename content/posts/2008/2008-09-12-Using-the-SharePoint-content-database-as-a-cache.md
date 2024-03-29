---
title: "Using the SharePoint content database as a cache"
date: "2008-09-12T08:00:00-08:00"
tags: [ "SharePoint", "Programming" ]
---

Data caching is a core concept in the web dominated world that we live in. The premise is that we should not have to go back to retrieve data from a data store for every single web request when the data is unchanged, thereby sharing data across web requests. This offers huge performance advantages because all latency related to data fetching, query processing and transmission is eliminated for requests that use the same data. In the SharePoint world this can be a very valuable technique when querying MOSS page libraries or any data stored in the content database. For high traffic sites, the performance of the SPQuery or SPSiteDataQuery api is not acceptable when executing queries for each request.

The most common data caching implementation is using the HttpContext.Cache collection. This is an ASP.NET facility that allows as an in-memory object cache associated with the ASP.NET application domain (w3wp.exe). For SharePoint applications this cache works great when caching can be scoped to the HttpContext. For applications that need caching that is not scoped based on the HttpContext it is necessary find a different solution. The most common case non-HttpContext caching would be any instance where you are consuming data outside of the ASP.NET context such as SPTimer jobs, stsadm commands, winform applications or console applications. For these cases it is not possible to use the HttpContext cache.

There are a few potential solutions to this problem including using the [HttpRuntime static cache](http://weblogs.asp.net/pjohnson/archive/2006/02/06/437559.aspx), but the best solution (in my opinion) is to use the SPSite instance as a data cache. The idea is that by using the SPSite.RootWeb.AllProperties hashtable, we can store cached data into the content database for later retrieval. This solves the HttpContext problem because for any application to operate it will need to have a SPSite object to provided context for it's operation no matter where it may be running. Because the SPSite object provides context, the data cache is always available.

Here's the class signatures for my implementation of SPSite data caching. By creating a subclass from this base you can implement application independent caching of any data type. [The full implement can be found here](http://code.google.com/p/rapid-tools/source/browse/trunk/Rapid.Tools/Domain/RapidCachedDataAdapterBase.cs).

<script src="https://gist.github.com/csim/10284798.js?file=RapidCachedDataAdapterBase.cs"></script>

Notes:

* **GetNativeData() is the only method you must override when creating a subclass.** GetNaiveData() provides data from the native datastore to feed the cache, it is called any time that data needs to be retrieved from the native data store.
* **Serialization to a string is necessary for all cached data types.** Since SPSite.RootWeb.AllProperties accepts only limited data types (date, int and string), it is necessary for us to convert our data into a string. My default the base class uses the standard XmlSerializer class. If you are caching a data type that is not xml serializable (such as Hashtable, Dictionary & DataTable) then you need to implement the Serialize() and Deserialize() method within your subclass. You can choose to serialize your data any way you like as long as it can be represented as a string.
* **The CacheTimeoutMinutes property determines how long the cached data will live.** An automatic refresh will be triggered when the timeout period expires. The timeout period is set to 20 minutes by default but you can override this in your subclass.
* **You need to handle cache invalidation when native data changes.** Cache invalidation is supported by the base class, but it is only called automatically if the cache expires due to a cache timeout. You will need to identify the cases where you would like to invalidate the cache and call InvalidateCache() at the appropriated time. Usually you would invalidate the cache when you detect that data has changed, such as when a user changes a list item. In this case you would need to have a feature receiver to detect the change and call InvalidateCache().
* **The CachedData property used for data access.** The CachedData property will either load the cache or retrieve the cache depending on the situation. You can use the CachedData property as the single access for data.
* **Using SPSite.RootWeb.AllProperties does carry a cost.** Because we need to load and manipulate an SPSite object, there is an implied cost associated with this approach. Anytime SPSite is loaded or saved SharePoint needs to communicate with the content database and that takes cycles. This is in sharp contrast to the HttpContext.Cache approach where all data is stored in memory. To mitigate this cost the base class uses the HttpContext.Items collection to cache data for each http request. This means that the SPSite object will only be loaded used once per request.

Here's a sample subclass:

<script src="https://gist.github.com/csim/10284798.js?file=RapidCachedDataAdapterBase2.cs"></script>

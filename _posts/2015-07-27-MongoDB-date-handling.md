---
title: MongoDB .Net Driver date handling
published: true
tags: 
  - MongoDB
  - Programming
---

I ran into an interesting situation when saving dated to MongoDB using the Mongo .Net driver (version 2.0).

When saving a date with [unspecified kind](https://msdn.microsoft.com/en-us/library/system.datetime.kind(v=vs.110).aspx), the driver would convert the date to a universal datetime. It appears that the driver will assume that a DateTime object with an unspecified kind is actually a local time, and convert it to universal time (UTC) before committing this value to the database.

In my particular case, my origin date was UTC and was read from SQL server. Because entity framework does not set the Kind property on DateTime fields, MongoDB assuming these dates were local and performed a conversion to UTC. (Arrghhh)

It took me a while to figure this out. You can imagine my befuddled process when date appears to be offset by my local timezone.

Moral of the story: if you are converting data from SQL Server to MongoDB, make sure to call .ToLocalTime() on all dates even if they are stored as UTC. This will set the DateTime kind to local and avoid an inadvertent conversion by MongoDB on commit. 

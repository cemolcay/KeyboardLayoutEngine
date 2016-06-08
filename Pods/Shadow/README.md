Shadow
===

A simple object for adding/removing shadows from your `CALayer`s or `UIView`s.  
You don't need to define or edit all shadow properties line by line anymore.

Install
----

#### CocoaPods

``` ruby
use_frameworks!
pod 'Shadow'
```

Usage
----

``` swift
// Create default shadow.
let shadow = Shadow()
// Add shadow
view.applyShadow(shadow: shadow)
// Remove shadow
view.applyShadow(shadow: nil)
```

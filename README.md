CRPixellatedView
=======================
Custom `UIView` subclass with a cool pixellated animation inspired by [Facebook's Slingshot][4].

[![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)](https://github.com/chroman/CRPixellatedView/blob/master/LICENSE)
[![Build Platform](https://cocoapod-badges.herokuapp.com/p/CRPixellatedView/badge.png)](http://cocoapods.org/?q=CRPixellatedView)
[![Build Version](https://cocoapod-badges.herokuapp.com/v/CRPixellatedView/badge.png)](http://cocoapods.org/?q=CRPixellatedView)
[![Build Status](https://travis-ci.org/chroman/CRPixellatedView.png?branch=master)](https://travis-ci.org/chroman/CRPixellatedView)

<img src="http://chroman.me/wp-content/uploads/2014/06/CRPixellatedView.gif" width="320">

Installation
-----

There are two options:

**CocoaPods**

* Add the dependency to your Podfile:
```ruby
platform :ios
pod 'CRPixellatedView'
...
```

* Run `pod install` to install the dependencies.

**Source files**

Just clone this repository or download it in zip-file. Then you will find source files under **CRPixellatedView** directory. Copy them to your project.

Usage
-----

To use CRPixellatedView, create a `CRPixellatedView`, configure and animate!

An example of making a CRPixellatedView:

```objc
CRPixellatedView *pixellatedView = [[CRPixellatedView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
pixellatedView.image = [UIImage imageNamed:@"Image"];
[self.view addSubview:pixellatedView]; // Add to your view
[pixellatedView animate];
```

You can configure this settings, customizable example:

```objc
CRPixellatedView *pixellatedView = [[CRPixellatedView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
pixellatedView.image = [UIImage imageNamed:@"Image"];
pixellatedView.pixelScale = 20.0f;
pixellatedView.animationDuration = 0.8f;
[self.view addSubview:pixellatedView]; // Add to your view
[pixellatedView animateWithCompletion:^(BOOL finished) {
	NSLog(@"completed");
}];
```

Also, you can customize the effect using the `reverse` property:
```objc
CRPixellatedView *pixellatedView2 = [[CRPixellatedView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
pixellatedView.image = [UIImage imageNamed:@"Image"];
pixellatedView.pixelScale = 20.0f;
pixellatedView.animationDuration = 0.8f;
pixellatedView.reverse = YES; // Reverse effect
[self.view addSubview:pixellatedView2]; // Add to your view
[pixellatedView animateWithCompletion:^(BOOL finished) {
	NSLog(@"completed");
}
```

Example
----------

![CRPixellatedView-demo1](http://chroman.me/wp-content/uploads/2014/02/CRPixellatedView_demo1.gif)
<br/>
![CRPixellatedView-demo2](http://chroman.me/wp-content/uploads/2014/02/CRPixellatedView_demo2.gif)
<br/>
![CRPixellatedView-demo3](http://chroman.me/wp-content/uploads/2014/02/CRPixellatedView_demo3.gif)

Requirements
----------
* iOS 6.0 or higher for Objective-C.

## License
CRPixellatedView is released under the MIT license. See
[LICENSE](https://github.com/chroman/CRPixellatedView/blob/master/LICENSE).

Contact
----------

Christian Roman
  
[http://chroman.me][1]

[chroman16@gmail.com][2]

[@chroman][3] 

  [1]: http://chroman.me
  [2]: mailto:chroman16@gmail.com
  [3]: http://twitter.com/chroman
  [4]: https://itunes.apple.com/app/id878681557
#
#  Be sure to run `pod spec lint KeyboardLayoutEngine.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "KeyboardLayoutEngine"
  s.version      = "0.8.3"
  s.summary      = "⌨️ Simplest custom keyboard generator for iOS ever!"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
KeyboardLayoutEngine
===

⌨️ Simplest custom keyboard generator for iOS ever!

`KeyboardLayoutEngine` is all about laying out keyboard buttons dynamically in a rectangle in a custom style easily but in fashion of original keyboard. For the sake of flexiblity, KeyboardLayoutEngine provides:

* `KeyboardLayout`: For laying out rows with custom paddings, colors.
* `KeyboardRow`: For laying out buttons or another set of KeyboardRow's inside.
* `KeyboardButton`: For rendering buttons in rows. Also provides flexible width, type and other very useful API's for flexiblty.
* They are also `UIView`s and handles their layout in their `layoutSubviews` function.
* They are faster than autolayout yet they can adopt perfectly any `CGFrame` you want apply a keyboard layout.
* That means they are play very well with orientation changes. (Layout for size class and/or orientation support is on the way.)
* `KeyboardLayoutStyle`, `KeyboardRowStyle` and `KeyboardButtonStyle` structs handles pretty much everything about styling.
* `KeyboardLayoutDelegate` for inform about button presses.
* Also `DefaultKeyboard` provided out of box, a good start point for figuring out how it works other than being of fully functional original keyboard.

Install
----
#### CocoaPods

``` ruby
use_frameworks!
# Target Keyboard
pod 'KeyboardLayoutEngine'
```

Usage
----

* Describe your keyboard with custom styles, rows and buttons with either text or image in it.
* Checkout the [DefaultKeyboardLayout](https://github.com/cemolcay/KeyboardLayoutEngine/blob/master/Keyboard/DefaultKeyboard/DefaultKeyboardLayout.swift) for detailed usage.

``` swift
let keyboardLayout = KeyboardLayout(
style: DefaultKeyboardLayoutStyle,
rows: [
KeyboardRow(
style: DefaultKeyboardRowStyle,
characters: [
KeyboardButton(type: .Key("Q"), style: DefaultKeyboardKeyButtonStyle),
KeyboardButton(type: .Key("W"), style: DefaultKeyboardKeyButtonStyle),
KeyboardButton(type: .Key("E"), style: DefaultKeyboardKeyButtonStyle),
KeyboardButton(type: .Key("R"), style: DefaultKeyboardKeyButtonStyle),
KeyboardButton(type: .Key("T"), style: DefaultKeyboardKeyButtonStyle),
KeyboardButton(type: .Key("Y"), style: DefaultKeyboardKeyButtonStyle),
KeyboardButton(type: .Key("U"), style: DefaultKeyboardKeyButtonStyle),
KeyboardButton(type: .Key("I"), style: DefaultKeyboardKeyButtonStyle),
KeyboardButton(type: .Key("O"), style: DefaultKeyboardKeyButtonStyle),
KeyboardButton(type: .Key("P"), style: DefaultKeyboardKeyButtonStyle),
]
)
]
)

override func viewDidLoad() {
super.viewDidLoad()
view.addSubview(keyboardLayout)
}

override func viewDidLayoutSubviews() {
super.viewDidLayoutSubviews()
keyboardLayout.setNeedsLayout()
}
```

KeyboardLayoutDelegate
----

* Implement `KeyboardLayoutDelegate` for get information about the button presses.

``` swift
@objc public protocol KeyboardLayoutDelegate {
optional func keyboardLayoutDidStartPressingButton(keyboardLayout: KeyboardLayout, keyboardButton: KeyboardButton)
optional func keyboardLayoutDidPressButton(keyboardLayout: KeyboardLayout, keyboardButton: KeyboardButton)
}
```

KeyboardButtonWidth
----

``` swift
public enum KeyboardButtonWidth {
case Dynamic
case Static(width: CGFloat)
case Relative(percent: CGFloat)
}
```

* Laying out buttons in rows are important. Since rows can their child rows, calculating right sizes for buttons and rows done by button types.
* If you leave `.Dynamic` which is default by the way, every button in a row, it will calculate their width by `KeyboardRowStyle.buttonPadding` and total width of row and figure out equal widths with equal buttonPaddings.
* Static will be static width obviusly.
* Relative is an interesting one, which takes a value between [0, 1], fills percent of parent row, smartly calculated.

KeyboardButtonType
----

``` swift
public enum KeyboardButtonType {
case Key(String)
case Text(String)
case Image(UIImage?)
}
```

* A button can be `Key`, `Text` or `Image`.
* Key case might be useful for `textDocumentProxy.insertText`operation.
* Text case might be useful for buttons like "space", "return", "ABC", "123" or any string include emojis.
* Image case might be useful for buttons like "shift", "backspace", "switch keyboard" etc.

Styling
----

* Every style struct has their default values in taste of original keyboard.
* If you dont assign a value in `init` function of a style struct, it will be loaded with its default value.

KeyboardLayoutStyle
----
Definition:

``` swift
public struct KeyboardLayoutStyle {
public var topPadding: CGFloat
public var bottomPadding: CGFloat
public var rowPadding: CGFloat
public var backgroundColor: UIColor
}
```

Example:

``` swift
let DefaultKeyboardLayoutStyle = KeyboardLayoutStyle(
topPadding: 10,
bottomPadding: 5,
rowPadding: 13,
backgroundColor: UIColor(red: 208.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1))
```

KeyboardRowStyle
----

Definition:


``` swift
public struct KeyboardRowStyle {
public var leadingPadding: CGFloat
public var trailingPadding: CGFloat
public var buttonsPadding: CGFloat
}
```

Example:

``` swift
let DefaultKeyboardRowStyle = KeyboardRowStyle(
leadingPadding: 5,
trailingPadding: 5,
buttonsPadding: 6)
```

KeyboardButtonStyle
----

Definition:

``` swift
public struct KeyboardButtonStyle {
public var backgroundColor: UIColor
public var cornerRadius: CGFloat

// Border
public var borderColor: UIColor
public var borderWidth: CGFloat

// Shadow
public var shadowColor: UIColor
public var shadowOpacity: Float
public var shadowOffset: CGSize
public var shadowRadius: CGFloat
public var shadowPath: UIBezierPath?

// Text
public var textColor: UIColor
public var font: UIFont

// Image
public var imageSize: CGFloat?

// Popup
public var showsPopup: Bool
public var popupWidthMultiplier: CGFloat
public var popupHeightMultiplier: CGFloat
}
```

Example:

``` swift
let DefaultKeyboardDarkImageButtonStyle = KeyboardButtonStyle(
backgroundColor: UIColor(red: 180.0/255.0, green: 188.0/255.0, blue: 201.0/255.0, alpha: 1),
imageSize: 18,
showsPopup: false)
```

DefaultKeyboard
----

Default iOS Keyboard implementation with `KeyboardLayoutEngine`.

* Shift toggle mechanism
* Backspace mechanisim
* Key button popups
* `textDocumentProxy` integrations with `DefaultKeyboardDelegate`
* Ridiculusly easy implementation in `KeyboardViewController`
* Change default styles before initilze it and you have your fully functional custumised standard English QWERTY keyboard!

``` swift
override func viewDidLoad() {
super.viewDidLoad()
DefaultKeyboardLayoutStyle.backgroundColor = UIColor.redColor()
DefaultKeyboardRowStyle.buttonsPadding = 5
defaultKeyboard = DefaultKeyboard()
defaultKeyboard.delegate = self
view.addSubview(defaultKeyboard)
}
```

#### DefaultKeyboard styles

* DefaultKeyboardLayoutStyle: `KeyboardLayoutStyle`
* DefaultKeyboardRowStyle: `KeyboardRowStyle`
* DefaultKeyboardSecondRowStyle: `KeyboardRowStyle`
* DefaultKeyboardChildRowStyle: `KeyboardRowStyle`
* DefaultKeyboardSpaceButtonStyle: `KeyboardButtonStyle`
* DefaultKeyboardBackspaceButtonStyle: `KeyboardButtonStyle`
* DefaultKeyboardShiftButtonStyle: `KeyboardButtonStyle`
* DefaultKeyboardGlobeButtonStyle: `KeyboardButtonStyle`
* DefaultKeyboardReturnButtonStyle: `KeyboardButtonStyle`
* DefaultKeyboardNumbersButtonStyle: `KeyboardButtonStyle`
* DefaultKeyboardKeyButtonStyle: `KeyboardButtonStyle`

DefaultKeyboardDelegate
----

* Provides information about key and special button presses.

``` swift
@objc public protocol DefaultKeyboardDelegate {
optional func defaultKeyboardDidPressKeyButton(defaultKeyboard: DefaultKeyboard, key: String)
optional func defaultKeyboardDidPressSpaceButton(defaultKeyboard: DefaultKeyboard)
optional func defaultKeyboardDidPressBackspaceButton(defaultKeyboard: DefaultKeyboard)
optional func defaultKeyboardDidPressGlobeButton(defaultKeyboard: DefaultKeyboard)
optional func defaultKeyboardDidPressReturnButton(defaultKeyboard: DefaultKeyboard)
}
```
                   DESC

  s.homepage     = "https://github.com/cemolcay/KeyboardLayoutEngine"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "cemolcay" => "ccemolcay@gmail.com" }
  # Or just: s.author    = "cemolcay"
  # s.authors            = { "cemolcay" => "ccemolcay@gmail.com" }
  # s.social_media_url   = "http://twitter.com/cemolcay"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
  s.platform     = :ios, "8.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/cemolcay/KeyboardLayoutEngine.git", :tag => "0.8.3" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "Keyboard/KeyboardLayoutEngine/*.swift", "Keyboard/DefaultKeyboard/*.swift", "Keyboard/KeyPop/*.swift"

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  s.resources = "Keyboard/Resources.xcassets"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  s.framework  = "UIKit"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "Shadow"
  s.dependency "ManualLayout"

end

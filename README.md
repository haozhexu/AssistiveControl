HMYAssistiveControl
===================

UIControl subclass which mimics the behaviour of iOS Assistive Touch on screen button, fully customisable and extensible.

The project includes a demo showing an on-screen logging utility.

Usage:

There are two ways to create an assistive control:

```
+ (HMYAssistiveControl *)createOnView:(UIView *)view withCollapsedView:(UIView *)collapsedView andExpandedView:(UIView *)expandedView;
+ + (HMYAssistiveControl *)createOnMainWindowWithCollapsedView:(UIView *)collapsedView andExpandedView:(UIView *)expandedView
```

The first one creates an assistive control on specified view, using the specified views for collapsed mode and expanded mode, respectively; Whereas the second one does the same thing except the control is added to the main window of the app (ie. ```[[[UIApplication sharedApplication] delegate] window]```).

UILOG:

To illustrate how it can be used, a small demo has been added. HMYAssistiveLog is a logging utility that works like NSLog, but instead of printing log messages to console, it prints them to UI. The class provides single entries to the collapsed view and expanded view for HMYAssistiveControl, also a method for printing log messages.

A macro ```UIDLog``` is also ```#defined``` to help ease the process, it works the same way as NSLog:

```
UIDLog(@"detail", @"Button pressed");
UIDLog(@"list", @"Did select item at section %ld row %ld", (long)section, (long)row);
```

Collapsed view:
![Collapsed View][screenshot-1]

Collapsed view:
![Collapsed View][screenshot-2]

Expanded view showing all logs:
![Expanded view showing all logs][screenshot-3]

Expanded view showing logs in a channel:
![Expanded view showing logs in a channel][screenshot-4]

Expanded view showing logs in a channel:
![Expanded view showing logs in a channel][screenshot-5]

[screenshot-1]: http://www.huiimy.ninja/wp-content/uploads/2015/03/ss-01.png "Collapsed View"
[screenshot-2]: http://www.huiimy.ninja/wp-content/uploads/2015/03/ss-02.png "Collapsed View"
[screenshot-3]: http://www.huiimy.ninja/wp-content/uploads/2015/03/ss-03.png "Expanded view showing all logs"
[screenshot-4]: http://www.huiimy.ninja/wp-content/uploads/2015/03/ss-04.png "Expanded view showing logs in a channel"
[screenshot-5]: http://www.huiimy.ninja/wp-content/uploads/2015/03/ss-05.png "Expanded view showing logs in a channel"



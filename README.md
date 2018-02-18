AssistiveControl
===================

UIControl subclass which mimics the behaviour of iOS Assistive Touch on screen button, fully customisable and extensible.

There can be times that we need an app-wise control for purposes like, provide developer/tester a way to intercept with internals of an app, or give user a way to perform certain tasks regardless of which screen they look at, I found the iOS Assistive Touch feature is a great way of doing this, so I made this control, which essential does the same thing. A collapsed view and an expanded view can be specified, so that collapsed view is the floating control that can be made visible across the app, while expanded control is displayed when user taps on the control.

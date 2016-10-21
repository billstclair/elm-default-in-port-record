Elm version 0.17.1<br/>
macOS Sierra version 10.12<br/>
Opera 40.0.2308.81


This project is for elucidation of an Elm compiler bug.

Build index.js with:

```
elm make default-in-port-record.elm --output index.js
```

Then open ```index.html``` in your browser.

Cick the "Click Me" button once. Note that the "default" value increments.

Refresh your browser. You'll get a JavaScript runtime error in the function ```initWithFlags``` in index.js.

The problem is that "default" is a reserved word in JavaScript. The compiler correctly escapes it by prepending a "$" in most of the code, e.g. here's the compiler output for the ```update``` function:

```
var _user$project$Main$update = F2(
	function (msg, model) {
		var _p0 = msg;
		return {
			ctor: '_Tuple2',
			_0: _elm_lang$core$Native_Utils.update(
				model,
				{$default: model.$default + 1}),
			_1: _elm_lang$core$Platform_Cmd$none
		};
	});
```

The compiler does _not_ properly escape it, however in the code the converts it from Elm to JavaScript for saving (when you click the "Click Me" button and ```updateWithStorage``` invokes the ```setStorage``` port):

```
var _user$project$Main$setStorage = _elm_lang$core$Native_Platform.outgoingPort(
	'setStorage',
	function (v) {
		return {default: v.default};
	});
```

Red/System [
	Title:   "Demo"
	Author:  "Thomas Royko"
	File: 	 %BridgeInit.reds
	Tabs:	 4
	Rights:  "Copyright (C) 2015 Thomas Royko. All rights reserved."
	License: {
		Distributed under the Boost Software License, Version 1.0.
	}
]

bridge-init: function [
	ptr
] [

]

bridge-deinit: function [
    return: [integer!]
] [ 0 ] ;-- Placeholder

#export [bridge-init bridge-deinit]
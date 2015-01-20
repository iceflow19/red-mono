Red/System [
	Title:   "Mono bridge"
	Author:  "Thomas Royko"
	File: 	 %MonoAPI.reds
	Tabs:	 4
	Rights:  "Copyright (C) 2015 Thomas Royko. All rights reserved."
	License: {
		Distributed under the Boost Software License, Version 1.0.
	}
]

#define func-ptr!			integer!
#define mono-domain!		int-ptr!
#define mono-assembly!		int-ptr!
#define mono-image!			int-ptr!
#define mono-class!			int-ptr!
#define mono-method!		int-ptr!
#define mono-method-desc!	int-ptr!
#define mono-obj!			int-ptr!

#define mono-ptr! [struct! [mono [MonoAPI!]]]

MonoAPI!: alias struct! [
	;Mono Domain
	domain [mono-domain!]
	;Mono Assembly
	assembly [mono-assembly!]
	
	;Add internal call to mono (unmarhalled)
	add-internal-call [function! [
		name		[c-string!]
		handle		[func-ptr!]
	]]
]
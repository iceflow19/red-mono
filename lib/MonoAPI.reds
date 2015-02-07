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
#define mono-array!			int-ptr!
#define mono-bool!			integer!

#define mono-ptr! [struct! [mono [MonoAPI!]]]

MonoAPI!: alias struct! [
	;Mono Domain
	domain [mono-domain!]
	;Mono Assembly
	assembly [mono-assembly!]
	
	;Add internal call to mono (unmarshalled)
	add-internal-call [function! [
		name		[c-string!]
		handle		[func-ptr!]
	]]

	;Get the mono-image given a particular assembly
	assembly-get-image [function! [
		assembly [mono-assembly!]
		return:  [mono-image!]
	]]

	;Get the mono-class by name
	class-from-name [function! [
		image [mono-image!]
		namespace [c-string!]
		name [c-string!]
		return: [mono-class!]
	]]

	;Make a new method description
	method-desc-new [function! [
		name [c-string!]
		include-namespace [mono-bool!]
		return: [mono-method-desc!]
	]]

	;Search for a method in a class
	method-desc-search-in-class [function! [
		desc [mono-method-desc!]
		class [mono-class!]
		return: [mono-method!]
	]]

	;Search for a method in an image
	method-desc-search-in-image [function! [
		desc [mono-method-desc!]
		image [mono-image!]
		return: [mono-method!]
	]]

	;Invoke a method
	runtime-invoke [function! [
		method [mono-method!]
		obj [int-ptr!]
		params [struct! [dummy [int-ptr!]]]
		exception [struct! [dummy [mono-obj!]]]
		return: [mono-obj!]
	]]

	;Invoke and array method
	runtime-invoke-array [function! [
		method [mono-method!]
		obj [int-ptr!]
		params [mono-array!]
		exception [struct! [dummy [mono-obj!]]]
		return: [mono-obj!]
	]]

	;Get a thunk for a managed method
	method-get-unmanaged-thunk [function! [
		method [mono-method!]
		return: [int-ptr!]
	]]
]
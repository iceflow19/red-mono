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
	
	;Load mono config file
	config-parse [function! [
		config		[c-string!]
	]]
	
	;Get a unique domain to load an assembly
	jit-init [function! [
		name		[c-string!]
		return:		[mono-domain!]
	]]
	
	;jit-init with NET version
	jit-init-version [function! [
		name		[c-string!]
		version		[c-string!]
		return:		[mono-domain!]
	]]
	
	;Add internal call to mono (unmarhalled)
	add-internal-call [function! [
		name		[c-string!]
		handle		[func-ptr!]
	]]

	;Open an assembly in a domain
	domain-assembly-open [function! [
		domain		[mono-domain!]
		exe			[c-string!]
		return:		[mono-assembly!]
	]]

	;Execute assembly
	jit-exec [function! [
		domain		[mono-domain!]
		assembly	[mono-assembly!]
		argc		[integer!]
		argv		[struct! [item [c-string!]]]
		return:		[integer!]
	]]

	;Cleanup jit and shutdown
	jit-cleanup [function! [
		domain		[mono-domain!]
	]]

	;Set search directories for mono libraries
	set-dirs [function! [
		lib-dir		[c-string!]
		etc-dir		[c-string!]
	]]
	;Close assembly
	assembly-close [function! [
		assembly 	[mono-assembly!]
	]]
]
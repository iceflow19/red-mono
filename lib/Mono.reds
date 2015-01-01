Red/System [
	Title:   "Mono bridge"
	Author:  "Thomas Royko"
	File: 	 %Mono.reds
	Tabs:	 4
	Rights:  "Copyright (C) 2015 Thomas Royko. All rights reserved."
	License: {
		Distributed under the Boost Software License, Version 1.0.
	}
]

#include %MonoAPI.reds

#switch OS [
	Windows  [#define MONO_LIB_BOEHM "libmonoboehm-2.0.dll"]
	MacOSX   [#define MONO_LIB_BOEHM "libmonoboehm-2.0.dylib"]
	#default [#define MONO_LIB_BOEHM "libmonoboehm-2.0.so"] ;Linux and FreeBSD
]

#switch OS [
	Windows  [#define MONO_LIB_SGEN "libmonosgen-2.0.dll"]
	MacOSX   [#define MONO_LIB_SGEN"libmonosgen-2.0.dylib"]
	#default [#define MONO_LIB_SGEN "libmonosgen-2.0.so"] ;Linux and FreeBSD
]

;Select Garbage Collector
#define MONOLIB MONO_LIB_BOEHM
;#define MONOLIB MONO_LIB_SGEN

;==================================================
; Binding
;==================================================
_monobinding: context [
	#import [ MONOLIB cdecl [

		config-parse: "mono_config_parse" [
			value		[c-string!]]

		jit-init: "mono_jit_init" [
			name		[c-string!]
			return:		[mono-domain!]]

		jit-init-version: "mono_jit_init_version" [
			name		[c-string!]
			version		[c-string!]
			return:		[mono-domain!]]

		add-internal-call: "mono_add_internal_call" [
			name		[c-string!]
			function	[func-ptr!]]

		domain-assembly-open: "mono_domain_assembly_open" [
			domain		[mono-domain!]
			exe			[c-string!]
			return:		[mono-assembly!]]

		jit-exec: "mono_jit_exec" [
			domain		[mono-domain!]
			assembly	[mono-assembly!]
			argc		[integer!]
			argv		[struct! [item [c-string!]]]
			return:		[integer!]]

		jit-cleanup: "mono_jit_cleanup" [
			domain		[mono-domain!]]

		set-dirs: "mono_set_dirs" [
			lib-dir		[c-string!]
			etc-dir		[c-string!]]

		assembly-close: "mono_assembly_close" [
			assembly 	[mono-assembly!]]
	]]
]

;==================================================
; Binding Wrapper
;==================================================
_mono: context [
	
	config-parse: func [
		config		[c-string!]
	][
		_monobinding/config-parse config
	]

	jit-init: func [
		name		[c-string!]
		return:		[mono-domain!]
	][
		_monobinding/jit-init name
	]

	jit-init-version: func [
		name		[c-string!]
		version		[c-string!]
		return:		[mono-domain!]
	][
		_monobinding/jit-init-version name version
	]

	add-internal-call: func [
		name		[c-string!]
		handle		[func-ptr!]
	][
		_monobinding/add-internal-call name handle
	]

	domain-assembly-open: func [
		domain		[mono-domain!]
		exe			[c-string!]
		return:		[mono-assembly!]
	][
		_monobinding/domain-assembly-open domain exe
	]

	jit-exec: func [
		domain		[mono-domain!]
		assembly	[mono-assembly!]
		argc		[integer!]
		argv		[struct! [item [c-string!]]]
		return:		[integer!]
	][
		_mono/jit-exec domain assembly argc argv
	]

	jit-cleanup: func [
		domain		[mono-domain!]
	][
		_monobinding/jit-cleanup domain
	]

	set-dirs: func [
		lib-dir		[c-string!]
		etc-dir		[c-string!]
	][
		_monobinding/set-dirs lib-dir etc-dir
	]

	assembly-close: func [
		assembly 	[mono-assembly!]
	][
		_monobinding/assembly-close assembly
	]
]

;==================================================
; Connection Between Wrapper and Public API
;==================================================
mono-ptr: declare mono-ptr!
mono-ptr/mono: declare MonoAPI!

with [ _mono ] [
	mono-ptr/mono/config-parse: :config-parse
	mono-ptr/mono/jit-init: :jit-init
	mono-ptr/mono/jit-init-version: :jit-init-version
	mono-ptr/mono/add-internal-call: :add-internal-call
	mono-ptr/mono/domain-assembly-open: :domain-assembly-open
	mono-ptr/mono/jit-exec: :jit-exec
	mono-ptr/mono/jit-cleanup: :jit-cleanup
	mono-ptr/mono/set-dirs: :set-dirs
	mono-ptr/mono/assembly-close: :assembly-close
]
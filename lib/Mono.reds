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
; VM Binding
;==================================================
monovm: context [
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

_mono: context [

	;==================================================
	; API Binding
	;==================================================
	#import [ MONOLIB cdecl [

		_add-internal-call: "mono_add_internal_call" [
			name		[c-string!]
			function	[func-ptr!]]

		_assembly-get-image: "mono_assembly_get_image" [
			assembly [mono-assembly!]
			return:  [mono-image!]]

		_class-from-name: "mono_class_from_name" [
			image [mono-image!]
			namespace [c-string!]
			name [c-string!]
			return: [mono-class!]]

		_method-desc-new: "mono_method_desc_new"[
			name [c-string!]
			include-namespace [mono-bool!]
			return: [mono-method-desc!]]

		_method-desc-search-in-class: "mono_method_desc_search_in_class" [
			desc [mono-method-desc!]
			class [mono-class!]
			return: [mono-method!]]

		_method-desc-search-in-image: "mono_method_desc_search_in_image" [
			desc [mono-method-desc!]
			image [mono-image!]
			return: [mono-method!]]

		_runtime-invoke: "mono_runtime_invoke" [
			method [mono-method!]
			obj [int-ptr!]
			params [struct! [dummy [int-ptr!]]]
			exception [struct! [dummy [mono-obj!]]]
			return: [mono-obj!]]

		_runtime-invoke-array: "mono_runtime_invoke_array" [
			method [mono-method!]
			obj [int-ptr!]
			params [mono-array!]
			exception [struct! [dummy [mono-obj!]]]
			return: [mono-obj!]]

		_method-get-unmanaged-thunk: "mono_method_get_unmanaged_thunk" [
			method [mono-method!]
			return: [int-ptr!]]
	]]

	;==================================================
	; API Binding Wrappers
	;==================================================
	add-internal-call: func [
		name		[c-string!]
		handle		[func-ptr!]
	][
		_add-internal-call name handle
	]

	assembly-get-image: func [
		assembly [mono-assembly!]
		return:  [mono-image!]
	][
		_assembly-get-image assembly
	]

	class-from-name: func [
		image [mono-image!]
		namespace [c-string!]
		name [c-string!]
		return: [mono-class!]
	][
		_class-from-name image namespace name
	]

	method-desc-new: func [
		name [c-string!]
		include-namespace [mono-bool!]
		return: [mono-method-desc!]
	][
		_method-desc-new name include-namespace
	]

	method-desc-search-in-class: func [
		desc [mono-method-desc!]
		class [mono-class!]
		return: [mono-method!]
	][
		_method-desc-search-in-class desc class
	]

	method-desc-search-in-image: func [
		desc [mono-method-desc!]
		image [mono-image!]
		return: [mono-method!]
	][
		_method-desc-search-in-image desc image
	]

	runtime-invoke: func [
		method [mono-method!]
		obj [int-ptr!]
		params [struct! [dummy [int-ptr!]]]
		exception [struct! [dummy [mono-obj!]]]
		return: [mono-obj!]
	][
		_runtime-invoke method obj params exception
	]

	runtime-invoke-array: func [
		method [mono-method!]
		obj [int-ptr!]
		params [mono-array!]
		exception [struct! [dummy [mono-obj!]]]
		return: [mono-obj!]
	][
		_runtime-invoke-array method obj params exception
	]

	method-get-unmanaged-thunk: func [
		method [mono-method!]
		return: [int-ptr!]
	][
		_method-get-unmanaged-thunk method
	]
]

;==================================================
; Connection Between Wrapper and Public API
;==================================================
mono-ptr: declare mono-ptr!
mono-ptr/mono: declare MonoAPI!

with [ _mono ] [
	mono-ptr/mono/add-internal-call: :add-internal-call
	mono-ptr/mono/assembly-get-image: :assembly-get-image
	mono-ptr/mono/class-from-name: :class-from-name
	mono-ptr/mono/method-desc-new: :method-desc-new
	mono-ptr/mono/method-desc-search-in-class: :method-desc-search-in-class
	mono-ptr/mono/method-desc-search-in-image: :method-desc-search-in-image
	mono-ptr/mono/runtime-invoke: :runtime-invoke
	mono-ptr/mono/runtime-invoke-array: :runtime-invoke-array
	mono-ptr/mono/method-get-unmanaged-thunk: :method-get-unmanaged-thunk
]
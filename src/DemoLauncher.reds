Red/System []

#include %../lib/Mono.reds

;Has to be done on Windows
#if OS = 'Windows [
	#define MONORT_LIB_DIR "C:\Program Files (x86)\Mono-3.2.3\lib\"
	#define MONORT_ETC_DIR "C:\Program Files (x86)\Mono-3.2.3\etc"
]

#define NET_USER_ASSEM "test.exe"
#define MONO_DOMAIN_NAME "Managed"

;Init Mono VM
mono-ptr/mono/config-parse null
#if OS = 'Windows [
	mono-ptr/mono/set-dirs MONORT_LIB_DIR MONORT_ETC_DIR
]

;Prep and open assembly
mono-ptr/mono/domain:   mono-ptr/mono/jit-init-version MONO_DOMAIN_NAME "v4.0.30128"
mono-ptr/mono/assembly: mono-ptr/mono/domain-assembly-open mono-ptr/mono/domain NET_USER_ASSEM

;Overwrite first arg with assembly name to satisfy mono
args: system/args-list
args: args + 1
args/item: NET_USER_ASSEM
if system/args-count < 2 [
	system/args-count: system/args-count + 1
]

_monobinding/jit-exec mono-ptr/mono/domain mono-ptr/mono/assembly system/args-count - 1 system/args-list + 1
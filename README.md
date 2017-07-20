# RATIONALE

Common `ffi` definitions are not easily reloadable. So, for writing reloadable code we need to have some workarounds:

1. Type cdefs are not reloadable at all.
2. Functions cdefs are reloadable, but they polluting memory
3. ctype metatypes are permament.

For type cdefs we check if that type already loaded. If type want metatable, then we create a wrapper metatable, that allows us to reload code without modifying the ctype

# METHODS

## `typedef(type,cdef,metatype)`

Create a type, that defined by cdef. Set ffi.metatype to wrapped metatype

## `fundef(type,cdef)`

Create a function definition with name type and defined by cdef

# SYNOPSIS

```lua
local ffi = require 'ffi.reloadable'

-- create some table and functions
local buf = {}
local function bin_buf_free(...) ... end
local function bin_buf_str(...) ... end

-- create ctype, based on struct and empowered with metatable
local bbuf = ffi.typedef('bin_buf',[[
    typedef struct bin_buf {
        char  *buf;
        size_t cur;
        size_t len;
    } bin_buf;
]], {
    __gc = bin_buf_free;
    __index = buf;
    __tostring = bin_buf_str;
})

-- define a function, if it was not defined yet
ffi.fundef('malloc',  [[ void * malloc(size_t size); ]])

-- All of the ffi methods are inherited
local C = ffi.C
print(ffi.typeof('bin_buf'))
--- so on...

```

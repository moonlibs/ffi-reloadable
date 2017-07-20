do
	-- some module
	local ffi = require 'ffi.reloadable'

	local t = ffi.typedef('mystruct',[[
		typedef struct mystruct {
			int i;
			char c;
		} mystruct;
	]], {
		__tostring = function() return "xxx" end
	})

	ffi.cdef[[ void free(void *); ]]

	local v = t()
	print(v)

end

-- time passes
-- reload required

package.loaded['ffi.reloadable'] = nil

-- and loading everything again

do
	-- load the module again, with another params
	local ffi = require 'ffi.reloadable'

	local t = ffi.typedef('mystruct',[[
		typedef struct mystruct {
			int i;
			char c;
		} mystruct;
	]], {
		__tostring = function() return "yyy" end
	})

	local v = t()
	print(v)

end

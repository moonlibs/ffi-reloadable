local M = {}
local ffi = require 'ffi'

setmetatable(M,{__index = ffi})

local allmethods
if not rawget(_G,'\0__FFI_RELOADABLE__') then
	allmethods = {}
	rawset(_G,'\0__FFI_RELOADABLE__', allmethods)
else
	allmethods = rawget(_G,'\0__FFI_RELOADABLE__')
end

function M.typedef(t,def,meta)
	local tid
	if not pcall(ffi.typeof,t) then
		-- print("create new type "..t)
		local r,e = pcall(ffi.cdef,def)
		if not r then error(e,2) end
		if meta then
			tid = ffi.typeof(t)
			local typeno = tonumber(tid)
			local mymethods = {}
			local mymeta = {}
			for mm,v in pairs(meta) do
				mymethods[mm] = v;--function() print("dummy method ",mm) return nil end
				if mm == '__index' then
					mymeta[mm] = function(self,k)
						if type(mymethods[mm]) == 'function' then
							return mymethods[mm](self,k)
						else
							return mymethods[mm][k]
						end
					end
				else
					mymeta[mm] = function(...)
						return mymethods[mm](...)
					end
				end
			end
			allmethods[typeno] = mymethods
			ffi.metatype(tid,mymeta)
		end
	else
		-- print("reuse existing type "..t)
		tid = ffi.typeof(t)
		if meta then
			local typeno = tonumber(tid)
			local mymethods = allmethods[typeno]
			for k,v in pairs(meta) do
				if mymethods[k] then
					mymethods[k] = v
				else
					error("Can't inject new metamethod "..k.." into existing "..t..". Restart required",2)
				end
			end
		end
	end
	return tid
end

function M.fundef(n,def,src)
	src = src or ffi.C
	local f = function(src,n) return src[n] end
	if not pcall(f,src,n) then
		local r,e = pcall(ffi.cdef,def)
		if not r then error(e,2) end
	end
	local r,e = pcall(f,src,n)
	if not r then
		error(e,2)
	end
	return r
end

return M

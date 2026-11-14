local ltBase = class("lbBase")
function ltBase:ctor()
end
function ltBase:init()
end
function ltBase:getProperty(t, key, property)
	if not key or not property then
		return
	end
	local object = "table" == type(t) and t[key]
	if object then
		local value = object[property]
		if not value and value == nil then
			print("not found the property:", property)
			return
		end
		return value
	else
		print("not found the object: key = ", key)
	end
end
return ltBase

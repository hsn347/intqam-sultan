local modelBase = class("modelBase")
function modelBase:ctor(property)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	self:initProperty(property)
end
function modelBase:initProperty(property)
	if not self.init and property then
		self.property = clone(property)
		self.init = true
	end
end
function modelBase:setProperty(key, value)
	if self.property[key] ~= nil and value ~= nil then
		self.property[key] = value
	elseif self[key] ~= nil and value ~= nil then
		self[key] = value
	end
end
function modelBase:getProperty(key)
	if key then
		return self.property[key]
	end
end
function modelBase:setProperties(properties)
	if "table" ~= type(properties) then
		return
	end
	for key, value in pairs(properties) do
		if self.property[key] ~= nil then
			self.property[key] = value
		end
	end
end
function modelBase:getProperties(keys)
	if not keys then
		return self.property
	end
	local _ENV, ret = self.property, self.property
	for _, key in ipairs(keys) do
		ret[key] = self:getProperty(key)
	end
	return ret
end
function modelBase:addProperty(key, default)
	if key and default ~= nil and self.property[key] ~= nil then
		self.property[key] = default
	end
end
function modelBase:removeProperty(key)
	if key then
		self.property[key] = nil
	end
end
function modelBase:dump(title)
	title = title or self.__cname
	print("\n")
end
return modelBase

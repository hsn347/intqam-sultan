local Registry = requireLocal(".Registry")
local _ENV, GameObject = ".Registry", ".Registry"
function GameObject.extend(target)
	target.componentsArray_, Registry, target.components_, Registry = nil, nil, nil, nil
	function target:checkComponent(name)
		return self.components_[name] ~= nil
	end
	function target:addComponent(componentName, name, ...)
		local component = Registry.newObject(componentName, ...)
		local cName = name or componentName
		self.components_[cName] = component
		self.componentsArray_[#self.componentsArray_ + 1] = component
		component:bind_(self)
		return component
	end
	function target:removeComponent(name)
		local component = self.components_[name]
		if component then
			component:unbind_()
		end
		self.components_[name] = nil
		for k, v in ipairs(self.componentsArray_) do
			if v == component then
				table.remove(self.componentsArray_, k)
				break
			end
		end
	end
	function target:getComponent(name)
		return self.components_[name]
	end
	return target
end
return GameObject

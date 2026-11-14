local pageObject = class("pageObject")
function pageObject:ctor()
	self.pages, _UPVALUE0_ = nil, nil
end
function pageObject:createObjectByPage(pageID)
end
function pageObject:delObject(object)
end
function pageObject:delObjectByPage(page)
	for _, v in pairs(page) do
		self:delObject(v)
	end
end
function pageObject:addObjectByPage(pageID, object)
	local page = self.pages[pageID]
	if page then
		page[object] = object
	else
		print("addObjectByPage not exit page", pageID)
	end
end
function pageObject:addPages(addPages)
	for _, k in pairs(addPages) do
		if self.pages[k] then
			self:delObjectByPage(self.pages[k])
			self.pages[k], _ENV = self, self
		else
			self.pages[k], _ENV = self, self
		end
		self:createObjectByPage(k)
	end
end
function pageObject:delPages(delPages)
	for _, k in pairs(delPages) do
		if self.pages[k] then
			self:delObjectByPage(self.pages[k])
			self.pages[k] = nil
		end
	end
end
function pageObject:clean()
	for k in pairs(self.pages) do
		self:delObjectByPage(k)
	end
	self.pages, _ENV = pairs(self.pages)
end
return pageObject

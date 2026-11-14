local pageObjectMgr = class("pageObjectMgr")
function pageObjectMgr:ctor(comInstance)
	self.pages, _ENV = nil, nil
	self.animateLayer = include("pageAnimate").new(comInstance)
	table.insert(self.pages, self.animateLayer)
end
function pageObjectMgr:addPages(addPages)
	for _, v in pairs(self.pages) do
		v:addPages(addPages)
	end
end
function pageObjectMgr:delPages(delPages)
	for _, v in pairs(self.pages) do
		v:delPages(delPages)
	end
end
return pageObjectMgr

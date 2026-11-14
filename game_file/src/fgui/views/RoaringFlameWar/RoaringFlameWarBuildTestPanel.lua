local roaringFlameWarRead = include("roaringFlameWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameWarBuildTestPanel = class("RoaringFlameWarBuildTestPanel", baseFguiPanel)
function RoaringFlameWarBuildTestPanel:ctor(...)
	self.isLRU = true
	RoaringFlameWarBuildTestPanel.super.ctor(self, ...)
	print("RoaringFlameWarBuildTestPanel:ctor", self.viewName)
end
function RoaringFlameWarBuildTestPanel:onInit()
	print("=======RoaringFlameWarBuildTestPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	local _ENV, tabsetArray = self.fields.List.setVirtual, self.fields.List.setVirtual
	for subType = 1, gWorldTypeServerDef.subTypeRoaringFlameWarGatewayCopy do
		local buildName = roaringFlameWarRead.getBuildName(subType)
		_ENV = handler(self, self.onItemRenderer)
		handler(self, self.onItemRenderer).title = buildName
		table.insert(tabsetArray, handler(self, self.onItemRenderer))
	end
	_ENV = (for index)
	;(1).defaultClick = 1
	;(1).tabsetArray = tabsetArray
	local (1).callback, param = handler(self, self.onClickTab), 1
	self.fields.com_TabW:initView(param)
end
function RoaringFlameWarBuildTestPanel:endShow()
	print("=======RoaringFlameWarBuildTestPanel:endShow")
end
function RoaringFlameWarBuildTestPanel:onClickTab(tag)
	self.curTag = tag
	local subType = tag
	self.objIdList = roaringFlameWarRead.getBuildIDListByType(subType)
	self.fields.List:setNumItems(#self.objIdList)
end
function RoaringFlameWarBuildTestPanel:onItemRenderer(index, obj)
	local objId = self.objIdList[index + 1]
	obj:initData(objId)
end
return RoaringFlameWarBuildTestPanel

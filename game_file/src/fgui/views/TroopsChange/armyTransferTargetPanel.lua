local armyChangeRead = include("armyChangeRead")
local basePanel = require("fgui.base.baseFguiPanel")
local armyTransferTargetPanel = class("armyTransferTargetPanel", basePanel)
function armyTransferTargetPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function armyTransferTargetPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "TroopsChange"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function armyTransferTargetPanel:onInit()
	self.param = self.proxy.param
	self.fields.Panel_bg:setTitle(i18n("armyExchange_text_004"))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
end
function armyTransferTargetPanel:onShow()
	_UPVALUE4_ = nil
	;(nil)[1] = "common_text_143"
	;(nil)[2] = "common_text_144"
	;(nil)[3] = "common_text_145"
	local (nil)[4], titles = "common_text_146", nil
	local armyChangeRead, tabsetArray = "common_text_143", "common_text_143"
	for index = 1, 4 do
		local armyList = armyChangeRead.getTargetArmyIDList(index + 3)
		if 0 < #armyList then
			armyChangeRead = nil
			;(nil).title = i18n(titles[index])
			;(nil).tag = index
			table.insert(tabsetArray, nil)
		end
	end
	armyChangeRead = (for index)
	;(1).defaultClick = tabsetArray[1].tag
	;(1).tabsetArray = tabsetArray
	local (1).callback, param = handler(self, self.onClickTab), 1
	self.fields.com_Tab:setTabNum(#tabsetArray, nil, true)
	self.fields.com_Tab:initView(param)
end
function armyTransferTargetPanel:onClickTab(tag)
	if self.tag == tag then
		return
	end
	self.tag = tag
	print("self.tag", self.tag)
	self:updatTaskScroll()
	self.fields.scroll:jumpToTop()
end
function armyTransferTargetPanel:updatTaskScroll()
	self.armyIdList = armyChangeRead.getTargetArmyIDList(self.tag + 3)
	dump(self.armyIdList, "self.armyIdList")
	self.fields.scroll:setNumItems(#self.armyIdList)
end
function armyTransferTargetPanel:chooseBack(armyId)
	if self.param.handler then
		self.param.handler(armyId)
	end
	self:close()
end
function armyTransferTargetPanel:onItemRenderer(index, object)
	object:initTargetData(self.armyIdList[index + 1], handler(self, self.chooseBack))
end
return armyTransferTargetPanel

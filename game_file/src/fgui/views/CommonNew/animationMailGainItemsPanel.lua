local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local MAX_SHOW_ITEMS = 12
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local animationMailGainItemsPanel = class("animationMailGainItemsPanel", baseFguiPanel)
function animationMailGainItemsPanel:ctor(...)
	self.super.ctor(self, ...)
	print("animationMailGainItemsPanel:ctor", self.viewName)
end
function animationMailGainItemsPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function animationMailGainItemsPanel:onInit()
	print("=======animationMailGainItemsPanel:onInit")
	self.showList, _ENV, self.itemList, _ENV, self.isHidePrePanel = print, print, print, print, false
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setAlignCenter(true)
	self.fields.List:setScale(0.1)
end
function animationMailGainItemsPanel:getMainUIBagPos()
	local mainUI = SoraDCurrentMainUI()
	if mainUI then
		local bag = mainUI:getMainUIBottomBag()
		local pos = bag:localToGlobal(cc.p(0, 0))
		local toPos = self:globalToLocal(cc.p(pos.x, pos.y))
		return toPos
	end
end
function animationMailGainItemsPanel:onItemRenderer(index, obj)
	obj:initData(self.showList[index + 1])
end
function animationMailGainItemsPanel:onShow()
	print("=======animationMailGainItemsPanel:onShow")
	SoraDPlaySound("uicontrol", 4)
	self.listPos = cc.p(self.fields.List:getPositionX(), self.fields.List:getPositionY())
	self.itemList = self.param.itemList
	if self.param.outpos then
		self.outpos = self.param.outpos
	else
		local bagPos = self:getMainUIBagPos()
		self.outpos = cc.p(bagPos and bagPos.x or self.listPos.x, self:getHeight() * math.max(1, 1136 / self:getHeight()) - 40)
	end
	self:initView()
end
function animationMailGainItemsPanel:initView()
	if #self.itemList < 1 then
		self:close()
		return
	end
	if #self.itemList > MAX_SHOW_ITEMS then
		for i = 1, MAX_SHOW_ITEMS do
			table.insert(self.showList, self.itemList[i])
		end
	else
		self.showList = self.itemList
	end
	self.fields.List:setNumItems(#self.showList)
	self.lastTime = self.param.lastTime or 0
	_UPVALUE3_ = nil
	_ENV = self.showList
	self.showList[1] = ffa.scaleTo(0.3, 1, 1)
	self.showList[2] = ffa.sineOut(ffa.moveTo(0.3, self.listPos.x, self.listPos.y - 200))
	self.showList[3] = ffa.sineOut(ffa.moveTo(0.3, self.listPos.x, self.listPos.y - 200))
	self.showList[4] = ffa.sineOut(ffa.moveTo(0.3, self.listPos.x, self.listPos.y - 200))
	self.showList[5] = ffa.sineOut(ffa.moveTo(0.3, self.listPos.x, self.listPos.y - 200))
	self.showList[6] = ffa.sineOut(ffa.moveTo(0.3, self.listPos.x, self.listPos.y - 200))
	self.showList[7] = ffa.sineOut(ffa.moveTo(0.3, self.listPos.x, self.listPos.y - 200))
	_ENV = ffa.sineOut(ffa.moveTo(0.3, self.listPos.x, self.listPos.y - 200))
	ffa.sineOut(ffa.moveTo(0.3, self.listPos.x, self.listPos.y - 200))[1] = ffa.scaleTo(0.4, 0.1, 0.1)
	ffa.sineOut(ffa.moveTo(0.3, self.listPos.x, self.listPos.y - 200))[2] = ffa.sineIn(ffa.moveTo(0.4, self.outpos))
	ffa.sineOut(ffa.moveTo(0.3, self.listPos.x, self.listPos.y - 200))[3] = ffa.sineIn(ffa.moveTo(0.4, self.outpos))
	ffa.sineOut(ffa.moveTo(0.3, self.listPos.x, self.listPos.y - 200))[4] = ffa.sineIn(ffa.moveTo(0.4, self.outpos))
	ffa.sineOut(ffa.moveTo(0.3, self.listPos.x, self.listPos.y - 200))[5] = ffa.sineIn(ffa.moveTo(0.4, self.outpos))
	;(nil)[1] = ffa.spawn(self.showList)
	;(nil)[2] = ffa.delay(0.3 + self.lastTime)
	;(nil)[3] = ffa.spawn(ffa.sineOut(ffa.moveTo(0.3, self.listPos.x, self.listPos.y - 200)))
	;(nil)[4] = ffa.callFunc(function()
		self:close()
	end)
	;(nil)[5] = ffa.callFunc(function()
		self:close()
	end)
	;(nil)[6] = ffa.callFunc(function()
		self:close()
	end)
	;(nil)[7] = ffa.callFunc(function()
		self:close()
	end)
	;(nil)[8] = ffa.callFunc(function()
		self:close()
	end)
	;(nil)[9] = ffa.callFunc(function()
		self:close()
	end)
	self.fields.List:runAction(ffa.seq(nil))
end
return animationMailGainItemsPanel

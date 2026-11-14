local baseFguiPanel = require("fgui.base.baseFguiPanel")
local gameMessageTimeInputPanel = class("gameMessageTimeInputPanel", baseFguiPanel)
function gameMessageTimeInputPanel:ctor(...)
	self.super.ctor(self, ...)
	print("gameMessageTimeInputPanel:ctor", self.viewName)
end
function gameMessageTimeInputPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function gameMessageTimeInputPanel:onInit()
	print("=======gameMessageTimeInputPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
	self.fields.List:addEventListener(fgui.UIEventType.ScrollEnd, handler(self, self.onScrollEnd))
	self.fields.List:setVirtualAndLoop()
	self.perCount = self.proxy.param.perCount
	self.low = self.proxy.param.low
	self.high = self.proxy.param.high
	self.flag = self.proxy.param.flag
	self.isCastleLv = self.proxy.param.isCastleLv
	self.curNum = self.proxy.param.curNum
	if self.proxy.param.handl then
		self:setCallBack(self.proxy.param.handl)
	end
end
function gameMessageTimeInputPanel:onShow()
	print("=======gameMessageTimeInputPanel:onShow")
	if self.isCastleLv then
		self:initAllianceLvData()
	else
		self:initData()
	end
	if self.curNum then
		local scrollIndex = 0
		for i, v in ipairs(self.numList) do
			if v == self.curNum then
				scrollIndex = i - 1
				self.num = v
			end
		end
		self.fields.List:scrollToView(math.max(scrollIndex - 1, 0))
	end
end
function gameMessageTimeInputPanel:initData()
	local per = self.perCount
	local lowNum = self.low
	local highNmum = self.high
	local dec = lowNum < highNmum and 1 or -1
	local _ENV, numList
	numList[1] = lowNum
	for i = 1, math.abs(math.ceil((highNmum - lowNum) / per)) do
		numList[i + 1] = lowNum + i * per * dec
	end
	self.numList = numList
	dump(numList, "数字")
	self.numStrList, _ENV = dump, dump
	for i, v in ipairs(numList) do
		table.insert(self.numStrList, string.format("%.2d", v))
	end
	self.num = lowNum
	self.fields.List:setNumItems(#self.numStrList)
end
function gameMessageTimeInputPanel:initAllianceLvData()
	local perCount = 1
	local _ENV, numList
	for i = 1, 40 do
		if i < 31 then
			table.insert(numList, i)
		else
			perCount = 9
			table.insert(numList, i + (i - 30) * perCount)
		end
	end
	dump(numList, "数字")
	self.numStrList, _ENV, self.numList = dump, dump, numList
	for i, v in ipairs(numList) do
		if 30 < i then
			_ENV = nil
			;(nil).lv = i - 30
			table.insert(self.numStrList, i18n("common_text_1948", nil))
		else
			table.insert(self.numStrList, string.format("%.2d", v))
		end
	end
	self.num = numList[1]
	self.fields.List:setNumItems(#self.numStrList)
end
function gameMessageTimeInputPanel:onItemRender(index, target)
	target:setString(self.numStrList[index + 1])
end
function gameMessageTimeInputPanel:onScrollEnd()
	local index = self.fields.List:childIndexToItemIndex(1)
	print("index", index)
	self.num = self.numList[index + 1]
end
function gameMessageTimeInputPanel:setCallBack(handl)
	self.closeCallBack = handl
end
function gameMessageTimeInputPanel:onHide()
	if self.closeCallBack then
		self.closeCallBack(self.num, self.flag)
	end
end
return gameMessageTimeInputPanel

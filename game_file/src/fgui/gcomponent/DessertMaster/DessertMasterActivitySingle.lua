local coffeeCraftsmanCtrl = SoraDGetCtrl("coffeeCraftsmanCtrl")
local coffeeCraftsmanRead = include("coffeeCraftsmanRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local DessertMasterActivitySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DessertMaster/DessertMasterActivitySingle", DessertMasterActivitySingle)
function DessertMasterActivitySingle:onInit()
	self.fields.Image_icon:addClickListener(handler(self, self.onClickIcon))
	self.fields.Label_countlDown:setTimeLast(function(strTime, time)
		self:updateTimeStatus(time)
		return strTime
	end)
	self.fields.Label_countlDown:setTimeEndListener(function()
	end)
	self.fields.Usm_appear:setBlendFunc(gl.ONE, gl.ONE)
	self.fields.Usm_steam:setBlendFunc(gl.ONE, gl.ONE)
	self.fields.Usm_appear:setCompleteCallback(function()
		self.fields.Usm_appear:setVisible(false)
	end)
end
function DessertMasterActivitySingle:setShowFlag()
	self.showFlag = true
end
function DessertMasterActivitySingle:showDisappearEffect()
	print("消失")
	self.transitions.appear:stop()
	self.transitions.disappear:play(function()
		print("消失结束")
		self:updateCoffee()
	end)
end
function DessertMasterActivitySingle:showAppearEffect()
	if self.showFlag then
		self:updateCoffee()
		print("self", self, self.index)
		self.transitions.appear:play(function()
			print("appear finish", self, self.index)
			self.showFlag = false
			self:updateCoffee()
		end)
		SoraDDelayCallOnce(self, function()
			self.fields.Usm_appear:play(false)
		end, 0.25)
	end
end
function DessertMasterActivitySingle:onClickIcon()
	SoraDPlaySound()
	local leftTime = coffeeCraftsmanCtrl:getLeftTime(self.index)
	if leftTime <= 0 then
		SoraDShowMsgTip(i18n("Dessertmaster_04"))
		return
	end
	_ENV = i18n("Dessertmaster_04")
	i18n("Dessertmaster_04").data = self._data
	i18n("Dessertmaster_04").index = self.index
	uiManager:show("DessertMasterTaste", i18n("Dessertmaster_04"))
end
function DessertMasterActivitySingle:onShow()
end
function DessertMasterActivitySingle:onDispose()
	SoraDManagerRemoveTimerByTarget(self)
end
function DessertMasterActivitySingle:initData(index)
	self.index = index
	self:updateCoffee()
end
function DessertMasterActivitySingle:updateCoffee()
	local index = self.index
	local data = coffeeCraftsmanCtrl:getSpecialCoffee(index)
	self._data = data
	local leftTime = coffeeCraftsmanCtrl:getLeftTime(index)
	if data and 0 < leftTime then
		local icon = coffeeCraftsmanRead:getCoffeeIcon(data.id)
		self.fields.Image_icon:setURL(icon)
	else
		self.fields.Image_icon:setURL("")
	end
	local show = not self.showFlag and data and 0 < leftTime
	local alpha = show and 1 or 0
	print("updateCoffee", index, show, alpha, self.showFlag, data, leftTime)
	self.fields.Label_countlDown:setVisible(show)
	self.fields.Label_cost:setVisible(show)
	self.fields.Usm_steam:setVisible(show)
	self:updateCount()
end
function DessertMasterActivitySingle:updateCount()
	local index = self.index
	local data = coffeeCraftsmanCtrl:getSpecialCoffee(index)
	local leftTime = coffeeCraftsmanCtrl:getLeftTime(index)
	if data and 0 < leftTime then
		local curNum = backpackCtrl:getItemCount(coffeeCraftsmanCtrl.SPOON_ID)
		local config = coffeeCraftsmanCtrl:getConfig(data.id)
		local needNum = config.itemNeed
		if curNum < needNum then
			self.fields.Label_cost:setString(string.format("%s/%d", fguiHelper.getColorString("#FF0000", curNum), needNum))
		else
			self.fields.Label_cost:setString(string.format("%d/%d", needNum, needNum))
		end
		self.lastRed = nil
		self.disappearTime = config.disappear
		self.fields.Label_countlDown:beginTime(leftTime)
	else
		self.fields.Label_countlDown:endTimeNoCauseEndCallBack()
	end
end
function DessertMasterActivitySingle:updateTimeStatus(time)
	local isRed = time <= self.disappearTime
	if self.lastRed == isRed then
		return
	end
	self.lastRed = isRed
	self.controllers.Ctrl_timeStatus:setSelectedIndex(isRed and 1 or 0)
end
return DessertMasterActivitySingle

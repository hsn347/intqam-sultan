local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local publicUtil = include("publicUtil")
local baseComponent = require("fgui.base.baseComponent")
local Button_cost2 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonNew/Button_cost2", Button_cost2)
function Button_cost2:onInit()
	self.fields.Text_gold:fixPos()
	self.fields.Icon_gold:fixPos()
	self.fields.Text_free:setString(i18n("common_text_049"))
end
function Button_cost2:onShow()
end
function Button_cost2:setCost(id, num, isTextShowHaveGold, isRevert)
	self.itemId = id
	local iconPng = publicRead.getIcon(id)
	self.fields.Icon_gold:setURL(iconPng)
	self:setCostNum(num, publicUtil.getCount(id), isTextShowHaveGold, isRevert)
end
function Button_cost2:setCost2(id, num, haveNum)
	self.itemId = id
	local iconPng = publicRead.getIcon(id)
	self.fields.Icon_gold:setURL(iconPng)
	self:setCostNum(num, haveNum)
end
function Button_cost2:setCostTitle(str)
	self.fields.Text_gold:setString(str)
end
function Button_cost2:setGoldColor(color)
	self.fields.Text_gold:setColor(color)
end
function Button_cost2:setCostNum(num, haveGold, isTextShowHaveGold, isRevert)
	if num == 0 then
		self.isEnough = true
		self.controllers.Ctrl_free:setSelectedIndex(1)
	else
		self.isEnough = haveGold and num <= haveGold
		self.controllers.Ctrl_free:setSelectedIndex(0)
		self.fields.Text_gold:setString(isTextShowHaveGold and string.format("%s/%s", isRevert and string.formatnumberthousands(num) or string.formatnumberthousands(haveGold), isRevert and string.formatnumberthousands(haveGold) or string.formatnumberthousands(num)) or num)
		self.fields.Icon_gold:setVisible(true)
		print(haveGold)
		self.controllers.Ctrl_status:setSelectedIndex((not haveGold or num <= haveGold) and 0 or 1)
	end
end
function Button_cost2:setNumTotal(needNum, total, color)
	self.controllers.Ctrl_free:setSelectedIndex(0)
	if total < needNum then
		needNum = fguiHelper.getColorString("#FF0000", needNum)
	else
		needNum = fguiHelper.getColorString(color or "#FFFFFF", needNum)
	end
	total = fguiHelper.getColorString(color or "#FFFFFF", "/" .. total)
	self.fields.Text_gold:setString(needNum .. total)
end
function Button_cost2:setNumTotal2(curNum, total, color)
	self.controllers.Ctrl_free:setSelectedIndex(0)
	if total <= curNum then
		curNum = fguiHelper.getColorString("#FFFFFF", string.formatnumberthousands(curNum))
	else
		curNum = fguiHelper.getColorString(color or "#FFFFFF", string.formatnumberthousands(curNum))
	end
	total = fguiHelper.getColorString("#FFFFFF", "/" .. string.formatnumberthousands(total))
	self.fields.Text_gold:setString(curNum .. total)
end
function Button_cost2:showRedPoint(isShow)
	self.fields.Label_reddot:setVisible(isShow)
end
function Button_cost2:setCostIcon(icon)
	self.fields.Icon_gold:setURL(icon)
end
function Button_cost2:setFreeTitle(freeTitle, freeIndex)
	self.fields.Text_free:setString(freeTitle)
	if freeIndex then
		self.controllers.Ctrl_free:setSelectedIndex(freeIndex)
	end
end
function Button_cost2:setGrayed(value)
	self.fields.btnBg:setGrayed(value)
end
function Button_cost2:setBeginTime(time, isStart)
	if not self.text_time then
		self.fields.Icon_gold:setURL("icon_hourglass.png")
		self.text_time = SoraDCreateTimerLabel(self, self.fields.Text_gold)
	end
	if isStart or isStart == nil then
		self.text_time:beginTime(time)
	end
end
function Button_cost2:checkItem(isTip)
	if self.isEnough then
		return true
	elseif isTip and self.itemId then
		_ENV = nil
		;(nil).item = publicRead.getName(self.itemId)
		SoraDShowMsgTip(i18n("common_text_1806", nil))
	end
	return false
end
return Button_cost2

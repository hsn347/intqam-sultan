local publicRead = include("publicRead")
local publicUtil = include("publicUtil")
local baseComponent = require("fgui.base.baseComponent")
local UI_Btn_cost = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Btn_cost", UI_Btn_cost)
fgui.register_extension("ui://CommonUI/UI_Btn_costMiddle", UI_Btn_cost)
function UI_Btn_cost:onInit()
	self.fields.Label_reddot:setVisible(false)
	self.fields.Text_free:setString(i18n("common_text_049"))
	self.fields.Text_gold:fixPos()
	self.fields.Icon_gold:fixPos()
end
function UI_Btn_cost:onShow()
end
function UI_Btn_cost:setCost(id, num)
	self.itemId = id
	self:setCostIcon(id)
	self:setCostNum(num)
	self:setIsEnough(num <= publicUtil.getCount(id))
end
function UI_Btn_cost:setCostIcon(id)
	if type(id) == "number" then
		self.fields.Icon_gold:setSpriteFrame(publicRead.getIcon(id))
	elseif type(id) == "string" then
		self.fields.Icon_gold:setSpriteFrame(id)
	end
end
function UI_Btn_cost:setCostNum(num)
	if type(num) == "number" then
		self.fields.Text_gold:setString(string.formatnumberthousands(num))
	elseif type(num) == "string" then
		self.fields.Text_gold:setString(num)
	end
end
function UI_Btn_cost:updateCostNum(num, id)
	local curNum = publicUtil.getCount(id)
	self.controllers.Ctrl_status:setSelectedIndex(0)
	publicUtil = nil
	;(nil).member = fguiHelper.getColorString(num <= curNum and "#FFFBD5" or "#BE2828", string.formatnumberthousands(curNum))
	;(nil).total = string.formatnumberthousands(num)
	self.fields.Text_gold:setString(i18n("common_text_155", nil))
end
function UI_Btn_cost:setBeginTime(time, isStart)
	if not self.text_time then
		self:setCostIcon("icon_hourglass.png")
		self.text_time = SoraDCreateTimerLabel(self, self.fields.Text_gold)
	end
	if isStart then
		self.text_time:beginTime(time)
	else
		self.text_time:setString(SoraDConvertSecondToString(time))
	end
end
function UI_Btn_cost:endTime()
	self.fields.Text_gold:endTime()
end
function UI_Btn_cost:setIsEnough(isEnough)
	self.isEnough = isEnough
	self.controllers.Ctrl_status:setSelectedIndex(isEnough and 0 or 1)
end
function UI_Btn_cost:setIsFree(isFree, title)
	self.controllers.Ctrl_free:setSelectedIndex(isFree and 1 or 0)
	if title then
		self.fields.Text_free:setString(title)
	end
end
function UI_Btn_cost:setBtnColorIndex(index)
	self.controllers.c1:setSelectedIndex(index)
end
function UI_Btn_cost:setGrayed(value)
	self.fields.btnBg:setGrayed(value)
end
function UI_Btn_cost:setTitleColor(color)
	self.fields.title:setColor(color)
end
function UI_Btn_cost:checkItem(isTip)
	if self.isEnough then
		return true
	elseif isTip and self.itemId then
		_ENV = nil
		;(nil).item = publicRead.getName(self.itemId)
		SoraDShowMsgTip(i18n("common_text_1806", nil))
	end
	return false
end
return UI_Btn_cost

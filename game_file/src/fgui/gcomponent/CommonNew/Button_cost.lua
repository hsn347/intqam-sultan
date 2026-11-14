local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local publicUtil = include("publicUtil")
local baseComponent = require("fgui.base.baseComponent")
local Button_cost = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonNew/Button_cost", Button_cost)
fgui.register_extension("ui://CommonNew/Button_snow", Button_cost)
fgui.register_extension("ui://Activity2112/Button_cost_snowman", Button_cost)
fgui.register_extension("ui://Activity2112/Button_cost_snowNight", Button_cost)
fgui.register_extension("ui://Ramadanstarlights/Button_cost_snowman", Button_cost)
fgui.register_extension("ui://Ramadanstarlights/Button_cost_snowNight", Button_cost)
fgui.register_extension("ui://StarryNightCarnival/Button_costStarry", Button_cost)
fgui.register_extension("ui://Activity_9001619/Button_cost_9001619", Button_cost)
fgui.register_extension("ui://CommonNew/Button_cost4", Button_cost)
function Button_cost:onInit()
	self.fields.Text_gold:fixPos()
	self.fields.Icon_gold:fixPos()
end
function Button_cost:onShow()
end
function Button_cost:setCost(id, num)
	local iconPng = publicRead.getIcon(id)
	self.fields.Icon_gold:setURL(iconPng)
	self:setCostNum(num, publicUtil.getCount(id))
end
function Button_cost:setCost2(id, num, haveNum)
	local iconPng = publicRead.getIcon(id)
	self.fields.Icon_gold:setURL(iconPng)
	self:setCostNum(num, haveNum)
end
function Button_cost:setCostDiscount(id, num, oriNum)
	local iconPng = publicRead.getIcon(id)
	self.fields.Icon_gold:setURL(iconPng)
	self:setCostNum(num, publicUtil.getCount(id))
	if self.fields.Text_oriPay and oriNum and oriNum ~= num then
		if self.controllers.c_dis then
			self.controllers.c_dis:setSelectedIndex(1)
		end
		self.fields.Text_gold:setPositionX(SoraDFIsRA() and 112 or 96)
		self.fields.Text_oriPay:setPositionX(SoraDFIsRA() and 52 or 156)
		self.fields.Text_oriPay:setString(string.formatnumberthousands(oriNum))
	else
		if self.controllers.c_dis then
			self.controllers.c_dis:setSelectedIndex(0)
		end
		self.fields.Text_gold:setPositionX(SoraDFIsRA() and 88 or 120)
	end
end
function Button_cost:setCostNum(num, haveGold, forceShowZero)
	if num == 0 and not forceShowZero then
		self.controllers.Ctrl_free:setSelectedIndex(1)
		self.fields.Text_free:setString(i18n("common_text_049"))
		self.fields.Icon_gold:setVisible(false)
		self.controllers.Ctrl_status:setSelectedIndex(0)
	else
		self.controllers.Ctrl_free:setSelectedIndex(0)
		self.fields.Text_gold:setString(string.formatnumberthousands(num))
		self.fields.Icon_gold:setVisible(true)
		self.controllers.Ctrl_status:setSelectedIndex((not haveGold or num <= haveGold) and 0 or 1)
	end
end
function Button_cost:setCostIcon(icon, scale)
	self.fields.Icon_gold:setURL(icon)
	if scale then
		self.fields.Icon_gold:setScale(scale)
	end
end
function Button_cost:setCostbg(bg)
	self.fields.btnBg:setURL(bg)
end
function Button_cost:setTitleColor(color)
	self.fields.title:setColor(color)
end
function Button_cost:setGoldColor(color)
	self.fields.Text_gold:setColor(color)
end
function Button_cost:setNumTotal(needNum, total, color)
	self.controllers.Ctrl_status:setSelectedIndex(total <= needNum and 0 or 1)
	if total < needNum then
		needNum = fguiHelper.getColorString("#FF0000", needNum)
	else
		needNum = fguiHelper.getColorString(color or "#FFFFFF", needNum)
	end
	total = fguiHelper.getColorString(color or "#FFFFFF", "/" .. total)
	self.fields.Text_gold:setString(needNum .. total)
end
function Button_cost:setNumTotal2(curNum, total, color)
	self.controllers.Ctrl_status:setSelectedIndex(total <= curNum and 0 or 1)
	if total <= curNum then
		curNum = fguiHelper.getColorString("#FFFFFF", string.formatnumberthousands(curNum))
	else
		curNum = fguiHelper.getColorString(color or "#FFFFFF", string.formatnumberthousands(curNum))
	end
	total = fguiHelper.getColorString("#FFFFFF", "/" .. string.formatnumberthousands(total))
	self.fields.Text_gold:setString(curNum .. total)
end
function Button_cost:setFree(title)
	self.controllers.Ctrl_free:setSelectedIndex(1)
	self.fields.Text_free:setString(title and title or i18n("common_text_049"))
	self.fields.Icon_gold:setVisible(false)
	self.controllers.Ctrl_status:setSelectedIndex(0)
end
function Button_cost:setBtnBgGray(flag)
	self.fields.btnBg:setGrayed(flag)
end
function Button_cost:setGrayed(value)
	self.fields.btnBg:setGrayed(value)
end
function Button_cost:setCostTitle(str)
	self.fields.Text_gold:setString(str)
end
function Button_cost:setBeginTime(time, isStart)
	if not self.text_time then
		self.fields.Icon_gold:setURL("icon_hourglass.png")
		self.text_time = SoraDCreateTimerLabel(self, self.fields.Text_gold)
	end
	if isStart or isStart == nil then
		self.text_time:beginTime(time)
	end
end
function Button_cost:endTime()
	if self.text_time then
		self.text_time:endTime()
	end
end
function Button_cost:setBtnColorIndex(index)
	self.controllers.c1:setSelectedIndex(index)
end
function Button_cost:setReddot(isVisible, num)
	if self.fields.Label_reddot then
		self.fields.Label_reddot:setVisible(isVisible)
		if num and 0 < num then
			self.fields.Label_reddot:setString(99 < num and "99+" or num)
		else
			self.fields.Label_reddot:setString("")
		end
	end
end
function Button_cost:getBtnCheck()
	return self.controllers.Ctrl_status:getSelectedIndex() == 0
end
function Button_cost:endGoldTimer()
	if self.fields.Text_gold.endTime then
		self.fields.Text_gold:endTime()
	end
end
function Button_cost:setGoldTimer(gold, time, totalTime)
	self.fields.Text_gold = SoraDCreateTimerLabel(self, self.fields.Text_gold)
	self.fields.Text_gold:setTimeUpdateListener(function(time)
		if time <= 0 then
			self.fields.Text_gold:endTime()
			self.fields.Text_gold:setString(0)
		else
			local realGold = math.ceil(gold * time / totalTime)
			self.fields.Text_gold:setString(realGold)
		end
	end)
	self.fields.Text_gold:beginTime(time)
end
function Button_cost:getWidget(widgetName)
	return self.fields[widgetName]
end
return Button_cost

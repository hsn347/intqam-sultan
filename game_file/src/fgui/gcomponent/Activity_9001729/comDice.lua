local activity_9001729_Ctrl = SoraDGetCtrl("activity_9001729_Ctrl")
local itemDesRead = include("itemDesRead")
local baseComponent = require("fgui.base.baseComponent")
local comDice = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity_9001729/comDice", comDice)
function comDice:onInit()
	self.itemID = 880201
	self.fields.Button_10:addClickListener(handler(self, self.onClick_Button_10))
	self.fields.Button_add:addClickListener(handler(self, self.onClick_Button_add))
	self.fields.Buttom_quation:addClickListener(handler(self, self.onClick_Buttom_quation))
	self.fields.Buttom_quation:setVisible(false)
	self.fields.Button_add:fixPos()
end
function comDice:onShow()
end
function comDice:onClick_Button_10(context)
	SoraDPlaySound()
	if self.isGold then
		if activity_9001729_Ctrl:getGoldDiceNum() > 0 then
			uiManager:show("Activity_9001729_GoldDice")
		else
		end
	elseif 0 < activity_9001729_Ctrl:getNormalDiceNum() or activity_9001729_Ctrl:isNextDiceFree() then
		activity_9001729_Ctrl:reqThrowDiceMsg()
	else
		_ENV = nil
		;(nil).name = itemDesRead.getName(self.itemID)
		SoraDShowMsgTip(i18n("Frosty_Market_text_19", nil))
		uiManager:show("Activity_9001729_Package")
	end
end
function comDice:onClick_Button_add(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001729_Package")
end
function comDice:onClick_Buttom_quation(context)
	SoraDPlaySound()
end
function comDice:initDice(isGold, data)
	self.isGold = isGold
	self.fields.Button_add:setVisible(not isGold)
	local num = 0
	if data then
		if isGold then
			if data.isGold then
				num = data.oldData.goldDiceNum - 1
			elseif data.eventType == gCrescentTreasureEventType.OPTION then
				num = data.oldData.goldDiceNum
			else
				num = activity_9001729_Ctrl:getGoldDiceNum()
			end
			local color = 0 < num and "#4CE61A" or "#FF0000"
			_ENV = nil
			;(nil).color = color
			self.fields.text_times:setString(i18n("common_text_096") .. SoraDWrapHtmlTagByStyle(num, nil))
		elseif data.isGold then
			num = activity_9001729_Ctrl:getNormalDiceNum()
			self.controllers.ctrlGold:setSelectedIndex(0)
			local color = 0 < num and "#4CE61A" or "#FF0000"
			_ENV = nil
			;(nil).color = color
			self.fields.text_times:setString(i18n("common_text_096") .. SoraDWrapHtmlTagByStyle(num, nil))
			if not isGold then
				if activity_9001729_Ctrl:isNextDiceFree() then
					_ENV = "common_text_049"
					;("common_text_049").color = "#4CE61A"
					self.fields.text_times:setString(SoraDWrapHtmlTagByStyle(i18n("common_text_049"), "common_text_049"))
				end
				if activity_9001729_Ctrl:isNextDice2x() then
					self.controllers.ctrl2x:setSelectedIndex(1)
				end
			end
		else
			num = activity_9001729_Ctrl:getNormalDiceNum()
			if data.oldData.isNextDouble then
				self.controllers.ctrl2x:setSelectedIndex(0)
			end
			local color = 0 < num and "#4CE61A" or "#FF0000"
			_ENV = SoraDWrapHtmlTagByStyle(i18n("common_text_049"), "common_text_049")
			SoraDWrapHtmlTagByStyle(i18n("common_text_049"), "common_text_049").color = color
			self.fields.text_times:setString(i18n("common_text_096") .. SoraDWrapHtmlTagByStyle(num, SoraDWrapHtmlTagByStyle(i18n("common_text_049"), "common_text_049")))
			if data.oldData.isNextFree and activity_9001729_Ctrl:isNextDiceFree() then
				_ENV = "common_text_049"
				;("common_text_049").color = "#4CE61A"
				self.fields.text_times:setString(SoraDWrapHtmlTagByStyle(i18n("common_text_049"), "common_text_049"))
			end
		end
	else
		self.controllers.ctrl2x:setSelectedIndex(0)
		if isGold then
			num = activity_9001729_Ctrl:getGoldDiceNum()
			self.controllers.ctrlGold:setSelectedIndex(1)
		else
			num = activity_9001729_Ctrl:getNormalDiceNum()
			self.controllers.ctrlGold:setSelectedIndex(0)
		end
		local color = 0 < num and "#4CE61A" or "#FF0000"
		_ENV = SoraDWrapHtmlTagByStyle(i18n("common_text_049"), "common_text_049")
		SoraDWrapHtmlTagByStyle(i18n("common_text_049"), "common_text_049").color = color
		self.fields.text_times:setString(i18n("common_text_096") .. SoraDWrapHtmlTagByStyle(num, SoraDWrapHtmlTagByStyle(i18n("common_text_049"), "common_text_049")))
		if not isGold then
			if activity_9001729_Ctrl:isNextDiceFree() then
				_ENV = "common_text_049"
				;("common_text_049").color = "#4CE61A"
				self.fields.text_times:setString(SoraDWrapHtmlTagByStyle(i18n("common_text_049"), "common_text_049"))
			end
			if activity_9001729_Ctrl:isNextDice2x() then
				self.controllers.ctrl2x:setSelectedIndex(1)
			end
		end
	end
end
return comDice

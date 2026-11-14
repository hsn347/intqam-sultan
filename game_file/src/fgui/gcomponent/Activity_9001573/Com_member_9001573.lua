local baseComponent = require("fgui.base.baseComponent")
local Com_member_9001573 = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
fgui.register_extension("ui://Activity_9001573/Com_member_9001573", Com_member_9001573)
function Com_member_9001573:onInit()
	self:fixChildrenPos()
	self.fields.Com_castleLv:fixChildrenPos()
	self.fields.btn_del:setTitle(i18n("Celestial_defense_text_066"))
	self.fields.btn_del:addClickEventListener(handler(self, self.onDelClick))
	self.fields.btn_add:addClickEventListener(handler(self, self.onAddClick))
	self.fields.txt_tip:setString(i18n("Celestial_defense_text_012"))
end
function Com_member_9001573:onShow()
end
function Com_member_9001573:initData(data)
	if data == nil then
		self.controllers.c1:setSelectedIndex(1)
		return
	end
	self.controllers.c1:setSelectedIndex(0)
	self.data = data
	self.fields.Text_name:setString(textParser.formatPlayerName(data.allianceAbbr, data.nickName))
	self.fields.Text_power:setString(string.formatnumberthousands(data.totalFc))
	self.fields.Com_castleLv:initData(data.cityLevel, data.starLv)
	self.fields.Com_head:setHeadSprite(data.headid or data.iconID, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	self.fields.btn_del:setVisible(activity_9001573_Ctrl:getIsManager())
end
function Com_member_9001573:onDelClick()
	SoraDPlaySound()
	if not activity_9001573_Ctrl:getIsManager() then
		SoraDShowMsgTip(i18n("Celestial_defense_text_010"))
	elseif not activity_9001573_Ctrl:getIsInPrepare() then
		SoraDShowMsgTip(i18n("Celestial_defense_text_011"))
	else
		activity_9001573_Ctrl:reqDismiss(self.data.uid)
	end
end
function Com_member_9001573:onAddClick()
	SoraDPlaySound()
	if not activity_9001573_Ctrl:getIsManager() then
		SoraDShowMsgTip(i18n("Celestial_defense_text_010"))
	elseif not activity_9001573_Ctrl:getIsInPrepare() then
		SoraDShowMsgTip(i18n("Celestial_defense_text_011"))
	else
		uiManager:show("Activity_9001573_Choose")
	end
end
return Com_member_9001573

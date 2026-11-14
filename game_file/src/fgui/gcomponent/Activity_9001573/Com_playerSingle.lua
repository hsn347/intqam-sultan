local baseComponent = require("fgui.base.baseComponent")
local Com_playerSingle = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
local constantRead = include("constantRead")
fgui.register_extension("ui://Activity_9001573/Com_playerSingle", Com_playerSingle)
function Com_playerSingle:onInit()
	self.fields.Text_powerLab:setString(i18n("common_text_090"))
	self.fields.Button_agree:addClickListener(handler(self, self.onClickBtnAgree))
	self.fields.Sprite_leader:setVisible(false)
	self.fields.Sprite_assembler:setVisible(false)
	self.fields.Button_agree:setVisible(false)
	self:fixChildrenPos()
	self.fields.Com_castleLv:fixChildrenPos()
end
function Com_playerSingle:onShow()
end
function Com_playerSingle:initData(data)
	self.data = data
	self:initNormalData(data)
	self.fields.Button_agree:setEnabled(true)
	local online = self.data.online
	dump(data, "Com_playerSingle:initData")
	if online == 0 then
		self.fields.Text_online:setString(i18n("common_text_224"))
		self.fields.Text_online:setColor(cc.c3b(0, 255, 66))
	else
		local time = math.max(60, online)
		self.fields.Text_online:setString(SoraDConverSecondToDate(time, false, true))
		self.fields.Text_online:setColor(cc.c3b(134, 127, 111))
	end
	self.fields.Button_agree:setVisible(true)
	self.fields.Button_agree:setString(i18n("common_text_687"))
end
function Com_playerSingle:initNormalData(data)
	self.fields.Text_name:setString(data.nickName)
	self.fields.Text_power:setString(string.formatnumberthousands(data.totalFc))
	_ENV = string.formatnumberthousands(data.totalFc)
	string.formatnumberthousands(data.totalFc).kid = data.kid
	self.fields.Text_kid:setString(i18n("common_text_342", string.formatnumberthousands(data.totalFc)))
	self.fields.Com_castleLv:initData(data.cityLevel, data.starLv)
	local lordLocalData = include("lordLocalData")
	self.fields.Image_bust:setURL(lordLocalData.getBust(data.headid))
end
function Com_playerSingle:onClickBtnAgree(...)
	SoraDPlaySound()
	local limit = constantRead.getConstValue("CELESTIAL_DEFENSE_COMMANDER", 0)
	if self.data.cityLevel < CASTLE_LV6_LIMITED then
		SoraDShowMsgTip(i18n("Celestial_defense_text_070"))
	elseif not activity_9001573_Ctrl:getIsActivityOpen() or not activity_9001573_Ctrl:getIsInPrepare() then
		SoraDShowMsgTip(i18n("Celestial_defense_text_011"))
	elseif limit <= activity_9001573_Ctrl:getCommanderNum() then
		SoraDShowMsgTip(i18n("Celestial_defense_text_072"))
	elseif activity_9001573_Ctrl:getIsCommander(self.data.uid) then
		SoraDShowMsgTip(i18n("Celestial_defense_text_068"))
	else
		activity_9001573_Ctrl:reqAppoint(self.data.uid)
		uiManager:close("Activity_9001573_Choose")
	end
end
return Com_playerSingle

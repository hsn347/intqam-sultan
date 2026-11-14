local activity_9001700_Read = include("activity_9001700_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_fireworkInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001700/Com_fireworkInfo", Com_fireworkInfo)
function Com_fireworkInfo:onInit()
	self.fields.Text_high:setString(i18n("common_text_1497"))
	self.fields.Text_send:setString(i18n("eid_fireworks_015"))
	self.fields.Button_send:setString(i18n("eid_fireworks_014"))
	self.fields.Button_send:addClickListener(handler(self, self.onClickBtnSend))
end
function Com_fireworkInfo:onShow()
end
function Com_fireworkInfo:onClickBtnSend(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).idx = self.idx
	uiManager:show("Activity_9001700_Send", nil)
end
function Com_fireworkInfo:initFireWorksInfo(bagType, idx, data)
	self.idx = idx
	if data.uid then
		self.controllers.c1:setSelectedIndex(1)
		local nickName = data.nickName or data.uid
		local playerName = textParser.formatPlayerName(nil, nickName, data.kid)
		_ENV = data.kid
		data.kid.color = "#70C723"
		playerName = SoraDWrapHtmlTagByStyle(playerName, data.kid)
		local nameStr = ""
		if bagType == 1 then
			nameStr = i18n("eid_fireworks_017") .. "\n" .. playerName
		else
			nameStr = playerName .. "\n" .. i18n("eid_fireworks_019")
		end
		self.fields.Text_name:setString(nameStr)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	local fireWorksID = data.saluteId
	self.fields.Com_firework:initFireWorksID(fireWorksID)
	local fireType = activity_9001700_Read.getFireWorksType(fireWorksID)
	if fireType == 1 then
		self.fields.Image_high:setVisible(false)
		self.fields.Text_high:setVisible(false)
	else
		self.fields.Image_high:setVisible(true)
		self.fields.Text_high:setVisible(true)
	end
end
return Com_fireworkInfo

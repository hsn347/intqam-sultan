local baseComponent = require("fgui.base.baseComponent")
local massSettingWhiteListCtrl = SoraDGetCtrl("massSettingWhiteListCtrl")
local Com_searchSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WorldMapMass/Com_searchSingle", Com_searchSingle)
function Com_searchSingle:onInit()
	self.fields.Button_send:addClickEventListener(handler(self, self.onClickSend))
	self.fields.Button_send:setTitle(i18n("shopping_text_10"))
end
function Com_searchSingle:onShow()
end
function Com_searchSingle:initData(data)
	dump(data, "Com_searchSingle:initData", 10)
	self.uid = data.uid
	self.fields.Button_send:setBright(true)
	self.fields.Button_send:setEnabled(true)
	self.fields.Com_head:setHeadSprite(data.iconID or data.headid, data.avatar or "")
	local kid = data.kid or otheData.kid
	local nameStr = textParser.formatPlayerName(data.abbr or data.allianceAbbr, data.nickName or data.playerName, kid)
	self.fields.Text_player:setString(nameStr)
end
function Com_searchSingle:onClickSend()
	SoraDPlaySound()
	if massSettingWhiteListCtrl:getIsInWhiteList(self.uid) then
		SoraDShowMsgTip(i18n("common_text_4903"))
		return
	end
	self.fields.Button_send:setBright(false)
	self.fields.Button_send:setEnabled(false)
	massSettingWhiteListCtrl:sendReqAdd(self.uid)
	uiManager:close("WorldMassSearch")
end
return Com_searchSingle

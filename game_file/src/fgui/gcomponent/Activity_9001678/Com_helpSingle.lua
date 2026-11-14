local activity_9001678_Read = include("activity_9001678_Read")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_helpSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001678/Com_helpSingle", Com_helpSingle)
function Com_helpSingle:onInit()
	self.frostyID = activity_9001678_Read.getFrostyMarketToolID()
	activity_9001678_Read = nil
	;(nil).num = ""
	self.fields.Text_save:setString(i18n("Frosty_Market_text_06", nil))
	self:fixChildrenPos()
end
function Com_helpSingle:onShow()
end
function Com_helpSingle:initData(data)
	self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	self.fields.Com_head:setKid(data.kid)
	self.fields.Text_name:setString(textParser.formatPlayerName(data.allianceAbbr, data.name))
	self.fields.Icon:setSpriteFrame(publicRead.getIcon(self.frostyID))
	self.fields.Text_num:setString(data.discount)
end
return Com_helpSingle

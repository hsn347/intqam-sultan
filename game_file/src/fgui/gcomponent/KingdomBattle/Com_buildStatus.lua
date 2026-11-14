local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_buildStatus = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://KingdomBattle/Com_buildStatus", Com_buildStatus)
function Com_buildStatus:onInit()
	self.fields.Text_none:setString(i18n("atlantiswar_text_0069"))
	self:fixChildrenPos()
end
function Com_buildStatus:onShow()
end
function Com_buildStatus:initData(cfg, buildingOwners, kingInfo, kid)
	self.fields.icon:setURL(cfg.towerIcon)
	local owerData = buildingOwners[tostring(cfg.index)]
	if owerData then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Com_head:setHeadSprite(owerData.iconID, owerData.avatar)
		self.fields.Com_head:setPlayerID(owerData.uid)
		self.fields.Com_head:setKid(owerData.hostKid)
		self.fields.Text_name:setString(textParser.formatPlayerName(owerData.abbr, owerData.name))
		self.fields.Lab_aInfo:setIcon(allianceDesRead.getFlagIcon(owerData.flag))
		self.fields.Lab_aInfo:setTitle(owerData.aName)
	elseif 0 < kingInfo.kingUid then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Com_head:setHeadSprite(kingInfo.kingIcon, kingInfo.kingAvatar)
		self.fields.Com_head:setPlayerID(kingInfo.kingUid)
		self.fields.Com_head:setKid(kid)
		self.fields.Text_name:setString(textParser.formatPlayerName(kingInfo.kingAbbr, kingInfo.kingName))
		self.fields.Lab_aInfo:setIcon(allianceDesRead.getFlagIcon(kingInfo.kingFlag))
		self.fields.Lab_aInfo:setTitle(kingInfo.kingAName)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
end
return Com_buildStatus

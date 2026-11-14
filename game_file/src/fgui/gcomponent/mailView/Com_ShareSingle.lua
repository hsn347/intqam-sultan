local baseComponent = require("fgui.base.baseComponent")
local Com_ShareSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://mailView/Com_ShareSingle", Com_ShareSingle)
function Com_ShareSingle:onInit()
	self:fixChildrenPos()
end
function Com_ShareSingle:onShow()
end
function Com_ShareSingle:initData(data, kingdomID)
	self.fields.Com_head:setVisible(false)
	self.fields.icon:setVisible(true)
	if data.channel == 1 or data.channel == 2 then
		self.fields.icon:setSpriteFrame(data.channel == 1 and "icon_position_world.png" or "icon_position_alliance.png")
		self.fields.title:setString(data.channel == 1 and i18n("common_text_070") or i18n("common_text_946"))
	elseif data.channel == gChatChannel.TEAM then
		local worldMapWarDef = include("worldMapWarDef")
		local fieldName = worldMapWarDef.getKingdomNameByKid(kingdomID) or ""
		local bg = worldMapWarDef.getPosFrameByKid(kingdomID)
		if bg then
			self.fields.icon:setSpriteFrame(bg)
		end
		_ENV = nil
		;(nil).var = fieldName
		self.fields.title:setString(i18n("position_share_01", nil))
	elseif data.chatChannel == gChatChannel.CHATROOM then
		self.fields.title:setString(data.serverMsg.chatroom.crName)
		self.fields.icon:setSpriteFrame("icon_position_chat.png")
	elseif data.chatChannel == gChatChannel.MAIL then
		self.fields.Com_head:setVisible(true)
		self.fields.icon:setVisible(false)
		self.fields.Com_head:setHeadSprite(data.customData.playerInfo.iconID, data.customData.playerInfo.avatar)
		self.fields.title:setString(include("chatDataParser").getChatMailTitle(data))
	end
end
function Com_ShareSingle:isTickSelect()
	return self.fields.Check_tick:isSelected()
end
return Com_ShareSingle

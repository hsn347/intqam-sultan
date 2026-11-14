local baseComponent = require("fgui.base.baseComponent")
local Com_ShareSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://WorldMap/Com_ShareSingle", Com_ShareSingle)
function Com_ShareSingle:onInit()
	self:fixChildrenPos()
end
function Com_ShareSingle:onShow()
end
function Com_ShareSingle:initData(data, kingdomID)
	self.fields.Com_head:setVisible(false)
	self.fields.icon:setVisible(true)
	if data.channel == gChatChannel.KINGDOM then
		if worldMapDefine.isInNebulaAllStar() then
			self.fields.icon:setSpriteFrame("icon_position_nebulaallstar.png")
			self.fields.title:setString(i18n("NebulaAllstar_187"))
		elseif worldMapDefine.isInRoaringFlame() then
			self.fields.icon:setSpriteFrame("icon_position_world.png")
			self.fields.title:setString(i18n("NebulaAllstar_187"))
		else
			self.fields.icon:setSpriteFrame("icon_position_world.png")
			self.fields.title:setString(i18n("common_text_070"))
		end
	elseif data.channel == gChatChannel.CAMP then
		self.fields.icon:setSpriteFrame("icon_position_world.png")
		if worldMapDefine.isInNebulaAllStar() then
			self.fields.title:setString(i18n("NebulaAllstar_186"))
		else
			self.fields.title:setString(i18n("nebula_war_text_0296"))
		end
	elseif data.channel == gChatChannel.ALLIANCE then
		self.fields.icon:setSpriteFrame("icon_position_alliance.png")
		self.fields.title:setString(i18n("common_text_946"))
	elseif data.channel == gChatChannel.TEAM then
		if worldMapDefine.isInNebulaAllStar() then
			local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
			local myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
			if myTeamInfo:getIsSuperTeam() then
				self.fields.icon:setSpriteFrame("icon_position_allstar.png")
				self.fields.title:setString(i18n("NebulaAllstar_184"))
			else
				self.fields.icon:setSpriteFrame("icon_position_assistance.png")
				self.fields.title:setString(i18n("NebulaAllstar_185"))
			end
		elseif worldMapDefine.isInRoaringFlame() then
			local worldMapWarDef = include("worldMapWarDef")
			local bg = worldMapWarDef.getPosFrameByKid(kingdomID)
			if bg then
				self.fields.icon:setSpriteFrame(bg)
			end
			self.fields.title:setString(i18n("flames_dunes_push3"))
		else
			local worldMapWarDef = include("worldMapWarDef")
			local fieldName = worldMapWarDef.getKingdomNameByKid(kingdomID) or ""
			local bg = worldMapWarDef.getPosFrameByKid(kingdomID)
			if bg then
				self.fields.icon:setSpriteFrame(bg)
			end
			_ENV = i18n("flames_dunes_push3")
			i18n("flames_dunes_push3").var = fieldName
			self.fields.title:setString(i18n("position_share_01", i18n("flames_dunes_push3")))
		end
	elseif data.channel == gChatChannel.VIEWER then
		self.fields.icon:setSpriteFrame("icon_position_audience.png")
		self.fields.title:setString(i18n("NebulaAllstar_188"))
	elseif data.crid then
		self.fields.icon:setSpriteFrame("icon_position_chat.png")
		self.fields.title:setString(data.crName)
	else
		self.fields.Com_head:setVisible(true)
		self.fields.icon:setVisible(false)
		self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
		self.fields.title:setString(data.name)
	end
end
function Com_ShareSingle:isTickSelect()
	return self.fields.Check_tick:isSelected()
end
return Com_ShareSingle

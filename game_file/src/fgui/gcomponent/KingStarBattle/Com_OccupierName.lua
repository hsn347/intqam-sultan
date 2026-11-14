local baseComponent = require("fgui.base.baseComponent")
local Com_OccupierName = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://KingStarBattle/Com_OccupierName", Com_OccupierName)
local allianceDesRead = include("allianceDesRead")
function Com_OccupierName:onInit()
end
function Com_OccupierName:onShow()
	self.fields.text_war_title:setString(i18n("common_text_1426"))
end
function Com_OccupierName:initData(data)
	if data.occupier then
		local occupier = data.occupier
		local allianceInfo = occupier.allianceInfo
		local playerInfo = occupier.playerInfo
		self.fields.alliance:setVisible(false)
		if allianceInfo and allianceInfo.alliance then
			if allianceInfo.alliance then
				self.fields.alliance:setVisible(true)
				self.fields.text_war_alliance_name:setString(allianceInfo.alliance)
			end
			if allianceInfo.flag and allianceDesRead.getFlagIcon(allianceInfo.flag) then
				self.fields.sprite_alliance_falg:setVisible(true)
				self.fields.sprite_alliance_falg:setURL(allianceDesRead.getFlagIcon(allianceInfo.flag))
			end
		end
		if playerInfo and playerInfo.nickName then
			self.fields.text_player_name:setVisible(true)
			local textName = playerInfo.nickName
			if textName then
				if allianceInfo and allianceInfo.aid and allianceInfo.aid > 0 and allianceInfo.abbr then
					allianceDesRead = allianceDesRead.getFlagIcon(allianceInfo.flag)
					allianceDesRead.getFlagIcon(allianceInfo.flag).abbr = allianceInfo.abbr
					allianceDesRead.getFlagIcon(allianceInfo.flag).name = playerInfo.nickName
					textName = i18n("common_text_186", allianceDesRead.getFlagIcon(allianceInfo.flag))
				end
				if occupier.kingdomInfo and occupier.kingdomInfo.kid and 0 < occupier.kingdomInfo.kid then
					textName = textName .. "#" .. occupier.kingdomInfo.kid
				end
				self.fields.text_player_name:setString(textName)
			else
				textName = i18n("common_text_480")
				self.fields.text_player_name:setString(textName)
			end
			self.fields.head:setVisible(true)
			self.fields.node_head_frame:setHeadSprite(playerInfo.imageId, playerInfo.avatar)
		else
			self.fields.head:setVisible(false)
		end
		if occupier.maxNum then
			self.controllers.c1:setSelectedIndex(0)
			self.fields.text_fight_power:setString(occupier.curNum .. "/" .. occupier.maxNum)
		else
			self.controllers.c1:setSelectedIndex(1)
		end
	end
end
return Com_OccupierName

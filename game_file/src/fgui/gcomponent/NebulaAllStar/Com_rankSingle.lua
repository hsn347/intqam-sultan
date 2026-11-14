local nebulaWarRead = include("nebulaWarRead")
local nebulaAllStarRead = include("nebulaAllStarRead")
local RANK_TYPE = nebulaAllStarRead.NEBULA_ALLSTAR_WAR_PLAYER_RANK_TYPE
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_rankSingle = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NebulaAllStar/Com_rankSingle", Com_rankSingle)
function Com_rankSingle:onInit()
	self:addClickListener(handler(self, self.btnClick))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_rankSingle:onShow()
end
function Com_rankSingle:initData(data, otherData)
	self.data = data
	local rank = otherData.rank
	local isSelf = otherData.isSelf
	self.isSelf = isSelf
	local isOwnRank = otherData.isOwnRank
	RANK_TYPE, self.rankType = otherData.rankType, otherData.rankType
	otherData.rankType.rank = rank
	local otherData.rankType.isOwnRank, baseData = isOwnRank, otherData.rankType
	self.fields.Com_base:initData2(baseData)
	self.controllers.c_self:setSelectedIndex(not isOwnRank and isSelf and 1 or 0)
	local key = otherData.valueKey
	if self.rankType == RANK_TYPE.CAMP_OCCUPY then
		self.controllers.c1:setSelectedIndex(1)
		local areaName = nebulaWarRead.getAreaName(data.camp)
		local areaIcon = nebulaWarRead.getAreaIcon(data.camp)
		self.fields.Load_region:setURL(areaIcon)
		self.fields.Text_region1:setString(areaName)
		RANK_TYPE = nil
		;(nil).name = data.leaderName
		self.fields.Text_region2:setString(i18n("NebulaAllstar_53", nil))
		self.fields.Text_score:setString(SoraDConvertSecondToString(data[key] or 0))
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
		self.fields.Com_head:setAvatarFrame(data.avatarFrameId)
		local areaAbbr = nebulaWarRead.getAreaAbbr(data.camp)
		RANK_TYPE = data.avatar
		data.avatar.abbr = areaAbbr
		data.avatar.name = data.nickName
		local nameStr = i18n("common_text_186", data.avatar)
		self.fields.Text_name:setString(nameStr)
		self.fields.Text_score:setString(string.formatnumberthousands(data[key] or 0))
	end
end
function Com_rankSingle:btnClick()
	SoraDPlaySound()
	if self.rankType == RANK_TYPE.CAMP_OCCUPY then
		return
	end
	if self.isSelf then
		SoraDOpenLordView(lordInfoCtrl:getLordInfo())
		return
	end
	if self.rankType == RANK_TYPE.VIEWER_COLLECT_SPOIL or not nebulaAllStarCtrl:getIsViewer() then
		_ENV = nebulaAllStarCtrl
		nebulaAllStarCtrl.msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
		nebulaAllStarCtrl.playerID = self.data.uid
		SoraDSendMessage(nebulaAllStarCtrl)
		return
	end
	local chatConst = include("chatConst")
	nebulaAllStarCtrl = "chatConst"
	;("chatConst")[1] = chatConst.OpId.OpSendEmail
	;("chatConst")[2] = chatConst.OpId.OpViewInfo
	local ("chatConst")[3], menuData = chatConst.OpId.OpShield, "chatConst"
	table.insert(menuData, chatConst.OpId.OpSendGiftNebulaAllStar)
	_ENV = table.insert
	table.insert.kid = self.data.fromKid
	table.insert.playerId = self.data.uid
	table.insert.nickName = self.data.nickName
	local table.insert.allianceAbbr, other = self.data.allianceAbbr, table.insert
	SoraDShowPlayerOperatePanel(self.data.nickName, menuData, other, function(btnTag)
		if btnTag == chatConst.OpId.OpSendGiftNebulaAllStar then
			chatConst = nil
			;(nil).uid = self.data.uid
			uiManager:show("NebulaAllStarSendGift", nil)
		end
	end)
end
return Com_rankSingle

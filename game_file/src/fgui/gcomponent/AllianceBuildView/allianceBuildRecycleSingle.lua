local allianceDesRead = include("allianceDesRead")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceBuildingltCtrl = include("allianceBuildingltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local allianceBuildRecycleSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceBuildView/allianceBuildRecycleSingle", allianceBuildRecycleSingle)
function allianceBuildRecycleSingle:onInit()
	self.fields.Button_build:addClickListener(handler(self, self.onClickBuild))
	self.fields.Button_build:setTitleText(i18n("common_text_2132"))
	self.fields.Sprite_flag:setVisible(false)
end
function allianceBuildRecycleSingle:onShow()
end
function allianceBuildRecycleSingle:setScroll(scroll)
	self.scroll = scroll
end
function allianceBuildRecycleSingle:initData(buildData)
	self.tableSingleData = buildData
	local bid = self.tableSingleData.bid
	self.fields.Sprite_build:setURL(allianceDesRead.getBuildIcon(bid))
	self.fields.Text_name:setString(allianceDesRead.getBuildName(bid))
	if bid == gAllianceBuilding.FLAG then
		self.fields.Sprite_flag:setVisible(true)
		local flag = allianceMgr:getAllianceProperty("flag")
		self.fields.Sprite_flag:setURL(allianceDesRead.getFlagIcon(flag))
		self.fields.Sprite_build:setScale(1.5)
	else
		if self.fields.Sprite_flag then
			self.fields.Sprite_flag:setVisible(false)
		end
		self.fields.Sprite_build:setScale(0.6)
	end
	local redCount = self.tableSingleData.count
	self.fields.Label_reddot:initData(0 < redCount, redCount)
end
function allianceBuildRecycleSingle:onClickBuild()
	local memberMgr = SoraDGetCtrl("memberMgr")
	local ownRank = memberMgr:getOwnMember():getProperty("rank")
	if not allianceBuildingltCtrl:canRankMemberCreate(self.tableSingleData.bid, ownRank, 1) then
		local needRank = allianceBuildingltCtrl:getRankMemberCreate(self.tableSingleData.bid, 1)
		local showIcon = allianceDesRead.getIcon(needRank, true)
		SoraDShowMsgTip(i18n("common_text_203"), showIcon)
		return
	end
	self:gotoWorldMapPos()
	SoraDRemoveAllPrePanelFromManager(self)
end
function allianceBuildRecycleSingle:gotoWorldMapPos()
	local _ENV, pos
	local proxy = uiManager:getProxy("AllianceBuildView")
	if proxy then
		pos = proxy:getParam().buildMovePos
	end
	local jumpPos = allianceMgr:getLeaderPos()
	if jumpPos == nil or jumpPos.x == -1 and jumpPos.y == -1 then
		SoraDShowMsgTip(i18n("common_text_2173"), nil, button)
		return
	end
	jumpPos = table.nums(pos) > 0 and pos or jumpPos
	_ENV = nil
	;(nil).buildClassID = self.tableSingleData.bid
	SoraDGotoWorldMapPoint(jumpPos, false, nil, worldMapLayInstanceTypeDef.layInstanceAllianceManor, nil)
end
return allianceBuildRecycleSingle

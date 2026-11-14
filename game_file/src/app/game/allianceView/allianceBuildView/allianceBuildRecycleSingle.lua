local allianceDesRead = include("allianceDesRead")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceBuildingltCtrl = include("allianceBuildingltCtrl")
local allianceBuildRecycleSingle = class("allianceBuildRecycleSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceBuildSingle")
	end
	return target
end)
function allianceBuildRecycleSingle:ctor()
	self:initWidget()
end
function allianceBuildRecycleSingle:initWidget(...)
	SoraDGetAllChildFromWidget(self._ccsView, self)
	_UPVALUE6_ = self._ccsView
	self._ccsView[1] = self.Button_buildInfo
	self._ccsView[2] = self.Node_des
	self._ccsView[3] = self.Button_jump
	self._ccsView[4] = self.Node_ing
	self._ccsView[5] = self.Text_blood
	self._ccsView[6] = self.Button_cold
	for i, widget in ipairs(self._ccsView) do
		if widget then
			widget:setVisible(false)
		end
	end
	self.Button_build = SoraDCreatePanelByCloneNode(self.Button_build, "commonBtnInstance")
	self.Button_build:setHandle(handler(self, self.onClickBuild))
	self.Button_build:setTitleText(i18n("common_text_2132"))
end
function allianceBuildRecycleSingle:setScroll(scroll)
	self.Button_build:setScroll(scroll)
end
function allianceBuildRecycleSingle:initData(buildData)
	self.tableSingleData = buildData
	local bid = self.tableSingleData.bid
	self.Sprite_build:setSpriteFrame(allianceDesRead.getBuildIcon(bid))
	self.Text_name:setString(allianceDesRead.getBuildName(bid))
	if bid == gAllianceBuilding.FLAG then
		if self.Sprite_flag then
			self.Sprite_flag:setVisible(true)
		else
			local flag = allianceMgr:getAllianceProperty("flag")
			local Sprite_flag = display.newSprite(allianceDesRead.getFlagIcon(flag, true))
			Sprite_flag:addTo(self._ccsView)
			Sprite_flag:setPosition(0, self.Sprite_build:getPositionY() + 15)
			Sprite_flag:setScale(0.5)
			self.Sprite_flag = Sprite_flag
		end
		self.Sprite_build:setScale(1.5)
	else
		if self.Sprite_flag then
			self.Sprite_flag:setVisible(false)
		end
		self.Sprite_build:setScale(0.6)
	end
	if not self.ccs_red then
		local commonRedPoint = SoraDCreatePanel("commonRedPoint")
		commonRedPoint:addTo(self._ccsView)
		commonRedPoint:setPosition(SoraDFSign(-116), -43)
		self.ccs_red = commonRedPoint
	end
	self.ccs_red:updateRedPoint(self.tableSingleData.count)
end
function allianceBuildRecycleSingle:onClickBuild(button, event)
	local memberMgr = SoraDGetCtrl("memberMgr")
	local ownRank = memberMgr:getOwnMember():getProperty("rank")
	if not allianceBuildingltCtrl:canRankMemberCreate(self.tableSingleData.bid, ownRank, 1) then
		local needRank = allianceBuildingltCtrl:getRankMemberCreate(self.tableSingleData.bid, 1)
		local showIcon = allianceDesRead.getIcon(needRank, true)
		SoraDShowMsgTip(i18n("common_text_203"), showIcon, button)
		return
	end
	self:gotoWorldMapPos()
	SoraDRemoveAllPrePanelFromManager(self)
end
function allianceBuildRecycleSingle:gotoWorldMapPos()
	local pos = include("allianceBuildView").getParam().buildMovePos
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

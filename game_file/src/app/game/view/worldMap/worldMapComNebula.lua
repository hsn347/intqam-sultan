local gametop = gModuleMgr.getObject("gametop")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local constantRead = include("constantRead")
local nebulaWarRead = include("nebulaWarRead")
local worldMapComNebula = class("worldMapComNebula", include("worldMapCom"))
function worldMapComNebula:ctor()
	worldMapComNebula.super.ctor(self, "worldMapComNebula")
end
function worldMapComNebula:init()
	self:initWidget()
end
function worldMapComNebula:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_REFRESH_WARDATA", handler(self, self.refreshWarData))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_INIT_DATA", handler(self, self.onMsgUpdateBtnSearch))
	self:doReqestData()
end
function worldMapComNebula:initWidget(...)
	self.Node_warTime = SoraDGetChildByName(self.target_, "Node_warTime")
	self.Node_warTime:setPositionY(display.height - 120 + display.iPhoneXBottom)
	self.Text_warTime = SoraDGetChildByName(self.Node_warTime, "Text_warTime")
	self.Text_warTime = SoraDCreateTimerLabel(self, self.Text_warTime)
	self.Text_warTime:setTimeLast(function(__, time)
		_ENV = nil
		;(nil).time = SoraDConvertSecondToStringNoDayNoHour(time)
		return i18n("nebula_war_text_0097", nil)
	end)
	self.Node_camp = SoraDGetChildByName(self.Node_warTime, "Node_camp")
	SoraDGetAllChildFromWidget(self.Node_camp, self)
	self.Sprite_camp:setVisible(false)
	local groupId = nebulaActivityCtrl:getSelfGroupId()
	local groupName = nebulaWarRead.getWarGroupName(groupId)
	_ENV = nil
	;(nil).camp = groupName
	self.Text_camp:setString(i18n("nebula_war_text_0499", nil))
	self.Node_war = SoraDGetChildByName(self.target_, "Node_war")
	self.Button_rank = SoraDGetChildByName(self.Node_war, "Button_rank")
	self.Button_rank:addTouchEventListener(handler(self, self.onClickBtnRank))
	self.btnMonsterSearch = SoraDGetChildByName(self.target_, "Button_monsterSearch")
	self.btnMonsterSearch:addTouchEventListener(handler(self, self.btnMonsterSearchCall))
	nebulaWarRead = self.btnMonsterSearch
	self.btnMonsterSearch[1] = "Sprite_monsterLock"
	self.btnMonsterSearch[2] = "Sprite_monsterBg"
	for __, v in ipairs(self.btnMonsterSearch) do
		local widget = SoraDGetChildByName(self.btnMonsterSearch, v)
		if widget then
			widget:setVisible(false)
		end
	end
	self:onMsgUpdateBtnSearch()
	self:fitNodeBottom()
end
function worldMapComNebula:fitNodeBottom()
	local fitHeight = 1136
	if fitHeight <= display.height then
		self.Node_war:setPositionY(display.iPhoneXBottom - 30)
		self.btnMonsterSearch:setPositionY(display.iPhoneXBottom + 170)
		return
	end
	local fitWidth = fitHeight / display.height * 640
	local fitScale = 640 / fitWidth
	local addX = (640 - fitScale * 640) / 2
	local posX = self.btnMonsterSearch:getPositionX()
	self.Node_war:setScale(fitScale)
	self.Node_war:setPositionY(display.iPhoneXBottom - 30 * fitScale)
	self.btnMonsterSearch:setScale(fitScale)
	self.btnMonsterSearch:setPositionY(display.iPhoneXBottom + 170 * fitScale)
	self.btnMonsterSearch:setPositionX(SoraDFIsRA() and posX - addX / 2 or posX + addX / 2)
end
function worldMapComNebula:createMapTip()
	if self.pyramidTip then
		return
	end
	local Z_ORDER = worldMapDefine.Z_ORDER
	local height = display.height + display.iPhoneXBottom
	local pyramidTip = include("worldMapPyramidTip").new()
	pyramidTip:setPosition(cc.p(display.cx, height - 270))
	pyramidTip:addTo(self.target_, Z_ORDER.topTipView)
	self.pyramidTip = pyramidTip
end
function worldMapComNebula:doReqestData(...)
	local mapId = worldMapDefine.currentMapKindomID
	nebulaActivityCtrl:reqWarData(mapId)
end
function worldMapComNebula:onClickBtnRank(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		uiManager:show("NebulaWarRank")
	end
end
function worldMapComNebula:refreshWarData(...)
	local remainTime = nebulaActivityCtrl:getWarRemainTime()
	if 0 < remainTime then
		self.Text_warTime:beginTime(remainTime)
	end
	self:createMapTip()
end
function worldMapComNebula:btnMonsterSearchCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
		if myTeamInfo:getIsSuperTeam() then
			SoraDShowMsgTip(i18n("common_text_4782"))
			return
		end
		local remainTime, refreshTime = nebulaWarRead.getFirstMonsterRefreshTime()
		if remainTime then
			_ENV = i18n("common_text_4782")
			i18n("common_text_4782").num = math.ceil(refreshTime / 60)
			SoraDShowMsgTip(i18n("common_text_4783", i18n("common_text_4782")))
			return
		end
		_ENV = i18n("common_text_4783", i18n("common_text_4782"))
		i18n("common_text_4783", i18n("common_text_4782")).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		SoraDSendMessage(i18n("common_text_4783", i18n("common_text_4782")))
		local myKindomID = gametop.playertop_:getMapID()
		if self.target_.currentInMapViewCell.kingdomID == myKindomID then
			local panel = SoraDCreatePanel("worldMapMonsterSearch")
			panel:show()
		else
			SoraDShowMsgTip(i18n("common_text_2180"))
		end
	end
end
function worldMapComNebula:onMsgUpdateBtnSearch(...)
	local myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
	if myTeamInfo then
		local isSuperTeam = myTeamInfo:getIsSuperTeam() or false
		self.btnMonsterSearch:setVisible(not isSuperTeam)
	end
end
function worldMapComNebula:getNodeWar()
	return self.Node_war
end
function worldMapComNebula:exportMethods()
	_UPVALUE1_ = nil
	;(nil)[1] = "getNodeWar"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComNebula

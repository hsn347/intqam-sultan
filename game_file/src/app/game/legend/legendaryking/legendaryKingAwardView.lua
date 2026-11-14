local legendLordWarCtrl = SoraDGetCtrl("legendLordWarCtrl")
local radianceActivityCtrl = SoraDGetCtrl("radianceActivityCtrl")
local legendaryKingAwardView = class("legendaryKingAwardView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardView")
end)
function legendaryKingAwardView:onEnterOther()
	if self.warType == gKingdomClassType.legendLord then
		_ENV, _ENV, _ENV, _UPVALUE3_ = nil, nil, 365, 640
		;(640)[1] = 365
		;(640)[2] = nil
		;(640)[3] = nil
		_ENV = nil
		;(nil).scroll = self.scroll
		;(nil).view = self
		;(nil).warType = self.warType
		;(nil).mapid = self.mapid
		self.scroll:updateScrollView(cc.size(640, 365), 640, 1, nil)
		legendLordWarCtrl:reqBestKillInfo(self.mapid)
		SoraDShowLoading(self)
	elseif self.warType == gKingdomClassType.radiance then
		radianceActivityCtrl:reqPlayerKillFcRank(nil, 1)
		SoraDShowLoading(self)
	end
end
function legendaryKingAwardView:ctor(properties)
	self.warType = gKingdomClassType.legendLord
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.nodeCommonFramTitle:setTitle(i18n("legendaryking_text_37"))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self.scroll = SoraDGetChildByName(self, "ScrollView_Size")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createScrollSingle))
end
function legendaryKingAwardView:onMessageListener()
	if self.warType == gKingdomClassType.legendLord then
		SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_ALLIANCE", handler(self, self.initData))
	elseif self.warType == gKingdomClassType.radiance then
		SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_PLAYER_RANK", handler(self, self.initData))
	end
end
function legendaryKingAwardView:initData(target, data)
	if data.topRankList then
		SoraDCloseLoading(self)
		_ENV = nil
		;(nil).scroll = self.scroll
		;(nil).view = self
		;(nil).warType = self.warType
		;(nil).mapid = self.mapid
		self.scroll:updateScrollView(cc.size(640, 365), data.topRankList, 1, nil)
	end
end
function legendaryKingAwardView:createScrollSingle()
	return include("legendaryKingAwardSingle").new(self.nodeSingle:clone())
end
function legendaryKingAwardView:setWarType(warType, mapid)
	self.warType = warType
	self.mapid = mapid
	if self.warType == gKingdomClassType.radiance then
		self.nodeCommonFramTitle:setTitle(i18n("brightWar_text_226"))
		self.nodeCommonFramTitle:setBtnHelpClickCallBack(handler(self, self.onBtnHelpClick))
		_ENV, _ENV, _UPVALUE2_ = handler(self, self.onBtnHelpClick)
		;(640)[1] = 365
		;(640)[2] = handler(self, self.onBtnHelpClick)
		_ENV = handler(self, self.onBtnHelpClick)
		handler(self, self.onBtnHelpClick).scroll = self.scroll
		handler(self, self.onBtnHelpClick).view = self
		handler(self, self.onBtnHelpClick).warType = self.warType
		handler(self, self.onBtnHelpClick).mapid = mapid
		self.scroll:updateScrollView(cc.size(640, 365), 640, 1, handler(self, self.onBtnHelpClick))
	end
	if worldMapDefine.isKingStarMapId(self.mapid) then
		self.nodeCommonFramTitle:setTitle(i18n("kingstarbattle_text_33"))
	end
end
function legendaryKingAwardView:onBtnHelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "nebula_war_text_0185"
		;("nebula_war_text_0185").align = SoraDFLabelR()
		;("nebula_war_text_0185").title = i18n("common_text_001")
		SoraDShowHelpMsgTip(i18n("nebula_war_text_0185"), "nebula_war_text_0185")
	end
end
return legendaryKingAwardView

local gametop = gModuleMgr.getObject("gametop")
local endlessTrialsCtrl = SoraDGetCtrl("endlessTrialsCtrl")
local collectMapCtrl = SoraDGetCtrl("collectMapCtrl")
local endlessTrialsProtal = class("endlessTrialsProtal", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("endlessTrialsProtal")
	end
	return target
end)
function endlessTrialsProtal:ctor()
	self.kingdomID = gametop.playertop_:getKingdomID()
	self:initWidget()
	endlessTrialsCtrl:reqBossInfo()
end
function endlessTrialsProtal:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_COLLECTMAP_SUCCESS", handler(self, self.refreshCollect))
	SoraDAddMessage(self, "MESSAGE_ENDLESSTRIALSVIEW_REFRESH", handler(self, self.refreshBossInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function()
		if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY) then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
end
function endlessTrialsProtal:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_boss = SoraDGetExtendChildFromCCSByName(self, "CCS_endlessTrialsBossSingle_1")
	self.Text_refresh:setString(i18n("Endless_trial_text_06"))
	self.Button_collect:addTouchEventListener(handler(self, self.btnCollectCallback))
	self.Button_copy:addTouchEventListener(handler(self, self.btnCopyCallback))
	self.Button_old_copy:addTouchEventListener(handler(self, self.btnOldCopyCallback))
	local protal = SoraDCreatePanel("worldMapProtal")
	protal:addTo(self.scaleActTarget)
	protal:setPosition(0, 75)
	protal:setScale(1.4024390243902438)
	local effect = SoraDCreatAnimation("Node_Effect_wjtzjf01")
	SoraDMixtureGLONEByParent(effect)
	effect:addTo(self.scaleActTarget)
	effect:setPosition(0, -162)
	effect:setScaleY(self.ccs_bg:getSize().height / 635)
end
function endlessTrialsProtal:initData(buildClassID, tilePoint)
	self.buildClassID = buildClassID
	self.tilePoint = tilePoint
	print("sldjfskdljf", self.buildClassID)
	local config = endlessTrialsCtrl:getMountainConfig(self.buildClassID)
	self.config = config
	self.favoriteName = i18n(config.name)
	self.ccs_bg:setTitleName(self.favoriteName)
	self.Text_point:setString(i18n("common_text_465", self.tilePoint))
	self:refreshCollect()
	local myCityTilePoint = SoraDGetCtrl("cityCtrl"):getCurCityPos()
	local miles = cc.pGetDistance(myCityTilePoint, self.tilePoint)
	_ENV = i18n("common_text_465", self.tilePoint)
	i18n("common_text_465", self.tilePoint).distance = math.ceil(miles)
	self.Text_distance:setString(i18n("common_text_4295") .. i18n("common_text_489", i18n("common_text_465", self.tilePoint)))
	self:refreshBossInfo()
end
function endlessTrialsProtal:refreshBossInfo(...)
	_UPVALUE0_ = nil
	;(nil).isUp = true
	;(nil).noJump = true
	self.ccs_boss:initData(self.config, nil)
end
function endlessTrialsProtal:btnCollectCallback(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isCollect then
			SoraDShowMsgTip(i18n("common_text_484"))
		else
			_ENV, _ENV = i18n("common_text_484")
			i18n("common_text_484").type = gCollectType.favorite
			_ENV, i18n("common_text_484").name = self.favoriteName or "???", self.favoriteName or "???"
			;(self.favoriteName or "???").x = self.tilePoint.x
			;(self.favoriteName or "???").y = self.tilePoint.y
			i18n("common_text_484").markData, i18n("common_text_484").pos, (self.favoriteName or "???").k = i18n("common_text_484")
			i18n("common_text_484").title = i18n("common_text_641")
			uiManager:show("WorldMapBookMarkPop", i18n("common_text_484"))
		end
	end
end
function endlessTrialsProtal:btnCopyCallback(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV, _ENV = nil, nil
		;(nil).x = math.floor(tonumber(self.tilePoint.x))
		;(nil).y = math.floor(tonumber(self.tilePoint.y))
		;(nil).mapInstance = self.buildClassID
		;(nil).kingdomID = self.kingdomID
		;(nil).mapData, (nil).isEndLess = nil, true
		uiManager:show("worldMapCordinateShareView", nil)
	end
end
function endlessTrialsProtal:btnOldCopyCallback(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tilePointString = string.format("X:%d,Y:%d", self.tilePoint.x, self.tilePoint.y)
		SoraDCopyText(tilePointString)
		SoraDShowMsgTip(i18n("common_text_2085"))
	end
end
function endlessTrialsProtal:refreshCollect(...)
	self.isCollect = self.tilePoint and collectMapCtrl:isCollect(self.kingdomID, self.tilePoint.x, self.tilePoint.y)
	if self.isCollect then
		SoraChangeButtonImage(self.Button_collect, "icon_map_favorite_01.png")
	end
end
return endlessTrialsProtal

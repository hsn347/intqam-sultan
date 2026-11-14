local gametop = gModuleMgr.getObject("gametop")
local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
local remainsWarUtil = include("remainsWarUtil")
local worldMapComRemains = class("worldMapComRemains", include("worldMapCom"))
function worldMapComRemains:ctor()
	worldMapComRemains.super.ctor(self, "worldMapComRemains")
end
function worldMapComRemains:init()
	self:createMapTip()
	self.nodeRemainsWar = SoraDGetChildByName(self.target_, "Node_remains_war")
	self.nodeRemainsWar:setVisible(true)
	self.btnRemainsWarTeam = SoraDGetChildByName(self.nodeRemainsWar, "Button_remainswar_team")
	self.btnRemainsWarTeam:addTouchEventListener(handler(self, self.btnRemainsWarTeamCall))
	self.iconBuffRed = SoraDGetChildByName(self.nodeRemainsWar, "icon_buff_red")
	self.labBuffNum = SoraDGetChildByName(self.nodeRemainsWar, "Text_BuffNum")
	self.btnMiniMap = SoraDGetChildByName(self.nodeRemainsWar, "Button_remainswar_mini")
	self.btnMiniMap:addTouchEventListener(handler(self, self.btnMiniMapCall))
	self.btnRemainsWarBuff = SoraDGetChildByName(self.nodeRemainsWar, "Button_remainswar_buff")
	SoraDGetChildByName(self.btnRemainsWarBuff, "btn_worldmap_shop_1"):setSpriteFrame("icon_ruins_buff_01.png")
	self._remainsShowBuffBtn = true
	if self._remainsShowBuffBtn then
		self.btnRemainsWarBuff:addTouchEventListener(handler(self, self.btnRemainsWarBuffCall))
	else
		self.btnRemainsWarBuff:setVisible(false)
	end
	self.btnMonsterSearch = SoraDGetChildByName(self.target_, "Button_monsterSearch")
	self.btnMonsterSearch:addTouchEventListener(handler(self, self.btnMonsterSearchCall))
	self.nodeParticle = SoraDGetChildByName(self.btnMonsterSearch, "Node_particle")
	self:updateMiniMap()
	self:fitNodeBottom()
end
local remainsFitBottomBtn = function(btn, designY, fitScale)
	local scale = btn:getScale()
	btn:setScale(scale * fitScale)
	btn:setPositionY(display.iPhoneXBottom + (1 - fitScale) * 50 + designY * fitScale)
end
function worldMapComRemains:fitNodeBottom()
	local fitHeight = 1136
	local teamY, buffY, miniYBuff, miniYNoBuff = 245, 330, 425, 330
	local miniY = self._remainsShowBuffBtn and miniYBuff or miniYNoBuff
	if fitHeight <= display.height then
		self.btnMonsterSearch:setScale(1)
		self.btnMonsterSearch:setPositionY(display.iPhoneXBottom + 170)
		self.btnRemainsWarTeam:setScale(1)
		self.btnRemainsWarTeam:setPositionY(display.iPhoneXBottom + teamY)
		self.btnMiniMap:setScale(1)
		self.btnMiniMap:setPositionY(display.iPhoneXBottom + miniY)
		if self._remainsShowBuffBtn then
			self.btnRemainsWarBuff:setScale(1)
			self.btnRemainsWarBuff:setPositionY(display.iPhoneXBottom + buffY)
		end
		return
	end
	local fitWidth = fitHeight / display.height * 640
	local fitScale = 640 / fitWidth
	local addX = (640 - fitScale * 640) / 2
	local posXSearch = self.btnMonsterSearch:getPositionX()
	self.btnMonsterSearch:setScale(fitScale)
	self.btnMonsterSearch:setPositionY(display.iPhoneXBottom + 170 * fitScale)
	self.btnMonsterSearch:setPositionX(SoraDFIsRA() and posXSearch - addX / 2 or posXSearch + addX / 2)
	remainsFitBottomBtn(self.btnRemainsWarTeam, teamY, fitScale)
	remainsFitBottomBtn(self.btnMiniMap, miniY, fitScale)
	if self._remainsShowBuffBtn then
		remainsFitBottomBtn(self.btnRemainsWarBuff, buffY, fitScale)
	end
end
function worldMapComRemains:createMapTip()
	local Z_ORDER = worldMapDefine.Z_ORDER
	local height = display.height + display.iPhoneXBottom
	local pyramidTip = include("worldMapPyramidTip").new()
	pyramidTip:setPosition(cc.p(display.cx, height - 270))
	pyramidTip:addTo(self.target_, Z_ORDER.topTipView)
	local legendTip = include("remainsWarUIWidget").new()
	legendTip:setPosition(cc.p(display.cx, height - 125))
	legendTip:addTo(self.target_, Z_ORDER.topTipView)
end
function worldMapComRemains:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_TEAM_BUFF_LIST", handler(self, self.updateBuffRed))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_PLAYER_BUFF_LIST", handler(self, self.updateBuffRed))
	self:updateBuffRed()
end
function worldMapComRemains:onEnter()
	self:reqSyncRW()
end
function worldMapComRemains:onExit()
	worldMapComRemains.super.onExit(self)
	if not worldMapDefine.isInRemains() then
		local kingdomID = self.target_.currentInMapViewCell.kingdomID
		if worldMapDefine.isRemainsKingdomID(kingdomID) and remainsWarUtil.checkIsReqSyncRw() then
			remainsWarCtrl:reqStopSyncRW(kingdomID)
		end
	end
end
function worldMapComRemains:reqSyncRW()
	if not worldMapDefine.isInRemains() and remainsWarUtil.checkIsReqSyncRw() then
		remainsWarCtrl:reqSyncRW(worldMapDefine.currentMapKindomID)
	end
end
function worldMapComRemains:doReqestData()
	self:reqSyncRW()
	self:updateBuffRed()
end
function worldMapComRemains:btnRemainsWarBuffCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		uiManager:show("remainsWarBuff")
	end
end
function worldMapComRemains:btnMiniMapCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local show = self:switchMiniView(true)
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:remainsMiniMap:show~bool", show, nil)
	end
end
function worldMapComRemains:updateMiniMap()
	_ENV = nil
	;(nil).byUID = true
	local ret = SoraDConfigGet("Game:remainsMiniMap:show~bool", nil)
	if ret then
		self:switchMiniView()
	end
end
function worldMapComRemains:switchMiniView(tips)
	local parent = display.getRunningScene().panelView
	local panel = SoraDGetChildByName(parent, "remainsMiniMap", true)
	local show = false
	if not panel then
		panel = SoraDCreatePanel("remainsMiniMap")
		panel:setName("remainsMiniMap")
		parent:addChild(panel)
		show = true
	else
		panel:removeFromParent()
	end
	if tips then
		if show then
			SoraDShowMsgTip(i18n("remains_text_368"))
		else
			SoraDShowMsgTip(i18n("remains_text_369"))
		end
	end
	return show
end
function worldMapComRemains:btnRemainsWarTeamCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("teamInfoView")
		panel:show()
	end
end
function worldMapComRemains:btnMonsterSearchCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.nodeParticle:setVisible(false)
		_ENV = self.nodeParticle
		self.nodeParticle.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		SoraDSendMessage(self.nodeParticle)
		local myKindomID = gametop.playertop_:getMapID()
		if self.target_.currentInMapViewCell.kingdomID == myKindomID then
			uiManager:show("worldMapRemainsSearch")
		else
			SoraDShowMsgTip(i18n("common_text_2180"))
		end
	end
end
function worldMapComRemains:updateBuffRed()
	local showNum = remainsWarCtrl:getRemainsWarTeamBuffNum()
	if showNum <= 0 then
		self.iconBuffRed:setVisible(false)
	else
		self.iconBuffRed:setVisible(true)
		self.labBuffNum:setString(showNum)
	end
end
return worldMapComRemains

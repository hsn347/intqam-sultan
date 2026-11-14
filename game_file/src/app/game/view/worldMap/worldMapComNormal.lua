local gametop = gModuleMgr.getObject("gametop")
local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
local worldMapComNormal = class("worldMapComNormal", include("worldMapCom"))
function worldMapComNormal:ctor()
	worldMapComNormal.super.ctor(self, "worldMapComNormal")
end
function worldMapComNormal:init()
	self.btnMonsterSearch = SoraDGetChildByName(self.target_, "Button_monsterSearch")
	self.btnWorldResource = SoraDGetChildByName(self.target_, "Button_worldResource")
	self.btnMonsterSearch:addTouchEventListener(handler(self, self.btnMonsterSearchCall))
	self.seaMonsterRedPoint = display.newSprite()
	self.seaMonsterRedPoint:setSpriteFrame("frame_mail_round_01.png")
	self.seaMonsterRedPoint:setPosition(cc.p(80, 80))
	self.seaMonsterRedPoint:setScale(0.8)
	self.seaMonsterRedPoint:addTo(self.btnMonsterSearch, 3)
	self.seaMonsterRedPoint:setVisible(false)
	self.spMonsterBg = SoraDGetChildByName(self.btnMonsterSearch, "Sprite_monsterBg")
	self.spMonsterLock = SoraDGetChildByName(self.btnMonsterSearch, "Sprite_monsterLock")
	self.nodeParticle = SoraDGetChildByName(self.btnMonsterSearch, "Node_particle")
	self.labelLockTime = SoraDGetChildByName(self.btnMonsterSearch, "Text_lockTime")
	self.labelLockTime = SoraDCreateTimerLabel(self, self.labelLockTime)
	self.labelLockTime:setVisible(false)
	self.spMonsterBg:setVisible(false)
	self.spMonsterLock:setVisible(false)
	self:monsterSearchLock()
	self.effectMonster = self.btnMonsterSearch:getChildByName("Node_particle")
	if self.effectMonster then
		local bool = SoraDConfigGet("Game:worldMapView:monsterEffect~bool")
		self.effectMonster:setVisible(bool)
		if bool then
			_ENV, _ENV = self.effectMonster, self.effectMonster.setVisible
			self.effectMonster.plist = "et_guaiwu_01.plist"
			_ENV, self.effectMonster.setVisible[1], self.effectMonster.scale = self.effectMonster, self.effectMonster, 0.74
			self.effectMonster.plist = "et_guaiwu_02.plist"
			_ENV, self.effectMonster.setVisible[2], self.effectMonster.scale = self.effectMonster, self.effectMonster, 0.7
			self.effectMonster.plist = "et_guaiwu_03.plist"
			self.effectMonster.setVisible[3], self.effectMonster.scale = self.effectMonster, 0.7
			local et = self.effectMonster.setVisible
			local et_bottom = SoraDCreateEffectNode(et)
			et_bottom:addTo(self.nodeParticle)
		end
	end
	local localBattleState = conquestWarCtrl:getConquestWarState()
	if localBattleState and gConquestWarState.OPENING == localBattleState then
		local Z_ORDER = worldMapDefine.Z_ORDER
		local warTip = include("worldMapWarTip").new()
		warTip:setPosition(cc.p(display.cx, display.height - 270 + display.iPhoneXBottom))
		warTip:addTo(self.target_, Z_ORDER.topTipView)
	end
	self:fitNodeBottom()
	self:showOrHideGuideView()
end
function worldMapComNormal:fitNodeBottom()
	local fitHeight = 1136
	if fitHeight <= display.height then
		self.btnMonsterSearch:setPositionY(170 + display.iPhoneXBottom)
		return
	end
	local fitWidth = fitHeight / display.height * 640
	local fitScale = 640 / fitWidth
	local addX = (640 - fitScale * 640) / 2
	local posX = self.btnMonsterSearch:getPositionX()
	self.btnMonsterSearch:setScale(fitScale)
	self.btnMonsterSearch:setPositionY(170 * fitScale + display.iPhoneXBottom)
	self.btnMonsterSearch:setPositionX(SoraDFIsRA() and posX - addX / 2 or posX + addX / 2)
end
function worldMapComNormal:relogin()
	self:monsterSearchLock()
end
function worldMapComNormal:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_MONSTER_SEARCH_LOCK", handler(self, self.monsterSearchLock))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeOpen))
	SoraDAddMessage(self, "MESSAGE_SERVER_GUIDE_HIDE_AND_SHOW", handler(self, self.showOrHideGuideView))
end
function worldMapComNormal:showOrHideGuideView()
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	local guideStep = guideCtrl:getCurForceGuideStep()
	self.btnMonsterSearch:setVisible(false)
	if not guideStep then
		self.btnMonsterSearch:setVisible(true)
	end
end
function worldMapComNormal:judgeOpen(target, data)
	SoraDConfigSet("Game:worldMapView:seaMonsterRedPoint~bool", false)
	self.seaMonsterRedPoint:setVisible(SoraDConfigGet("Game:worldMapView:seaMonsterRedPoint~bool"))
end
function worldMapComNormal:monsterSearchLock(target, data)
	local hideTime = function(bool)
		self.labelLockTime:setVisible(bool)
		self.spMonsterBg:setVisible(bool)
		self.spMonsterLock:setVisible(bool)
	end
	local killMonsterVerifyCtrl = gametop.playertop_:getModule("killMonsterVerifyCtrl")
	local leftTime = killMonsterVerifyCtrl:getQuickSearchMonsterLockLeftTime()
	if killMonsterVerifyCtrl:isQuickSearchMonsterLock() then
		self.labelLockTime:beginTime(leftTime)
		hideTime(true)
	else
		hideTime(false)
	end
end
function worldMapComNormal:btnMonsterSearchCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		SoraDSendMessage(nil)
		local myKindomID = gametop.playertop_:getMapID()
		if self.target_.currentInMapViewCell.kingdomID == myKindomID then
			local killMonsterVerifyCtrl = gametop.playertop_:getModule("killMonsterVerifyCtrl")
			if killMonsterVerifyCtrl:isQuickSearchMonsterLock() then
				SoraDShowMsgTip(i18n("common_text_2863"))
			else
				local panel = SoraDCreatePanel("worldMapMonsterSearch")
				panel:show()
				if self.effectMonster:isVisible() then
					SoraDConfigSet("Game:worldMapView:monsterEffect~bool", false)
					self.effectMonster:setVisible(false)
					self.nodeParticle:removeAllChildren()
				end
				SoraDConfigSet("Game:worldMapView:seaMonsterRedPoint~bool", false)
				if self.seaMonsterRedPoint then
					self.seaMonsterRedPoint:setVisible(SoraDConfigGet("Game:worldMapView:seaMonsterRedPoint~bool"))
				end
			end
		else
			SoraDShowMsgTip(i18n("common_text_2180"))
		end
	end
end
function worldMapComNormal:getButtonMonsterSearch(...)
	return self.btnMonsterSearch
end
function worldMapComNormal:exportMethods()
	_UPVALUE1_ = nil
	;(nil)[1] = "getButtonMonsterSearch"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComNormal

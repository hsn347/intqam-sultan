local babelTowerCtrl = SoraDGetCtrl("babelTowerCtrl")
local babelTowerRead = gModuleMgr.sharedMgr("babelTowerRead")
local babelTowerResult = class("babelTowerResult", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("babelTowerResult")
end)
function babelTowerResult:onExitPanel()
	if self.reward then
		SoraDMailGainItems(self.reward, true)
	end
	if not self.isWin then
		_ENV = self.reward
		self.reward.msg = "MESSAGE_BABEL_TOWER_REFRESH"
		self.reward.subMsg = "reset"
		SoraDSendMessage(self.reward)
	elseif self.nowFloor < babelTowerRead:getTowerNum() then
		_ENV = babelTowerRead:getTowerNum()
		babelTowerRead:getTowerNum().msg = "MESSAGE_BABEL_TOWER_REFRESH"
		babelTowerRead:getTowerNum().subMsg = "nextFloorAction"
		SoraDSendMessage((babelTowerRead:getTowerNum()))
	elseif self.nowFloor >= babelTowerRead:getTowerNum() then
		_ENV = babelTowerRead:getTowerNum()
		babelTowerRead:getTowerNum().msg = "MESSAGE_BABEL_TOWER_REFRESH"
		babelTowerRead:getTowerNum().subMsg = "maxTowerReset"
		SoraDSendMessage((babelTowerRead:getTowerNum()))
	end
end
function babelTowerResult:ctor()
	self.farme_winlose = SoraDGetChildByName(self, "farme_winlose")
	self.btnSure = SoraDGetChildByName(self, "Button_Sure")
	self.btnSure:setTitleText(i18n("common_text_204"))
	self.btnSure:addTouchEventListener(handler(self, self.btnSureClick))
	self.Node_win = SoraDGetChildByName(self, "Node_win")
	self.Text_AwardTitle = SoraDGetChildByName(self.Node_win, "Text_AwardTitle")
	self.Text_AwardTitle:setString(i18n("Promise_Summit_text_29"))
	self.scrollItem = SoraDGetChildByName(self.Node_win, "ScrollView")
	self.nodeItem = SoraDGetChildByName(self.Node_win, "Node_Item")
	self.Node_lose = SoraDGetChildByName(self, "Node_lose")
	self.Text_LoseTip = SoraDGetChildByName(self.Node_lose, "Text_LoseTip")
	self.Text_LoseTip:setString(i18n("Promise_Summit_text_21"))
	self:initEffect()
end
function babelTowerResult:initEffect()
	local loop = true
	local cssFileName = "babelTowerResult"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, loop)
	self:runAction(action)
end
function babelTowerResult:initData(floor, reward, isWin)
	self.Node_win:setVisible(isWin)
	self.Node_lose:setVisible(not isWin)
	if isWin then
		self.farme_winlose:setSpriteFrame(SoraDFIsRA() and "font_ttt_congratulations_ar.png" or "farme_jlnf_gx_en.png")
	else
		self.farme_winlose:setSpriteFrame(SoraDFIsRA() and "font_ttt_fail_ar.png" or "font_ttt_fail_en.png")
	end
	self.nowFloor = floor
	self.reward = reward
	self.isWin = isWin
	if self.reward then
		self:refreshScroll()
	end
end
function babelTowerResult:refreshScroll()
	local innerContainer = self.scrollItem:getInnerContainer()
	local innerWidth = innerContainer:getContentSize().width
	self.scrollItem:setBounceEnabled(#self.reward > 4)
	for i, v in ipairs(self.reward) do
		local single = include("commonItemAward").new()
		single:addTo(self.nodeItem)
		single:setScale(#self.reward > 4 and 0.8 or 1)
		single:setBaseScale(1.0)
		single:setOwnView(self)
		single:initData(v.id, v.count)
	end
	SoraDautoSortPos(self.nodeItem, 4, 1, cc.size(110, 100), SoraDFIsRA())
end
function babelTowerResult:btnSureClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function babelTowerResult:btnBoxAwardClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.nowFloor % 10 == 1 then
			local panel = SoraDCreatePanel("babelTowerBoxInfo")
			local nextTenFloor = math.ceil(self.nowFloor / 10) * 10
			panel:initData(nextTenFloor)
			panel:show()
		end
	end
end
return babelTowerResult

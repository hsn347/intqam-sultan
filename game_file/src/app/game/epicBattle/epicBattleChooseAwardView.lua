local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local publicRead = include("publicRead")
local buffDesRead = include("buffDesRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local epicBattleDef = include("epicBattleDef")
local epicBattleChooseAwardView = class("epicBattleChooseAwardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicBattleChooseAwardView")
	end
	return target
end)
function epicBattleChooseAwardView:ctor()
	self.isChoose = false
	self.isShow = false
	self.data = nil
	self.param, _ENV, self.singleArray, _ENV, self.finalIndex = nil, nil, nil, nil, 1
	SoraDGetChildByName(self, "Image_contentBg"):setFillType(1)
	self.Node_round = SoraDGetChildByName(self, "Node_round")
	self.Text_chooseOne = SoraDGetChildByName(self, "Text_chooseOne")
	self.Text_chooseOne:setString(i18n("epicbattle_text_14"))
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("epicbattle_text_38"))
	self.Node_items = SoraDGetChildByName(self, "Node_items")
	self.Node_select = SoraDGetChildByName(self, "Node_select")
	self.act_select = SoraDCreatAnimation("epicBattleChooseBorder")
	self.act_select:addTo(self.Node_select)
	self.Node_select:setVisible(false)
	self.dh_shishizzann = SoraDGetChildByName(self, "dh_shishizzann")
	SoraDMixtureGLONE(self.dh_shishizzann)
	self.dh_shishizzann:setVisible(false)
	local bDrawNode = cc.DrawNode:create()
	local bigR = bDrawNode:drawDot(cc.p(0, 0), 220, cc.c4b(0, 0, 0, 200))
	bigR:addTo(self.Node_round, 1)
	local sDrawNode = cc.DrawNode:create()
	local smallR = sDrawNode:drawDot(cc.p(0, 0), 100, cc.c4b(0, 0, 0, 180))
	smallR:addTo(self.Node_round, 1)
	self.Text_tip:setVisible(false)
	self.dh_shishizzann:setVisible(true)
	self.dh_shishizzann:runAction(cc.RepeatForever:create(cca.rotateBy(1.1666666666666667, -360)))
	self.Button_choose = SoraDGetChildByName(self, "Button_choose")
	self.Text_draw = SoraDGetChildByName(self.Button_choose, "Text_draw")
	self.Text_draw:setString(i18n("common_btn_02"))
	self.Node_draw = SoraDGetChildByName(self.Button_choose, "Node_draw")
	self.Text_silver = SoraDGetChildByName(self.Button_choose, "Text_silver")
	self.Button_choose:addTouchEventListener(handler(self, self.onBtnChooseClick))
end
function epicBattleChooseAwardView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_CHOOSE_BOX", handler(self, self.showAction))
end
function epicBattleChooseAwardView:initData(data, pos)
	self.data = data
	self.pos = pos
	self.mithrilCount = epicWarCtrl:getMithrilCount()
	self.cost = self.data.eventData.eventParam.needMithril
	self.randomPackage = self.data.eventData.eventParam.randomPackage
	self.randomRet = self.data.eventData.eventParam.randomRet
	local multiple = activityShowCtrl:getEpicCommandMultiple()
	for k, v in ipairs(self.randomRet) do
		if backpackltCtrl:getItemType(v.id) == gItemType.LEADER_POINT and 1 < multiple then
			v.count = v.count * multiple
		end
	end
	self:initAwards()
	self.Text_silver:setString(self.cost)
	self.Text_silver:setColor(self.mithrilCount >= self.cost and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
	SoraDToCenter(self.Node_draw, 0)
end
function epicBattleChooseAwardView:setBorderVistble(ret)
	SoraDGetChildByName(self.act_select, "Image_selected_01"):setVisible(ret)
	SoraDGetChildByName(self.act_select, "Image_selected_02"):setVisible(ret)
end
function epicBattleChooseAwardView:initAwards()
	self.award = backpackltCtrl:getShowItems(self.randomPackage)
	local multiple = activityShowCtrl:getEpicCommandMultiple()
	local _r = 160
	local _total = #self.award
	local _angle = 360 / _total
	for i = 1, _total do
		local single = include("commonItemAward").new()
		single:setOwnView(self)
		single:initData(self.award[i].id, self.award[i].count)
		if backpackltCtrl:getItemType(self.award[i].id) == gItemType.LEADER_POINT and 1 < multiple then
			single:setUpVisible(true)
			single:initData(self.award[i].id, self.award[i].count * multiple)
		end
		single:setScale(0.8)
		single:setBaseScale(1.0)
		local _rad = math.rad(_angle * (i - 1))
		local _posX = _r * math.sin(_rad)
		local _posY = _r * math.cos(_rad)
		if i == 3 or i == 4 then
			_posX = _posX + 3
			_posY = _posY + (3 < i and 6 or -6)
		end
		if i == 8 or i == 9 then
			_posX = _posX - 3
			_posY = _posY + (8 < i and -6 or 6)
		end
		single:setPosition(cc.p(_posX, _posY))
		single:addTo(self.Node_items)
		table.insert(self.singleArray, single)
		if self.randomRet[1].id == self.award[i].id and self.randomRet[1].count == self.award[i].count then
			self.finalIndex = i
		end
	end
end
function epicBattleChooseAwardView:showAction(target, data)
	SoraDCloseLoading(self)
	local nextIndex = 1
	local posX = self.singleArray[nextIndex]:getPositionX()
	local posY = self.singleArray[nextIndex]:getPositionY()
	self.Node_select:setPosition(posX, posY)
	self.Node_select:setVisible(true)
	self:setBorderVistble(false)
	local speedTime = 0
	local cicle = 1
	self.timer = SoradCreateTimer(self, function(dt)
		if 5 < cicle and nextIndex == self.finalIndex and self.timer then
			SoraDPlaySound("pyramid", 6)
			self:setBorderVistble(true)
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
			nextIndex = nil
			;(nil)[1] = cca.delay(1.0)
			;(nil)[2] = cca.callFunc(function()
				self:showResult()
				self.isShow = true
				self:removeFromParent()
			end)
			;(nil)[3] = cca.callFunc(function()
				self:showResult()
				self.isShow = true
				self:removeFromParent()
			end)
			self:runAction(cca.seq(nil))
			return
		end
		if speedTime >= nextIndex * (2 * math.abs(3 - cicle) + 1) / 120 then
			if nextIndex > #self.award then
			end
			local _posX = self.singleArray[nextIndex]:getPositionX()
			local _posY = self.singleArray[nextIndex]:getPositionY()
			self.Node_select:setPosition(_posX, _posY)
			SoraDPlaySound("pyramid", 3)
		end
	end, true)
end
function epicBattleChooseAwardView:onBtnChooseClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.mithrilCount >= self.cost then
			self.Button_choose:setTouchEnabled(false)
			self.isChoose = true
			epicWarCtrl:sendReqTriggerEvent(self.pos)
			SoraDShowLoading(self)
		else
			SoraDShowMsgTip(i18n("tips_silverCoins_noEnough"))
		end
	end
end
function epicBattleChooseAwardView:showResult()
	if not buffDesRead.isBuff(self.randomRet[1].id) then
		SoraDMailGainItems(self.randomRet, true)
	else
		local isGood = buffDesRead.isGoodBuff(self.randomRet[1].id)
		local eType = isGood and epicBattleDef.epicFlyColor.orange or epicBattleDef.epicFlyColor.black
		buffDesRead = nil
		;(nil).msg = "MESSAGE_UI_EPICBATTLE_BUFF_CHOOSE"
		;(nil).eType = eType
		;(nil).pos = self.singleArray[self.finalIndex]:convertToWorldSpace(cc.p(0, 0))
		SoraDSendMessage(nil)
	end
end
function epicBattleChooseAwardView:onExitPanel()
	if self.isChoose and not self.isShow then
		self:showResult()
	end
end
return epicBattleChooseAwardView

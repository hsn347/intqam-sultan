local pyramidBattleNewWinPopView = class("pyramidBattleNewWinPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("pyramidBattleNewWinPopView")
	end
	return target
end)
function pyramidBattleNewWinPopView:ctor()
	self.enableTouchCloseSelf = true
	self.baseclose = self.close
	self.rHeadTbl, _ENV, self.lHeadTbl, _ENV, self.close = function()
		print("overrided")
	end, function()
		print("overrided")
	end, function()
		print("overrided")
	end, function()
		print("overrided")
	end, function()
		print("overrided")
	end
	self.imgTitle = SoraDGetChildByName(self, "Image_title")
	self.node_action = SoraDGetChildByName(self, "Node_action")
	self.nodeLordLeft = SoraDGetChildByName(self, "Node_leftSingle")
	self.nodeLordRight = SoraDGetChildByName(self, "Node_rightSingle")
	self.panelList = SoraDGetChildByName(self, "Top_Panel_list")
	self.nodeTop = SoraDGetChildByName(self, "Top_Node")
	self.btnOk = SoraDGetChildByName(self, "Button_ok")
	self.btnShare = SoraDGetChildByName(self, "Button_share")
	self.btnOk:addTouchEventListener(handler(self, self.btnOkClick))
	self.imgLeft = SoraDGetChildByName(self, "Image_left")
	self.txtLName = SoraDGetChildByName(self, "Text_leftName")
	self.txtLPoint = SoraDGetChildByName(self, "Text_leftPoint")
	self.imgRight = SoraDGetChildByName(self, "Image_right")
	self.txtRName = SoraDGetChildByName(self, "Text_rightName")
	self.txtRPoint = SoraDGetChildByName(self, "Text_rightPoint")
	self.nodeTitle = SoraDGetChildByName(self, "Top_Node_title")
	self.scrollItems = SoraDGetChildByName(self, "Top_Size_ScrollView_items")
	self.nodeBottom = SoraDGetChildByName(self, "Bottom_Node")
	self.txtPersionInt = SoraDGetChildByName(self, "Text_title")
	self.btnOk:setTitleText(i18n("common_text_204"))
	SoraDGetChildByName(self, "Text_tip"):setString(i18n("common_text_4403"))
	self.timeHandler = SoraDCreateTimerEx(self, handler(self, self.endTime), 15)
	include("commonShareButton").createSnapshootWithButton(self.btnShare, 4, nil, function()
	end, function()
	end, function()
	end)
	self:clipPanel()
end
function pyramidBattleNewWinPopView:clipPanel(...)
	_UPVALUE2_, _UPVALUE4_ = nil, nil
	_UPVALUE2_, (nil)[1] = 0, 0
	_UPVALUE2_, (nil)[2] = 0, 0
	_UPVALUE2_, (0)[1] = 0, 0
	_UPVALUE2_, (0)[2] = 0, 106
	_UPVALUE2_, (0)[1] = 337, 337
	_UPVALUE2_, (0)[2] = 337, 106
	;(337)[1] = 300
	;(337)[2] = 0
	;(nil)[1] = nil
	;(nil)[2] = 0
	;(nil)[3] = 0
	local (nil)[4], points = 337, nil
	local shapNode = display.newPolygon(points)
	self.cliperNode = cc.ClippingNode:create()
	self.cliperNode:setStencil(shapNode)
	self.cliperNode:setInverted(false)
	self.cliperNode:setPosition(0, -312)
	self.cliperNode:addTo(self.nodeTop, -1)
	self.imgLeft:retain()
	self.imgLeft:removeFromParent()
	self.imgLeft:addTo(self.cliperNode)
	self.imgLeft:setPosition(0, 0)
	self.imgLeft:setAnchorPoint(cc.p(0, 0))
	self.imgLeft:release()
	_UPVALUE2_, _UPVALUE4_ = self.imgLeft, self.imgLeft.release
	_UPVALUE2_, self.imgLeft[1] = -337, -337
	_UPVALUE2_, self.imgLeft[2] = -337, 0
	_UPVALUE2_, (-337)[1] = -300, -300
	_UPVALUE2_, (-337)[2] = -300, 106
	_UPVALUE2_, (-300)[1] = 0, 0
	_UPVALUE2_, (-300)[2] = 0, 106
	;(0)[1] = 0
	;(0)[2] = 0
	self.imgLeft.release[1] = self.imgLeft
	self.imgLeft.release[2] = -337
	self.imgLeft.release[3] = -300
	local self.imgLeft.release[4], points1 = 0, self.imgLeft.release
	local shapNode1 = display.newPolygon(points1)
	self.cliperNode1 = cc.ClippingNode:create()
	self.cliperNode1:setStencil(shapNode1)
	self.cliperNode1:setInverted(false)
	self.cliperNode1:setPosition(640, -312)
	self.cliperNode1:addTo(self.nodeTop, -1)
	self.imgRight:retain()
	self.imgRight:setPosition(0, 0)
	self.imgRight:setAnchorPoint(cc.p(1, 0))
	self.imgRight:removeFromParent()
	self.imgRight:addTo(self.cliperNode1)
	self.imgRight:release()
end
function pyramidBattleNewWinPopView:prepare4Action(...)
	self.imgTitle:setPositionY(self.imgTitle:getPositionY() + self.imgTitle:getContentSize().height)
	self.cliperNode:setPositionX(-self.imgLeft:getContentSize().width)
	self.cliperNode1:setPositionX(640 + self.imgRight:getContentSize().width)
	for i = 1, 3 do
		if self.lHeadTbl[i] then
			self.lHeadTbl[i]:setPositionX(-320)
		end
		if self.rHeadTbl[i] then
			self.rHeadTbl[i]:setPositionX(960)
		end
	end
	self.PosYNodeTitle = self.nodeTitle:getPositionY()
	self.nodeTitle:setPositionY(0)
	self.scrollItems:setPositionY(-50)
	self.nodeBottom:setPositionY(-50 - self.scrollItems:getContentSize().height - 90)
	self.txtLName:setPositionX(-self.txtLName:getPositionX())
	self.txtLPoint:setPositionX(-self.txtLPoint:getPositionX())
	self.txtRName:setPositionX(320 + self.txtRName:getPositionX())
	self.txtRPoint:setPositionX(320 + self.txtRPoint:getPositionX())
end
function pyramidBattleNewWinPopView:start2Action(...)
	self.imgTitle:runAction(cca.moveTo(0.3, self.imgTitle:getPositionX(), self.imgTitle:getPositionY() - self.imgTitle:getContentSize().height))
	self.cliperNode:runAction(cca.moveTo(0.3, 0, self.cliperNode:getPositionY()))
	self.cliperNode1:runAction(cca.moveTo(0.3, 640, self.cliperNode1:getPositionY()))
	for i = 1, 3 do
		if self.lHeadTbl[i] then
			_UPVALUE1_ = cca.moveTo(0.3, 640, self.cliperNode1:getPositionY())
			cca.moveTo(0.3, 640, self.cliperNode1:getPositionY())[1] = cca.delay(i * 0.1)
			cca.moveTo(0.3, 640, self.cliperNode1:getPositionY())[2] = cca.moveTo(0.2, 0, self.lHeadTbl[i]:getPositionY())
			cca.moveTo(0.3, 640, self.cliperNode1:getPositionY())[3] = cca.moveTo(0.2, 0, self.lHeadTbl[i]:getPositionY())
			cca.moveTo(0.3, 640, self.cliperNode1:getPositionY())[4] = cca.moveTo(0.2, 0, self.lHeadTbl[i]:getPositionY())
			cca.moveTo(0.3, 640, self.cliperNode1:getPositionY())[5] = cca.moveTo(0.2, 0, self.lHeadTbl[i]:getPositionY())
			cca.moveTo(0.3, 640, self.cliperNode1:getPositionY())[6] = cca.moveTo(0.2, 0, self.lHeadTbl[i]:getPositionY())
			self.lHeadTbl[i]:runAction(cca.seq(cca.moveTo(0.3, 640, self.cliperNode1:getPositionY())))
		end
		if self.rHeadTbl[i] then
			_UPVALUE1_ = cca.seq(cca.moveTo(0.3, 640, self.cliperNode1:getPositionY()))
			cca.seq(cca.moveTo(0.3, 640, self.cliperNode1:getPositionY()))[1] = cca.delay(i * 0.1)
			cca.seq(cca.moveTo(0.3, 640, self.cliperNode1:getPositionY()))[2] = cca.moveTo(0.2, 640, self.rHeadTbl[i]:getPositionY())
			cca.seq(cca.moveTo(0.3, 640, self.cliperNode1:getPositionY()))[3] = cca.moveTo(0.2, 640, self.rHeadTbl[i]:getPositionY())
			cca.seq(cca.moveTo(0.3, 640, self.cliperNode1:getPositionY()))[4] = cca.moveTo(0.2, 640, self.rHeadTbl[i]:getPositionY())
			cca.seq(cca.moveTo(0.3, 640, self.cliperNode1:getPositionY()))[5] = cca.moveTo(0.2, 640, self.rHeadTbl[i]:getPositionY())
			cca.seq(cca.moveTo(0.3, 640, self.cliperNode1:getPositionY()))[6] = cca.moveTo(0.2, 640, self.rHeadTbl[i]:getPositionY())
			self.rHeadTbl[i]:runAction(cca.seq(cca.seq(cca.moveTo(0.3, 640, self.cliperNode1:getPositionY()))))
		end
	end
	self.nodeTitle:runAction(cca.moveTo(0.3, self.nodeTitle:getPositionX(), self.PosYNodeTitle))
	self.scrollItems:runAction(cca.moveTo(0.3, self.scrollItems:getPositionX(), self.PosYNodeTitle - 50))
	self.nodeBottom:runAction(cca.moveTo(0.3, self.nodeBottom:getPositionX(), 0))
	self.txtLName:runAction(cca.moveTo(0.3, -self.txtLName:getPositionX(), self.txtLName:getPositionY()))
	self.txtLPoint:runAction(cca.moveTo(0.3, -self.txtLPoint:getPositionX(), self.txtLPoint:getPositionY()))
	self.txtRName:runAction(cca.moveTo(0.3, self.txtRName:getPositionX() - 320, self.txtRName:getPositionY()))
	self.txtRPoint:runAction(cca.moveTo(0.3, self.txtRPoint:getPositionX() - 320, self.txtRPoint:getPositionY()))
	SoraDCreateScoreLabel(self.txtRPoint, true)
	self.txtRPoint:runScoreAnimation(1, tonumber(self.txtRPoint:getString()), 1)
	SoraDCreateScoreLabel(self.txtLPoint, true)
	self.txtLPoint:runScoreAnimation(1, tonumber(self.txtLPoint:getString()), 1)
end
function pyramidBattleNewWinPopView:initData(info)
	self.battleInfo = info
	self.attackerInfo = info.topRankInfo.attacker
	self.defenderInfo = info.topRankInfo.defender
	if not next(self.attackerInfo.allianceInfo) then
		_ENV = self.attackerInfo.allianceInfo
		self.attackerInfo.allianceInfo.kid = 1
		self.attackerInfo.allianceInfo.aid = 0
		self.attackerInfo.allianceInfo.allianceAbbr = "N/A"
		self.attackerInfo.allianceInfo.allianceName = "N/A"
		self.attackerInfo.allianceInfo, self.attackerInfo.allianceInfo.point = self.attackerInfo.allianceInfo, 0
	end
	if not next(self.defenderInfo.allianceInfo) then
		_ENV = self.defenderInfo.allianceInfo
		self.defenderInfo.allianceInfo.kid = 1
		self.defenderInfo.allianceInfo.aid = 0
		self.defenderInfo.allianceInfo.allianceAbbr = "N/A"
		self.defenderInfo.allianceInfo.allianceName = "N/A"
		self.defenderInfo.allianceInfo, self.defenderInfo.allianceInfo.point = self.defenderInfo.allianceInfo, 0
	end
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	self.myAid = tonumber(allianceMgr:getOwnAid())
	if self.myAid == self.attackerInfo.allianceInfo.aid and self.battleInfo.isWin or self.myAid == self.defenderInfo.allianceInfo.aid and not self.battleInfo.isWin then
		self.attackWin = true
	end
	print("self.attackWin=", self.attackWin)
	self:initView()
end
function pyramidBattleNewWinPopView:initView(...)
	_ENV = nil
	;(nil).abbr = self.attackerInfo.allianceInfo.allianceAbbr
	;(nil).name = self.attackerInfo.allianceInfo.allianceName
	local lName = i18n("common_text_186", nil) .. "#" .. self.attackerInfo.allianceInfo.kid
	self.txtLName:setString(lName)
	self.txtLPoint:setString(self.attackerInfo.allianceInfo.point)
	_ENV = self.attackerInfo.allianceInfo.point
	self.attackerInfo.allianceInfo.point.abbr = self.defenderInfo.allianceInfo.allianceAbbr
	self.attackerInfo.allianceInfo.point.name = self.defenderInfo.allianceInfo.allianceName
	local rName = i18n("common_text_186", self.attackerInfo.allianceInfo.point) .. "#" .. self.defenderInfo.allianceInfo.kid
	self.txtRName:setString(rName)
	self.txtRPoint:setString(self.defenderInfo.allianceInfo.point)
	_ENV = nil
	;(nil).score = string.formatnumberthousands(self.battleInfo.points)
	self.txtPersionInt:setString(i18n("common_text_4404", nil))
	if self.attackWin then
		self.txtLName:setColor(cc.c3b(255, 255, 255))
		self.txtLPoint:setColor(cc.c3b(255, 255, 0))
	else
		self.txtRName:setColor(cc.c3b(255, 255, 255))
		self.txtRPoint:setColor(cc.c3b(255, 255, 0))
	end
	local sSize = self.panelList:getContentSize()
	for i = 1, 3 do
		if self.attackerInfo.topInfo and self.attackerInfo.topInfo[i] then
			local lItem = self.nodeLordLeft:clone()
			local lItemName = SoraDGetChildByName(lItem, "Text_name")
			local lItemInt = SoraDGetChildByName(lItem, "Text_int")
			lItemName:setString(self.attackerInfo.topInfo[i].nickName)
			lItemInt:setString(string.formatnumberthousands(self.attackerInfo.topInfo[i].point))
			if self.attackWin then
				lItemName:setColor(cc.c3b(214, 194, 156))
				lItemInt:setColor(cc.c3b(255, 255, 0))
			end
			local lHead = SoraDGetExtendChildFromCCSByName(lItem, "CCS_commonHead_head")
			lHead:setHeadSprite(self.attackerInfo.topInfo[i].iconID, self.attackerInfo.topInfo[i].avatar)
			lHead:setBgLightVisible(false)
			lItem:setPosition(0, sSize.height - (i - 1) * 100 - 50.0)
			lItem:addTo(self.panelList)
			table.insert(self.lHeadTbl, lItem)
		end
		if self.defenderInfo.topInfo and self.defenderInfo.topInfo[i] then
			local rItem = self.nodeLordRight:clone()
			local rItemName = SoraDGetChildByName(rItem, "Text_name")
			local rItemInt = SoraDGetChildByName(rItem, "Text_int")
			rItemName:setString(self.defenderInfo.topInfo[i].nickName)
			rItemInt:setString(string.formatnumberthousands(self.defenderInfo.topInfo[i].point))
			if not self.attackWin then
				rItemName:setColor(cc.c3b(214, 194, 156))
				rItemInt:setColor(cc.c3b(255, 255, 0))
			end
			local rHead = SoraDGetExtendChildFromCCSByName(rItem, "CCS_commonHead_head")
			rHead:setHeadSprite(self.defenderInfo.topInfo[i].iconID, self.defenderInfo.topInfo[i].avatar)
			rHead:setBgLightVisible(false)
			rItem:setPosition(640, sSize.height - (i - 1) * 100 - 50.0)
			rItem:addTo(self.panelList)
			table.insert(self.rHeadTbl, rItem)
		end
	end
	local itemCounts = #self.battleInfo.rewards
	sSize = self.scrollItems:getContentSize()
	local sH = math.max(sSize.height, math.ceil(itemCounts / 6) * 100)
	self.scrollItems:setInnerContainerSize(cc.size(sSize.width, sH))
	local sP = 20.0
	for i, v in ipairs(self.battleInfo.rewards) do
		local item = include("commonItemAward").new()
		item:addTo(self.scrollItems)
		item:setBaseScale(0.95)
		item:setOwnView(self)
		item:setOwnScroll(self.scrollItems)
		item:initData(v.id, v.count)
		item:setPosition(sP + (i - 1) % 6 * 100 + 50.0, sH - math.ceil(i / 6) * 100 + 50)
	end
	if self.battleInfo.isWin then
		local node = SoraDCreatAnimation("animationKingWarWin", nil, false)
		local Node_action = SoraDGetChildByName(node, "Node_action")
		for i, v in ipairs(Node_action:getChildren()) do
			v:setVisible(false)
		end
		_UPVALUE2_ = ipairs(Node_action:getChildren())
		ipairs(Node_action:getChildren())[1] = "image_zdwin_14_1"
		ipairs(Node_action:getChildren())[2] = "image_zdwin_11_2"
		for i, v in ipairs(ipairs(Node_action:getChildren())) do
			local widget = SoraDGetChildByName(Node_action, v)
			if widget then
				widget:setVisible(true)
			end
		end
		node:addTo(self.node_action)
		SoraDPlaySound("epicControl", 5)
	else
		local node = SoraDCreatAnimation("animationKingWarLose", nil, false)
		SoraDGetChildByName(node, "Node_butiao"):setVisible(false)
		SoraDGetChildByName(node, "Image_1"):setVisible(false)
		SoraDGetChildByName(node, "Image_2"):setVisible(false)
		SoraDGetChildByName(node, "Image_3"):setVisible(false)
		SoraDGetChildByName(node, "Image_4"):setVisible(false)
		node:addTo(self.node_action)
		SoraDPlaySound("epicControl", 2)
	end
end
local reLogin = function(...)
	if not worldMapDefine.isInPyramid() then
		_G.SoraDQuickLogin()
	end
end
function pyramidBattleNewWinPopView:endTime(dt)
	reLogin()
end
function pyramidBattleNewWinPopView:btnOkClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		reLogin()
	end
end
function pyramidBattleNewWinPopView:onExitPanel()
	_G.SoraDGetCtrl("pyramidWarCtrl"):resetPyramidWarEnd()
end
return pyramidBattleNewWinPopView

local gametop = gModuleMgr.getObject("gametop")
local spiritualGiftRead = include("spiritualGiftRead")
local spiritualGiftCtrl = SoraDGetCtrl("spiritualGiftCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local effectUI = include("effectUI")
local spiritualGiftPopRewardView = class("spiritualGiftPopRewardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("spiritualGiftPopRewardView")
	end
	return target
end)
singleNodeH = 100
function spiritualGiftPopRewardView:ctor()
	self.group = activityShowCtrl:getParamByID(gActivityTimeActivityID.SPIRITUAL_GIFT).classtype
	self:initControls()
	self:fitDevice()
	self:initEffect()
	self:showShaderEffect()
	self:panelScaleAct()
end
function spiritualGiftPopRewardView:fitDevice()
	print("weoiruwieouroiwefsdfds", display.height)
	if math.floor(display.height) < 960 then
		self.centerNode:setScale(0.7)
	elseif math.floor(display.height) == 960 then
	end
end
function spiritualGiftPopRewardView:showShaderEffect()
	if not self.meshNode2 then
		local _shader = require("app.game.eventCenterView.eventTemplate.spiritualGift.Shader_ljlnf_Flow_002")
		local _meshData = require("app.game.eventCenterView.eventTemplate.spiritualGift.MeshData_ljlnf_Flow_002")
		local _param = require("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002")
		_ENV = "app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002"
		;("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002").meshData = _meshData
		_ENV, ("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002").size = cc.size(1, 1), cc.size(1, 1)
		cc.size(1, 1).vertBytes = _shader.vertBytes
		;("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002").shader, cc.size(1, 1).fragBytes = cc.size(1, 1), _shader.fragBytes
		;("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002").param = _param.param
		_ENV, ("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002").pos = cc.p(0, 350), cc.p(0, 350)
		cc.p(0, 350).x = 0.4
		;("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002").scale, cc.p(0, 350).y = cc.p(0, 350), 0.4
		local createData = "app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002"
		local meshNode = SoraDCreateMeshNode(createData.meshData, createData.size, createData.shader, createData.param)
		meshNode:setPosition(cc.p(createData.pos))
		_ENV = cc.p(createData.pos)
		cc.p(createData.pos).x = 0
		cc.p(createData.pos).y = 0
		cc.p(createData.pos).z = 0
		meshNode:setRotation3D(cc.p(createData.pos))
		meshNode:setScale(createData.scale.x, createData.scale.y)
		meshNode:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		meshNode:addTo(self.centerNode, -1)
		self.meshNode2 = meshNode
	end
end
function spiritualGiftPopRewardView:initControls()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.nodeUpper = SoraDGetChildByName(self, "Node_lace")
	self.nodeNumber = SoraDGetChildByName(self, "Node_Number")
	self.txtInstruct = SoraDGetChildByName(self, "text_instruct")
	self.txtNumber = SoraDGetChildByName(self, "text_number")
	self.scroll = SoraDGetChildByName(self, "ScrollView_1")
	self.btnOne = SoraDGetChildByName(self, "btn_one")
	self.btnTen = SoraDGetChildByName(self, "btn_ten")
	self.imgProgress = SoraDGetChildByName(self, "Image_bgProgress")
	self.imgNumber = SoraDGetChildByName(self, "Image_37")
	self.iconTicket2 = SoraDGetChildByName(self.btnOne, "icon_main_gold_228_0")
	self.iconTicket3 = SoraDGetChildByName(self.btnTen, "icon_main_gold_228_0_0")
	self.txtOneGold = SoraDGetChildByName(self, "text_oneGold")
	self.txtTenGold = SoraDGetChildByName(self, "text_tenGold")
	self.txtOneTitle = SoraDGetChildByName(self, "text_oneTitle")
	self.txtTenTitle = SoraDGetChildByName(self, "text_tenTitle")
	self.txtProgress = SoraDGetChildByName(self, "text_progress")
	self.loadingbar = SoraDGetChildByName(self, "LoadingBar_progress")
	self.txtMaintitle = SoraDGetChildByName(self, "text_instruct")
	self.btnOne:addTouchEventListener(handler(self, self.btnOneDrawClick))
	self.btnTen:addTouchEventListener(handler(self, self.btnTenDrawClick))
	self.imgTextLan = SoraDGetChildByName(self, "farme_jlnf_gx_en_19")
	if SoraDGetDefaultLanguage() ~= "ar" and SoraDGetDefaultLanguage() ~= "en" then
		local str = "bg_spiritual_gift_pop_" .. SoraDGetDefaultLanguage() .. ".png"
		self.imgTextLan:setSpriteFrame(str)
	end
	self.iconTicket2:setSpriteFrame("1049.png")
	self.iconTicket3:setSpriteFrame("1049.png")
	self.iconTicket2:setScale(0.3)
	self.iconTicket3:setScale(0.3)
	self.centerNode:setPositionY(display.height / 2)
	self.txtNumber:setString(i18n("godGift_text_20"))
	self.txtOneGold:setString(1)
	self.txtTenGold:setString(10)
	_ENV = i18n("godGift_text_20")
	i18n("godGift_text_20").num = 1
	self.txtOneTitle:setString(i18n("godGift_btn_02", i18n("godGift_text_20")))
	_ENV = i18n("godGift_btn_02", i18n("godGift_text_20"))
	i18n("godGift_btn_02", i18n("godGift_text_20")).num = 10
	self.txtTenTitle:setString(i18n("godGift_btn_02", i18n("godGift_btn_02", i18n("godGift_text_20"))))
	self.txtMaintitle:setString(i18n("godGift_text_19"))
	self.tableCell, _ENV, self.luckyNumberTable, _ENV, self.oneTimeCostTicket = spiritualGiftRead:getOneTimeTicketCost(self.group), spiritualGiftRead:getOneTimeTicketCost(self.group), spiritualGiftRead:getOneTimeTicketCost(self.group), spiritualGiftRead:getOneTimeTicketCost(self.group), spiritualGiftRead:getOneTimeTicketCost(self.group)
	self.enableTouchCloseSelf = true
	self.changeNum = 0
end
function spiritualGiftPopRewardView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SPIRITUAL_BUY_ROLL_BACK", function(target, data)
		SoraDCloseLoading(self)
		if self.changeNum > 0 then
			spiritualGiftCtrl:reqDrawLottery(self.changeNum)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SPIRITUAL_DRAW_BACK", function(target, data)
		SoraDCloseLoading(self)
	end)
end
function spiritualGiftPopRewardView:initEffect()
	local effect = SoraDCreatAnimation("spiritualGiftPopRewardEffect")
	SoraDMixtureGLONEByParent(effect)
	effect:setPosition(0, -185)
	effect:addTo(self.nodeUpper)
end
function spiritualGiftPopRewardView:initData(rewardList)
	if not rewardList then
		return
	end
	self.luckyNumberTable, spiritualGiftCtrl = nil, nil
	self.poolPrizeType = spiritualGiftCtrl:getPoolPrizeType()
	local specialReward = spiritualGiftRead:getNormalPrizePreview(self.group)
	if next(self.tableCell) then
		for i, v in ipairs(self.tableCell) do
			v:setVisible(false)
		end
		self.tableCell, spiritualGiftCtrl = ipairs(self.tableCell)
	end
	self.scroll:removeAllChildren()
	self.btnOne:setVisible(false)
	self.btnTen:setVisible(false)
	self.imgProgress:setVisible(true)
	self.rewardList = rewardList
	local ticketCount = spiritualGiftCtrl:getGiftRollNum()
	local effect = SoraDCreatAnimation("Node_Effect_hjjm02", nil, false)
	SoraDMixtureGLONEByParent(effect)
	effect:addTo(self.nodeUpper)
	effect:setPosition(0, -150)
	if table.nums(self.rewardList) == 1 then
		local node = SoraDGetChildByName(effect, "Node_1")
		local cell = include("commonItemAward").new()
		cell:setOwnView(self)
		cell:initData(self.rewardList[1].reward[1].id, self.rewardList[1].reward[1].count)
		cell:setPosition(cc.p(23, 23))
		cell:addTo(SoraDGetChildByName(node, "wupin_4"))
		cell:setCascadeOpacityEnabled(true)
		if self.rewardList[1].reward[1].id == 821101 or self.rewardList[1].reward[1].id == 716401 then
			cell:showCoolSquare()
			cell.coolSquare:setCascadeOpacityEnabled(true)
		end
		local imgNumber = self.imgNumber:clone()
		imgNumber:setPosition(0, -115)
		if 0 >= self.rewardList[1].luckyGold then
			imgNumber:loadTexture("frame_alliance_grade_01.png", ccui.TextureResType.plistType)
		end
		imgNumber:addTo(self.nodeNumber)
		local txtNumber = SoraDGetChildByName(imgNumber, "BitmapFontLabel_1")
		txtNumber:setString(self.rewardList[1].luckyNumber)
		table.insert(self.tableCell, cell)
		table.insert(self.tableCell, imgNumber)
		table.insert(self.tableCell, txtNumber)
		if 0 < self.rewardList[1].luckyGold then
			table.insert(self.luckyNumberTable, self.rewardList[1])
		end
	else
		for i, v in ipairs(self.rewardList) do
			local node = SoraDGetChildByName(effect, "Node_" .. i)
			local cell = include("commonItemAward").new()
			cell:setScale(0.85)
			cell:setBaseScale(1.0)
			cell:setOwnView(self)
			cell:initData(v.reward[1].id, v.reward[1].count)
			if v.reward[1].id == 821101 or v.reward[1].id == 716401 then
				cell:showCoolSquare()
				cell.coolSquare:setCascadeOpacityEnabled(true)
			end
			cell:setPosition(cc.p(23, 23))
			cell:addTo(SoraDGetChildByName(node, "wupin_4"))
			cell:setCascadeOpacityEnabled(true)
			table.insert(self.tableCell, cell)
		end
		self:initScroll()
	end
	if table.nums(self.rewardList) == 1 then
		effect:setPosition(effect:getPositionX() - 220, effect:getPositionY() - 52)
	else
		self.nodeList, spiritualGiftCtrl = effect.setPosition, effect.setPosition
		for i = 1, 10 do
			local node = SoraDGetChildByName(effect, "Node_" .. i)
			if node then
				self.nodeList[i] = node
			end
		end
		if not SoraDFIsRA() then
			for i = 1, 2 do
				local Node_1 = self.nodeList[i]
				local Node_5 = self.nodeList[6 - i]
				local posx = Node_1:getPositionX()
				Node_1:setPositionX(Node_5:getPositionX())
				Node_5:setPositionX(posx)
			end
			for i = 1, 2 do
				local Node_1 = self.nodeList[5 + i]
				local Node_5 = self.nodeList[11 - i]
				local posx = Node_1:getPositionX()
				Node_1:setPositionX(Node_5:getPositionX())
				Node_5:setPositionX(posx)
			end
		end
	end
	for i = #self.rewardList + 1, 10 do
		local node = SoraDGetChildByName(effect, "Node_" .. i)
		if node then
			node:setVisible(false)
		end
	end
	local playerScore = spiritualGiftCtrl:getPlayerScore()
	local poolUpperLimit = spiritualGiftRead:getPoolUpperLimit(self.group, playerScore)
	self.txtProgress:setString(playerScore .. "/" .. poolUpperLimit)
	self.loadingbar:setPercent(playerScore / poolUpperLimit * 100)
	if ticketCount <= 0 then
		self.txtOneGold:setColor(cc.c3b(255, 0, 0))
		self.txtTenGold:setColor(cc.c3b(255, 0, 0))
	elseif 0 < ticketCount and ticketCount < 10 then
		self.txtOneGold:setColor(cc.c3b(255, 255, 0))
		self.txtTenGold:setColor(cc.c3b(255, 0, 0))
	elseif 10 <= ticketCount then
		self.txtOneGold:setColor(cc.c3b(255, 255, 0))
		self.txtTenGold:setColor(cc.c3b(255, 255, 0))
	end
	_UPVALUE5_ = self.txtTenGold
	self.txtTenGold[1] = cca.delay(2.0)
	self.txtTenGold[2] = cca.callFunc(function()
		for i = #self.luckyNumberTable, 1, -1 do
			local insPanel = SoraDCreatePanel("spiritualGiftGold")
			insPanel:initData(self.luckyNumberTable[i])
			insPanel:show()
		end
	end)
	self.txtTenGold[3] = cca.delay(2.0)
	self.txtTenGold[4] = cca.callFunc(function()
		self.btnOne:setVisible(true)
		self.btnTen:setVisible(true)
		self.imgProgress:setVisible(false)
	end)
	self.txtTenGold[5] = cca.delay(1.0)
	self.txtTenGold[6] = cca.callFunc(function()
		self.enableTouchCloseSelf = false
	end)
	self.txtTenGold[7] = cca.callFunc(function()
		self.enableTouchCloseSelf = false
	end)
	self.txtTenGold[8] = cca.callFunc(function()
		self.enableTouchCloseSelf = false
	end)
	local seq = cca.seq(self.txtTenGold)
	self:runAction(seq)
end
function spiritualGiftPopRewardView:initScroll()
	local initCol = math.ceil(#self.rewardList / 5)
	if #self.rewardList <= 5 then
		initCol = 2
	end
	local scrollH = math.max(self.scroll:getContentSize().height, 70 * initCol)
	self.scroll:setInnerContainerSize(cc.size(518, scrollH))
	for i, v in ipairs(self.rewardList) do
		local imgNumber = self.imgNumber:clone()
		if i <= 5 then
			imgNumber:setPosition(-90 + (i + 1) * 90, 100)
		else
			imgNumber:setPosition(-90 + (i - 5 + 1) * 90, 30)
		end
		if v.luckyGold <= 0 then
			imgNumber:loadTexture("frame_alliance_grade_01.png", ccui.TextureResType.plistType)
		end
		imgNumber:addTo(self.scroll)
		local txtNumber = SoraDGetChildByName(imgNumber, "BitmapFontLabel_1")
		txtNumber:setString(v.luckyNumber)
		if v.luckyGold > 0 then
			table.insert(self.luckyNumberTable, v)
		end
	end
end
function spiritualGiftPopRewardView:drawNow(type, other)
	if type == MSGBOX_CALLBACK_YES then
		local isCheck = other.isCheck or false
		self.changeNum = 1
		self:sureBuy(1)
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:spiritualGiftView:timeNotice~bool", isCheck, nil)
	end
end
function spiritualGiftPopRewardView:drawTenNow(type, other)
	if type == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
		local isCheck = other.isCheck or false
		self.changeNum = self.curTotalCount
		self:sureBuy(self.curNeedNum)
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:spiritualGiftView:timeNotice~bool", isCheck, nil)
	end
end
function spiritualGiftPopRewardView:btnOneDrawClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local ticketCount = spiritualGiftCtrl:getGiftRollNum()
		if self:getDailyRemainDrawCount() <= 0 then
			SoraDShowMsgTip(i18n("godGift_text_16"))
			return
		end
		if ticketCount < 1 then
			_ENV = i18n("godGift_text_16")
			i18n("godGift_text_16").byUID = true
			local isTodayNotice = SoraDConfigGet("Game:spiritualGiftView:timeNotice~bool", i18n("godGift_text_16"))
			print("sdlkjfsldkfjslds10", isTodayNotice)
			if not isTodayNotice then
				_ENV = i18n("godGift_text_16")
				i18n("godGift_text_16").price = self.oneTimeCostTicket
				i18n("godGift_text_16").num = 1
				SoraDShowBuyBox(i18n("godGift_text_12", i18n("godGift_text_16")), self.oneTimeCostTicket, i18n("common_text_054"), handler(self, self.drawNow), nil, nil, nil, nil, nil, i18n("godGift_text_27"), false, nil, "spiritualGiftView")
			else
				self.changeNum = 1
				self:sureBuy(1)
			end
			return
		end
		spiritualGiftCtrl:reqDrawLottery(1)
		SoraDShowLoading(self)
	end
end
function spiritualGiftPopRewardView:btnTenDrawClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local totalCount = 10
		local ticketCount = spiritualGiftCtrl:getGiftRollNum()
		local todayRemainCount = self:getDailyRemainDrawCount()
		local needNum = 0
		if todayRemainCount <= 0 then
			SoraDShowMsgTip(i18n("godGift_text_16"))
			return
		end
		if totalCount > todayRemainCount then
			totalCount = todayRemainCount
		end
		if ticketCount < 10 then
			needNum = totalCount - ticketCount
			if ticketCount >= totalCount then
				needNum = totalCount
			end
			needNum = totalCount - ticketCount
			self.curTotalCount = totalCount
			self.curNeedNum = needNum
			if 0 < needNum then
				_ENV = i18n("godGift_text_16")
				i18n("godGift_text_16").byUID = true
				local isTodayNotice = SoraDConfigGet("Game:spiritualGiftView:timeNotice~bool", i18n("godGift_text_16"))
				print("sdlkjfsldkfjslds10", isTodayNotice)
				if not isTodayNotice then
					_ENV = i18n("godGift_text_16")
					i18n("godGift_text_16").price = self.oneTimeCostTicket * needNum
					i18n("godGift_text_16").num = needNum
					SoraDShowBuyBox(i18n("godGift_text_12", i18n("godGift_text_16")), self.oneTimeCostTicket * needNum, i18n("common_text_054"), handler(self, self.drawTenNow), nil, nil, nil, nil, nil, i18n("godGift_text_27"), nil, nil, "spiritualGiftView")
				else
					self.changeNum = totalCount
					self:sureBuy(needNum)
				end
			else
				spiritualGiftCtrl:reqDrawLottery(totalCount)
				SoraDShowLoading(self)
			end
			return
		end
		spiritualGiftCtrl:reqDrawLottery(totalCount)
		SoraDShowLoading(self)
	end
end
function spiritualGiftPopRewardView:getDailyRemainDrawCount()
	local alreadyDrawCount = spiritualGiftCtrl:getAlreadyDrawNum()
	local remainDrawCount = spiritualGiftRead:getDailyBuyLimit(self.group) - alreadyDrawCount
	return remainDrawCount
end
function spiritualGiftPopRewardView:sureBuy(num)
	print("选择了数量:", num)
	local totalDiceCost = self.oneTimeCostTicket * num
	local ownGold = lordInfoCtrl:getBaseInfo().gold
	if totalDiceCost <= ownGold then
		spiritualGiftCtrl:reqBuyGiftRoll(num)
		SoraDShowLoading(self)
	else
		SoraDShowMsgBox(i18n("common_text_430"), i18n("common_text_054"), nil, handler(self, self.gotoStore))
	end
end
function spiritualGiftPopRewardView:gotoStore(type)
	if type == MSGBOX_CALLBACK_YES then
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
	end
end
function spiritualGiftPopRewardView:addItemEffect(item)
	local scale = 0.5
	self.glow1, self.glow2 = effectUI.getItemEffect()
	self.glow1:addTo(item)
	self.glow1:setPosition(cc.p(48, 49))
	self.glow1:setLocalZOrder(-1)
	self.glow1:setScale(1.4 * scale)
	self.glow2:addTo(item)
	self.glow2:setPosition(cc.p(48, 49))
	self.glow2:setLocalZOrder(1)
	self.glow2:setScale(1.4 * scale)
end
function spiritualGiftPopRewardView:onExitPanel()
	_ENV = nil
	;(nil).msg = "MESSAGE_SPIRITUAL_BIG_PRIZE_POOL_REFRESH"
	SoraDSendMessage(nil)
end
return spiritualGiftPopRewardView

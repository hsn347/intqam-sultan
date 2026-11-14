local gametop = gModuleMgr.getObject("gametop")
local secretBagCtrl = gametop.playertop_:getModule("secretBagCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local secretBagMainView = class("secretBagMainView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("secretBagMainView")
	end
	return target
end)
function secretBagMainView:ctor()
	self.isHideCurrentSceneView = true
	self.commonFramTitle_node = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_bg")
	self.commonFramTitle_node:setTitle(i18n("kits_name_01"))
	_UPVALUE4_ = self.commonFramTitle_node.setTitle
	self.boxImgs, self.commonFramTitle_node.setTitle[1] = self.commonFramTitle_node.setTitle, "icon_KingGroupbuy_lv1_small.png"
	self.boxImgs, self.commonFramTitle_node.setTitle[2] = self.commonFramTitle_node.setTitle, "icon_KingGroupbuy_lv2_small.png"
	self.boxImgs, self.commonFramTitle_node.setTitle[3] = self.commonFramTitle_node.setTitle, "icon_KingGroupbuy_lv3_small.png"
	self.boxImgs, self.commonFramTitle_node.setTitle[4] = self.commonFramTitle_node.setTitle, "icon_KingGroupbuy_lv4_small.png"
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.panelSingle = SoraDGetChildByName(self, "Panel_single")
	self.loadBar = SoraDGetChildByName(self, "LoadingBar_progress")
	self.btnBox = SoraDGetChildByName(self, "Button_price")
	self.btnBag = SoraDGetChildByName(self, "Button_openBag")
	self.txtBgCount = SoraDGetChildByName(self, "Text_bagNum")
	self.nodeProgress = SoraDGetChildByName(self, "Node_progress")
	self.nodeBag = SoraDGetChildByName(self, "Bottom_Node_bag")
	self.nodeTask = SoraDGetChildByName(self, "Top_Node_quest")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_list")
	self.scroll = include("dynamicScroll").new(self.scroll)
	self.btnBag:addTouchEventListener(handler(self, self.btnBagClick))
	self.txtCompleteNum = SoraDGetChildByName(self, "Text_completeNum")
	self.txtCompleteNum = SoraDChangeTextToHtml(self.txtCompleteNum)
	self.btnBagPrice = SoraDGetChildByName(self, "Top_Button_bagPrice")
	self.btnBagPrice:addTouchEventListener(handler(self, self.btnBagPriceClick))
	self.imgBag = SoraDGetChildByName(self, "Top_Image_bagBg")
	self.nodeGold = SoraDGetChildByName(self, "Top_Node_gold")
	self.nodeExplosion = SoraDGetChildByName(self, "Node_explo")
	self.nodeExplosion:setScale(1.2)
	self.nodeExplosion:setVisible(false)
	self.panelTip = SoraDGetChildByName(self, "Panel_tip")
	self.btns = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_btns")
	_ENV = "CCS_commonTabBtn_btns"
	;("CCS_commonTabBtn_btns").tabNum = 2
	_ENV, _ENV, ("CCS_commonTabBtn_btns").defaultClick = handler(self, self.btnBagPriceClick)
	handler(self, self.btnBagPriceClick).title = i18n("kits_title_01")
	handler(self, self.btnBagPriceClick).handle = handler(self, self.btnClickCallBack)
	handler(self, self.btnBagPriceClick).fontSize = 22
	handler(self, self.btnBagPriceClick).tag = 2
	_ENV, handler(self, self.btnBagPriceClick)[1], handler(self, self.btnBagPriceClick).name = handler(self, self.btnBagPriceClick)
	handler(self, self.btnBagPriceClick).title = i18n("kits_name_01")
	handler(self, self.btnBagPriceClick).handle = handler(self, self.btnClickCallBack)
	handler(self, self.btnBagPriceClick).fontSize = 22
	handler(self, self.btnBagPriceClick).tag = 1
	;("CCS_commonTabBtn_btns").tabsetArray, handler(self, self.btnBagPriceClick)[2], handler(self, self.btnBagPriceClick).name = handler(self, self.btnBagPriceClick)
	self.btns:initView("CCS_commonTabBtn_btns")
	self.btnBag:setTitleText(i18n("kits_btn_01"))
	SoraDGetChildByName(self, "Text_bagTip"):setString(i18n("common_text_3893"))
	SoraDGetChildByName(self, "Text_tip"):setString(i18n("kits_text_01"))
	SoraDGetChildByName(self, "Top_Size_Image_bg"):setFillType(1)
	self:initData()
end
function secretBagMainView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_SECRETBAG_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_SECRETBAG_GAINTASK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_SECRETBAG_OPENBOX", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_SECRETBAG_OPENBAG", function(target, redata)
		if redata.itemList then
			self.nodeExplosion:setVisible(true)
			SoraDResetEffectNode(self.nodeExplosion)
			self = nil
			;(nil).delay = 0.3
			;(nil).onComplete = function()
				SoraDOpenGiftView(redata.itemList)
				self:initData()
			end
			transition.execute(self, nil, nil)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeEventClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_SECRETBAG_ERRBACK", function(...)
		SoraDCloseLoading(self)
	end)
end
function secretBagMainView:initData(...)
	SoraDCloseLoading(self)
	local secretBagData = secretBagCtrl:getsecretBagData()
	self.taskList = secretBagData.taskData
	self.curRewardLv = secretBagData.curRewardLv
	self.boxData = secretBagData.boxData
	table.sort(self.boxData, function(l, r)
		return l.taskNum < r.taskNum
	end)
	self:initView()
end
function secretBagMainView:initView(...)
	self:initSecretBag()
	self:initTaskTabPoint()
	self:initProgressBar()
	self:initScroll()
	self:initTimer()
end
function secretBagMainView:initTimer(...)
	self.txtTime:setTimeLast(function(str)
		_ENV = nil
		;(nil).time = str
		return i18n("common_text_766", nil) .. i18n("common_text_3779")
	end)
	self.txtTime:beginTime(serviceFunctions.getTodayRemainTime())
end
function secretBagMainView:initSecretBag(...)
	self.bagCount = backpackCtrl:getItemCount(secretBagCtrl.localClass.bagItemID)
	self.txtBgCount:setString(string.formatnumberthousands(self.bagCount))
	self.btnBag:setBright(self.bagCount > 0)
	self.btns:setRedPointState(1, self.bagCount > 0)
end
function secretBagMainView:initTaskTabPoint(...)
	self.btns:setRedPointState(2, secretBagCtrl:getIsAnyTaskCanReceive() or secretBagCtrl:getsecretBagBoxCount() > 0)
end
function secretBagMainView:initProgressBar(...)
	local cur = secretBagCtrl:getsecretBagTaskCount()
	local maxCount = self.boxData[#self.boxData].taskNum
	if cur >= maxCount then
		secretBagCtrl = nil
		secretBagCtrl = nil
		;(nil).color = "#00FF00"
		;(nil).num = SoraDWrapHtmlTagByStyle(cur, nil)
		;(nil).total = maxCount
		self.txtCompleteNum:setString(i18n("kits_text_03", nil))
	else
		secretBagCtrl = i18n("kits_text_03", nil)
		secretBagCtrl = i18n("kits_text_03", nil)
		i18n("kits_text_03", nil).color = "#fbbe02"
		i18n("kits_text_03", nil).num = SoraDWrapHtmlTagByStyle(cur, i18n("kits_text_03", nil))
		i18n("kits_text_03", nil).total = maxCount
		self.txtCompleteNum:setString(i18n("kits_text_03", i18n("kits_text_03", nil)))
	end
	local belongNum = 0
	for i, v in ipairs(self.boxData) do
		if cur >= v.taskNum then
			belongNum = i
		end
	end
	if 1 <= belongNum then
		local perDis = math.ceil(100 / (#self.boxData - 1))
		local baseDis = (belongNum - 1) * perDis
		local preTaskNum = self.boxData[belongNum] and self.boxData[belongNum].taskNum or 0
		local afterTaskNum = self.boxData[belongNum + 1] and self.boxData[belongNum + 1].taskNum or self.boxData[#self.boxData].taskNum + 1
		local curDis = (cur - preTaskNum) / (afterTaskNum - preTaskNum) * perDis
		local totalDis = baseDis + curDis
		self.loadBar:setPercent(totalDis)
	else
		self.loadBar:setPercent(0)
	end
	local caculatePosX = function(num)
		local totalWidth = self.loadBar:getContentSize().width
		local perDis = totalWidth / (#self.boxData - 1)
		if SoraDFIsRA() then
			return totalWidth / 2 - (num - 1) * perDis
		else
			return (num - 1) * perDis - totalWidth / 2
		end
	end
	if not self.ocxBoxs then
		self.ocxBoxs, secretBagCtrl = self.ocxBoxs, self.ocxBoxs
		for i, v in ipairs(self.boxData) do
			local single = self.btnBox:clone()
			single:getChildByName("Sprite_box"):setSpriteFrame(self.boxImgs[i] or self.boxImgs[1])
			single:setTag(i)
			single:setPosition(caculatePosX(i), -60)
			single:addTouchEventListener(handler(self, self.boxClick))
			single:addTo(self.nodeProgress)
			table.insert(self.ocxBoxs, single)
		end
	end
	for i, v in ipairs(self.boxData) do
		secretBagCtrl = handler(self, self.boxClick)
		handler(self, self.boxClick).num = v.taskNum
		self.ocxBoxs[i]:getChildByName("Text_price"):setString(i18n("kits_text_02", handler(self, self.boxClick)))
		self:stateFun(cur, v, function(...)
			self:showRoundEffect(self.ocxBoxs[i], 1)
		end, function(...)
			self:showRoundEffect(self.ocxBoxs[i], 3)
		end, function(...)
			self:showRoundEffect(self.ocxBoxs[i], 2)
		end)
	end
end
function secretBagMainView:stateFun(num, info, fun1, fun2, fun3)
	if num >= info.taskNum and info.receive == false then
		fun1()
	elseif num >= info.taskNum and info.receive == true then
		fun2()
	else
		fun3()
	end
end
function secretBagMainView:boxClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local index = button:getTag()
		local panel = SoraDCreatePanel("secretBagReward")
		panel:initData(self.boxData[index])
		panel:show()
	end
end
function secretBagMainView:showRoundEffect(pNode, state)
	if state == 1 then
		if not pNode:getChildByName("effect_node") then
			local _ENV, _ENV, _ENV, param = "effect_node", pNode, pNode:getChildByName("effect_node"), pNode:getChildByName("effect_node")
			;("effect_node").png = "dh_xsyd_01.png"
			;("effect_node").scale = 2.75
			;("effect_node").opacity = 178.5
			_UPVALUE1_ = nil
			;(nil)[1] = cca.fadeTo(0.55, 0.2)
			;(nil)[2] = cca.fadeTo(0.5333333333333333, 0.7)
			;(nil)[3] = cca.fadeTo(0.5333333333333333, 0.7)
			;(nil)[4] = cca.fadeTo(0.5333333333333333, 0.7)
			;(nil)[5] = cca.fadeTo(0.5333333333333333, 0.7)
			;(nil)[6] = cca.fadeTo(0.5333333333333333, 0.7)
			;(nil)[7] = cca.fadeTo(0.5333333333333333, 0.7)
			;(nil)[8] = cca.fadeTo(0.5333333333333333, 0.7)
			;(nil)[9] = cca.fadeTo(0.5333333333333333, 0.7)
			;(nil)[10] = cca.fadeTo(0.5333333333333333, 0.7)
			_ENV, pNode[1], ("effect_node").seq = "effect_node", "effect_node", cca.seq(nil)
			;("effect_node").png = "dh_xsyd_07.png"
			_ENV, pNode[2], ("effect_node").scale = "effect_node", "effect_node", 2
			;("effect_node").png = "dh_xsyd_02.png"
			;("effect_node").scale = 2.4
			_ENV = nil
			;(nil)[1] = cca.rotateBy(1.0833333333333333, 540)
			;(nil)[2] = cca.rotateBy(1.0833333333333333, 540)
			;(nil)[3] = cca.rotateBy(1.0833333333333333, 540)
			;(nil)[4] = cca.rotateBy(1.0833333333333333, 540)
			;(nil)[5] = cca.rotateBy(1.0833333333333333, 540)
			;(nil)[6] = cca.rotateBy(1.0833333333333333, 540)
			;(nil)[7] = cca.rotateBy(1.0833333333333333, 540)
			;(nil)[8] = cca.rotateBy(1.0833333333333333, 540)
			;(nil)[9] = cca.rotateBy(1.0833333333333333, 540)
			;(nil)[10] = cca.rotateBy(1.0833333333333333, 540)
			pNode[3], ("effect_node").seq = "effect_node", cca.seq(nil)
			local actionConfig = pNode
			local roundNode = display.newNode()
			roundNode:setName("effect_node")
			local nSize = pNode:getContentSize()
			roundNode:setPosition(nSize.width / 2, nSize.height / 2)
			roundNode:addTo(pNode, 1)
			for k, v in ipairs(actionConfig) do
				if v.png then
					local sprite = display.newSprite("#" .. v.png)
					if v.scale then
						sprite:setScale(v.scale)
					end
					if v.opacity then
						sprite:setOpacity(v.opacity)
					end
					if v.rotation then
						sprite:setRotation(v.rotation)
					end
					if v.seq then
						sprite:runAction(cc.RepeatForever:create(v.seq))
					end
					sprite:addTo(roundNode, k)
				end
			end
			roundNode:setScale(0.35)
		else
			pNode:getChildByName("effect_node"):setVisible(true)
		end
		pNode:getChildByName("Sprite_box"):setColor(cc.c3b(255, 255, 255))
	elseif state == 2 then
		if pNode:getChildByName("effect_node") then
			pNode:getChildByName("effect_node"):setVisible(false)
		end
		pNode:getChildByName("Sprite_box"):setColor(cc.c3b(255, 255, 255))
	elseif state == 3 then
		if pNode:getChildByName("effect_node") then
			pNode:getChildByName("effect_node"):setVisible(false)
		end
		pNode:getChildByName("Sprite_box"):setColor(cc.c3b(125, 125, 125))
	end
end
function secretBagMainView:initScroll(...)
	dump(self.taskList, "self.taskList")
	local group = activityShowCtrl:getParamByID(gActivityTimeActivityID.KITS_ACTIVITY).classtype or 1
	table.sort(self.taskList, function(l, r)
		local lr = l.receive and 1 or 0
		local rr = r.receive and 1 or 0
		local lf = l.finishCount >= secretBagCtrl.localClass.getTaskData(tostring(l.taskId), group).amount and 1 or 0
		local rf = r.finishCount >= secretBagCtrl.localClass.getTaskData(tostring(r.taskId), group).amount and 1 or 0
		if l.receive or r.receive then
			return lr < rr
		elseif lf == rf then
			return l.taskId < r.taskId
		else
			return lf > rf
		end
	end)
	dump(self.taskList, "self.taskList")
	if not self.firstInitScroll then
		self.scroll:init(self.taskList, handler(self, self.doSingle), self.panelSingle:getContentSize())
		self.firstInitScroll = true
	else
		self.scroll:setList(self.taskList)
	end
end
function secretBagMainView:doSingle(idx, info, ocx)
	if not ocx then
		ocx = include("secretBagTaskSingle").new(self.panelSingle:clone())
		ocx:setScroll(self.scroll)
		ocx:setFather(self)
	end
	ocx:initData(info)
	return ocx
end
function secretBagMainView:btnBagClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.bagCount > 1 then
			_ENV, _ENV = nil, nil
			;(nil).id = secretBagCtrl.localClass.bagItemID
			;(nil).itemData, (nil).count = nil, self.bagCount
			;(nil).handle = function(target, tbl)
				SoraDShowLoading(self)
				secretBagCtrl:openBag(tbl.num)
			end
			uiManager:show("newItemSingleUse", nil)
		elseif self.bagCount == 1 then
			SoraDShowLoading(self)
			secretBagCtrl:openBag(1)
		else
			SoraDShowMsgTip(i18n("common_text_2512"))
		end
	end
end
function secretBagMainView:btnBagPriceClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("secretBagPriceReview")
		panel:initData()
		panel:show()
	end
end
function secretBagMainView:btnHelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("kits_text_08"))
	end
end
function secretBagMainView:btnClickCallBack(tag, name)
	if 1 == tag then
		self.nodeBag:setVisible(true)
		self.nodeTask:setVisible(false)
		self.scroll:setVisible(false)
		self.imgBag:setVisible(true)
		self.btnBagPrice:setVisible(true)
		self.panelTip:setVisible(false)
		self.nodeGold:setVisible(true)
	elseif 2 == tag then
		self.nodeBag:setVisible(false)
		self.nodeTask:setVisible(true)
		self.scroll:setVisible(true)
		self.imgBag:setVisible(false)
		self.btnBagPrice:setVisible(false)
		self.panelTip:setVisible(true)
		self.nodeGold:setVisible(false)
	end
end
function secretBagMainView:judgeEventClose(target, redata)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.KITS_ACTIVITY)
	if gActivityState.CLOSE == state then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return secretBagMainView

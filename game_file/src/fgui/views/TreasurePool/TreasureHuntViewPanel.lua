local gametop = gModuleMgr.getObject("gametop")
local treviFountainCtrl = gametop.playertop_:getModule("treviFountainCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local resDesRead = include("resDesRead")
local dailyRemindManager = include("dailyRemindManager")
local endlessTreasureCtrl = SoraDGetCtrl("endlessTreasureCtrl")
local funUnlockRead = include("funUnlockRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local TreasureHuntViewPanel = class("TreasureHuntViewPanel", baseFguiPanel)
function TreasureHuntViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("TreasureHuntViewPanel:ctor", self.viewName)
end
function TreasureHuntViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function TreasureHuntViewPanel:onInit()
	print("=======TreasureHuntViewPanel:onInit")
	if not SoraDFIsRA() then
		self.fields.Image_poolFrameBottom:fixChildrenPos()
	end
	self.resImgArray, _ENV = self.fields.Image_poolFrameBottom.fixChildrenPos, self.fields.Image_poolFrameBottom.fixChildrenPos
	self.bnfontLab1 = nil
	self.bnfontLab2List, _ENV, self.bnfontLab1List, _ENV, self.bnfontLab2 = self.fields.Image_poolFrameBottom.fixChildrenPos, self.fields.Image_poolFrameBottom.fixChildrenPos, self.fields.Image_poolFrameBottom.fixChildrenPos, self.fields.Image_poolFrameBottom.fixChildrenPos, nil
	self.isTenClick = false
	self.tableResSingle, _ENV, self.tableResData, _ENV, self.clickResData, _ENV, self.isFromEquip = self.fields.Image_poolFrameBottom.fixChildrenPos, self.fields.Image_poolFrameBottom.fixChildrenPos, self.fields.Image_poolFrameBottom.fixChildrenPos, self.fields.Image_poolFrameBottom.fixChildrenPos, self.fields.Image_poolFrameBottom.fixChildrenPos, self.fields.Image_poolFrameBottom.fixChildrenPos, false
	self.showArea = cc.size(display.width, display.height - 460)
	self.huntCount = 0
	self.itemFields = fguiHelper.get_fields(self.fields.Image_poolFrameBottom)
	self.topFields = fguiHelper.get_fields(self.fields.Com_TP_frameTop)
	self.nodeTop = display.newNode()
	self.fields.nodeTop:setContent(self.nodeTop)
	self.nodeCenter = display.newNode()
	self.fields.nodeCenter:setContent(self.nodeCenter)
	self.btn_useTool = self.itemFields.btn_add
	self.txtChances = self.itemFields.title
	self.txtChanceNum = self.itemFields.num
	self.btnHelp = self.topFields.btn_help
	self.resBanner = self.topFields.resBanner
	self.resBanner:updateResource()
	self.btn_useTool:setVisible(false)
	self.fields.btn_tenClick:setTitle(i18n("privilege_text_110"))
	self.fields.btn_tenClick:setVisible(false)
	if SoraDGetCtrl("exaltedPrivilegeCtrl"):checkPrivilege(gExaltedPrivilegeType.WISH_RESOURCE) then
		self.fields.btn_tenClick:setVisible(true)
	end
	self.topFields.Button_close:addClickListener(handler(self, self.onClickClose))
	self.btnHelp:addClickEventListener(handler(self, self.btnHelpClick))
	self.btn_useTool:addClickEventListener(handler(self, self.btnUseToolClick))
	self.fields.btn_tenClick:addClickEventListener(handler(self, self.btnChooseTenClick))
	self.fields.Button_touch:addEventListener(fgui.UIEventType.Click, handler(self, self.btnTreasureClick))
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.ENDLESS_TREASURE)
	self.isEndlessVisible = unlockLv <= SoraDGetCastleLv()
	self.fields.Button_touch:setVisible(self.isEndlessVisible)
	self:addHarvestSeasonButton()
	self.updateTimer = SoradCreateTimer(self, function(dt)
		self:niuqu3Update(dt)
	end, true)
	self:update(true)
	self:updateTreasureNum()
	self:addPoolEffect()
	self:addWaterShader()
	self:addStarShader()
end
function TreasureHuntViewPanel:updateLuckyBless()
	local luckyBlessCtrl = SoraDGetCtrl("luckyBlessCtrl")
	local luckyData = luckyBlessCtrl:getLuckyData()
	if luckyData.curEffectType == gLuckyBlessActivityEffectType.MAKE_A_WISH then
		local leftTime = luckyBlessCtrl:getRealTime()
		self.fields.Com_lucky:setVisible(true)
		self.fields.Com_lucky:setTime(leftTime, luckyData.discount / 10)
	else
		self.fields.Com_lucky:setVisible(false)
	end
end
function TreasureHuntViewPanel:addPoolEffect()
end
function TreasureHuntViewPanel:addStarShader(...)
end
function TreasureHuntViewPanel:niuqu3Update(dt)
end
function TreasureHuntViewPanel:addWaterShader()
end
function TreasureHuntViewPanel:updateHarvestSeasonRedPoint(target, data)
	if self.fields.btnHarvestSeason then
		self.fields.btnHarvestSeason:setReddot(false)
	end
end
function TreasureHuntViewPanel:getData(data)
	local treviFountainCtrl, treviFountainCtrl, huntData = nil, treviFountainCtrl, data or treviFountainCtrl:getTreviFountainData()
	;(nil).resid = gIDDef.WOOD
	;(nil).needGold = TREASUREHUNT_MIN_GOLD_COST
	;(nil).resper = 0
	treviFountainCtrl, treviFountainCtrl[1], (nil).isLocked = nil, nil, true
	;(nil).resid = gIDDef.FOOD
	;(nil).needGold = TREASUREHUNT_MIN_GOLD_COST
	;(nil).resper = 0
	treviFountainCtrl, treviFountainCtrl[2], (nil).isLocked = nil, nil, true
	;(nil).resid = gIDDef.STEEL
	;(nil).needGold = TREASUREHUNT_MIN_GOLD_COST
	;(nil).resper = 0
	treviFountainCtrl, treviFountainCtrl[3], (nil).isLocked = nil, nil, true
	;(nil).resid = gIDDef.MITHRIL
	;(nil).needGold = TREASUREHUNT_MIN_GOLD_COST
	;(nil).resper = 0
	treviFountainCtrl, treviFountainCtrl[4], (nil).isLocked = nil, nil, true
	;(nil).resid = gIDDef.CRYSTAL
	;(nil).needGold = TREASUREHUNT_MIN_GOLD_COST
	;(nil).resper = 0
	treviFountainCtrl, treviFountainCtrl[5], (nil).isLocked = nil, nil, true
	;(nil).resid = gIDDef.IRON
	;(nil).needGold = TREASUREHUNT_MIN_GOLD_COST
	;(nil).resper = 0
	treviFountainCtrl[6], (nil).isLocked = nil, true
	local initResData = treviFountainCtrl
	if not SoraDFIsRA() then
		treviFountainCtrl, treviFountainCtrl = TREASUREHUNT_MIN_GOLD_COST, SoraDFIsRA()
		TREASUREHUNT_MIN_GOLD_COST.resid = gIDDef.WOOD
		TREASUREHUNT_MIN_GOLD_COST.needGold = TREASUREHUNT_MIN_GOLD_COST
		TREASUREHUNT_MIN_GOLD_COST.resper = 0
		treviFountainCtrl, SoraDFIsRA()[1], TREASUREHUNT_MIN_GOLD_COST.isLocked = TREASUREHUNT_MIN_GOLD_COST, TREASUREHUNT_MIN_GOLD_COST, true
		TREASUREHUNT_MIN_GOLD_COST.resid = gIDDef.IRON
		TREASUREHUNT_MIN_GOLD_COST.needGold = TREASUREHUNT_MIN_GOLD_COST
		TREASUREHUNT_MIN_GOLD_COST.resper = 0
		treviFountainCtrl, SoraDFIsRA()[2], TREASUREHUNT_MIN_GOLD_COST.isLocked = TREASUREHUNT_MIN_GOLD_COST, TREASUREHUNT_MIN_GOLD_COST, true
		TREASUREHUNT_MIN_GOLD_COST.resid = gIDDef.CRYSTAL
		TREASUREHUNT_MIN_GOLD_COST.needGold = TREASUREHUNT_MIN_GOLD_COST
		TREASUREHUNT_MIN_GOLD_COST.resper = 0
		treviFountainCtrl, SoraDFIsRA()[3], TREASUREHUNT_MIN_GOLD_COST.isLocked = TREASUREHUNT_MIN_GOLD_COST, TREASUREHUNT_MIN_GOLD_COST, true
		TREASUREHUNT_MIN_GOLD_COST.resid = gIDDef.MITHRIL
		TREASUREHUNT_MIN_GOLD_COST.needGold = TREASUREHUNT_MIN_GOLD_COST
		TREASUREHUNT_MIN_GOLD_COST.resper = 0
		treviFountainCtrl, SoraDFIsRA()[4], TREASUREHUNT_MIN_GOLD_COST.isLocked = TREASUREHUNT_MIN_GOLD_COST, TREASUREHUNT_MIN_GOLD_COST, true
		TREASUREHUNT_MIN_GOLD_COST.resid = gIDDef.STEEL
		TREASUREHUNT_MIN_GOLD_COST.needGold = TREASUREHUNT_MIN_GOLD_COST
		TREASUREHUNT_MIN_GOLD_COST.resper = 0
		treviFountainCtrl, SoraDFIsRA()[5], TREASUREHUNT_MIN_GOLD_COST.isLocked = TREASUREHUNT_MIN_GOLD_COST, TREASUREHUNT_MIN_GOLD_COST, true
		TREASUREHUNT_MIN_GOLD_COST.resid = gIDDef.FOOD
		TREASUREHUNT_MIN_GOLD_COST.needGold = TREASUREHUNT_MIN_GOLD_COST
		TREASUREHUNT_MIN_GOLD_COST.resper = 0
		initResData, SoraDFIsRA()[6], TREASUREHUNT_MIN_GOLD_COST.isLocked = SoraDFIsRA(), TREASUREHUNT_MIN_GOLD_COST, true
	end
	local treviFountainCtrl, unLockTable = SoraDFIsRA(), SoraDFIsRA()
	for k, v in pairs(huntData.multipleResource) do
		for index, value in ipairs(initResData) do
			if k == tostring(value.resid) then
				value.isLocked = not SoraDResIsLock(value.resid)
				value.resper = v
				if v.gold then
					value.needGold = v.gold
				end
				if v.goldTen then
					value.needGoldTen = v.goldTen
				end
			end
		end
	end
	self.huntCount = huntData.multipleTimes
	self.tableResData = initResData
end
function TreasureHuntViewPanel:updateTreasureNum()
	local setNum = endlessTreasureCtrl:getTreasureSetNum()
	endlessTreasureCtrl = nil
	;(nil).num = setNum
	self.fields.Button_touch:setTitle(i18n("endless_treasures_text_48", nil))
	self.fields.Button_touch:setTitleColor(4 <= setNum and cc.c3b(190, 40, 40) or cc.c3b(240, 230, 210))
end
function TreasureHuntViewPanel:refreshChance(target, data)
	self:refreshChance_imp()
	if data and data.msg == "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK" then
		self:refreshSingles()
	end
end
function TreasureHuntViewPanel:refreshChance_imp(data)
	self:getData(data)
	_ENV = nil
	;(nil).count = ""
	self.txtChances:setString(i18n("common_text_433", nil))
	self.txtChanceNum:setString(self.huntCount)
	if self.huntCount > 0 then
		self.btn_useTool:setVisible(false)
	else
		local itemId = 500301
		local itemCount = backpackCtrl:getItemCount(itemId)
		if 0 < itemCount then
			self.btn_useTool:setVisible(true)
		else
			self.btn_useTool:setVisible(false)
		end
	end
end
function TreasureHuntViewPanel:refreshSingles()
	for i = 1, 6 do
		if self.tableResData[i] and self.fields["Com_TP_itemSingle" .. i] then
			self.fields["Com_TP_itemSingle" .. i]:setIsTenClick(self.isTenClick)
			self.fields["Com_TP_itemSingle" .. i]:setIsJumpFromEquip(self.isFromEquip)
			self.fields["Com_TP_itemSingle" .. i]:initData(self.tableResData[i], self.huntCount > 0)
		end
	end
end
function TreasureHuntViewPanel:setIsJumpFromEquip(isFromEquip)
	self.isFromEquip = isFromEquip
	self:refreshSingles()
end
function TreasureHuntViewPanel:update(isFrist, data)
	self:refreshChance_imp(data)
	if isFrist then
		math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
		for i, v in ipairs(self.tableResData) do
			local single = self.fields["Com_TP_itemSingle" .. i]
			single:setVisible(true)
			single:setIsTenClick(self.isTenClick)
			single:setIsJumpFromEquip(self.isFromEquip)
			single:initData(v, self.huntCount > 0)
			single:setHuntHandl(handler(self, self.huntCallBack))
			table.insert(self.tableResSingle, single)
		end
	else
		self:refreshSingles()
	end
	self:harvestTime()
end
function TreasureHuntViewPanel:harvestTime(target, data)
	local addEffect = function(bool)
		for i = 1, 6 do
			if self.fields["Com_TP_itemSingle" .. i]:isVisible() and not self.fields["Com_TP_itemSingle" .. i].tableMeData.isLocked then
				self.fields["Com_TP_itemSingle" .. i]:harvestEffect(bool)
			end
		end
	end
	local activityShowCtrl = gModuleMgr.getObject("gametop").playertop_:getModule("activityShowCtrl")
	local isInFestival = activityShowCtrl:isActivityOpen(gActivityTimeActivityID.BUMPER_TREVIFOUNTAIN)
	if isInFestival then
		addEffect(true)
	else
		addEffect(false)
	end
end
function TreasureHuntViewPanel:huntCallBack(resid, resCount, needGold, isTen)
	print(resid .. "被许愿")
	self.clickResData[1] = resid
	self.clickResData[2] = resCount
	self.clickResData[3] = needGold
	self.clickResData[4] = isTen
	if isTen then
		self:privilegeMultipleCallBack()
		return
	end
	if self.huntCount <= 0 then
		local ctype = dailyRemindManager.REMIND_TYPE.treasureHuntView_gold
		if dailyRemindManager.checkNeedRemind(ctype) then
			_ENV = nil
			;(nil).gold = needGold
			SoraDShowBuyBox(i18n("common_text_432", nil), needGold, i18n("common_text_282"), handler(self, self.goldForContinue), true)
		else
			SoraDShowLoading(nil, nil, nil, true)
			self:goldForContinue(MSGBOX_CALLBACK_YES)
			return
		end
	else
		SoraDShowLoading(nil, nil, nil, true)
		_ENV = nil
		;(nil).eventargs = resid
		userSDKManager.logEvent(gSDKDef.TDonEvent.treasurehunt_click, nil)
		treviFountainCtrl:multiple(resid)
	end
end
function TreasureHuntViewPanel:privilegeMultipleCallBack(...)
	local doPrivilegeMultiple = function()
		local ctype = dailyRemindManager.REMIND_TYPE.treasureHuntView_ten
		if dailyRemindManager.checkNeedRemind(ctype) then
			SoraDShowMsgBox(i18n("privilege_text_112"), i18n("common_text_204"), nil, function(eventType)
				if eventType == MSGBOX_CALLBACK_YES then
					if tolua.isnull(self) then
						return
					end
					dailyRemindManager.addRemindToManager(ctype)
					_ENV = nil
					;(nil).eventargs = self.clickResData[1]
					userSDKManager.logEvent(gSDKDef.TDonEvent.treasurehunt_click, nil)
					self:goldForContinue(MSGBOX_CALLBACK_YES)
				end
			end)
		else
			self:goldForContinue(MSGBOX_CALLBACK_YES)
		end
	end
	if self.huntCount < 10 then
		local ctype = dailyRemindManager.REMIND_TYPE.treasureHuntView_tenGold
		if dailyRemindManager.checkNeedRemind(ctype) then
			SoraDShowBuyBox(i18n("privilege_text_113"), self.clickResData[3], i18n("common_text_282"), function(eventType)
				if eventType == MSGBOX_CALLBACK_YES then
					dailyRemindManager.addRemindToManager(ctype)
					doPrivilegeMultiple()
				end
			end)
		else
			doPrivilegeMultiple()
		end
	else
		doPrivilegeMultiple()
	end
end
function TreasureHuntViewPanel:goldForContinue(exitType)
	if exitType == MSGBOX_CALLBACK_YES then
		SoraDPlaySound()
		if SoraDEnoughGold(self.clickResData[3]) then
			SoraDShowLoading(nil, nil, nil, true)
			_ENV = nil
			;(nil).eventargs = self.clickResData[1]
			userSDKManager.logEvent(gSDKDef.TDonEvent.treasurehunt_click, nil)
			if self.clickResData[4] then
				treviFountainCtrl:privilegeMultiple(self.clickResData[1])
			else
				treviFountainCtrl:multiple(self.clickResData[1])
				if self.huntCount <= 0 then
					local ctype = dailyRemindManager.REMIND_TYPE.treasureHuntView_gold
					dailyRemindManager.addRemindToManager(ctype)
				end
			end
		else
			SoraDShowMsgBox(i18n("common_text_430"), i18n("common_text_054"), nil, handler(self, self.gotoStore))
			SoraDCloseLoading()
		end
	end
end
function TreasureHuntViewPanel:gotoStore(type)
	if type == MSGBOX_CALLBACK_YES then
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:show()
		end
	end
end
function TreasureHuntViewPanel:receiveData(target, redata)
	SoraDCloseLoading()
	if redata and redata.data then
		local critical = redata.data.must
		if redata.respone.resData then
			critical = TREASUREHUNT_CRITICAL_MAX
		end
		if critical == TREASUREHUNT_CRITICAL_MAX then
			print("暴击===")
			self:addWishSuccessCriticalEffect()
		else
			self:addWishSuccessEffect()
		end
		self:huntAction(critical, self.clickResData[1], self.clickResData[2], redata.respone.resData)
		if redata.respone.resData then
			local _ENV, dropList = redata.respone.resData, redata.respone.resData
			for k, v in ipairs(redata.respone.resData) do
				if v.drop then
					for ki, vi in ipairs(v.drop) do
						table.insert(dropList, vi)
					end
				end
			end
			self:harvestItems(dropList)
		else
			self:harvestItems(redata.data.drop)
		end
		self:soundAction(self.clickResData[1])
		self:update(false, redata.data)
	elseif redata and redata.err and redata.err == gErrDef.Err_TREVIFOUNTAIN_CAST_GOLD_TIMES_LIMIT then
		local resourceType = redata.resourceType
		if gIDDef.STEEL == resourceType then
			SoraDShowMsgTip(i18n("common_text_3159"))
		elseif gIDDef.CRYSTAL == resourceType then
			SoraDShowMsgTip(i18n("common_text_4096"))
		else
			SoraDShowMsgTip(i18n("common_text_3160"))
		end
	end
end
function TreasureHuntViewPanel:addWishSuccessEffect(...)
	self.fields.Node_wishSuccess1:setVisible(true)
	SoraDResetEffectNode(self.fields.Node_wishSuccess1)
	self.fields.Node_wishSuccess2:setVisible(true)
	SoraDResetEffectNode(self.fields.Node_wishSuccess2)
	self.fields.Node_wishSuccess3:setVisible(true)
	SoraDResetEffectNode(self.fields.Node_wishSuccess3)
end
function TreasureHuntViewPanel:addWishSuccessCriticalEffect(...)
	self.fields.Node_wishSuccess1:setVisible(true)
	SoraDResetEffectNode(self.fields.Node_wishSuccess1)
	self.fields.Node_wishSuccess2:setVisible(true)
	SoraDResetEffectNode(self.fields.Node_wishSuccess2)
	self.fields.Node_wishSuccess3:setVisible(true)
	SoraDResetEffectNode(self.fields.Node_wishSuccess3)
	self.fields.Node_wishCrit:setVisible(true)
	SoraDResetEffectNode(self.fields.Node_wishCrit)
end
function TreasureHuntViewPanel:soundAction(rid)
	_ENV = nil
	;(nil)[gIDDef.FOOD] = 24
	;(nil)[gIDDef.WOOD] = 28
	;(nil)[gIDDef.IRON] = 26
	;(nil)[gIDDef.MITHRIL] = 27
	;(nil)[gIDDef.STEEL] = 26
	local (nil)[gIDDef.CRYSTAL], soundTbl = 23, nil
	local f1 = ffa.callFunc(function()
		SoraDPlaySound("uicontrol", soundTbl[rid])
	end)
	local d1 = ffa.delay(0.2)
	_UPVALUE3_ = nil
	;(nil)[1] = f1
	;(nil)[2] = d1
	;(nil)[3] = f1
	self:runAction(ffa.seq(nil))
end
function TreasureHuntViewPanel:getBlessBuffAdd(resCount)
	local blessBuff = 0
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.LUCKY_BLESSING_ACTIVITY) then
		local luckyBlessCtrl = SoraDGetCtrl("luckyBlessCtrl")
		local status = luckyBlessCtrl:getLuckyBlessStatus()
		local luckyData = luckyBlessCtrl:getLuckyData()
		local preData = luckyBlessCtrl:getCurBless()
		local effectType = preData and preData.type or luckyData.curEffectType
		if status == 2 and effectType == gLuckyBlessActivityEffectType.MAKE_A_WISH then
			blessBuff = luckyData.discount / 1000
		end
	end
	return math.floor(resCount * blessBuff)
end
function TreasureHuntViewPanel:huntAction(Critical, resId, resCount, resData)
	local multiple = math.floor(Critical * 3)
	local frmx, frmy = display.cx, -300
	local tablePosX = SoraDGetRandNum(multiple, 100, 550)
	local tablePosY = SoraDGetRandNum(multiple, frmy + 100, frmy + 180)
	self:clearAnimationCache(multiple)
	for i = 1, multiple do
		self.resImgArray[i] = nil
		self.resImgArray[i] = cc.Sprite:createWithSpriteFrameName(resDesRead.getIcon(resId))
		self.resImgArray[i]:setPosition(cc.p(frmx, frmy + 50))
		self.resImgArray[i]:addTo(self.nodeTop)
		local callFunc = cca.callFunc(function()
			self.resImgArray[i]:removeFromParent()
			self.resImgArray[i] = nil
		end)
		local actionTo0 = cca.jumpTo(0.5, tablePosX[i], tablePosY[i], 50, 2)
		local actionTo1 = cca.delay(0.5)
		local failAction
		if resId ~= gIDDef.STEEL then
			failAction = cca.moveTo(0.5, self.nodeTop:convertToNodeSpace(self.resBanner:getResWorldPos(resId)))
		else
			failAction = cca.fadeTo(1, 0.1)
		end
		local actionTo2 = cc.EaseExponentialOut:create(failAction)
		_UPVALUE4_ = self.nodeTop:convertToNodeSpace(self.resBanner:getResWorldPos(resId))
		self.nodeTop:convertToNodeSpace(self.resBanner:getResWorldPos(resId))[1] = actionTo0
		self.nodeTop:convertToNodeSpace(self.resBanner:getResWorldPos(resId))[2] = actionTo1
		self.nodeTop:convertToNodeSpace(self.resBanner:getResWorldPos(resId))[3] = actionTo2
		self.nodeTop:convertToNodeSpace(self.resBanner:getResWorldPos(resId))[4] = callFunc
		self.resImgArray[i]:runAction(cca.seq(self.nodeTop:convertToNodeSpace(self.resBanner:getResWorldPos(resId))))
		self.resImgArray[i]:setGlobalZOrder(1000)
	end
	self.bnfontLab1 = nil
	self.bnfontLab2List, _ENV, self.bnfontLab1List, _ENV, self.bnfontLab2 = 1, 1, 1, 1, nil
	if resData then
		self:doTenHuntAction(resData)
		return
	end
	_ENV = self
	self.text = string.formatnumberthousands(resCount + self:getBlessBuffAdd(resCount))
	self.font = "res/fonts/pve_fnt_title.fnt"
	self.align = cc.TEXT_ALIGNMENT_RIGHT
	self.x = 320
	self.y = -300
	self.bnfontLab1 = display.newBMFontLabel(self)
	self.bnfontLab1:addTo(self.nodeTop)
	self.bnfontLab1:sscale(0.2)
	_UPVALUE3_ = resCount + self:getBlessBuffAdd(resCount)
	;(resCount + self:getBlessBuffAdd(resCount))[1] = cca.scaleTo(0.2, 1.2)
	;(resCount + self:getBlessBuffAdd(resCount))[2] = cca.scaleTo(0.1, 1)
	;(resCount + self:getBlessBuffAdd(resCount))[3] = cca.delay(1)
	;(resCount + self:getBlessBuffAdd(resCount))[4] = cca.fadeOut(0.5)
	;(resCount + self:getBlessBuffAdd(resCount))[5] = cca.fadeOut(0.5)
	;(resCount + self:getBlessBuffAdd(resCount))[6] = cca.fadeOut(0.5)
	;(resCount + self:getBlessBuffAdd(resCount))[7] = cca.fadeOut(0.5)
	;(resCount + self:getBlessBuffAdd(resCount))[8] = cca.fadeOut(0.5)
	;(resCount + self:getBlessBuffAdd(resCount))[9] = cca.fadeOut(0.5)
	;(resCount + self:getBlessBuffAdd(resCount))[10] = cca.fadeOut(0.5)
	;(resCount + self:getBlessBuffAdd(resCount))[11] = cca.fadeOut(0.5)
	;(resCount + self:getBlessBuffAdd(resCount))[12] = cca.fadeOut(0.5)
	;(resCount + self:getBlessBuffAdd(resCount))[13] = cca.fadeOut(0.5)
	_ENV = resCount + self:getBlessBuffAdd(resCount)
	;(resCount + self:getBlessBuffAdd(resCount)).onComplete = function()
		self.bnfontLab1:removeFromParent()
		self.bnfontLab1 = nil
	end
	transition.execute(self.bnfontLab1, cca.seq(resCount + self:getBlessBuffAdd(resCount)), resCount + self:getBlessBuffAdd(resCount))
	if 1 < Critical then
		_ENV = self.bnfontLab1
		self.bnfontLab1.text = "x" .. Critical
		self.bnfontLab1.font = "res/fonts/pve_fnt_title.fnt"
		self.bnfontLab1.align = cc.TEXT_ALIGNMENT_RIGHT
		self.bnfontLab1.x = 500
		self.bnfontLab1.y = -250
		self.bnfontLab2 = display.newBMFontLabel(self.bnfontLab1)
		self.bnfontLab2:addTo(self.nodeTop)
		self.bnfontLab2:sscale(0.2)
		transition.stopTarget(self.bnfontLab2)
		_UPVALUE3_ = Critical
		Critical[1] = cca.scaleTo(0.2, 1.2)
		Critical[2] = cca.scaleTo(0.1, 1)
		Critical[3] = cca.delay(1)
		Critical[4] = cca.fadeOut(0.5)
		Critical[5] = cca.fadeOut(0.5)
		Critical[6] = cca.fadeOut(0.5)
		Critical[7] = cca.fadeOut(0.5)
		Critical[8] = cca.fadeOut(0.5)
		Critical[9] = cca.fadeOut(0.5)
		Critical[10] = cca.fadeOut(0.5)
		Critical[11] = cca.fadeOut(0.5)
		Critical[12] = cca.fadeOut(0.5)
		Critical[13] = cca.fadeOut(0.5)
		_ENV = Critical
		function Critical.onComplete()
			self.bnfontLab2:removeFromParent()
			self.bnfontLab2 = nil
		end
		transition.execute(self.bnfontLab2, cca.seq(Critical), Critical)
	end
	print("x" .. Critical .. "倍")
end
function TreasureHuntViewPanel:doTenHuntAction(resData)
	for i = 1, 10 do
		do
			local isCrite = 1 < resData[i].must
			local bScale = 1
			if isCrite then
				bScale = 1.5
			end
			_ENV = nil
			;(nil).text = string.formatnumberthousands(resData[i].addResource + self:getBlessBuffAdd(resData[i].addResource))
			;(nil).font = "res/fonts/pve_fnt_title.fnt"
			;(nil).align = cc.TEXT_ALIGNMENT_RIGHT
			;(nil).x = 320
			;(nil).y = -200
			local bnfontLab = display.newBMFontLabel(nil)
			bnfontLab:addTo(self.nodeTop)
			bnfontLab:sscale(0.2)
			bnfontLab:setGlobalZOrder(1001)
			self.bnfontLab1List[i] = bnfontLab
			_UPVALUE5_ = self:getBlessBuffAdd(resData[i].addResource)
			_UPVALUE1_ = 1 * bScale
			;(1 * bScale)[1] = cca.moveBy(0.5, 0, 50)
			;(1 * bScale)[2] = cca.fadeOut(0.5)
			;(1 * bScale)[3] = cca.fadeOut(0.5)
			;(1 * bScale)[4] = cca.fadeOut(0.5)
			;(1 * bScale)[5] = cca.fadeOut(0.5)
			self:getBlessBuffAdd(resData[i].addResource)[1] = cca.callFunc(function()
				bnfontLab:setVisible(false)
			end)
			self:getBlessBuffAdd(resData[i].addResource)[2] = cca.delay(i * 0.13)
			self:getBlessBuffAdd(resData[i].addResource)[3] = cca.callFunc(function()
				bnfontLab:setVisible(true)
			end)
			self:getBlessBuffAdd(resData[i].addResource)[4] = cca.scaleTo(0.2, 1.2 * bScale)
			self:getBlessBuffAdd(resData[i].addResource)[5] = cca.scaleTo(0.1, 1 * bScale)
			self:getBlessBuffAdd(resData[i].addResource)[6] = cca.spawn(1 * bScale)
			self:getBlessBuffAdd(resData[i].addResource)[7] = cca.spawn(1 * bScale)
			self:getBlessBuffAdd(resData[i].addResource)[8] = cca.spawn(1 * bScale)
			self:getBlessBuffAdd(resData[i].addResource)[9] = cca.spawn(1 * bScale)
			self:getBlessBuffAdd(resData[i].addResource)[10] = cca.spawn(1 * bScale)
			self:getBlessBuffAdd(resData[i].addResource)[11] = cca.spawn(1 * bScale)
			self:getBlessBuffAdd(resData[i].addResource)[12] = cca.spawn(1 * bScale)
			_ENV = self:getBlessBuffAdd(resData[i].addResource)
			self:getBlessBuffAdd(resData[i].addResource).onComplete = function()
				bnfontLab:removeFromParent()
				self.bnfontLab1List[i] = nil
			end
			transition.execute(bnfontLab, cca.seq((self:getBlessBuffAdd(resData[i].addResource))), (self:getBlessBuffAdd(resData[i].addResource)))
			if 1 < resData[i].must then
				_ENV = bnfontLab
				bnfontLab.text = "x" .. resData[i].must
				bnfontLab.font = "res/fonts/pve_fnt_title.fnt"
				bnfontLab.align = cc.TEXT_ALIGNMENT_RIGHT
				bnfontLab.x = 500
				bnfontLab.y = -150
				do
					local bnfontLab = display.newBMFontLabel(bnfontLab)
					bnfontLab:addTo(self.nodeTop)
					bnfontLab:sscale(0.2)
					self.bnfontLab2List[i] = bnfontLab
					function _UPVALUE5_()
						bnfontLab:removeFromParent()
						self.bnfontLab1List[i] = nil
					end
					_UPVALUE1_ = 1
					;(1)[1] = cca.moveBy(0.5, 0, 50)
					;(1)[2] = cca.fadeOut(0.5)
					;(1)[3] = cca.fadeOut(0.5)
					;(1)[4] = cca.fadeOut(0.5)
					;(function()
						bnfontLab:removeFromParent()
						self.bnfontLab1List[i] = nil
					end)[1] = cca.callFunc(function()
						self.bnfontLab2List[i]:setVisible(false)
					end)
					;(function()
						bnfontLab:removeFromParent()
						self.bnfontLab1List[i] = nil
					end)[2] = cca.delay(i * 0.13)
					;(function()
						bnfontLab:removeFromParent()
						self.bnfontLab1List[i] = nil
					end)[3] = cca.callFunc(function()
						self.bnfontLab2List[i]:setVisible(true)
					end)
					;(function()
						bnfontLab:removeFromParent()
						self.bnfontLab1List[i] = nil
					end)[4] = cca.scaleTo(0.2, 1.2)
					;(function()
						bnfontLab:removeFromParent()
						self.bnfontLab1List[i] = nil
					end)[5] = cca.scaleTo(0.1, 1)
					;(function()
						bnfontLab:removeFromParent()
						self.bnfontLab1List[i] = nil
					end)[6] = cca.spawn(1)
					;(function()
						bnfontLab:removeFromParent()
						self.bnfontLab1List[i] = nil
					end)[7] = cca.spawn(1)
					;(function()
						bnfontLab:removeFromParent()
						self.bnfontLab1List[i] = nil
					end)[8] = cca.spawn(1)
					;(function()
						bnfontLab:removeFromParent()
						self.bnfontLab1List[i] = nil
					end)[9] = cca.spawn(1)
					;(function()
						bnfontLab:removeFromParent()
						self.bnfontLab1List[i] = nil
					end)[10] = cca.spawn(1)
					;(function()
						bnfontLab:removeFromParent()
						self.bnfontLab1List[i] = nil
					end)[11] = cca.spawn(1)
					function _ENV()
						bnfontLab:removeFromParent()
						self.bnfontLab1List[i] = nil
					end
					;(function()
						bnfontLab:removeFromParent()
						self.bnfontLab1List[i] = nil
					end).onComplete = function()
						self.bnfontLab2List[i]:removeFromParent()
						self.bnfontLab2List[i] = nil
					end
					transition.execute(bnfontLab, cca.seq(function()
						bnfontLab:removeFromParent()
						self.bnfontLab1List[i] = nil
					end), function()
						bnfontLab:removeFromParent()
						self.bnfontLab1List[i] = nil
					end)
				end
			end
		end
	end
end
function TreasureHuntViewPanel:harvestItems(itemList)
	if not itemList or next(itemList) == nil then
		return
	end
	local popAction = function(_item, ticket, total)
		_ENV = nil
		;(nil).num = "+"
		;(nil).char = string.formatnumberthousands(_item.num)
		local itemDes = i18n("common_text_1470", nil)
		local labelDes = ccui.Text:create()
		labelDes:setFontSize(16)
		labelDes:setColor(cc.c3b(0, 255, 0))
		labelDes:setString(itemDes)
		labelDes:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		labelDes:setAnchorPoint(cc.p(0.5, 0))
		labelDes:setPosition(cc.p(53, -15))
		local parentSize = cc.size(0, 0)
		local aSpeed = 300
		local bSpeed = 650
		local aScale = 0.7
		local bScale = 1.0
		local cScale = 0.6
		local aPos = cc.p(parentSize.width / 2, parentSize.height / 2 - 30)
		local bPos = cc.p(parentSize.width / 2, parentSize.height / 2 + 30)
		local cPos = cc.p(parentSize.width / 2, parentSize.height / 2 - 260)
		local mailItemBox = include("mailItemBox")
		local boxNode = mailItemBox.new()
		_ENV = cc.p(53, -15)
		cc.p(53, -15).id = _item.id
		boxNode:initWithData(cc.p(53, -15))
		boxNode:setContentSize(cc.size(boxNode:getItemWidth(), boxNode:getItemHeight()))
		boxNode:setAnchorPoint(cc.p(0.5, 0.5))
		boxNode:setPosition(aPos)
		boxNode:setScale(aScale)
		boxNode:setLocalZOrder(total - ticket + 2)
		boxNode:addChild(labelDes)
		self.nodeCenter:addChild(boxNode)
		local aLen = cc.pGetDistance(bPos, aPos)
		local aDt = aLen / aSpeed
		local aMove = cca.moveTo(aDt, bPos)
		local aBackOut = cc.EaseBounceOut:create(aMove)
		local aScaleTo = cca.scaleTo(aDt, bScale)
		local aFadeIn = cca.fadeIn(aDt)
		local callFuncA = cca.callFunc(function()
			boxNode:setNodeOpacity(0)
			boxNode:runAnimFadeIn(aDt)
		end)
		_UPVALUE3_ = cc.p(0.5, 0.5)
		cc.p(0.5, 0.5)[1] = aMove
		cc.p(0.5, 0.5)[2] = aScaleTo
		cc.p(0.5, 0.5)[3] = callFuncA
		local aSpawn = cca.spawn(cc.p(0.5, 0.5))
		local sDelay = cca.delay(0.15 * (ticket - 1))
		local delay = cca.delay(0.15)
		local bLen = cc.pGetDistance(bPos, cPos)
		local bDt = bLen / bSpeed
		local bMove = cca.moveTo(bDt, cPos)
		local bEase = cc.EaseSineIn:create(bMove)
		local bScaleTo = cca.scaleTo(bDt, cScale)
		local callFuncB = cca.callFunc(function()
			boxNode:setLocalZOrder(total - ticket + 1)
			boxNode:runAnimFadeOut(bDt * 1.5)
		end)
		_UPVALUE3_ = cc.p(0.5, 0.5)
		cc.p(0.5, 0.5)[1] = callFuncB
		cc.p(0.5, 0.5)[2] = bEase
		cc.p(0.5, 0.5)[3] = bScaleTo
		local bSpawn = cca.spawn(cc.p(0.5, 0.5))
		local callFuncEnd = cca.callFunc(function()
			boxNode:removeFromParent()
		end)
		_UPVALUE5_ = bEase
		bEase[1] = sDelay
		bEase[2] = aSpawn
		bEase[3] = delay
		bEase[4] = bSpawn
		bEase[5] = callFuncEnd
		local seq = cca.seq(bEase)
		boxNode:runAction(seq)
	end
	for i, v in ipairs(itemList) do
		popAction(v, i, #itemList)
	end
end
function TreasureHuntViewPanel:clearAnimationCache(multiple)
	for i = 1, multiple do
		if self.resImgArray[i] then
			transition.stopTarget(self.resImgArray[i])
			self.nodeTop:removeChild(self.resImgArray[i], true)
		end
	end
	if self.bnfontLab1 then
		transition.stopTarget(self.bnfontLab1)
		self.nodeTop:removeChild(self.bnfontLab1, true)
	end
	if self.bnfontLab2 then
		transition.stopTarget(self.bnfontLab2)
		self.nodeTop:removeChild(self.bnfontLab2, true)
	end
	for k, v in pairs(self.bnfontLab1List) do
		transition.stopTarget(v)
		self.nodeTop:removeChild(v, true)
	end
	for k, v in pairs(self.bnfontLab2List) do
		transition.stopTarget(v)
		self.nodeTop:removeChild(v, true)
	end
end
function TreasureHuntViewPanel:btnTreasureClick()
	SoraDPlaySound()
	uiManager:show("EndlessTreasureView")
end
function TreasureHuntViewPanel:btnHelpClick(button, type)
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("common_text_431"))
end
function TreasureHuntViewPanel:btnChooseTenClick(button, type)
	SoraDPlaySound()
	self.isTenClick = not self.isTenClick
	self.fields.btn_tenClick:setSelected(self.isTenClick)
	self:refreshSingles()
end
function TreasureHuntViewPanel:btnUseToolClick(button, event)
	SoraDPlaySound()
	local itemId = 500301
	local itemCount = backpackCtrl:getItemCount(itemId)
	if 0 < itemCount then
		_ENV, _ENV = nil, nil
		;(nil).id = itemId
		;(nil).itemData, (nil).count = nil, itemCount
		uiManager:show("newItemSingleUse", nil)
	end
end
function TreasureHuntViewPanel:onShow()
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	guideCtrl:updateGuideModule(gGuideModule.WISH)
	self:updateLuckyBless()
end
function TreasureHuntViewPanel:onHide()
	display.removeAnimationCache("huntAnimation")
	if self.soundId then
		AudioEngine.stopEffect(self.soundId)
	end
end
function TreasureHuntViewPanel:addHarvestSeasonButton()
	if not IsArClient then
		return
	end
	local newFlag = false
	local _ENV, actIDList
	local config = require("app." .. LocalTblPath .. ".config_server.act_common_config")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local remainTime = 0
	for actID, v in pairs(config) do
		if clientEventMgr.judgeIsOpen(actID) then
			local newF = SoraDGetCtrl("activityCenterUICtrl", gametop):isHaveNewFlag(actID)
			if newF then
				newFlag = true
			end
			table.insert(actIDList, actID)
			local eventTime = activityShowCtrl:getTimeInfoByID(actID)
			if eventTime then
				local tmp = eventTime.timerNode.timer:getRemainTime()
				if remainTime < tmp then
					remainTime = tmp
				end
			end
		end
	end
	if remainTime and remainTime ~= 0 then
		if self.fields.btnHarvestSeason then
			self.fields.btnHarvestSeason:setVisible(true)
			if newFlag then
				self.fields.btnHarvestSeason:setReddot(true)
			end
			self.fields.btnHarvestSeason:getTextField():beginTime(remainTime)
			if not self.fields.btnHarvestSeason.isAddClick then
				self.fields.btnHarvestSeason.isAddClick = true
				self.fields.btnHarvestSeason:addClickEventListener(function(button, eventType)
					SoraDPlaySound()
					_UPVALUE5_ = SoraDPlaySound
					SoraDPlaySound[1] = 9001010
					SoraDPlaySound[2] = 9001011
					SoraDPlaySound[3] = 9001012
					SoraDPlaySound[4] = 9001024
					local SoraDPlaySound[5], list = 9001025, SoraDPlaySound
					SoraDGetCtrl("activityCenterUICtrl", gametop):sendClearNewList2Msg(list)
					self.fields.btnHarvestSeason:setReddot(false)
					_ENV = self.fields.btnHarvestSeason.setReddot
					self.fields.btnHarvestSeason.setReddot.time = remainTime
					local self.fields.btnHarvestSeason.setReddot.actList, param = actIDList, self.fields.btnHarvestSeason.setReddot
					uiManager:show("HarvestSeasonMain", param)
				end)
			end
		end
	elseif self.fields.btnHarvestSeason then
		self.fields.btnHarvestSeason:setVisible(false)
		self.fields.btnHarvestSeason:getTextField():endTime()
	end
end
function TreasureHuntViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "treasureHuntSingle" then
		dump(self.tableResSingle[1], "self.tableResSingle[1]")
		return self.tableResSingle[1]
	else
		return self.fields[itemName]
	end
end
return TreasureHuntViewPanel

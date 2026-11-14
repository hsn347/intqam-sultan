local baseComponent = require("fgui.base.baseComponent")
local Com_TP_itemSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://TreasurePool/Com_TP_itemSingle", Com_TP_itemSingle)
local resDesRead = include("resDesRead")
local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local luckyBlessCtrl = SoraDGetCtrl("luckyBlessCtrl")
function Com_TP_itemSingle:onInit()
	self.tableMeData, _ENV = nil, nil
	self.handlHunt = nil
	self.scroll = nil
	self.singleIsMoved = false
	self.isTenClick = false
	self.isFromEquip = false
	self.fields.Text_tip:setString(i18n("common_text_428"))
	self:addClickEventListener(handler(self, self.btnSingleClick))
	self.Panel_op = display.newNode()
	self.fields.Panel_op:setContent(self.Panel_op)
	self.isShowTen = SoraDGetCtrl("exaltedPrivilegeCtrl"):checkPrivilege(gExaltedPrivilegeType.WISH_RESOURCE)
	self:addBgEffect()
end
function Com_TP_itemSingle:onShow()
	local _posX = self:getPositionX()
	local _posY = self:getPositionY()
	self:setPositionY(_posY + display.height / 2)
	self:setAlpha(0)
	local _delay = math.random(0, 300) / 500
	_UPVALUE2_ = 300
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.callFunc(function()
		self:fadeIn(1.0)
	end)
	;(nil)[2] = ffa.exponentialOut(ffa.moveTo(1.0, _posX, _posY))
	;(nil)[3] = ffa.exponentialOut(ffa.moveTo(1.0, _posX, _posY))
	;(nil)[4] = ffa.exponentialOut(ffa.moveTo(1.0, _posX, _posY))
	;(nil)[5] = ffa.exponentialOut(ffa.moveTo(1.0, _posX, _posY))
	;(nil)[6] = ffa.exponentialOut(ffa.moveTo(1.0, _posX, _posY))
	;(300)[1] = ffa.delay(_delay)
	;(300)[2] = ffa.spawn(nil)
	;(300)[3] = ffa.callFunc(function()
		self:doAction()
	end)
	;(300)[4] = ffa.callFunc(function()
		self:doAction()
	end)
	;(300)[5] = ffa.callFunc(function()
		self:doAction()
	end)
	;(300)[6] = ffa.callFunc(function()
		self:doAction()
	end)
	;(300)[7] = ffa.callFunc(function()
		self:doAction()
	end)
	;(300)[8] = ffa.callFunc(function()
		self:doAction()
	end)
	;(300)[9] = ffa.callFunc(function()
		self:doAction()
	end)
	local seq = ffa.seq(300)
	self:runAction(seq)
end
function Com_TP_itemSingle:addBgEffect()
	local effectPool = SoraDCreatAnimation("Node_Effect_xycSingleBg", nil, true)
	effectPool:setPosition(cc.p(0, 0))
	self.Panel_op:addChild(effectPool)
end
function Com_TP_itemSingle:setOpacity(opacity)
	self:setAlpha(opacity)
end
function Com_TP_itemSingle:fadeIn(time)
	self:runAction(ffa.fadeIn(time))
end
function Com_TP_itemSingle:doAction()
	local delayRandom = math.random(0, 100) / 100
	local moveRandom1 = 1
	local moveRandom3 = 1
	local posRandom = 8
	_UPVALUE3_ = nil
	;(nil)[1] = ffa.delay(delayRandom)
	;(nil)[2] = ffa.moveBy(2 * moveRandom1, 0, posRandom)
	;(nil)[3] = ffa.moveBy(2 * moveRandom3, 0, -posRandom)
	;(nil)[4] = ffa.callFunc(function()
	end)
	;(nil)[5] = ffa.callFunc(function()
	end)
	;(nil)[6] = ffa.callFunc(function()
	end)
	local seq = ffa.seq(nil)
	self.fields.spRes:runAction(ffa.repeatForever(seq))
end
function Com_TP_itemSingle:setHuntHandl(handl)
	self.handlHunt = handl
end
function Com_TP_itemSingle:initData(treasureHuntData, isFree)
	self.tableMeData = treasureHuntData
	local icon = resDesRead.getTreasureIcon(self.tableMeData.resid)
	icon = icon or "icon_item_common.png"
	self.fields.spRes:setURL(icon)
	if self.tableMeData.isLocked then
		self.controllers.c1:setSelectedIndex(0)
		local unlockLv = resDesRead.getUnLockLevel(self.tableMeData.resid)
		local isShowWarLv, textLv = SoraDGetBuildWarLv(unlockLv)
		local strLevel = textLv
		if isShowWarLv then
			resDesRead = nil
			;(nil).level = strLevel
			self.fields.txtLocked:setString(i18n("common_text_4094", nil))
		else
			resDesRead = i18n("common_text_4094", nil)
			i18n("common_text_4094", nil).level = strLevel
			self.fields.txtLocked:setString(i18n("common_text_427", i18n("common_text_4094", nil)))
		end
		self:setTouchEnabled(false)
		return
	end
	self.controllers.c1:setSelectedIndex(1)
	self.fields.labCount:setString(string.formatnumberthousands(self.tableMeData.resper.otherTotal))
	local blessBuff = 0
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.LUCKY_BLESSING_ACTIVITY) then
		local status = luckyBlessCtrl:getLuckyBlessStatus()
		local luckyData = luckyBlessCtrl:getLuckyData()
		local preData = luckyBlessCtrl:getCurBless()
		local effectType = preData and preData.type or luckyData.curEffectType
		if status == 2 and effectType == gLuckyBlessActivityEffectType.MAKE_A_WISH then
			blessBuff = luckyData.discount / 1000
		end
	end
	local actTotal = self.tableMeData.resper.actTotal + math.floor(self.tableMeData.resper.otherTotal * blessBuff)
	self.fields.addbg:setVisible(0 < actTotal)
	self.fields.txtAddCount:setVisible(0 < actTotal)
	resDesRead = string.formatnumberthousands(self.tableMeData.resper.otherTotal)
	string.formatnumberthousands(self.tableMeData.resper.otherTotal).num = "+"
	string.formatnumberthousands(self.tableMeData.resper.otherTotal).char = string.formatnumberthousands(actTotal)
	self.fields.txtAddCount:setString(i18n("common_text_1470", string.formatnumberthousands(self.tableMeData.resper.otherTotal)))
	self.isFree = isFree
	self:setIsFree(isFree)
	if self.tableMeData.resid == gIDDef.STEEL then
		self.fields.text_ownSteel:setVisible(self.isFromEquip)
		local curCount = SoraDConvertNumberWithUnit(cityCtrl:getResCount(self.tableMeData.resid))
		resDesRead = cityCtrl:getResCount(self.tableMeData.resid)
		cityCtrl:getResCount(self.tableMeData.resid).count = curCount
		self.fields.text_ownSteel:setString(i18n("common_text_1377", cityCtrl:getResCount(self.tableMeData.resid)))
	end
end
function Com_TP_itemSingle:setIsTenClick(isTenClick)
	self.isTenClick = isTenClick
	self.fields.frame_xyc_bg:setURL(self.isTenClick and "frame_treasurepool_xuyuankuang02.png" or "frame_treasurepool_xuyuankuang01.png")
	self:setIsFree(self.isFree)
end
function Com_TP_itemSingle:setIsJumpFromEquip(isFromEquip)
	self.isFromEquip = isFromEquip
end
function Com_TP_itemSingle:setIsFree(isFree)
	local str
	if self.isTenClick then
		isfree = not self.tableMeData.needGoldTen or not (self.tableMeData.needGoldTen > 0)
		_ENV = nil
		_ENV, _ENV, (nil).gold = nil, self.tableMeData.needGoldTen, self.tableMeData.needGoldTen
		self.tableMeData.needGoldTen.gold, (nil).color = nil, "#FFFF00"
		str = i18n_html("privilege_text_111", nil, self.tableMeData.needGoldTen)
	else
		_ENV = nil
		;(nil).price = self.tableMeData.needGold
		str = i18n("common_text_429", nil)
	end
	if self.isTenClick then
		self.fields.Text_tip:setString(i18n("privilege_text_110"))
	else
		self.fields.Text_tip:setString(i18n("common_text_428"))
	end
	if isFree then
		self.fields.Text_tip:setVisible(true)
		self.fields.gold:setVisible(false)
		self.fields.txtGold:setVisible(false)
	else
		self.fields.Text_tip:setVisible(false)
		self.fields.gold:setVisible(true)
		self.fields.txtGold:setVisible(true)
	end
	self.fields.txtGold:setString(str)
end
function Com_TP_itemSingle:harvestEffect(bool)
	if bool then
		self.fields.Particle_harvest:setVisible(true)
	else
		self.fields.Particle_harvest:setVisible(false)
	end
end
function Com_TP_itemSingle:showBowen(isPlay)
	if isPlay then
		if self.effectPop then
			SoraDResetEffectNode(self.effectPop)
			self.effectPop:setVisible(true)
			self.effectPop.action:gotoFrameAndPlay(0, 60, false)
			SoraDGetChildByName(self.effectPop, "et_Par_gmzz_003"):resetSystem()
		else
			self.effectPop = SoraDCreatAnimationEx("Node_Effect_xycSinglePop", nil, false)
			self.effectPop:setPosition(cc.p(0, 0))
			self.effectPop:addTo(self.Panel_op, 1)
		end
	elseif self.effectPop then
		self.effectPop:setVisible(false)
	end
end
function Com_TP_itemSingle:btnSingleClick(button, type)
	SoraDPlaySound("uicontrol", 41)
	if button == self then
		if self.isTenClick then
			self.handlHunt(self.tableMeData.resid, self.tableMeData.resper.resTotal, self.tableMeData.needGoldTen, true)
		else
			self.handlHunt(self.tableMeData.resid, self.tableMeData.resper.resTotal, self.tableMeData.needGold)
		end
	else
		self.handlHunt(self.tableMeData.resid, self.tableMeData.resper.resTotal, self.tableMeData.needGoldTen, true)
	end
	self.fields.spRes:stopActionByTag(8)
	self.fields.spRes:setScale(1.0)
	_UPVALUE1_ = self.fields.spRes
	_UPVALUE1_ = self.tableMeData.needGoldTen
	self.tableMeData.needGoldTen[1] = ffa.bounceOut(ffa.scaleTo(0.6, 1.1))
	self.tableMeData.needGoldTen[2] = ffa.callFunc(self:showBowen(true))
	self.tableMeData.needGoldTen[3] = ffa.callFunc(self:showBowen(true))
	self.tableMeData.needGoldTen[4] = ffa.callFunc(self:showBowen(true))
	self.tableMeData.needGoldTen[5] = ffa.callFunc(self:showBowen(true))
	self.fields.spRes[1] = ffa.spawn(self.tableMeData.needGoldTen)
	self.fields.spRes[2] = ffa.exponentialOut(ffa.scaleTo(0.6, 1.0))
	self.fields.spRes[3] = ffa.exponentialOut(ffa.scaleTo(0.6, 1.0))
	self.fields.spRes[4] = ffa.exponentialOut(ffa.scaleTo(0.6, 1.0))
	self.fields.spRes[5] = ffa.exponentialOut(ffa.scaleTo(0.6, 1.0))
	self.fields.spRes[6] = ffa.exponentialOut(ffa.scaleTo(0.6, 1.0))
	self.fields.spRes[7] = ffa.exponentialOut(ffa.scaleTo(0.6, 1.0))
	local seq = ffa.seq(self.fields.spRes)
	seq:setTag(8)
	self.fields.spRes:runAction(seq)
end
return Com_TP_itemSingle

local baseProxy = require("fgui.base.baseProxy")
local PetFguiViewProxy = class("PetFguiViewProxy", baseProxy)
local gametop = gModuleMgr.getObject("gametop")
local petCtrl = gametop.playertop_:getModule("petCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local shopCtrl = gametop.playertop_:getModule("shopCtrl")
local petltCtrl = include("petltCtrl")
local petDesRead = include("petDesRead")
local itemDesRead = include("itemDesRead")
function PetFguiViewProxy:onRegisterEvent()
	self.tableEXPLabelSpare, _ENV, self.tableEXPActionData, _ENV = nil, nil, nil, nil
	SoraDAddMessage(self, "MESSAGE_UI_COMMON_EDITBOX_CLOSE", function(...)
		self.msgBox = true
	end)
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", function(...)
		self.view:updateRedPoint()
		self.view:updateTrainDetail()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_PET_DATA_UPDATE", handler(self, self.petDataUpdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_PET_UNLOCK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_PET_SKILL_TOOL_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UI_PET_ISFEEDITEM_SHOW", function(target, data)
		self.view.fields.scroll_attributes:setVisible(not data.data)
		self:updateView()
	end)
	SoraDAddMessage(self, "MESSAGE_UI_PET_FEEDITEM_UPADTE", handler(self, self.updateAddExpPreview))
	SoraDAddMessage(self, "MESSAGE_PET_ITEM_GUILD", function(target, data)
		local itemID = data.itemID
		_ENV = nil
		;(nil).itemID = itemID
		uiManager:show("CommonSourceGuide", nil)
	end)
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.updateGold))
end
function PetFguiViewProxy:updateView()
	SoraDCloseLoading()
	self.view:updateCurPet()
end
function PetFguiViewProxy:updateAddExpPreview(target, data)
	self.view:updateAddExpPreview(data.data)
end
function PetFguiViewProxy:updateGold()
	self.view.fields.btnGold:updateGold()
end
function PetFguiViewProxy:petDataUpdate(target, data)
	self:updateView()
	if data.isRankChange or data.isLevelChange then
		self.view.fields.pet_model:playUpgradeEffect(true, true)
	end
	local feedType = data.feedType
	if feedType == gPetFeedType.GOLD or feedType == gPetFeedType.FREE then
		print("这是金币喂养返回-------")
		local add_history = data.add_history
		self:showFeedHitTimes(add_history)
	elseif feedType == gPetFeedType.TWENTY then
		print("这是20次连续喂养返回------")
		local add_history = data.add_history
		self:showFeedHitTimes(add_history)
		if SoraDIsGameGuide() == nil and #add_history < 20 then
			local result = add_history
			_ENV = nil
			;(nil).result = result
			uiManager:show("PetFeedResultView", nil)
		end
	elseif feedType == gPetFeedType.TOOL then
		local other = data.other
		if other then
			local exp = other.count * backpackltCtrl:getPetFeedExp(other.id)
			_ENV, _ENV = nil, other.id
			;(nil).times = 1
			;(nil).exp = exp
			other.id[1], (nil).count = nil, 1
			self:showFeedHitTimes(other.id)
		end
	end
end
function PetFguiViewProxy:showFeedHitTimes(add_history)
	for i = 1, #add_history do
		local addItem = add_history[i]
		if 1 <= addItem.times then
			local expStr = ""
			if addItem.times == 1 then
				expStr = addItem.exp / addItem.times
			else
				expStr = addItem.exp / addItem.times .. "x" .. addItem.times
			end
			self:insertEXPAction(expStr, 1 < addItem.times and 1 or 0)
		end
	end
	self:createEXPAction()
end
function PetFguiViewProxy:insertEXPAction(text, actType)
	_ENV = nil
	;(nil).text = text
	;(nil).actType = actType
	table.insert(self.tableEXPActionData, nil)
end
function PetFguiViewProxy:createEXPAction()
	if not self.isRunAction and self.tableEXPActionData[1] then
		self.isRunAction = true
		local actionData = table.remove(self.tableEXPActionData, 1)
		_UPVALUE2_ = 1
		;(1)[1] = ffa.callFunc(function()
			self:SoraDCreateWaveBMP(actionData)
		end)
		;(1)[2] = ffa.delay(0.1)
		;(1)[3] = ffa.callFunc(function()
			self.isRunAction = false
			self:createEXPAction()
		end)
		;(1)[4] = ffa.callFunc(function()
			self.isRunAction = false
			self:createEXPAction()
		end)
		local action = ffa.seq(1)
		self.view:runAction(action)
	end
end
function PetFguiViewProxy:SoraDCreateWaveBMP(actionData)
	local _ENV, text = nil, actionData.text or "NA"
	;(nil).color = cc.c3b(255, 255, 0)
	;(nil).fontSize = 18
	;(nil).pos = cc.p(140, -80)
	;(nil).zOrder = 10
	;(nil).duration = 0.4
	;(nil).moveH = 155
	;(nil).scale = 1.2
	local (nil).font, param = "res/fonts/baojishuzi0-9.fnt", nil
	local waveLabel
	if #self.tableEXPLabelSpare >= 20 then
		waveLabel = table.remove(self.tableEXPLabelSpare, 1)
		waveLabel:stopAllActions()
		waveLabel:setOpacity(255)
		waveLabel:setVisible(true)
		waveLabel:setString(text)
	else
		_ENV = waveLabel
		waveLabel.text = text
		waveLabel.font = param.font
		waveLabel = display.newBMFontLabel(waveLabel)
		self.view.fields.Node_Effect_bj:setContent(waveLabel)
	end
	table.insert(self.tableEXPLabelSpare, waveLabel)
	waveLabel:setCascadeColorEnabled(false)
	waveLabel:setColor(param.color)
	waveLabel:setScale(param.scale)
	waveLabel:setPosition(param.pos)
	local baseScale = param.scale
	if actionData.actType == 1 then
		local tmpAni = SoraDCreatAnimation("petEffectbj", nil, false)
		self.view.fields.Node_Effect_bj3:setContent(tmpAni)
		waveLabel:setScale(0.1 * baseScale)
		waveLabel:setOpacity(0)
		_UPVALUE6_ = waveLabel
		_UPVALUE1_ = 0.24
		;(0.24)[1] = cca.fadeTo(0.06666666666666667, 1)
		;(0.24)[2] = cca.scaleTo(0.06666666666666667, 2)
		;(0.24)[3] = cca.scaleTo(0.06666666666666667, 2)
		;(0.24)[4] = cca.scaleTo(0.06666666666666667, 2)
		;(0.24)[5] = cca.scaleTo(0.06666666666666667, 2)
		waveLabel[1] = cca.delay(0.06666666666666667)
		waveLabel[2] = cca.fadeTo(0.016666666666666666, 0.24)
		waveLabel[3] = cca.spawn(0.24)
		waveLabel[4] = cca.scaleTo(0.08333333333333333, 1.68 * baseScale)
		waveLabel[5] = cca.scaleTo(0.05, 1.0 * baseScale)
		waveLabel[6] = cca.scaleTo(0.08333333333333333, 1.07 * baseScale)
		waveLabel[7] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
		waveLabel[8] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
		waveLabel[9] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
		local seqPrepare = cca.seq(waveLabel)
		local moveBy = cca.moveBy(param.duration, 0, param.moveH)
		local fadeTo = cca.fadeTo(param.duration, 0)
		_UPVALUE2_ = 0
		;(0)[1] = moveBy
		;(0)[2] = fadeTo
		local spawn = cca.spawn(0)
		local callFunc = cca.callFunc(function()
			waveLabel:setVisible(false)
		end)
		_UPVALUE3_ = fadeTo
		fadeTo[1] = seqPrepare
		fadeTo[2] = spawn
		fadeTo[3] = callFunc
		local seq = cca.seq(fadeTo)
		waveLabel:runAction(seq)
		self:showCritical(param)
	else
		local moveBy = cca.moveBy(param.duration, 0, param.moveH)
		local tintTo = cca.fadeTo(param.duration, 0)
		_UPVALUE2_ = 0
		;(0)[1] = moveBy
		;(0)[2] = tintTo
		local spawn = cca.spawn(0)
		local callFunc = cca.callFunc(function()
			waveLabel:setVisible(false)
		end)
		_UPVALUE2_ = tintTo
		tintTo[1] = spawn
		tintTo[2] = callFunc
		local seq = cca.seq(tintTo)
		waveLabel:runAction(seq)
	end
	return waveLabel
end
function PetFguiViewProxy:showCritical(param)
	if not self.spCritical then
		local spName = SoraDFIsRA() and "#baojialabo.png" or "#baojiyingwen.png"
		self.spCritical = display.newSprite(spName)
		self.view.fields.Node_Effect_bj2:setContent(self.spCritical)
		self.spCritical:setPosition(cc.p(140, -130))
	else
		self.spCritical:setVisible(true)
	end
	local baseScale = param.scale
	self.spCritical:setScale(0.1 * baseScale)
	self.spCritical:setOpacity(0)
	_UPVALUE6_ = self.spCritical
	_UPVALUE1_ = 0.24
	;(0.24)[1] = cca.fadeTo(0.06666666666666667, 1)
	;(0.24)[2] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[3] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[4] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[5] = cca.scaleTo(0.06666666666666667, 2)
	self.spCritical[1] = cca.delay(0.06666666666666667)
	self.spCritical[2] = cca.fadeTo(0.016666666666666666, 0.24)
	self.spCritical[3] = cca.spawn(0.24)
	self.spCritical[4] = cca.scaleTo(0.08333333333333333, 1.68 * baseScale)
	self.spCritical[5] = cca.scaleTo(0.05, 1.0 * baseScale)
	self.spCritical[6] = cca.scaleTo(0.08333333333333333, 1.07 * baseScale)
	self.spCritical[7] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	self.spCritical[8] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	self.spCritical[9] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	local seqPrepare = cca.seq(self.spCritical)
	_UPVALUE2_ = cca.delay(0.06666666666666667)
	cca.delay(0.06666666666666667)[1] = seqPrepare
	cca.delay(0.06666666666666667)[2] = cca.delay(param.duration * 0.5)
	cca.delay(0.06666666666666667)[3] = cca.fadeOut(param.duration * 0.6)
	cca.delay(0.06666666666666667)[4] = cca.fadeOut(param.duration * 0.6)
	cca.delay(0.06666666666666667)[5] = cca.fadeOut(param.duration * 0.6)
	cca.delay(0.06666666666666667)[6] = cca.fadeOut(param.duration * 0.6)
	cca.delay(0.06666666666666667)[7] = cca.fadeOut(param.duration * 0.6)
	cca.delay(0.06666666666666667)[8] = cca.fadeOut(param.duration * 0.6)
	local seqAct = cca.seq((cca.delay(0.06666666666666667)))
	self.spCritical:stopAllActions()
	self.spCritical:runAction(seqAct)
end
return PetFguiViewProxy

local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local magicFlipCtrl = SoraDGetCtrl("magicFlipCtrl")
local publicRead = include("publicRead")
local constantRead = include("constantRead")
local magicFlipRead = include("magicFlipRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampActivityPanel = class("MagicLampActivityPanel", baseFguiPanel)
function MagicLampActivityPanel:ctor(...)
	MagicLampActivityPanel.super.ctor(self, ...)
	print("MagicLampActivityPanel:ctor", self.viewName)
end
function MagicLampActivityPanel:onInit()
	print("=======MagicLampActivityPanel:onInit")
	self.activityID = gActivityTimeActivityID.MAGIC_FLIP_ACTIVITY
	self.itemID = constantRead.getConstValue("USE_ITEM_9001498", 860901)
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_Reward:setString(i18n("magic_flip_2"))
	self.fields.Button_Reward:addClickListener(handler(self, self.onClickPreaward))
	self.fields.Button_Log:setString(i18n("magic_flip_3"))
	self.fields.Button_Log:addClickListener(handler(self, self.onClickLog))
	self.fields.Com_Have:initData(self.itemID)
	_ENV = handler(self, self.onClickLog)
	handler(self, self.onClickLog).num = 1
	self.fields.Button_One:setString(i18n("magic_flip_5", handler(self, self.onClickLog)))
	self.fields.Button_One:addClickListener(handler(self, self.onClickOne))
	_ENV = handler(self, self.onClickOne)
	handler(self, self.onClickOne).num = 10
	self.fields.Button_Ten:setString(i18n("magic_flip_5", handler(self, self.onClickOne)))
	self.fields.Button_Ten:addClickListener(handler(self, self.onClickTen))
	local scale = self:getHeight() / 1136 * 0.2 + 0.6
	self.fields.Usm_OpenEffect:setScaleY(scale)
end
function MagicLampActivityPanel:onShow()
	print("=======MagicLampActivityPanel:onShow")
	local _ENV, stageData = print, print
	local stageConfig = magicFlipRead.getStageConfig()
	for __, cfg in ipairs(stageConfig) do
		_ENV = nil
		;(nil).stage = cfg.index
		;(nil).point = cfg.num
		magicFlipCtrl = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		;(nil).rewards = serviceFunctions.tableFormat(cfg.reward, nil)
		table.insert(stageData, nil)
	end
	self.stageData = stageData
	_ENV = ipairs(stageConfig)
	ipairs(stageConfig).activityID = self.activityID
	ipairs(stageConfig).stageMax = #self.stageData
	self.fields.Com_boxList:initData(ipairs(stageConfig))
	magicFlipCtrl:sendReqInitDataMsg()
	self:updateView()
end
function MagicLampActivityPanel:updateView()
	self:updateStageButton()
	self:updateButton()
end
function MagicLampActivityPanel:getCardIsSame(newCard, index)
	for i, v in ipairs(newCard) do
		if i ~= index and v == newCard[index] then
			return true
		end
	end
end
function MagicLampActivityPanel:updateStageButton()
	self.nowCount = magicFlipCtrl:getFlipCount()
	magicFlipCtrl = self.nowCount
	self.nowCount.color = "#FFDF2D"
	local numStr = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(self.nowCount), self.nowCount)
	magicFlipCtrl = nil
	;(nil).num = numStr
	self.fields.Text_openCount:setString(i18n("magic_flip_8", nil))
	for __, data in ipairs(self.stageData) do
		data.state = magicFlipCtrl:getStageBoxStatues(data.stage, data.point)
	end
	magicFlipCtrl = ipairs(self.stageData)
	ipairs(self.stageData).score = self.nowCount
	ipairs(self.stageData).stageData = self.stageData
	self.fields.Com_boxList:updateData(ipairs(self.stageData))
end
function MagicLampActivityPanel:updateButton()
	self.fields.Button_One:setCost(self.itemID, 1)
	self.fields.Button_Ten:setCost(self.itemID, 10)
	self.fields.Com_Have:updateNum()
	self:showDouble(magicFlipCtrl:getIsDouble())
end
function MagicLampActivityPanel:showDouble(isShow)
	self.controllers.c1:setSelectedIndex(isShow and 1 or 0)
end
function MagicLampActivityPanel:playFlipAnimation(reward)
	local newCard = magicFlipCtrl:getNewCardRecord()
	for i = 1, 3 do
		local Flip_Icon = self.fields[string.format("Flip_Icon%d", SoraDFPosX(i, 4))]
		Flip_Icon:initData(newCard[i], false)
		Flip_Icon:setVisible(true)
		Flip_Icon:setAlpha(0)
		Flip_Icon:resetEffect()
	end
	self.fields.Usm_OpenEffect:play(false)
	self.transitions.t0:play(1, 0, 0, -1, function()
		SoraDMailGainItems(reward, true)
		for i = 1, 3 do
			if self:getCardIsSame(newCard, i) then
				self.fields[string.format("Flip_Icon%d", SoraDFPosX(i, 4))]:playEffect()
			end
		end
		self.isOpen = false
	end)
end
function MagicLampActivityPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).item = publicRead.getName(self.itemID)
	local content = i18n("magic_flip_1", nil)
	_ENV = self.itemID
	self.itemID.content = content
	uiManager:show("RuleView", self.itemID)
end
function MagicLampActivityPanel:onClickPreaward()
	SoraDPlaySound()
	uiManager:show("MagicLampPreaward")
end
function MagicLampActivityPanel:onClickLog()
	SoraDPlaySound()
	SoraDShowLoading()
	uiManager:show("MagicLampLog")
end
function MagicLampActivityPanel:onClickOne()
	SoraDPlaySound()
	if self.isOpen then
		return
	end
	self.isOpen = true
	if backpackCtrl:getItemCount(self.itemID) > 0 then
		self:showDouble(false)
		SoraDShowLoading(self)
		magicFlipCtrl:reqMagicFlipOpenOne()
	else
		SoraDShowMsgTip(i18n("common_text_2512"))
	end
end
function MagicLampActivityPanel:onClickTen()
	SoraDPlaySound()
	if self.isOpen then
		return
	end
	if backpackCtrl:getItemCount(self.itemID) >= 10 then
		self:showDouble(false)
		SoraDShowLoading(self)
		magicFlipCtrl:reqMagicFlipOpenTen()
	else
		SoraDShowMsgTip(i18n("common_text_2512"))
	end
end
return MagicLampActivityPanel

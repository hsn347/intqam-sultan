local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local publicRead = include("publicRead")
local buffLogic = include("buffLogic")
local MAX_LV = 10
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local heroMskillFeedViewPanel = class("heroMskillFeedViewPanel", baseFguiPanel)
function heroMskillFeedViewPanel:ctor(...)
	heroMskillFeedViewPanel.super.ctor(self, ...)
	print("heroMskillFeedViewPanel:ctor", self.viewName)
end
function heroMskillFeedViewPanel:onInit()
	print("=======heroMskillFeedViewPanel:onInit")
	self.chipsArray, _ENV = print, print
	self.itemID = nil
	self.selectIndex = 1
	self.isMaxLv = false
	self.fields.Panel_bg:setString(i18n("hero_mastery_04"))
	self.fields.Text_ins:setString(i18n("hero_mastery_07"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self.fields.Text_none:setString(i18n("heroskill_text_04"))
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClick))
	self.fields.Button_feed:setString(i18n("common_text_055"))
	self.fields.Button_feed:addClickListener(handler(self, self.btnFeedClick))
	self.fields.Button_feed:setBright(false)
	self.fields.Slider:setSliderCallBack(handler(self, self.sliderCallBack))
	self.fields.Slider:fixPos()
	self.fields.Slider:setInpuBoxFixPos()
	self.fields.item:fixPos()
	self.fields.Image_skill:fixPos()
	self.fields.Text_lv:fixPos()
	self.fields.Text_skillName:fixPos()
	self.fields.Text_skillDes:fixPos()
	self.fields.Text_percent:fixPos()
	self.fields.Text_preview:fixPos()
	self.fields.Bar_val:fixPos()
	self.fields.Bar_val:setScaleX(SoraDFIsRA() and -1 or 1)
end
function heroMskillFeedViewPanel:onItemRenderer(index, obj)
	local chip = self.chipsArray[index + 1]
	obj:getChildByName("item"):initData(chip.id, chip.count)
	obj:getController("c1"):setSelectedIndex(chip.isHave and 0 or 1)
	obj:setSelected(self.selectIndex == index + 1)
end
function heroMskillFeedViewPanel:onClickItem()
	SoraDPlaySound()
	local index = self.fields.List:getSelectedIndex() + 1
	self.selectIndex = index
	self.itemID = self.chipsArray[self.selectIndex].id
	self:setSelectItemInfo()
	if not self.chipsArray[self.selectIndex].isHave then
		SoraDShowMsgTip(i18n("awakeSkillCrit_text_09"))
	end
end
function heroMskillFeedViewPanel:sliderCallBack(value)
	local singEXP = heroltCtrl:getAdvancedSkillFeedEXP(self.itemID)
	self.fields.Text_preview:setVisible(not self.isMaxLv)
	heroltCtrl = nil
	;(nil).value = string.formatnumberthousands(value * singEXP)
	self.fields.Text_preview:setString(i18n("common_text_1952", nil))
end
function heroMskillFeedViewPanel:onShow()
	print("=======heroMskillFeedViewPanel:onShow")
	self.heroID = self.param.heroID
	self:initData()
end
function heroMskillFeedViewPanel:initData()
	self.advanceInfo = heroCtrl:getHeroAdvancedSkillInfo(self.heroID)
	local mSkillID = heroltCtrl.getMSkillID(self.heroID)
	local mSkillInfo = heroltCtrl.getSkillDesInfo(mSkillID)
	self.fields.Image_skill:setIcon(mSkillInfo.herIcon)
	self.fields.Text_skillName:setString(i18n(mSkillInfo.herName))
	local skillAddition, awakeAddition, stuntAddition, masteryAddition = heroCtrl:getHeroPalaceBuff(self.heroID)
	if self.advanceInfo and next(self.advanceInfo) then
		local heroCtrl, args = next(self.advanceInfo), next(self.advanceInfo)
		local level = self.advanceInfo.level or 1
		heroCtrl = i18n(mSkillInfo.herName)
		i18n(mSkillInfo.herName).lv = level
		self.fields.Text_lv:setString(i18n("common_text_100", i18n(mSkillInfo.herName)))
		local curMSkillID = tonumber(string.format("%d%.2d", mSkillID, level))
		local mSkillCfg = heroltCtrl:getMasterySkillInfo(curMSkillID)
		if #mSkillCfg.buffType > 0 then
			for k, v in ipairs(mSkillCfg.buffType) do
				local model = mSkillCfg.buffMode[k]
				local val = mSkillCfg.buffValue[k]
				local isAddP = true
				if model == 2 then
					local isAddP = false
					val = buffLogic.isNeedThousand(v) and mSkillCfg.buffValue[k] / 1000 or mSkillCfg.buffValue[k]
				end
				if not heroltCtrl:isScreenBuff(v) and 0 < masteryAddition then
					local showVal = isAddP and SoraDPreciseDecimal(val * (1 + masteryAddition / 1000), 4) or math.floor(val * (1 + masteryAddition / 1000))
					local des = isAddP and showVal / 10 .. "%" or showVal
					local oriStr = isAddP and SoraDPreciseDecimal(val / 10, 4) .. "%" or math.floor(val)
					local palaceVal = showVal - val
					local palaceStr = isAddP and SoraDPreciseDecimal(palaceVal / 10, 4) .. "%" or math.floor(palaceVal)
					heroCtrl = string.format("%d%.2d", mSkillID, level)
					string.format("%d%.2d", mSkillID, level).des = des
					string.format("%d%.2d", mSkillID, level).ori = oriStr
					string.format("%d%.2d", mSkillID, level).add = palaceStr
					val = i18n("%{des}(%{ori}+%{add})", string.format("%d%.2d", mSkillID, level))
				else
					val = isAddP and val / 10 .. "%" or val
				end
				if not args.num then
					args.num = val
				end
				if not args.var then
					args.var = val
				end
				args["var" .. k] = val
				args["num" .. k] = val
			end
		end
		self.fields.Text_skillDes:setString(i18n(mSkillInfo.des, args))
		local skillExp = self.advanceInfo.skillExp or 0
		self.isMaxLv = level >= MAX_LV
		local percent, nextExp = heroltCtrl:getAdvancedSkillPercent(self.heroID, level, skillExp)
		self.fields.Bar_val:setValue(self.isMaxLv and 100 or percent)
		if not self.isMaxLv or not "MAX" then
			heroCtrl = i18n(mSkillInfo.des, args)
			i18n(mSkillInfo.des, args).member = string.formatnumberthousands(skillExp)
			i18n(mSkillInfo.des, args).total = string.formatnumberthousands(nextExp)
		end
		self.fields.Text_percent:setString((i18n("common_text_155", i18n(mSkillInfo.des, args))))
	end
	self.chipsArray = heroltCtrl:getAllAwakeSkillItem(self.heroID)
	if 0 < #self.chipsArray then
		self.controllers.c1:setSelectedIndex(0)
		self.selectIndex = math.min(self.chipsArray[self.selectIndex] and self.chipsArray[self.selectIndex].id == self.itemID and self.selectIndex or 1, #self.chipsArray)
		self:setSelectItemInfo()
	else
		self.controllers.c1:setSelectedIndex(1)
		self.selectIndex = 1
		self.fields.Text_preview:setVisible(false)
	end
	self.fields.List:setNumItems(#self.chipsArray)
end
function heroMskillFeedViewPanel:setSelectItemInfo()
	self.itemID = self.chipsArray[self.selectIndex].id
	local skillValue = self:getSkillValue()
	self.fields.item:initData(self.itemID)
	_UPVALUE0_ = self.itemID
	self.itemID.maxValue = skillValue
	self.itemID.minValue = 1
	self.itemID.curValue = 1
	self.fields.Slider:initData(self.itemID)
	self.fields.Button_feed:setBright(self.chipsArray[self.selectIndex].isHave)
end
function heroMskillFeedViewPanel:getSkillValue()
	local skillValue = 0
	local bagCount = backpackCtrl:getItemCount(self.itemID)
	local singEXP = heroltCtrl:getAdvancedSkillFeedEXP(self.itemID)
	local totalEXP = 0
	local level = self.advanceInfo.level or 1
	local skillExp = self.advanceInfo.skillExp or 0
	for i = level, MAX_LV - 1 do
		local percent, nextExp = heroltCtrl:getAdvancedSkillPercent(self.heroID, i, skillExp)
		totalEXP = totalEXP + nextExp
	end
	local needEXP = totalEXP - skillExp
	skillValue = math.ceil(needEXP / singEXP)
	if bagCount <= skillValue then
		skillValue = bagCount
	end
	return skillValue
end
function heroMskillFeedViewPanel:refreshView(target, data)
	SoraDCloseLoading(self)
	self:initData()
	self.fields.Bar_val:playAct()
end
function heroMskillFeedViewPanel:btnGoClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = heroltCtrl.getHeroInfo(self.heroID).itemID
	;(nil).needCount = 1
	uiManager:show("newHeroGainChipMethodView", nil)
end
function heroMskillFeedViewPanel:btnFeedClick()
	SoraDPlaySound()
	if not self.chipsArray[self.selectIndex].isHave then
		SoraDShowMsgTip(i18n("awakeSkillCrit_text_09"))
		return
	end
	if self.isMaxLv then
		SoraDShowMsgTip(i18n("hero_mastery_01"))
		return
	end
	local level = self.advanceInfo.level or 1
	local skillExp = self.advanceInfo.skillExp or 0
	print("花费碎片升级====")
	local toFullEXP = heroltCtrl:getAdvancedSkillFullEXP(self.heroID, level, skillExp)
	print("toFullEXP======", toFullEXP)
	local singEXP = heroltCtrl:getAdvancedSkillFeedEXP(self.itemID)
	local selectNum = self.fields.Slider:getSliderCurValue()
	local sureFeedHero = function()
		if heroltCtrl:isAwakeSkillItem(self.itemID) then
			heroCtrl:feedHeroMastery(self.heroID, self.itemID, selectNum)
			SoraDShowLoading(self)
		end
	end
	if toFullEXP < singEXP * selectNum then
		print("溢出提示=====")
		_ENV = i18n("hero_mastery_01")
		i18n("hero_mastery_01").num = selectNum
		i18n("hero_mastery_01").name = publicRead.getName(self.itemID)
		SoraDShowMsgBox(i18n("hero_mastery_05", i18n("hero_mastery_01")), i18n("common_text_204"), nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				sureFeedHero()
			end
		end)
	else
		_ENV = i18n("common_text_204")
		i18n("common_text_204").byUID = true
		local isIgnore = SoraDConfigGet("Game:heroMSkillFeedView:refresh~bool", (i18n("common_text_204")))
		if isIgnore then
			sureFeedHero()
		else
			function _ENV(callBack)
				if callBack == MSGBOX_CALLBACK_YES then
					sureFeedHero()
				end
			end
			_ENV = i18n("hero_mastery_01")
			i18n("hero_mastery_01").num = selectNum
			i18n("hero_mastery_01").name = publicRead.getName(self.itemID)
			;(function(callBack)
				if callBack == MSGBOX_CALLBACK_YES then
					sureFeedHero()
				end
			end).content = i18n("hero_mastery_06", i18n("hero_mastery_01"))
			;(function(callBack)
				if callBack == MSGBOX_CALLBACK_YES then
					sureFeedHero()
				end
			end).confirmFunc = function()
				sureFeedHero()
			end
			;(function(callBack)
				if callBack == MSGBOX_CALLBACK_YES then
					sureFeedHero()
				end
			end).remindString = i18n("heroskill_text_11")
			;(function(callBack)
				if callBack == MSGBOX_CALLBACK_YES then
					sureFeedHero()
				end
			end).remindFunc = function(value)
				_ENV = nil
				;(nil).byUID = true
				SoraDConfigSet("Game:heroMSkillFeedView:refresh~bool", value, nil)
			end
			uiManager:show("MessageBox", function(callBack)
				if callBack == MSGBOX_CALLBACK_YES then
					sureFeedHero()
				end
			end)
		end
	end
end
return heroMskillFeedViewPanel

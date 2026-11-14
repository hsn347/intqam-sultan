local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local buffLogic = include("buffLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_herouskill_sp = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_herouskill_sp", Com_herouskill_sp)
function Com_herouskill_sp:onInit()
	self.fields.Text_spex:setString(i18n("heroDes_text_04"))
	self.fields.Text_topNum:setString(i18n("common_text_283"))
	self.fields.Button_upgrade:setTitle(i18n("common_text_055"))
	self.fields.Button_upgrade:addTouchEventListener(handler(self, self.btnUpgradeClick))
	self.fields.skillItem:fixPos()
	self.fields.Text_skillName:fixPos()
	self.fields.Text_skillDes:fixPos()
	self.fields.Button_upgrade:fixPos()
	self.fields.Text_topNum:fixPos()
end
function Com_herouskill_sp:onShow()
end
function Com_herouskill_sp:initData(heroID)
	self.heroID = heroID
	local heroInfo = heroCtrl:getHeroInfoByID(heroID)
	local advanceInfo = heroCtrl:getHeroAdvancedSkillInfo(heroID)
	local mSkillID = heroltCtrl.getMSkillID(heroID)
	local mSkillInfo = heroltCtrl.getSkillDesInfo(mSkillID)
	local isFullSkill = heroltCtrl:isHeroUSkillFull(heroInfo.powerSkill, heroInfo.advancedSkill.bActive)
	local costInfo = heroltCtrl:getAwakeCost(self.heroID)
	self.itemID = costInfo.id
	self.itemNum = backpackCtrl:getItemCount(self.itemID)
	self.needNum = costInfo.num
	if not isFullSkill or not i18n(mSkillInfo.herName) then
		heroCtrl = nil
		;(nil).name = i18n(mSkillInfo.herName)
	end
	self.fields.Text_skillName:setString((i18n("hero_mastery_02", nil)))
	local heroCtrl, args = self.fields.Text_skillName.setString, self.fields.Text_skillName.setString
	local level = 10
	local isUnlock = false
	local percent = 0
	self.fields.Text_topNum:setVisible(false)
	self.fields.Button_upgrade:setVisible(isFullSkill)
	self.controllers.c1:setSelectedIndex(0)
	if advanceInfo and next(advanceInfo) then
		isUnlock = true
		self.controllers.c1:setSelectedIndex(1)
		level = advanceInfo.level
		local rarity = heroltCtrl:getRarity(self.heroID)
		local isShowSpNode = rarity >= gHeroQuality.BLUE and IsArClient and 10 <= level
		self.fields.Text_topNum:setVisible(isShowSpNode)
		self.fields.Button_upgrade:setVisible(level < 10)
		percent = 10 <= advanceInfo.level and 100 or heroltCtrl:getAdvancedSkillPercent(self.heroID, advanceInfo.level, advanceInfo.skillExp)
		heroCtrl = advanceInfo.skillExp
		advanceInfo.skillExp.lv = level
		self.fields.Text_skillName:setString(i18n("common_text_101", advanceInfo.skillExp) .. "  " .. i18n(mSkillInfo.herName))
	end
	local curMSkillID = tonumber(string.format("%d%.2d", mSkillID, level))
	local mSkillCfg = heroltCtrl:getMasterySkillInfo(curMSkillID)
	local skillAddition, awakeAddition, stuntAddition, masteryAddition = heroCtrl:getHeroPalaceBuff(self.heroID)
	if 0 < #mSkillCfg.buffType then
		for k, v in ipairs(mSkillCfg.buffType) do
			local model = mSkillCfg.buffMode[k]
			local isAddP = true
			local val = mSkillCfg.buffValue[k]
			if model == 2 then
				isAddP = false
				val = buffLogic.isNeedThousand(v) and mSkillCfg.buffValue[k] / 1000 or mSkillCfg.buffValue[k]
			end
			if not heroltCtrl:isScreenBuff(v) and 0 < masteryAddition then
				local showVal = isAddP and SoraDPreciseDecimal(val * (1 + masteryAddition / 1000), 4) or SoraDPreciseDecimal(val * (1 + masteryAddition / 1000), 1)
				local des = isAddP and showVal / 10 .. "%" or showVal
				local oriStr = isAddP and SoraDPreciseDecimal(val / 10, 4) .. "%" or SoraDPreciseDecimal(val, 1)
				local palaceVal = showVal - val
				local palaceStr = isAddP and SoraDPreciseDecimal(palaceVal / 10, 4) .. "%" or SoraDPreciseDecimal(palaceVal, 1)
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
	self.fields.skillItem:initData(isUnlock, mSkillInfo.herIcon, percent)
end
function Com_herouskill_sp:btnUpgradeClick()
	SoraDPlaySound()
	local advanceInfo = heroCtrl:getHeroAdvancedSkillInfo(self.heroID)
	if advanceInfo and next(advanceInfo) and advanceInfo.level >= 10 then
		SoraDShowMsgTip(i18n("hero_mastery_01"))
		return
	end
	local isChipsEnough = false
	for i, v in ipairs(heroltCtrl:getAllAwakeSkillItem(self.heroID)) do
		if backpackCtrl:getItemCount(v.id) > 0 then
			isChipsEnough = true
			break
		end
	end
	if not isChipsEnough then
		SoraDShowMsgBox(i18n("heroskill_text_04"), i18n("common_text_054"), i18n("common_text_185"), function(eventType)
			if MSGBOX_CALLBACK_YES == eventType then
				_ENV = nil
				;(nil).itemID = self.itemID
				;(nil).needCount = self.needNum
				uiManager:show("newHeroGainChipMethodView", nil)
			end
		end)
		return
	end
	local chipsArray = heroltCtrl:getAllAwakeSkillItem(self.heroID)
	if 0 < #chipsArray then
		function _ENV(eventType)
			if MSGBOX_CALLBACK_YES == eventType then
				_ENV = nil
				;(nil).itemID = self.itemID
				;(nil).needCount = self.needNum
				uiManager:show("newHeroGainChipMethodView", nil)
			end
		end
		;(function(eventType)
			if MSGBOX_CALLBACK_YES == eventType then
				_ENV = nil
				;(nil).itemID = self.itemID
				;(nil).needCount = self.needNum
				uiManager:show("newHeroGainChipMethodView", nil)
			end
		end).heroID = self.heroID
		uiManager:show("heroMskillFeedView", function(eventType)
			if MSGBOX_CALLBACK_YES == eventType then
				_ENV = nil
				;(nil).itemID = self.itemID
				;(nil).needCount = self.needNum
				uiManager:show("newHeroGainChipMethodView", nil)
			end
		end)
	else
		function _ENV(eventType)
			if MSGBOX_CALLBACK_YES == eventType then
				_ENV = nil
				;(nil).itemID = self.itemID
				;(nil).needCount = self.needNum
				uiManager:show("newHeroGainChipMethodView", nil)
			end
		end
		;(function(eventType)
			if MSGBOX_CALLBACK_YES == eventType then
				_ENV = nil
				;(nil).itemID = self.itemID
				;(nil).needCount = self.needNum
				uiManager:show("newHeroGainChipMethodView", nil)
			end
		end).itemID = heroltCtrl.getHeroInfo(self.heroID).itemID
		;(function(eventType)
			if MSGBOX_CALLBACK_YES == eventType then
				_ENV = nil
				;(nil).itemID = self.itemID
				;(nil).needCount = self.needNum
				uiManager:show("newHeroGainChipMethodView", nil)
			end
		end).needCount = 1
		uiManager:show("newHeroGainChipMethodView", function(eventType)
			if MSGBOX_CALLBACK_YES == eventType then
				_ENV = nil
				;(nil).itemID = self.itemID
				;(nil).needCount = self.needNum
				uiManager:show("newHeroGainChipMethodView", nil)
			end
		end)
	end
end
return Com_herouskill_sp

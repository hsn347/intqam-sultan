local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroROSUskillStudyPopPanel = class("HeroROSUskillStudyPopPanel", baseFguiPanel)
function HeroROSUskillStudyPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroROSUskillStudyPopPanel:ctor", self.viewName)
end
function HeroROSUskillStudyPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroROSUskillStudyPopPanel:onInit()
	print("=======HeroROSUskillStudyPopPanel:onInit")
	self.isEnoughChip = false
	self.fields.Text_original:setString(i18n("hero_comprehend_text_04"))
	self.fields.Text_now:setString(i18n("hero_comprehend_text_05"))
	_ENV = i18n("hero_comprehend_text_05")
	i18n("hero_comprehend_text_05").num = 1
	self.fields.Button_awake:setString(i18n("common_text_4947", i18n("hero_comprehend_text_05")))
	self.fields.Button_awake:addClickListener(handler(self, self.btnAwakeClick))
	self:updateView(self.proxy.param)
	self.imgScouring = self.fields.imgScouring
	if SoraDFIsRA() then
		self.imgScouring:setURL("font_slim_sessesful_ar.png")
	end
end
function HeroROSUskillStudyPopPanel:onShow()
	print("=======HeroROSUskillStudyPopPanel:onShow")
end
function HeroROSUskillStudyPopPanel:updateView(data)
	self.isSuccess = self.proxy.param.isSuccess
	self.afterBuff = self.proxy.param.afterBuff
	self.preBuff = self.proxy.param.preBuff
	self.isCrit = self.proxy.param.isCrit
	local data = self.proxy.param.data
	self.times = data.times or 1
	self.heroExInfo = heroltCtrl.getHeroInfo(data.heroID)
	local skillInfo = heroltCtrl:getStuntSkillInfo(data.skillID)
	local costInfo = heroltCtrl:getAwakeCost(data.heroID)
	self.itemID = data.itemID or costInfo.id
	self.itemNum = backpackCtrl:getItemCount(self.itemID)
	self.needNum = costInfo.num * self.times
	self.heroID = data.heroID
	self.skillID = data.skillID
	self.controllers.c1:setSelectedIndex(self.isSuccess and 0 or 1)
	self.fields.Text_Result:setString(i18n(self.isSuccess and "hero_comprehend_text_03" or "hero_comprehend_text_01"))
	self.fields.Text_ResultTips:setString(i18n(self.isSuccess and "hero_comprehend_text_06" or "hero_comprehend_text_02"))
	heroltCtrl = i18n(self.isSuccess and "hero_comprehend_text_06" or "hero_comprehend_text_02")
	i18n(self.isSuccess and "hero_comprehend_text_06" or "hero_comprehend_text_02").name = i18n(self.heroExInfo.herName)
	self.fields.Panel_bg:setString(i18n("heroskill_title_02", i18n(self.isSuccess and "hero_comprehend_text_06" or "hero_comprehend_text_02")))
	self.fields.Com_Origin:setString(i18n(skillInfo.des))
	self.fields.Com_Now:setString(i18n(skillInfo.des))
	self.fields.Com_Origin:setIcon(skillInfo.icon)
	self.fields.Com_Now:setIcon(skillInfo.icon)
	self.fields.Com_Origin:initData(self.preBuff, nil, self.isCrit, heroltCtrl:getMaxBuffValue(data.skillID))
	if self.isSuccess then
		self.fields.Com_Now:initData(self.preBuff, self.afterBuff, self.isCrit, heroltCtrl:getMaxBuffValue(data.skillID))
	end
	heroltCtrl = self.isCrit
	self.isCrit.num = self.times
	self.fields.Button_awake:setString(i18n("common_text_4947", self.isCrit))
	self.fields.Button_awake:setCost(self.itemID, self.needNum)
	self.fields.Button_awake:setNumTotal(self.needNum, self.itemNum, "#FFFF00")
	self.isEnoughChip = self.itemNum >= self.needNum
	local rarity = heroltCtrl:getRarity(self.heroID)
	if (rarity == gHeroRarity.BLUE or rarity == gHeroRarity.PURPLE or rarity == gHeroRarity.ORANGE) and self.isSuccess and clientEventMgr.judgeIsOpen(gActivityTimeActivityID.HERO_AWAKE_ACTIVTY) then
		local isShowEffect = true
		local valueNow = self.afterBuff - self.preBuff
		if valueNow <= 0 then
			isShowEffect = false
		end
		if isShowEffect then
			_UPVALUE3_ = "#FFFF00"
			;("#FFFF00")[1] = ffa.delay(0.5)
			;("#FFFF00")[2] = ffa.callFunc(function()
				self:showInsightBonusEffect()
				self.imgScouring:setVisible(true)
			end)
			;("#FFFF00")[3] = ffa.delay(1.0)
			;("#FFFF00")[4] = ffa.callFunc(function()
				self.imgScouring:setVisible(false)
			end)
			;("#FFFF00")[5] = ffa.callFunc(function()
				self.imgScouring:setVisible(false)
			end)
			local seq = ffa.seq("#FFFF00")
			self:runAction(seq)
		end
	end
end
function HeroROSUskillStudyPopPanel:showInsightBonusEffect()
	self.fields.Effect_1:setVisible(true)
	self.effectScouring = self.fields.Effect_1:getEffect()
	SoraDResetEffectNode(self.effectScouring)
	self.effectScouring.action:gotoFrameAndPlay(0, 57, false)
end
function HeroROSUskillStudyPopPanel:btnAwakeClick(button, eventType)
	SoraDPlaySound()
	if self.isEnoughChip then
		if not IsArClient and self.afterBuff >= heroltCtrl:getMaxBuffValue(self.skillID) then
			SoraDShowMsgTip(i18n("skill_text_17"))
			return
		end
		local remake = function(isCheck)
			if isCheck ~= nil then
				GAME_HERO_REMAKE_SHOW = isCheck
			end
			SoraDShowLoading(self)
			SoraDPlaySound("uicontrol", 21)
			heroCtrl:remakeSkillReq(self.heroID, self.skillID, self.itemID, self.times)
		end
		remake()
	else
		SoraDShowMsgBox(i18n("heroskill_text_04"), i18n("common_text_054"), i18n("common_text_185"), function(eventType)
			if MSGBOX_CALLBACK_YES == eventType then
				_ENV = nil
				;(nil).itemID = self.itemID
				;(nil).needCount = self.needNum
				uiManager:show("newHeroGainChipMethodView", nil)
			end
		end)
	end
end
return HeroROSUskillStudyPopPanel

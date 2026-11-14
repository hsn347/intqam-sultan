local luckyBlessCtrl = SoraDGetCtrl("luckyBlessCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local expostulationLogic = include("expostulationLogic")
local constantRead = include("constantRead")
_ENV = "constantRead"
;("constantRead").default = 0
;("constantRead").bless = 1
local _ENV, ("constantRead").actived, statusDef = nil, 2, "constantRead"
_ENV = nil
;(nil).des = "alliance_beast_btn_08"
;(nil)[gLuckyBlessActivityEffectType.NONE], (nil).img = nil, "frame_xyzf_di.png"
_ENV = nil
;(nil).des = "daily_reward_name_05"
;(nil).img = "frame_xyzf_jzjz.png"
;(nil)[gLuckyBlessActivityEffectType.BUILD_UPGRADE], (nil).tip = nil, "daily_reward_name_05"
_ENV = nil
;(nil).des = "common_text_2275"
;(nil).img = "frame_xyzf_yfkj.png"
;(nil)[gLuckyBlessActivityEffectType.TECHNOLOGY_RESEARCH], (nil).tip = nil, "daily_reward_name_06"
_ENV = nil
;(nil).des = "limitactivities_sectiontitle_03"
;(nil).img = "frame_xyzf_xlsb.png"
;(nil)[gLuckyBlessActivityEffectType.TRAIN_SOLDIERS], (nil).tip = nil, "epicbattle_btn_02"
_ENV = nil
;(nil).des = "daily_reward_name_20"
;(nil).img = "frame_xyzf_xhjs.png"
;(nil)[gLuckyBlessActivityEffectType.BUILD_STRENGTH], (nil).tip = nil, "daily_reward_name_20"
_ENV = nil
;(nil).des = "cat_common_05"
;(nil).img = "frame_xyzf_bzzc.png"
;(nil)[gLuckyBlessActivityEffectType.MAKE_A_WISH], (nil).tip = nil, "cat_common_05"
local desDef
local MAX_ACTIVATE_TIMES = 3
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001128_MainPanel = class("Activity_9001128_MainPanel", baseFguiPanel)
function Activity_9001128_MainPanel:ctor(...)
	Activity_9001128_MainPanel.super.ctor(self, ...)
	print("Activity_9001128_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.LUCKY_BLESSING_ACTIVITY
end
function Activity_9001128_MainPanel:onInit()
	print("=======Activity_9001128_MainPanel:onInit")
	self.status = statusDef.default
	self.effectType = gLuckyBlessActivityEffectType.NONE
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_leftTime:setString(i18n("lucky_text_15"))
	self.fields.Button_active:setString(i18n("common_btn_05"))
	self.fields.Button_active:addClickListener(handler(self, self.btnActiveClick))
	self.fields.Button_free:setString(i18n("lucky_btn_02"))
	self.fields.Button_free:addClickListener(handler(self, self.btnBlessClick))
	self.fields.Button_bless:setString(i18n("lucky_btn_01"))
	self.fields.Button_bless:addClickListener(handler(self, self.btnBlessClick))
	self.Text_timer = SoraDCreateTimerLabel(self, self.fields.Text_timer)
	self.fields.Particle_1:setAutoCull(false)
	self.fields.Particle_2:setAutoCull(false)
	self.fields.Com_bless:fixPos()
	self.fields.Com_discount:fixPos()
	self.fields.Text_active_count:fixPos()
	self.fields.Text_bless_count:fixPos()
	self.fields.Button_active:fixPos()
	self.fields.Button_free:fixPos()
	self.fields.Button_bless:fixPos()
end
function Activity_9001128_MainPanel:onShow()
	print("=======Activity_9001128_MainPanel:onShow")
	self.blessNumCfg = require("app." .. LocalTblPath .. ".config_server.lucky_blessing_num")
	self.fields.Com_bless:setType(0)
	self.fields.Com_discount:setType(1)
	self:getMaxCount()
	self:initData()
end
function Activity_9001128_MainPanel:getMaxCount()
	self.maxDiscount, _ENV = nil, nil
	local config = require("app." .. LocalTblPath .. ".config_server.lucky_blessing_config")
	for i, v in ipairs(config) do
		if v.Highest == 1 then
			self.maxDiscount[v.type] = v.value / 10
		end
	end
end
function Activity_9001128_MainPanel:initData(target, data)
	SoraDCloseLoading(self)
	self.luckyData = luckyBlessCtrl:getLuckyData()
	local preData = luckyBlessCtrl:getCurBless()
	self.effectType = preData and preData.type or self.luckyData.curEffectType
	self.status = luckyBlessCtrl:getLuckyBlessStatus()
	self.controllers.c_status:setSelectedIndex(self.status)
	local desStr = i18n("lucky_text_03")
	if self.status == statusDef.actived then
		if self.effectType == gLuckyBlessActivityEffectType.MAKE_A_WISH then
			_ENV = nil
			;(nil).num = string.format("%d%%", self.luckyData.discount / 10)
			desStr = i18n("lucky_text_28", nil)
		else
			_ENV = nil
			;(nil).name = i18n(desDef[self.effectType].des)
			;(nil).num = string.format("%d%%", self.luckyData.discount / 10)
			desStr = i18n("lucky_text_04", nil)
		end
	end
	self.fields.Text_activityDes:setString(desStr)
	local isFlash = data and data.isFlash or false
	local oriEtype = data and data.oriEtype or nil
	self:setBottomNode()
	if isFlash and oriEtype then
		self:flashEffect()
	else
		self:setBlessNode()
		self:setDiscountNode()
	end
end
function Activity_9001128_MainPanel:setBlessNode()
	self.fields.Com_bless:setStatus(self.status)
	self.fields.Com_bless:setEffect(self.effectType)
	self.fields.Com_bless:setTitle(i18n(desDef[self.effectType].des))
	self.fields.Com_bless:setIcon(desDef[self.effectType].img)
end
function Activity_9001128_MainPanel:setDiscountNode()
	local preData = luckyBlessCtrl:getCurBless()
	local value = preData and preData.value / 10 or self.luckyData.discount / 10
	local discountStr = string.format("-%d%%", value)
	local titleStr = i18n("lucky_text_05")
	if self.effectType == gLuckyBlessActivityEffectType.MAKE_A_WISH then
		discountStr = string.format("+%d%%", value)
		luckyBlessCtrl = value
		value.num = string.format("+%d%%", value)
		titleStr = i18n("common_text_4858", value)
	elseif self.effectType == gLuckyBlessActivityEffectType.NONE then
		titleStr = i18n("lucky_text_05")
	else
		luckyBlessCtrl = value
		value.num = string.format("%d%%", value)
		titleStr = i18n("lucky_text_06", value)
	end
	self.fields.Com_discount:setStatus(self.status, discountStr)
	self.fields.Com_discount:setTitle(titleStr)
end
function Activity_9001128_MainPanel:setBottomNode()
	if self.status == statusDef.actived then
		local leftTime = activityShowCtrl:getRemainTime(self.activityID) or 0
		local realTime = math.min(leftTime, self.luckyData.curEffectEndTime - serviceFunctions.systemTime())
		self.Text_timer:beginTime(math.max(0, realTime))
		self.Text_timer:setTimeEndListener(function()
			self:initData()
		end)
		self.fields.Text_tip:setVisible(0 < self.luckyData.leftActivateCount)
		statusDef = math.max(0, realTime)
		math.max(0, realTime).num = self.luckyData.leftActivateCount
		self.fields.Text_tip:setString(i18n("lucky_text_16", math.max(0, realTime)))
	else
		local leftACount = self.luckyData.leftActivateCount
		local leftOCount = 0 < leftACount and self.luckyData.leftOpenCount or 0
		statusDef = i18n("lucky_text_16", math.max(0, realTime))
		i18n("lucky_text_16", math.max(0, realTime)).num = leftACount
		self.fields.Text_active_count:setString(i18n("lucky_text_09", i18n("lucky_text_16", math.max(0, realTime))))
		statusDef = i18n("lucky_text_09", i18n("lucky_text_16", math.max(0, realTime)))
		i18n("lucky_text_09", i18n("lucky_text_16", math.max(0, realTime))).num = leftOCount
		self.fields.Text_bless_count:setString(i18n("lucky_text_24", i18n("lucky_text_09", i18n("lucky_text_16", math.max(0, realTime)))))
		self.fields.Button_active:setEnabled(self.status == statusDef.bless and 0 < leftACount)
		if leftOCount == #self.blessNumCfg then
			self.fields.Button_free:setVisible(true)
			self.fields.Button_bless:setVisible(false)
			self.fields.Button_free:setEnabled(true)
			self.fields.Button_free:setString(i18n("lucky_btn_02"))
		elseif leftOCount == 0 then
			self.fields.Button_free:setVisible(true)
			self.fields.Button_bless:setVisible(false)
			self.fields.Button_free:setEnabled(false)
			self.fields.Button_free:setString(i18n("lucky_btn_01"))
		else
			self.fields.Button_free:setVisible(false)
			self.fields.Button_bless:setVisible(true)
			self.fields.Button_bless:setCostNum(self.luckyData.costGold)
			self.fields.Button_bless:setIsEnough(SoraDEnoughGold(self.luckyData.costGold, true))
		end
	end
end
function Activity_9001128_MainPanel:flashEffect()
	self.fields.Com_bless:playFlash(handler(self, self.setBlessNode))
	self.fields.Com_discount:playFlash(handler(self, self.setDiscountNode))
end
function Activity_9001128_MainPanel:checkShowBlessTips()
	if self.luckyData.leftOpenCount == #self.blessNumCfg - 1 then
		_ENV = nil
		;(nil).byUID = true
		local clickTime = SoraDConfigGet("Game:eventLuckyBlessView:checkShowBlessTips~integer", nil) or 0
		if clickTime == 0 or not serviceFunctions.isSameDay(clickTime) then
			return true
		end
		return false
	end
	return false
end
function Activity_9001128_MainPanel:btnBlessClick()
	SoraDPlaySound()
	local openBless = function()
		SoraDShowLoading(self)
		luckyBlessCtrl:sendOpenReq()
	end
	if SoraDEnoughGold(self.luckyData.costGold) then
		if self:checkShowBlessTips() then
			_ENV = nil
			;(nil).content = i18n("common_text_4426")
			;(nil).confirmString = i18n("common_text_054")
			;(nil).confirmFunc = function()
				_ENV = nil
				;(nil).byUID = true
				SoraDConfigSet("Game:eventLuckyBlessView:checkShowBlessTips~integer", serviceFunctions.systemTime(), nil)
				openBless()
			end
			uiManager:show("MessageBox", nil)
		else
			local preData = luckyBlessCtrl:getCurBless()
			local value = preData and preData.value / 10 or self.luckyData.discount / 10
			if self.maxDiscount[self.effectType] == value then
				_ENV = "common_text_054"
				_ENV = nil
				;(nil).blessing = i18n(desDef[self.effectType].tip)
				;("common_text_054").content = i18n("shop_text_09", nil)
				;("common_text_054").confirmString = i18n("common_text_054")
				;("common_text_054").confirmFunc = function()
					openBless()
				end
				uiManager:show("MessageBox", "common_text_054")
			else
				openBless()
			end
		end
	end
end
function Activity_9001128_MainPanel:btnActiveClick()
	SoraDPlaySound()
	local preData = luckyBlessCtrl:getCurBless()
	local value = preData and preData.value / 10 or self.luckyData.discount / 10
	local leftTime = activityShowCtrl:getRemainTime(self.activityID) or 0
	local lang = leftTime < 3600 and "lucky_text_10" or "lucky_text_11"
	if self.effectType == gLuckyBlessActivityEffectType.MAKE_A_WISH then
		lang = leftTime < 3600 and "lucky_text_30" or "lucky_text_32"
	end
	_ENV = nil
	_ENV = nil
	;(nil).name = i18n(desDef[self.effectType].des)
	;(nil).num = string.format("%d%%", value)
	;(nil).content = i18n(lang, nil)
	;(nil).confirmFunc = function()
		SoraDShowLoading(self)
		luckyBlessCtrl:sendActivateReq()
	end
	uiManager:show("MessageBox", nil)
end
function Activity_9001128_MainPanel:onClickHelp()
	SoraDPlaySound()
	uiManager:show("Activity_9001128_Help")
end
return Activity_9001128_MainPanel

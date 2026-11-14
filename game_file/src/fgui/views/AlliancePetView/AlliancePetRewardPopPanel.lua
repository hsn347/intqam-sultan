local gametop = gModuleMgr.getObject("gametop")
local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local allianceDesRead = include("allianceDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AlliancePetRewardPopPanel = class("AlliancePetRewardPopPanel", baseFguiPanel)
function AlliancePetRewardPopPanel:ctor(...)
	AlliancePetRewardPopPanel.super.ctor(self, ...)
	print("AlliancePetRewardPopPanel:ctor", self.viewName)
end
function AlliancePetRewardPopPanel:onInit()
	print("=======AlliancePetRewardPopPanel:onInit")
	self.fields.Panel_bg:setString(i18n("alliance_beast_btn_04"))
	self.Text_lv = self.fields.Text_lv
	self.Text_des_1 = self.fields.Text_des_1
	self.Text_des_2 = self.fields.Text_des_2
	self.Text_des_1:setString(i18n("alliance_beast_text_17"))
	self.Button_pre = self.fields.Button_pre
	self.Button_pre:addClickListener(function()
		self.curShowLv = self.curShowLv - 1
		if self.curShowLv < self.minTrailLv then
			self.curShowLv = self.maxTrailLv
		end
		self:initData()
	end)
	self.Button_next = self.fields.Button_next
	self.Button_next:addClickListener(function()
		self.curShowLv = self.curShowLv + 1
		if self.curShowLv > self.maxTrailLv then
			self.curShowLv = self.minTrailLv
		end
		self:initData()
	end)
	self.Button_trial = self.fields.Button_trial
	self.Button_trial:setTitleText(i18n("alliance_beast_btn_03"))
	self.Button_trial:addClickListener(handler(self, self.btnTrialCallback))
end
function AlliancePetRewardPopPanel:onShow()
	print("=======AlliancePetRewardPopPanel:onShow")
	local petType = self.param and self.param.petType
	if petType then
		self:setRewardInfo(petType)
	end
end
function AlliancePetRewardPopPanel:initData()
	self:checkBtnState()
	_ENV = nil
	;(nil).lv = self.curShowLv
	self.Text_lv:setString(string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", nil)))
	local alliancePetRead = include("alliancePetRead")
	if not alliancePetRead.getRewards(self.petType, self.curShowLv) then
		local _ENV, rewards = alliancePetRead.getRewards(self.petType, self.curShowLv), alliancePetRead.getRewards(self.petType, self.curShowLv)
	end
	local _ENV, rewardsList = self.petType, self.petType
	if IsArClient then
		_UPVALUE2_ = string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", nil))
		string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", nil))[1] = "id"
		string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", nil))[2] = "count"
		rewardsList = serviceFunctions.tableFormat(rewards, string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", nil)))
	else
		_UPVALUE3_ = string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", nil))
		string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", nil))[1] = "id"
		string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", nil))[2] = "count"
		string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", nil))[3] = "weight"
		rewardsList = serviceFunctions.tableFormat(rewards, string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", nil)))
	end
	self.fields.List:setItemRenderer(function(index, obj)
		local item = rewardsList[index + 1]
		obj:initData(item.id, item.count)
	end)
	self.fields.List:setNumItems(#rewardsList)
	self.Text_des_2:setString(alliancePetRead.getWishDesByType(self.petType, self.curShowLv))
	if self.curLv == self.maxTrailLv then
		self.Button_pre:setVisible(false)
		self.Button_next:setVisible(false)
	end
end
function AlliancePetRewardPopPanel:checkBtnState()
	self.curLv = alliancePetCtrl:getAlliancePetLv()
	if self.curLv < self.curShowLv then
		self.Button_trial:setBright(false)
		return false
	else
		self.Button_trial:setBright(true)
		return true
	end
end
function AlliancePetRewardPopPanel:btnTrialCallback()
	local checkTrialBeginCond = function()
		if not self:checkBtnState() then
			self = nil
			;(nil).Lvl = self.curShowLv
			SoraDShowMsgTip(i18n("alliance_beast_notice_05", nil))
			return false
		end
		if not permissionCtrl:hasPlayerPermission(gAPermission.ALLIANCE_PET_TRIAL) then
			SoraDShowMsgTip(i18n("notice_0073"))
			return false
		end
		return true
	end
	if not checkTrialBeginCond() then
		return
	end
	SoraDShowMsgBox(i18n("alliance_beast_notice_06"), i18n("common_text_204"), i18n("common_text_185"), function(type)
		if type == MSGBOX_CALLBACK_YES then
			if not checkTrialBeginCond() then
				return
			end
			alliancePetCtrl:sendReqTrial()
		end
	end)
end
function AlliancePetRewardPopPanel:setRewardInfo(petType)
	self.petType = petType
	local alliancePetRead = include("alliancePetRead")
	self.maxTrailLv = alliancePetRead.getMaxTrailLevel(self.petType)
	self.minTrailLv = alliancePetRead.getMinTrailLevel(self.petType)
	self.curLv = alliancePetCtrl:getAlliancePetLv()
	self.curShowLv = math.max(self.curLv, self.minTrailLv)
	self.minTrailLv = self.curShowLv
	self:initData()
end
return AlliancePetRewardPopPanel

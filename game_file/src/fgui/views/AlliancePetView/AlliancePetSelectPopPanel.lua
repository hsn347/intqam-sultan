local alliancePetCtrl = SoraDGetCtrl("alliancePetCtrl")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local alliancePetRead = include("alliancePetRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AlliancePetSelectPopPanel = class("AlliancePetSelectPopPanel", baseFguiPanel)
function AlliancePetSelectPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AlliancePetSelectPopPanel:ctor", self.viewName)
	self.state = gAlliancePetCallState.UNLOCKED
end
function AlliancePetSelectPopPanel:onInit()
	print("=======AlliancePetSelectPopPanel:onInit")
	self.fields.Text_cond1:setString(i18n("alliance_beast_text_05"))
	self.fields.Text_cond2:setString(i18n("alliance_beast_text_06"))
	self.fields.Button_call:addClickListener(handler(self, self.btnClickCallback))
	if not SoraDFIsRA() then
		_UPVALUE6_ = SoraDFIsRA()
		SoraDFIsRA()[1] = "Com_petHead"
		SoraDFIsRA()[2] = "Text_des_1"
		SoraDFIsRA()[3] = "Text_des_2"
		SoraDFIsRA()[4] = "Text_des_3"
		SoraDFIsRA()[5] = "Text_gold"
		local SoraDFIsRA()[6], tempList = "Sprite_gold", SoraDFIsRA()
		for __, widgetName in ipairs(tempList) do
			local widget = self.fields[widgetName]
			if widget then
				widget:fixPos()
			end
		end
	end
end
function AlliancePetSelectPopPanel:onShow()
	print("=======AlliancePetSelectPopPanel:onShow")
	local petInfo = self.param and self.param.petInfo
	if petInfo then
		self:setPetInfo(petInfo)
	end
end
function AlliancePetSelectPopPanel:initData()
	self:refreshState()
	self.petName = alliancePetRead.getName(self.petType)
	self.fields.Panel_bg:setString(self.petName)
	self.fields.Com_petHead:setIcon(alliancePetRead.getIcon(self.petType))
	local maxLv = alliancePetRead.getMaxLevel(self.petType)
	alliancePetRead = alliancePetRead.getIcon(self.petType)
	alliancePetRead.getIcon(self.petType).lv = maxLv
	self.fields.Text_des_1:setString(i18n("alliance_beast_text_03") .. i18n("common_text_100", alliancePetRead.getIcon(self.petType)))
	self.fields.Text_des_2:setString(i18n("common_text_097") .. string.formatnumberthousands(alliancePetRead.getMaxSword(self.petType)))
	self.fields.Text_des_3:setString(i18n("alliance_beast_text_04") .. alliancePetRead.getWishDesByType(self.petType, maxLv))
	alliancePetRead = alliancePetRead.getMaxSword(self.petType)
	alliancePetRead.getMaxSword(self.petType).lv = alliancePetRead.getCallFreeCond(self.petType)
	self.fields.Text_cond1_value:setString(string.format("%s%s", i18n("alliance_beast_text_07"), i18n("common_text_100", alliancePetRead.getMaxSword(self.petType))))
	self.needGold = alliancePetRead.getCallGoldCond(self.petType)
	self.fields.Text_gold:setString(string.formatnumberthousands(self.needGold))
end
function AlliancePetSelectPopPanel:refreshState()
	if self.state == gAlliancePetCallState.UNLOCKED then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Button_call:setTitleText(i18n("alliance_beast_btn_01"))
	elseif self.state == gAlliancePetCallState.LOCKED then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Button_call:setTitleText(i18n("alliance_beast_btn_02"))
	end
end
function AlliancePetSelectPopPanel:btnClickCallback()
	SoraDPlaySound()
	local callTimeCD = alliancePetCtrl:getAlliancePetCallTimeCD()
	if 0 < callTimeCD then
		_ENV = nil
		;(nil).time = SoraDConvertSecondToString(callTimeCD)
		SoraDShowMsgTip(i18n("alliance_beast_text_02", nil))
		return
	end
	if not permissionCtrl:hasPlayerPermission(gAPermission.ALLIANCE_PET_CALL) then
		SoraDShowMsgTip(i18n("notice_0073"))
		return
	end
	if self.state == gAlliancePetCallState.UNLOCKED then
		local freeLv = alliancePetRead.getCallFreeCond(self.petType)
		if not alliancePetRead.checkScienceTotalLv(freeLv, true) then
			return
		end
		SoraDShowLoading(self:displayObject(), nil, nil, nil, 15)
		alliancePetCtrl:sendReqCallPet(self.petType, false)
	elseif self.state == gAlliancePetCallState.LOCKED then
		local checkGoldCallCond = function()
			if not permissionCtrl:hasPlayerPermission(gAPermission.ALLIANCE_PET_CALL) then
				SoraDShowMsgTip(i18n("notice_0073"))
				return false
			end
			local freeLv = alliancePetRead.getCallFreeCond(self.petType)
			if alliancePetRead.checkScienceTotalLv(freeLv) then
				SoraDShowMsgTip(i18n("notice_0026"))
				self.state = gAlliancePetCallState.UNLOCKED
				self:refreshState()
				return false
			end
			if not SoraDEnoughGold(self.needGold) then
				return false
			end
			return true
		end
		if not checkGoldCallCond() then
			return
		end
		_ENV = false
		;(false).Num = self.needGold
		;(false).PetName = self.petName
		SoraDShowMsgBox(i18n("alliance_beast_notice_02", false), i18n("common_text_204"), i18n("common_text_185"), function(type)
			if type == MSGBOX_CALLBACK_YES then
				if not checkGoldCallCond() then
					return
				end
				SoraDShowLoading(self:displayObject(), nil, nil, nil, 15)
				alliancePetCtrl:sendReqCallPet(self.petType, true)
			end
		end)
	end
end
function AlliancePetSelectPopPanel:setPetInfo(data)
	self.state = data.state
	self.petType = data.petType
	self:initData()
end
return AlliancePetSelectPopPanel

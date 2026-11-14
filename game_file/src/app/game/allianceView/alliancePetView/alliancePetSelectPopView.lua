local gametop = gModuleMgr.getObject("gametop")
local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local alliancePetRead = include("alliancePetRead")
local allianceDesRead = include("allianceDesRead")
local alliancePetSelectPopView = class("alliancePetSelectPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("alliancePetSelectPopView")
	end
	return target
end)
function alliancePetSelectPopView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.state = 1
	self:initWidget()
end
function alliancePetSelectPopView:initWidget()
	self.commonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.Image_petHead = SoraDGetChildByName(self, "Image_petHead")
	self.Text_des_1 = SoraDGetChildByName(self, "Text_des_1")
	self.Text_des_2 = SoraDGetChildByName(self, "Text_des_2")
	self.Text_des_3 = SoraDGetChildByName(self, "Text_des_3")
	SoraDSetTextWidthHeight(self.Text_des_3, cc.size(280, 60))
	self.Text_cond1 = SoraDGetChildByName(self, "Text_cond1")
	self.Text_cond1:setString(i18n("alliance_beast_text_05"))
	self.Text_cond1_value = SoraDGetChildByName(self, "Text_cond1_value")
	self.Image_cond2_bg = SoraDGetChildByName(self, "Image_cond2_bg")
	self.Text_cond2 = SoraDGetChildByName(self, "Text_cond2")
	self.Text_cond2:setString(i18n("alliance_beast_text_06"))
	self.Sprite_gold = SoraDGetChildByName(self, "Sprite_gold")
	self.Text_gold = SoraDGetChildByName(self, "Text_gold")
	self.Button_call = SoraDGetChildByName(self, "Button_call")
	self.Button_call:addTouchEventListener(handler(self, self.btnClickCallback))
end
function alliancePetSelectPopView:initData()
	self:refreshState()
	self.petName = alliancePetRead.getName(self.petType)
	self.commonPopBox:setTitleName(self.petName)
	self.Image_petHead:loadTexture(alliancePetRead.getIcon(self.petType), ccui.TextureResType.plistType)
	local maxLv = alliancePetRead.getMaxLevel(self.petType)
	alliancePetRead = nil
	;(nil).lv = maxLv
	self.Text_des_1:setString(i18n("alliance_beast_text_03") .. i18n("common_text_100", nil))
	self.Text_des_2:setString(i18n("common_text_097") .. tostring(alliancePetRead.getMaxSword(self.petType)))
	self.Text_des_3:setString(i18n("alliance_beast_text_04") .. alliancePetRead.getWishDesByType(self.petType, maxLv))
	alliancePetRead = alliancePetRead.getMaxSword(self.petType)
	alliancePetRead.getMaxSword(self.petType).lv = alliancePetRead.getCallFreeCond(self.petType)
	self.Text_cond1_value:setString(string.format("%s%s", i18n("alliance_beast_text_07"), i18n("common_text_100", alliancePetRead.getMaxSword(self.petType))))
	self.needGold = alliancePetRead.getCallGoldCond(self.petType)
	self.Text_gold:setString(tostring(self.needGold))
end
function alliancePetSelectPopView:refreshState()
	if self.state == gAlliancePetCallState.UNLOCKED then
		self.Text_cond1_value:setColor(cc.c3b(230, 180, 110))
		self.Text_cond2:setColor(cc.c3b(120, 120, 120))
		self.Button_call:setTitleText(i18n("alliance_beast_btn_01"))
		_UPVALUE1_ = self.Button_call
		self.Button_call[1] = self.Sprite_gold
		SoraDSetArrayGray(self.Button_call, true)
		self.Image_cond2_bg:setColor(cc.c3b(0, 0, 0))
	elseif self.state == gAlliancePetCallState.LOCKED then
		self.Text_cond1_value:setColor(cc.c3b(190, 40, 40))
		self.Text_cond2:setColor(cc.c3b(250, 200, 100))
		self.Button_call:setTitleText(i18n("alliance_beast_btn_02"))
		_UPVALUE1_ = self.Button_call
		self.Button_call[1] = self.Sprite_gold
		SoraDSetArrayGray(self.Button_call, false)
		self.Image_cond2_bg:setColor(cc.c3b(255, 255, 255))
	end
end
function alliancePetSelectPopView:btnClickCallback(buttton, type)
	if type ~= ccui.TouchEventType.ended then
		return
	end
	local callTimeCD = alliancePetCtrl:getAlliancePetCallTimeCD()
	if 0 < callTimeCD then
		_ENV = nil
		;(nil).time = SoraDConvertSecondToString(callTimeCD)
		SoraDShowMsgTip(i18n("alliance_beast_text_02", nil))
		return
	end
	local callTimeCD = alliancePetCtrl:getAlliancePetCallTimeCD()
	if 0 < callTimeCD then
		_ENV = i18n("alliance_beast_text_02", nil)
		i18n("alliance_beast_text_02", nil).time = SoraDConvertSecondToString(callTimeCD)
		SoraDShowMsgTip(i18n("alliance_beast_text_02", i18n("alliance_beast_text_02", nil)))
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
		SoraDShowLoading(self, nil, nil, nil, 15)
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
				SoraDShowLoading(self, nil, nil, nil, 15)
				alliancePetCtrl:sendReqCallPet(self.petType, true)
			end
		end)
	end
end
function alliancePetSelectPopView:setPetInfo(data)
	self.state = data.state
	self.petType = data.petType
	self:initData()
end
return alliancePetSelectPopView

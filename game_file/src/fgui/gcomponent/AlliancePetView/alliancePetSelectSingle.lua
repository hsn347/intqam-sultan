local alliancePetRead = include("alliancePetRead")
local baseComponent = require("fgui.base.baseComponent")
local alliancePetSelectSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AlliancePetView/alliancePetSelectSingle", alliancePetSelectSingle)
function alliancePetSelectSingle:onInit()
	self.fields.Button_call:addClickListener(handler(self, self.onClickBtnCall))
	self.fields.Text_wait:setString(i18n("common_text_1036"))
	self.fields.Panel_click:addClickListener(handler(self, self.onClickPanelClick))
	local nodeFireL = SoraDGetCommonJetFireNode(true)
	nodeFireL:setPosition(30, 180)
	nodeFireL:addTo(self.fields.frame_lmss1_left)
	local nodeFireR = SoraDGetCommonJetFireNode(true)
	nodeFireR:setPosition(30, 180)
	nodeFireR:addTo(self.fields.frame_lmss1_right)
end
function alliancePetSelectSingle:onShow()
end
function alliancePetSelectSingle:onClickBtnCall(...)
	SoraDPlaySound()
	self:openPetSelectPopView()
end
function alliancePetSelectSingle:onClickPanelClick(...)
	if gAlliancePetCallState.UNKNOW == self.petState then
		return
	else
		SoraDPlaySound()
		self:openPetSelectPopView()
	end
end
function alliancePetSelectSingle:openPetSelectPopView(...)
	self:updatePetState()
	_ENV = self.updatePetState
	self.updatePetState.state = self.petState
	local self.updatePetState.petType, petInfo = self.petType, self.updatePetState
	_ENV = nil
	;(nil).petInfo = petInfo
	uiManager:show("AlliancePetSelectPop", nil)
end
function alliancePetSelectSingle:initPetType(petType)
	self.petType = petType
	self:updatePetState()
	if gAlliancePetCallState.UNLOCKED == self.petState then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Button_call:setTitleText(i18n("alliance_beast_btn_01"))
	elseif gAlliancePetCallState.LOCKED == self.petState then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Button_call:setTitleText(i18n("alliance_beast_btn_02"))
	elseif gAlliancePetCallState.UNKNOW == self.petState then
		self.controllers.c1:setSelectedIndex(2)
	end
	if gAlliancePetCallState.UNKNOW ~= self.petState then
		self.fields.Sprite_petSingle:setURL(alliancePetRead.getPicture(self.petType))
	end
end
function alliancePetSelectSingle:updatePetState(...)
	if self.petType == 9999 then
		self.petState = gAlliancePetCallState.UNKNOW
	else
		local freeLv = alliancePetRead.getCallFreeCond(self.petType)
		if alliancePetRead.checkScienceTotalLv(freeLv) then
			self.petState = gAlliancePetCallState.UNLOCKED
		else
			self.petState = gAlliancePetCallState.LOCKED
		end
	end
end
return alliancePetSelectSingle

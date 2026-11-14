local gametop = gModuleMgr.getObject("gametop")
local allianceOfficialSingle = class("allianceOfficialSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceOfficialSingle")
	end
	return target
end)
function allianceOfficialSingle:ctor()
	self.Image_official = SoraDGetChildByName(self, "Image_official")
	self.Text_officialName = SoraDGetChildByName(self, "Text_officialName")
	self.Node_have = SoraDGetChildByName(self, "Node_have")
	self.Node_have:setVisible(false)
	self.Image_flg = SoraDGetChildByName(self.Node_have, "Image_flg")
	self.Image_portrait = SoraDGetChildByName(self.Node_have, "Image_portrait")
	self.Text_online = SoraDGetChildByName(self.Node_have, "Text_online")
	self.Text_lastTime = SoraDGetChildByName(self.Node_have, "Text_lastTime")
	self.Text_powerLab = SoraDGetChildByName(self.Node_have, "Text_powerLab")
	self.Text_powerLab:setString(i18n("common_text_090"))
	self.Text_power = SoraDGetChildByName(self.Node_have, "Text_power")
	self.Text_castleLv = SoraDGetChildByName(self.Node_have, "Text_castleLv")
	self.Sprite_castle = SoraDGetChildByName(self.Node_have, "Sprite_castle")
	self.Text_name = SoraDGetChildByName(self.Node_have, "Text_name")
	self.Node_none = SoraDGetChildByName(self, "Node_none")
	self.Node_none:setVisible(false)
	self.Text_none = SoraDGetChildByName(self.Node_none, "Text_none")
	self.Text_none:setString(i18n("alliance_office_text_15"))
	self.Text_applyed = SoraDGetChildByName(self.Node_none, "Text_applyed")
	self.Text_applyed:setString(i18n("alliance_office_btn_02"))
	self.Button_apply = SoraDGetChildByName(self.Node_none, "Button_apply")
	self.Button_apply:addTouchEventListener(handler(self, self.onClickBtnApply))
end
function allianceOfficialSingle:initData(data)
end
function allianceOfficialSingle:onClickBtnApply()
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("申请点击=======")
	end
end
return allianceOfficialSingle

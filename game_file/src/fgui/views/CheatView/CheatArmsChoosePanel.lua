local equipDesRead = include("equipDesRead")
local artifactRuneRead = include("artifactRuneRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatArmsChoosePanel = class("CheatArmsChoosePanel", baseFguiPanel)
function CheatArmsChoosePanel:ctor(...)
	self.isLRU = true
	CheatArmsChoosePanel.super.ctor(self, ...)
	print("CheatArmsChoosePanel:ctor", self.viewName)
end
function CheatArmsChoosePanel:onInit()
	print("=======CheatArmsChoosePanel:onInit")
	self.fields.Panel_bg:setString("选择出征神器")
	self.fields.Text_name:setString("神器名")
	self.fields.Text_id:setString("神器ID")
	self.fields.Text_arms:setString("神器")
	self.fields.List:setItemRenderer(handler(self, self.onArmsRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseArms))
	self.fields.Btn_ok:setString(i18n("common_text_204"))
	self.fields.Btn_ok:addClickListener(handler(self, self.btnClick))
end
function CheatArmsChoosePanel:onArmsRenderer(index, obj)
	local cfg = self.armsList[index + 1]
	obj:getChild("Text_ID"):setString(cfg.weaponID)
	obj:getChild("Text_name"):setString(equipDesRead.getArtifactName(cfg.weaponID))
	obj:getChild("icon"):setSpriteFrame(equipDesRead.getArtifactIcon(cfg.weaponID))
	obj:getChild("Text_tip"):setString("无战纹配置")
	obj:getChild("Text_tip"):setVisible(not self.holeMap[cfg.weaponID])
end
function CheatArmsChoosePanel:onChooseArms()
	SoraDPlaySound()
	self.selIndex = self.fields.List:getSelectedIndex() + 1
	self.fields.Btn_ok:setEnabled(true)
end
function CheatArmsChoosePanel:endShow()
	print("=======CheatArmsChoosePanel:endShow")
	self.selIndex = nil
	self.armsList = equipDesRead.getArtifactInfo()
	self.holeMap = artifactRuneRead.getHoleMap()
	self.fields.List:SelectNone()
	self.fields.List:setNumItems(#self.armsList)
	self.fields.Btn_ok:setEnabled(false)
end
function CheatArmsChoosePanel:btnClick()
	SoraDPlaySound()
	if self.selIndex then
		_ENV = nil
		;(nil).msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_ARMS"
		;(nil).armsID = self.armsList[self.selIndex].weaponID
		SoraDSendMessage(nil)
	end
	self:close()
end
return CheatArmsChoosePanel

local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_flag = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceManageView/Com_flag", Com_flag)
function Com_flag:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Com_flag:onShow()
end
function Com_flag:initData(flagID, selectFlag)
	self.flagID = flagID
	self.selectFlag = selectFlag
	if self.flagID > 0 then
		self:setVisible(true)
		self.fields.select:setVisible(self.flagID == self.selectFlag)
		self.fields.Node_flag:clearContent()
		local flagNode = allianceDesRead.getFlagNode(self.flagID)
		flagNode:setScale(0.5)
		flagNode:setPosition(5, 5)
		self.fields.Node_flag:setContent(flagNode)
	else
		self:setVisible(false)
	end
end
function Com_flag:btnClick()
	SoraDPlaySound()
	if self.flagID > 0 and self.flagID ~= self.selectFlag then
		_ENV = self.selectFlag
		self.selectFlag.msg = "MESSAGE_ALLIANCE_UI_FLAG_SELECT"
		self.selectFlag.flagID = self.flagID
		SoraDSendMessage(self.selectFlag)
	end
end
return Com_flag

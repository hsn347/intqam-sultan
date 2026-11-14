local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceSetting = SoraDGetCtrl("allianceSetting")
local baseComponent = require("fgui.base.baseComponent")
local changeSloganNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceManageView/changeSloganNode", changeSloganNode)
function changeSloganNode:onInit()
	self.fields.Button_save:setString(i18n("common_text_195"))
	self.fields.Button_save:setEnabled(false)
	self.fields.Button_save:addClickListener(handler(self, self.btnClick))
	self.fields.TextField_edit:setMaxLength(200)
	self.fields.TextField_edit:addEventListener(fgui.UIEventType.Changed, handler(self, self.onChanged))
	self.fields.TextField_edit:setAlign(SoraDFLabelR())
end
function changeSloganNode:onShow()
end
function changeSloganNode:initData(tag)
	self.fields.TextField_edit:setText(allianceMgr:getAllianceProperty("notice"))
end
function changeSloganNode:onChanged()
	self.fields.Button_save:setEnabled(true)
end
function changeSloganNode:btnClick()
	SoraDPlaySound()
	self.fields.Button_save:setEnabled(false)
	allianceSetting:reqModifyNotice(self.fields.TextField_edit:getText())
end
return changeSloganNode

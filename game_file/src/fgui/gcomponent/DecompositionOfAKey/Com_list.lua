local equipDesRead = include("equipDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DecompositionOfAKey/Com_list", Com_list)
function Com_list:onInit()
	self.fields.Check_tick:addClickListener(handler(self, self.onTickClick))
	self:fixChildrenPos()
end
function Com_list:onShow()
end
function Com_list:initData(quality, qualityList)
	self.quality = quality
	self.fields.title:setString(equipDesRead.getQualityName(quality))
	self.fields.title:setColor(gQualityTextColorDef[quality])
	if qualityList[self.quality] then
		self.fields.Check_tick:setSelected(true)
	else
		self.fields.Check_tick:setSelected(false)
	end
end
function Com_list:onTickClick()
	SoraDPlaySound()
	local isSelected = self.fields.Check_tick:isSelected()
	if not isSelected then
		_ENV = nil
		;(nil).msg = "MESSAGE_UI_RESOLVE_SURE_CHOOSE"
		;(nil).quality = self.quality
		;(nil).isDel = true
		SoraDSendMessage(nil)
		return
	end
	self.fields.Check_tick:setSelected(false)
	if self.quality >= gQualityDef.PURPLE then
		_ENV = nil
		;(nil).quality = self.quality
		uiManager:show("OneKeyFactorizes", nil)
	else
		_ENV = uiManager
		uiManager.msg = "MESSAGE_UI_RESOLVE_SURE_CHOOSE"
		uiManager.quality = self.quality
		SoraDSendMessage(uiManager)
	end
end
return Com_list

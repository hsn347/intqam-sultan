local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_value = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://SmithyView/Com_value", Com_value)
function Com_value:onInit()
	self.fields.Btn_add:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function Com_value:onShow()
end
function Com_value:initData(materialID, curNum, needNum, handle)
	self.materialID = materialID
	self.handle = handle
	self.fields.icon:setIcon(publicRead.getIcon(self.materialID))
	if gIDDef.STEEL == self.materialID then
		if needNum then
			publicRead = publicRead.getIcon(self.materialID)
			publicRead.getIcon(self.materialID).var1 = fguiHelper.getColorString(curNum < needNum and "#BE2828" or "#F0E6D2", SoraDConvertNumberWithUnit(curNum))
			publicRead.getIcon(self.materialID).var2 = SoraDConvertNumberWithUnit(needNum)
			self.fields.title:setString(i18n("%{var1}/%{var2}", publicRead.getIcon(self.materialID)))
		else
			self.fields.title:setString(SoraDConvertNumberWithUnit(curNum))
		end
	elseif needNum then
		publicRead = SoraDConvertNumberWithUnit(curNum)
		SoraDConvertNumberWithUnit(curNum).var1 = fguiHelper.getColorString(curNum < needNum and "#BE2828" or "#F0E6D2", string.formatnumberthousands(curNum))
		SoraDConvertNumberWithUnit(curNum).var2 = string.formatnumberthousands(needNum)
		self.fields.title:setString(i18n("%{var1}/%{var2}", SoraDConvertNumberWithUnit(curNum)))
	else
		self.fields.title:setString(string.formatnumberthousands(curNum))
	end
end
function Com_value:btnClick()
	SoraDPlaySound()
	if self.handle then
		self.handle()
	else
		_ENV = nil
		;(nil).itemID = self.materialID
		uiManager:show("commonGetWayView", nil)
	end
end
return Com_value

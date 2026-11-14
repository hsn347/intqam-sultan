local basePanel = require("fgui.base.baseFguiPanel")
local test1Panel = class("test1Panel", basePanel)
function test1Panel:ctor(...)
	self.debug = true
	self.super.ctor(self, ...)
	print("test1Panel:ctor", self.viewName)
end
function basePanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "test"
	end
	return self._packageList
end
function test1Panel:onInit()
	print("=======test1Panel:onInit")
	self.dropdown = self.fields.ComboBox:getDropdown()
	self.fields.ComboBox:addEventListener(fgui.UIEventType.Changed, handler(self, self.onComboBoxChanged))
	self:addClickListener(handler(self, self.onClickSelf))
	self.fields.n13:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.n15:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.n16:setItemRenderer(handler(self, self.onItemRenderer))
end
function test1Panel:onItemRenderer(index, obj)
	obj:setString(tostring(index + 1))
end
function test1Panel:onClickSelf(context)
	local comboBox = self.fields.ComboBox
	local dropdown = comboBox:getDropdown()
	local touchTarget = self:getTouchTarget()
	print("=====", touchTarget:getName(), touchTarget, comboBox, dropdown, touchTarget:getParent(), touchTarget:getParent():getParent())
	print(self, self.view)
	if touchTarget ~= comboBox and touchTarget ~= dropdown and touchTarget:getParent() ~= dropdown and touchTarget:getParent():getParent() ~= dropdown then
		print("hideDropdown!!!!!!!!")
		comboBox:hideDropdown()
	end
	local comboBox = self.fields.n12
	local dropdown = comboBox:getDropdown()
	local touchTarget = self:getTouchTarget()
	print("=====", touchTarget:getName(), touchTarget, comboBox, dropdown, touchTarget:getParent(), touchTarget:getParent():getParent())
	print(self, self.view)
	if touchTarget ~= comboBox and touchTarget ~= dropdown and touchTarget:getParent() ~= dropdown and touchTarget:getParent():getParent() ~= dropdown then
		print("hideDropdown!!!!!!!!")
		comboBox:hideDropdown()
	end
end
function test1Panel:onComboBoxChanged()
	print("ComboBox:", self.fields.ComboBox:getSelectedIndex(), self.fields.ComboBox:getValue())
end
function test1Panel:onShow()
	print("=======test1Panel:onShow")
	_UPVALUE10_ = nil
	;(nil)[1] = "1"
	;(nil)[2] = "2"
	;(nil)[3] = "4"
	;(nil)[4] = "5"
	;(nil)[5] = "99"
	;(nil)[6] = "100"
	;(nil)[7] = "2"
	;(nil)[8] = "4"
	;(nil)[9] = "5"
	;(nil)[10] = "99"
	self.fields.ComboBox:setItems(nil)
	_UPVALUE10_ = nil
	;(nil)[1] = "987"
	;(nil)[2] = "2"
	;(nil)[3] = "4"
	;(nil)[4] = "5"
	;(nil)[5] = "99"
	;(nil)[6] = "100"
	;(nil)[7] = "2"
	;(nil)[8] = "4"
	;(nil)[9] = "5"
	;(nil)[10] = "99"
	self.fields.n12:setItems(nil)
	self.fields.n13:setNumItems(13)
	self.fields.n15:setNumItems(13)
	self.fields.n16:setNumItems(13)
	self.fields.Input:setPrompt("prompt")
	self.fields.Button_test:addClickListener(handler(self, self.onClickTest))
	self.edit = ccui.EditBox:create(cc.size(300, 60), "bg_transparent.png", ccui.TextureResType.plistType)
	self.edit:addTo(self:displayObject())
	self.edit:setPosition(300, 100)
	self.edit:setPlaceHolder("prompt")
end
function test1Panel:onClickTest()
	if string.len(self.fields.Input:getText()) > 0 then
		self.fields.Input:setString("")
	else
		self.fields.Input:setString("123")
	end
	if 0 < string.len(self.edit:getString()) then
		self.edit:setString("")
	else
		self.edit:setString("123")
	end
end
function test1Panel:onHide()
	print("=======test1Panel:onHide")
end
function test1Panel:onDispose()
	print("=======test1Panel:onDispose")
end
return test1Panel

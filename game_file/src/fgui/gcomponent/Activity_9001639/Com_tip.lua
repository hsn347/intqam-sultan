local activity_9001639_Ctrl = SoraDGetCtrl("activity_9001639_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_tip = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001639/Com_tip", Com_tip)
function Com_tip:onInit()
	self.index = 1
	self.lastIndex = 10
	self.actTime = 10
	self.pageTime = 0
	self.fields.Text_none:setString(i18n("datepalm_tree_text44"))
	self.fields.Text_none:setVisible(false)
	self.fields.Btn_tip:addClickListener(handler(self, self.btnClick))
	self.fields.List:setVirtualAndLoop()
	self.fields.List:setItemRenderer(handler(self, self.onPageItemRenderer))
	self:fixChildrenPos()
end
function Com_tip:onShow()
end
function Com_tip:onExit()
	Com_tip.super.onExit(self)
	if self.activeTimer then
		SoraDManagerRemoveTimer(self, self.activeTimer)
		self.activeTimer = nil
	end
end
function Com_tip:activeTimeUp()
	self.pageTime = self.pageTime + 1
	if self.pageTime >= self.actTime then
		self.pageTime = 0
		self.index = self.index + 1
		if self.index > self.lastIndex then
			self.index = 1
		end
		self.fields.List:scrollToView(self.index - 1, true)
	end
end
function Com_tip:onPageItemRenderer(index, obj)
	obj:initData(self.record[index + 1])
end
function Com_tip:initData()
	if not activity_9001639_Ctrl:getRecord() then
		activity_9001639_Ctrl = activity_9001639_Ctrl:getRecord()
	end
	self.record = activity_9001639_Ctrl:getRecord()
	self.fields.Text_none:setVisible(#self.record == 0)
	if #self.record > 0 then
		self:runActInfo()
	end
end
function Com_tip:runActInfo()
	if not self.activeTimer then
		self:activeTimeUp()
		self.activeTimer = SoradCreateTimer(self, handler(self, self.activeTimeUp))
	end
	self.lastIndex = math.min(#self.record, self.lastIndex)
	self.fields.List:setNumItems(self.lastIndex)
end
function Com_tip:btnClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001639_Record")
end
return Com_tip

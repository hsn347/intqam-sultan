local combinationCtrl = SoraDGetCtrl("combinationCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_List5 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_List5", Com_List5)
function Com_List5:onInit()
	self.fields.Button_select:addClickListener(handler(self, self.btnSelectCallBack))
	self.fields.Button_rename:addClickListener(handler(self, self.btnRenameCallBack))
end
function Com_List5:onShow()
end
function Com_List5:initData(index, ctype, rtype, handle, curIndex, parent)
	self.index = index
	self.ctype = ctype
	self.rtype = rtype
	self.handle = handle
	self.parent = parent
	local unlock = combinationCtrl:checkSetUnLock(ctype, index)
	self.controllers.c1:setSelectedIndex(unlock and 0 or 1)
	self.fields.Effect:setVisible(index == curIndex)
	self.fields.Text_name:setString(combinationCtrl:getSetName(ctype, index))
end
function Com_List5:btnSelectCallBack()
	SoraDPlaySound()
	if not combinationCtrl:checkSetUnLock(self.ctype, 4) and 4 <= self.index then
		SoraDShowMsgTip(i18n("common_text_4585"))
		return
	end
	if combinationCtrl:checkSetUnLock(self.ctype, self.index, true) then
		self.handle(self.index)
		if self.parent then
			self.parent:close()
		end
	end
end
function Com_List5:btnRenameCallBack()
	SoraDPlaySound()
	if combinationCtrl:checkSetUnLock(self.ctype, self.index, true) then
		_ENV = self.index
		self.index.setID = tostring(self.index)
		self.index.renameType = self.rtype
		uiManager:show("lordEquipRename", self.index)
	end
end
return Com_List5

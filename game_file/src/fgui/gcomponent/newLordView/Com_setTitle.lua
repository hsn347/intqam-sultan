local combinationCtrl = SoraDGetCtrl("combinationCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_setTitle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_setTitle", Com_setTitle)
function Com_setTitle:onInit()
	self.fields.Button_rename:addClickListener(handler(self, self.btnRenameCallBack))
	self.fields.Button_select:addClickListener(handler(self, self.btnSelectCallBack))
	self:fixChildrenPos()
end
function Com_setTitle:onShow()
end
function Com_setTitle:initData(param)
	self.setID = param.setID
	self.ctype = param.ctype
	self.renameType = param.rtype
	self.handle = param.handle
	self:setTitleName(combinationCtrl:getSetName(self.ctype, self.setID))
end
function Com_setTitle:setTitleName(title)
	self.fields.title:setString(title)
end
function Com_setTitle:btnRenameCallBack()
	SoraDPlaySound()
	if combinationCtrl:checkSetUnLock(self.ctype, self.setID, true) then
		_ENV = self.setID
		self.setID.setID = self.setID
		self.setID.renameType = self.renameType
		uiManager:show("lordEquipRename", self.setID)
	end
end
function Com_setTitle:btnSelectCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).setID = self.setID
	;(nil).ctype = self.ctype
	;(nil).rtype = self.renameType
	;(nil).handle = self.handle
	uiManager:show("setSelectPopView", nil)
end
return Com_setTitle

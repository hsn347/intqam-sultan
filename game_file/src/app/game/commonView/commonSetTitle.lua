local combinationCtrl = SoraDGetCtrl("combinationCtrl")
local commonSetTitle = class("commonSetTitle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonSetTitle")
	end
	return target
end)
function commonSetTitle:ctor()
	self:initWidget()
end
function commonSetTitle:initWidget()
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Button_select = SoraDGetChildByName(self, "Button_select")
	self.Button_select:addTouchEventListener(handler(self, self.btnSelectCallBack))
	self.Button_rename = SoraDGetChildByName(self, "Button_rename")
	self.Button_rename:addTouchEventListener(handler(self, self.btnRenameCallBack))
	if not SoraDFIsRA() then
		self.Image_15 = SoraDGetChildByName(self, "Image_15")
		self.Button_select:setAnchorPoint(cc.p(1.0 - self.Button_select:getAnchorPoint().x, self.Button_select:getAnchorPoint().y))
		_UPVALUE3_ = self.Button_select
		self.Button_select[1] = self.Button_rename
		self.Button_select[2] = self.Image_15
		self.Button_select[3] = self.Button_select
		for k, v in pairs(self.Button_select) do
			v:setPositionX(-v:getPositionX())
		end
	end
end
function commonSetTitle:initData(data)
	self.setID = data.setID
	self.ctype = data.ctype
	self.renameType = data.rtype
	self.handle = data.handle
	local title = combinationCtrl:getSetName(self.ctype, self.setID)
	self.Text_name:setString(title)
end
function commonSetTitle:btnSelectCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).setID = self.setID
		;(nil).ctype = self.ctype
		;(nil).rtype = self.renameType
		;(nil).handle = self.handle
		uiManager:show("setSelectPopView", nil)
	end
end
function commonSetTitle:btnRenameCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if combinationCtrl:checkSetUnLock(self.ctype, self.setID, true) then
			_ENV = self.setID
			self.setID.setID = self.setID
			self.setID.renameType = self.renameType
			uiManager:show("lordEquipRename", self.setID)
		end
	end
end
return commonSetTitle

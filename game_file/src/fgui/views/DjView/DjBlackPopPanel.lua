local djCtrl = SoraDGetCtrl("djCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DjBlackPopPanel = class("DjBlackPopPanel", baseFguiPanel)
function DjBlackPopPanel:ctor(...)
	self.isLRU = true
	DjBlackPopPanel.super.ctor(self, ...)
	print("DjBlackPopPanel:ctor", self.viewName)
end
function DjBlackPopPanel:onInit()
	print("=======DjBlackPopPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Anchor_text_117"))
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Button_save:addClickListener(handler(self, self.onClick_Button_save))
	self.fields.Button_move:addClickListener(handler(self, self.onClick_Button_move))
	self.fields.Text_tip:setString(i18n("Anchor_text_140"))
	self.fields.Text_enter:setString(i18n("Anchor_text_136"))
	self.fields.Text_chat:setString(i18n("Anchor_text_135"))
	self.fields.Text_speak:setString(i18n("Anchor_text_134"))
	self.fields.Button_save:fixPos()
	self.fields.Button_move:fixPos()
	self.fields.Text_enter:fixPos()
	self.fields.Text_chat:fixPos()
	self.fields.Text_speak:fixPos()
end
function DjBlackPopPanel:endShow()
	print("=======DjBlackPopPanel:endShow")
	self.model = 0
	self.controllers.c1:setSelectedIndex(self.model)
	self.fields.Button_save:setTitle(i18n("Anchor_text_139"))
	self.fields.Button_move:setTitle(i18n("Anchor_text_141"))
	djCtrl:reqGetUserBlackList()
	SoraDShowLoading(self)
end
function DjBlackPopPanel:initView(target, data)
	SoraDCloseLoading(self)
	if not djCtrl:getBlackList() then
		_ENV = djCtrl:getBlackList()
	end
	self.ListData = djCtrl:getBlackList()
	self.fields.List:setNumItems(#self.ListData)
end
function DjBlackPopPanel:itemRenderer_List(index, obj)
	local data = self.ListData[index + 1]
	obj:initData(data, self.model)
end
function DjBlackPopPanel:onClick_Button_save(context)
	SoraDPlaySound()
	if self.model == 1 then
		self.model = 0
		self.fields.Button_save:setTitle(i18n("Anchor_text_139"))
		self.controllers.c1:setSelectedIndex(self.model)
		self.fields.List:setNumItems(#self.ListData)
	else
		local _ENV, uInfoList = self.fields.List.setNumItems, self.fields.List.setNumItems
		for k, v in ipairs(self.fields.List:getChildren()) do
			local uid, permissionList = v:getPermissonCfg()
			_ENV = self.fields.List:getChildren()
			self.fields.List:getChildren().uid = uid
			self.fields.List:getChildren().permissionList = permissionList
			table.insert(uInfoList, self.fields.List:getChildren())
		end
		djCtrl:reqSetUsersBlack(uInfoList)
		self:close()
	end
end
function DjBlackPopPanel:onClick_Button_move(context)
	SoraDPlaySound()
	if self.model == 1 then
		_ENV = nil
		;(nil).content = i18n("Anchor_text_193")
		;(nil).confirmFunc = function()
			local _ENV, uInfoList
			for k, v in ipairs(self.fields.List:getChildren()) do
				local uid, isRemove = v:getRemoveCfg()
				if isRemove then
					_ENV = self.fields.List:getChildren()
					_UPVALUE3_, self.fields.List:getChildren().uid = self.fields.List:getChildren()
					self.fields.List:getChildren().permissionList, self.fields.List:getChildren()[1] = self.fields.List:getChildren()
					self.fields.List:getChildren().permissionList, self.fields.List:getChildren()[2] = self.fields.List:getChildren()
					self.fields.List:getChildren().permissionList, self.fields.List:getChildren()[3] = self.fields.List:getChildren()
					table.insert(uInfoList, self.fields.List:getChildren())
				end
			end
			djCtrl:reqSetUsersBlack(uInfoList)
			self:close()
		end
		;(nil).cancel = true
		uiManager:show("MessageBox", nil)
	else
		self.model = 1
		self.fields.Button_save:setTitle(i18n("Anchor_text_142"))
		self.controllers.c1:setSelectedIndex(self.model)
		self.fields.List:setNumItems(#self.ListData)
	end
end
return DjBlackPopPanel

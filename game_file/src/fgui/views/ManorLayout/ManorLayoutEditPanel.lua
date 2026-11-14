local manorCityUtil = include("manorCityUtil")
local manorLayoutCtrl = SoraDGetCtrl("manorLayoutCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorLayoutEditPanel = class("ManorLayoutEditPanel", baseFguiPanel)
function ManorLayoutEditPanel:ctor(...)
	self.isLRU = true
	ManorLayoutEditPanel.super.ctor(self, ...)
	print("ManorLayoutEditPanel:ctor", self.viewName)
end
function ManorLayoutEditPanel:onInit()
	print("=======ManorLayoutEditPanel:onInit")
	self.fields.Com_title:initData(i18n("Socialize_text_52"), handler(self, self.onClickClose))
	self.fields.Button_reset:setString(i18n("Socialize_text_44"))
	self.fields.Button_reset:addClickListener(handler(self, self.onClick_Button_reset))
	self.fields.Button_upload:setString(i18n("Socialize_text_53"))
	self.fields.Button_upload:addClickListener(handler(self, self.onClick_Button_upload))
	self.fields.Button_build:addClickListener(handler(self, self.onClick_Button_build))
	self.fields.Button_save:setString(i18n("Anchor_text_170"))
	self.fields.Button_save:addClickListener(handler(self, self.onClick_Button_save))
	self.fields.Text_delete:setString(i18n("Socialize_text_43"))
	self.fields.Check_tick:addClickListener(handler(self, self.onClickBtnDelete))
	self.fields.Button_move:addClickListener(handler(self, self.onClick_Button_move))
	self.fields.Button_moveUp:addClickListener(handler(self, self.onClick_Button_moveUp))
	self.fields.Button_moveDown:addClickListener(handler(self, self.onClick_Button_moveDown))
	self.fields.Button_moveLeft:addClickListener(handler(self, self.onClick_Button_moveLeft))
	self.fields.Button_moveRight:addClickListener(handler(self, self.onClick_Button_moveRight))
end
function ManorLayoutEditPanel:endShow()
	print("=======ManorLayoutEditPanel:endShow")
	self.index = self.param.index or -1
	self.fields.Com_map:initInLayoutEdit()
	local layoutData = manorLayoutCtrl:getLayoutData(self.index)
	if not layoutData.map then
		_ENV = layoutData.map
	end
	self.layoutMap = layoutData.map
	local gardenMap = manorCityUtil.createMapData(self.layoutMap)
	self.fields.Com_map:initMapData(gardenMap)
	self.isMoveModel = false
	self:updateMoveModel()
	self.isDeleteModel = false
	self:updateDeleteModel()
end
function ManorLayoutEditPanel:onClick_Button_reset(context)
	SoraDPlaySound()
	self:resetLayoutMap()
	_ENV = nil
	;(nil).content = i18n("Socialize_text_45")
	;(nil).cancel = true
	;(nil).confirmFunc = function()
		self.fields.Com_map:initScrollPane()
		self.fields.Com_map:clearMapData()
	end
	uiManager:show("MessageBox", nil)
end
function ManorLayoutEditPanel:onClick_Button_upload(context)
	SoraDPlaySound()
	self:resetLayoutMap()
	self:saveLayoutMap(true)
end
function ManorLayoutEditPanel:onClick_Button_save(context)
	SoraDPlaySound()
	self:resetLayoutMap()
	self:saveLayoutMap(false)
end
function ManorLayoutEditPanel:saveLayoutMap(isUpload)
	local gardenMap = self.fields.Com_map:getMapData()
	local layoutMap = manorCityUtil.gardenMap2LayoutMap(gardenMap)
	manorLayoutCtrl:reqSave(self.index, layoutMap, isUpload)
end
function ManorLayoutEditPanel:onClickBtnDelete(context)
	SoraDPlaySound()
	self:closeMoveModel()
	self.fields.Com_map:checkEndEdit()
	self.isDeleteModel = not self.isDeleteModel
	self:updateDeleteModel()
end
function ManorLayoutEditPanel:updateDeleteModel()
	self.fields.Check_tick:setSelected(self.isDeleteModel)
	self.fields.Com_map:setDeleteModel(self.isDeleteModel)
end
function ManorLayoutEditPanel:onClick_Button_build(context)
	SoraDPlaySound()
	self:resetLayoutMap()
	local gardenMap = self.fields.Com_map:getMapData()
	_ENV = nil
	;(nil).isInLayoutEdit = true
	;(nil).mapData = gardenMap
	uiManager:show("ManorCityBuildList", nil)
end
function ManorLayoutEditPanel:onClick_Button_move(context)
	SoraDPlaySound()
	self:closeDeleteModel()
	self.fields.Com_map:checkEndEdit()
	self.isMoveModel = not self.isMoveModel
	self:updateMoveModel()
end
function ManorLayoutEditPanel:updateMoveModel()
	self.fields.Com_map:setMoveModel(self.isMoveModel)
	self.fields.Button_moveUp:setVisible(self.isMoveModel)
	self.fields.Button_moveDown:setVisible(self.isMoveModel)
	self.fields.Button_moveLeft:setVisible(self.isMoveModel)
	self.fields.Button_moveRight:setVisible(self.isMoveModel)
	if self.isMoveModel then
		self.fields.Button_move:setString(i18n("common_text_185"))
	else
		self.fields.Button_move:setString(i18n("Socialize_text_31"))
	end
end
function ManorLayoutEditPanel:onClick_Button_moveUp(context)
	SoraDPlaySound()
	self.fields.Com_map:moveAllBuild(cc.p(0, -1))
end
function ManorLayoutEditPanel:onClick_Button_moveDown(context)
	SoraDPlaySound()
	self.fields.Com_map:moveAllBuild(cc.p(0, 1))
end
function ManorLayoutEditPanel:onClick_Button_moveLeft(context)
	SoraDPlaySound()
	self.fields.Com_map:moveAllBuild(cc.p(-1, 0))
end
function ManorLayoutEditPanel:onClick_Button_moveRight(context)
	SoraDPlaySound()
	self.fields.Com_map:moveAllBuild(cc.p(1, 0))
end
function ManorLayoutEditPanel:closeMoveModel()
	if not self.isMoveModel then
		return
	end
	self.isMoveModel = false
	self:updateMoveModel()
end
function ManorLayoutEditPanel:closeDeleteModel()
	if not self.isDeleteModel then
		return
	end
	self.isDeleteModel = false
	self:updateDeleteModel()
end
function ManorLayoutEditPanel:close()
	self:resetLayoutMap()
	if self:isLayoutChanged() then
		_ENV = nil
		;(nil).content = i18n("Socialize_text_58")
		;(nil).cancel = true
		;(nil).confirmFunc = function()
			self:closePanel()
		end
		uiManager:show("MessageBox", nil)
	else
		self:closePanel()
	end
end
function ManorLayoutEditPanel:isLayoutChanged()
	dump(self.layoutMap, "self.layoutMap")
	local gardenMap = self.fields.Com_map:getMapData()
	local layoutMapNew = manorCityUtil.gardenMap2LayoutMap(gardenMap)
	dump(layoutMapNew, "layoutMapNew")
	for realId, __ in pairs(self.layoutMap) do
		if not layoutMapNew[realId] then
			return true
		end
	end
	for realId, __ in pairs(layoutMapNew) do
		if not self.layoutMap[realId] then
			return true
		end
	end
	return false
end
function ManorLayoutEditPanel:onMsgManorLayoutSave(...)
	local layoutData = manorLayoutCtrl:getLayoutData(self.index)
	if not layoutData.map then
		manorLayoutCtrl = layoutData.map
	end
	self.layoutMap = layoutData.map
	self.fields.Com_map:clearMapData()
	local gardenMap = manorCityUtil.createMapData(self.layoutMap)
	self.fields.Com_map:initMapData(gardenMap)
end
function ManorLayoutEditPanel:resetLayoutMap()
	self:closeMoveModel()
	self:closeDeleteModel()
	self.fields.Com_map:checkEndEdit()
end
return ManorLayoutEditPanel

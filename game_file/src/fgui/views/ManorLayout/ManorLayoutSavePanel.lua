local manorLayoutCtrl = SoraDGetCtrl("manorLayoutCtrl")
local manorCityUtil = include("manorCityUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorLayoutSavePanel = class("ManorLayoutSavePanel", baseFguiPanel)
function ManorLayoutSavePanel:ctor(...)
	self.isLRU = true
	ManorLayoutSavePanel.super.ctor(self, ...)
	print("ManorLayoutSavePanel:ctor", self.viewName)
end
function ManorLayoutSavePanel:onInit()
	print("=======ManorLayoutSavePanel:onInit")
	self.fields.Panel_bg:setString(i18n("Socialize_text_48"))
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
end
function ManorLayoutSavePanel:endShow()
	print("=======ManorLayoutSavePanel:endShow")
	self.index = self.param.index or -1
	self.layoutData = self.param.layoutData
	self.layoutMap = manorLayoutCtrl:getLayoutMap()
	local layoutNum = manorCityUtil.getLayoutNumLimit()
	self.fields.List:setNumItems(layoutNum)
end
function ManorLayoutSavePanel:itemRenderer_List(index, obj)
	local _fields = fguiHelper.get_fields(obj)
	local layoutData = self.layoutMap[tostring(index + 1)]
	if not layoutData or not manorCityUtil.isLayoutComplete(layoutData.map) then
		_fields.Image_notComple:setVisible(true)
		_fields.Text_notComple:setVisible(true)
		_fields.Text_notComple:setString(i18n("common_text_2139"))
	else
		_fields.Image_notComple:setVisible(false)
		_fields.Text_notComple:setVisible(false)
	end
	if not SoraDFIsRA() then
		_fields.Text_notComple:setAlign(cc.TEXT_ALIGNMENT_RIGHT)
	end
	local showSelect = index + 1 ~= self.index
	_fields.Image_canSelect:setVisible(showSelect)
	_fields.mv_canSelect:setVisible(showSelect)
	_fields.mv_canSelect:setAllFrameName("dh_budui1_%.2d.png", 0)
	if not layoutData or not layoutData.map then
		local _ENV, map = layoutData.map, layoutData.map
	end
	_fields.Com_mapLayout:initLayoutMap(map)
end
function ManorLayoutSavePanel:onClickItem(EventContext)
	SoraDPlaySound()
	local obj = EventContext:getGObjectData()
	local childIndex = self.fields.List:getChildIndex(obj)
	local idx = childIndex + 1
	if idx == self.index then
		return
	end
	local _ENV, map = self.index, self.index
	local uid, iid
	if self.index == -1 then
		uid = self.layoutData.uid or 0
		iid = self.layoutData.id or 0
	elseif self.index == 0 then
		map = manorCityUtil.getCurLayoutMap()
	else
		local data = self.layoutMap[tostring(self.index)]
		if data then
			map, _ENV = data.map, data.map
			map = data.map or manorCityUtil.getCurLayoutMap()
		end
	end
	_ENV = nil
	;(nil).content = i18n("Socialize_text_23")
	;(nil).cancel = true
	;(nil).confirmFunc = function()
		if self.index == -1 then
			manorLayoutCtrl:reqDownload(idx, uid, iid)
		else
			manorLayoutCtrl:reqSave(idx, map, false, true)
		end
		self:closePanel()
	end
	uiManager:show("MessageBox", nil)
end
return ManorLayoutSavePanel

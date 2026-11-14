local manorLayoutCtrl = SoraDGetCtrl("manorLayoutCtrl")
local manorCityUtil = include("manorCityUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorMyLayoutPanel = class("ManorMyLayoutPanel", baseFguiPanel)
function ManorMyLayoutPanel:ctor(...)
	self.isLRU = true
	ManorMyLayoutPanel.super.ctor(self, ...)
	print("ManorMyLayoutPanel:ctor", self.viewName)
end
function ManorMyLayoutPanel:onInit()
	print("=======ManorMyLayoutPanel:onInit")
	local layoutNum = manorCityUtil.getLayoutNumLimit()
	self.layoutNum = layoutNum + 1
	self.fields.Com_title:initData(i18n("Socialize_text_54"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self.fields.Text_noData:setString(i18n("Socialize_text_32"))
	self.fields.Button_copy:setString(i18n("common_text_078"))
	self.fields.Button_copy:addClickListener(handler(self, self.onClickBtnCopy))
	self.fields.Button_use:setString(i18n("common_text_314"))
	self.fields.Button_use:addClickListener(handler(self, self.onClickBtnUse))
	self.fields.Button_edit:setString(i18n("common_text_244"))
	self.fields.Button_edit:addClickListener(handler(self, self.onClickBtnEdit))
	self.fields.Button_delete:setString(i18n("common_text_697"))
	self.fields.Button_delete:addClickListener(handler(self, self.onClickBtnDelete))
end
function ManorMyLayoutPanel:endShow()
	print("=======ManorMyLayoutPanel:endShow")
	_ENV = print
	_ENV, _ENV, print.defaultClick = nil, "=======ManorMyLayoutPanel:endShow", 1
	_ENV, ("=======ManorMyLayoutPanel:endShow")[1], (nil).title = nil, nil, i18n("Socialize_text_20")
	print.tabsetArray, ("=======ManorMyLayoutPanel:endShow")[2], (nil).title = "=======ManorMyLayoutPanel:endShow", nil, i18n("Socialize_text_21")
	local print.callback, param = handler(self, self.onClickTab), print
	self.fields.com_Tab:initView(param)
	manorLayoutCtrl:reqInit()
end
function ManorMyLayoutPanel:onClickTab(tag)
	self.curTag = tag
	if self.curTag == 1 then
		self.layoutMap = manorLayoutCtrl:getLayoutMap()
		self.fields.List:setNumItems(self.layoutNum)
		self.fields.List:setSelectedIndex(0)
		self.fields.List:scrollToView(0)
		self.fields.Button_copy:setVisible(true)
		self.fields.Button_use:setVisible(true)
		self.fields.Button_edit:setVisible(true)
		self.fields.Button_delete:setVisible(false)
		self.fields.Image_noData:setVisible(false)
		self.fields.Text_noData:setVisible(false)
	else
		local manorLayoutCtrl, ret = self.fields.Text_noData.setVisible, self.fields.Text_noData.setVisible
		local uploadMap = manorLayoutCtrl:getUploadMap()
		for i = #uploadMap, 1, -1 do
			table.insert(ret, uploadMap[i])
		end
		self.uploadMap = ret
		self.fields.List:setNumItems(#self.uploadMap)
		if 0 < #self.uploadMap then
			self.fields.List:setSelectedIndex(0)
			self.fields.List:scrollToView(0)
			self.fields.Button_delete:setVisible(true)
		else
			self.fields.Button_delete:setVisible(false)
		end
		self.fields.Button_copy:setVisible(false)
		self.fields.Button_use:setVisible(false)
		self.fields.Button_edit:setVisible(false)
		self.fields.Image_noData:setVisible(#self.uploadMap == 0)
		self.fields.Text_noData:setVisible(#self.uploadMap == 0)
	end
	self:updateButtonState()
end
function ManorMyLayoutPanel:itemRenderer_List(index, obj)
	if self.curTag == 1 then
		if index == 0 then
			local map = manorCityUtil.getCurLayoutMap()
			manorCityUtil = nil
			local (nil).map, data = map, nil
			obj:initData(0, data, index)
		else
			local data = self.layoutMap[tostring(index)]
			obj:initData(1, data, index)
		end
	else
		local data = self.uploadMap[index + 1]
		obj:initData(2, data, index + 1)
	end
end
function ManorMyLayoutPanel:onClickItem(EventContext)
	SoraDPlaySound()
	self:updateButtonState()
end
function ManorMyLayoutPanel:updateButtonState()
	local index = self.fields.List:getSelectedIndex()
	print("ManorMyLayoutPanel:updateButtonState", index)
	if self.curTag == 1 then
		if index == 0 then
			self.fields.Button_use:setVisible(false)
			self.fields.Button_edit:setVisible(false)
		else
			self.fields.Button_use:setVisible(true)
			self.fields.Button_edit:setVisible(true)
		end
	end
	self.fields.Com_map:initInLayoutPreview()
	if 0 <= index then
		local obj = self.fields.List:getChildAt(index)
		local gardenMap = obj:getGardenMap()
		self.fields.Com_map:initMapData(gardenMap)
	end
end
function ManorMyLayoutPanel:onClickBtnCopy(context)
	SoraDPlaySound()
	if self.curTag ~= 1 then
		return
	end
	local index = self.fields.List:getSelectedIndex()
	_ENV = nil
	;(nil).index = index
	uiManager:show("ManorLayoutSave", nil)
end
function ManorMyLayoutPanel:onClickBtnUse(context)
	SoraDPlaySound()
	if self.curTag ~= 1 then
		return
	end
	local index = self.fields.List:getSelectedIndex()
	if index == 0 then
		return
	end
	local idx = index
	local layoutData = self.layoutMap[tostring(idx)]
	if not layoutData or not manorCityUtil.isLayoutComplete(layoutData.map) then
		SoraDShowMsgTip(i18n("Socialize_text_28"))
		return
	end
	_ENV = i18n("Socialize_text_28")
	i18n("Socialize_text_28").content = i18n("Socialize_text_27")
	i18n("Socialize_text_28").cancel = true
	i18n("Socialize_text_28").confirmFunc = function()
		manorLayoutCtrl:reqUse(idx)
	end
	uiManager:show("MessageBox", i18n("Socialize_text_28"))
end
function ManorMyLayoutPanel:onClickBtnEdit(context)
	SoraDPlaySound()
	if self.curTag ~= 1 then
		return
	end
	local index = self.fields.List:getSelectedIndex()
	if index == 0 then
		return
	end
	_ENV = nil
	;(nil).index = index
	uiManager:show("ManorLayoutEdit", nil)
end
function ManorMyLayoutPanel:onClickBtnDelete(context)
	SoraDPlaySound()
	if self.curTag ~= 2 then
		return
	end
	local index = self.fields.List:getSelectedIndex()
	local data = self.uploadMap[index + 1]
	if not data then
		return
	end
	local iid = data.id
	_ENV = nil
	;(nil).content = i18n("Socialize_text_33")
	;(nil).cancel = true
	;(nil).confirmFunc = function()
		manorLayoutCtrl:reqDelete(iid)
	end
	uiManager:show("MessageBox", nil)
end
function ManorMyLayoutPanel:onMsgLayoutSave(target, event)
	if self.curTag ~= 1 then
		return
	end
	self.layoutMap = manorLayoutCtrl:getLayoutMap()
	local index = event.idx
	local obj = self.fields.List:getChildAt(index)
	self:itemRenderer_List(index, obj)
	local curIndex = self.fields.List:getSelectedIndex()
	if curIndex == index then
		self.fields.Com_map:initInLayoutPreview()
		if 0 <= curIndex then
			local obj = self.fields.List:getChildAt(curIndex)
			local gardenMap = obj:getGardenMap()
			self.fields.Com_map:initMapData(gardenMap)
		end
	end
end
function ManorMyLayoutPanel:onMsgMapInit(...)
	if self.curTag ~= 1 then
		return
	end
	local index = 0
	local obj = self.fields.List:getChildAt(index)
	self:itemRenderer_List(index, obj)
end
function ManorMyLayoutPanel:onMsgLayoutDelete(...)
	if self.curTag ~= 2 then
		return
	end
	self:onClickTab(self.curTag)
end
return ManorMyLayoutPanel

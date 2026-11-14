local manorLayoutCtrl = SoraDGetCtrl("manorLayoutCtrl")
local manorCityUtil = include("manorCityUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorLayoutPreviewPanel = class("ManorLayoutPreviewPanel", baseFguiPanel)
function ManorLayoutPreviewPanel:ctor(...)
	self.isLRU = true
	ManorLayoutPreviewPanel.super.ctor(self, ...)
	print("ManorLayoutPreviewPanel:ctor", self.viewName)
end
function ManorLayoutPreviewPanel:onInit()
	print("=======ManorLayoutPreviewPanel:onInit")
	self.fields.Com_title:initData(i18n("Socialize_text_47"), handler(self, self.onClickClose))
	self.fields.Button_save:setString(i18n("Socialize_text_48"))
	self.fields.Button_save:addClickListener(handler(self, self.onClickBtnSave))
	self.fields.Button_like:addClickListener(handler(self, self.onClickBtnLike))
end
function ManorLayoutPreviewPanel:endShow()
	print("=======ManorLayoutPreviewPanel:endShow")
	if not self.param.layoutData then
		_ENV = self.param.layoutData
	end
	self.layoutData = self.param.layoutData
	if not self.param.player then
		_ENV = self.param.player
	end
	self.player = self.param.player
	local nickName = self.player.nickName or ""
	_ENV = nil
	;(nil).name = nickName
	local nameStr = i18n("Socialize_text_12", nil)
	self.fields.Text_name:setString(nameStr)
	self:updateButtonLike()
	self.fields.Com_map:initInLayoutPreview()
	if not self.layoutData.map then
		local _ENV, map = self.layoutData.map, self.layoutData.map
	end
	local gardenMap = manorCityUtil.createMapData(map)
	self.fields.Com_map:initMapData(gardenMap)
end
function ManorLayoutPreviewPanel:onHide()
	_ENV = nil
	;(nil).msg = "MESSAGE_MANOR_CITY_FARMLAND_UPDATE"
	SoraDSendMessage(nil)
end
function ManorLayoutPreviewPanel:onClickBtnSave(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).layoutData = self.layoutData
	uiManager:show("ManorLayoutSave", nil)
end
function ManorLayoutPreviewPanel:onClickBtnLike(context)
	SoraDPlaySound()
	local uid = self.layoutData.uid or 0
	local iid = self.layoutData.id or 0
	local isLike = self:getSelfIsLike(self.layoutData)
	if isLike then
		manorLayoutCtrl:reqUnlike(uid, iid)
	else
		manorLayoutCtrl:reqLike(uid, iid)
	end
end
function ManorLayoutPreviewPanel:updateButtonLike(layoutData)
	if layoutData then
		self.layoutData = layoutData
	end
	local likeCount = self.layoutData.likeCount or 0
	self.fields.Button_like:setString(tostring(likeCount))
	local isLike = self:getSelfIsLike(self.layoutData)
	self.fields.Button_like:setGrayed(not isLike)
end
function ManorLayoutPreviewPanel:getSelfIsLike(layoutData)
	if not layoutData.likeUserMap then
		local _ENV, likeUserMap = layoutData.likeUserMap, layoutData.likeUserMap
	end
	local selfUid = SoraDGetPlayerID()
	local isLike = likeUserMap[tostring(selfUid)] or false
	return isLike
end
function ManorLayoutPreviewPanel:onMsgManorLayoutLike(target, event)
	dump(event, "ManorLayoutPreviewPanel:onMsgManorLayoutLike", 10)
	local uid = event.uid or 0
	local iid = event.iid or 0
	if self.layoutData.uid == uid and self.layoutData.id == iid then
		local _data = manorLayoutCtrl:getOtherLayout(iid)
		self:updateButtonLike(_data)
	end
end
return ManorLayoutPreviewPanel

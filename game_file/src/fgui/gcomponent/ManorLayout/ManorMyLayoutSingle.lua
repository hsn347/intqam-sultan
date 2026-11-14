local manorLayoutCtrl = SoraDGetCtrl("manorLayoutCtrl")
local manorCityUtil = include("manorCityUtil")
local baseComponent = require("fgui.base.baseComponent")
local ManorMyLayoutSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://ManorLayout/ManorMyLayoutSingle", ManorMyLayoutSingle)
function ManorMyLayoutSingle:onInit()
	self.fields.Text_curLayout:setString(i18n("Socialize_text_22"))
	self.fields.Button_upload:setString(i18n("Socialize_text_53"))
	self.fields.Button_upload:addClickListener(handler(self, self.onClickBtnUpload))
	self.fields.Text_notComple:setString(i18n("common_text_2139"))
	if not SoraDFIsRA() then
		self.fields.Text_curLayout:setAlign(cc.TEXT_ALIGNMENT_RIGHT)
		self.fields.Text_notComple:setAlign(cc.TEXT_ALIGNMENT_RIGHT)
	end
end
function ManorMyLayoutSingle:onShow()
end
function ManorMyLayoutSingle:onClickBtnUpload(context)
	SoraDPlaySound()
	if self.layoutType ~= 1 then
		return
	end
	if not self:isLayoutComplete() then
		SoraDShowMsgTip(i18n("Socialize_text_24"))
		return
	end
	if manorLayoutCtrl:checkUploadLayoutLimit() then
		SoraDShowMsgTip(i18n("Socialize_text_25"))
		return
	end
	manorLayoutCtrl:reqUpload(self.layoutIdx)
end
function ManorMyLayoutSingle:initData(layoutType, layoutData, layoutIdx)
	dump(layoutData, "ManorMyLayoutSingle:initData" .. layoutType)
	self.layoutType = layoutType
	self.layoutData = layoutData
	self.layoutIdx = layoutIdx
	self.controllers.c1:setSelectedIndex(self.layoutType)
	if self.layoutType == 0 then
	elseif self.layoutType == 1 then
		if not self:isLayoutComplete() then
			self.fields.Image_curLayout:setVisible(true)
			self.fields.Text_notComple:setVisible(true)
		else
			self.fields.Image_curLayout:setVisible(false)
			self.fields.Text_notComple:setVisible(false)
		end
	elseif self.layoutType == 2 then
		local likeCount = self.layoutData.likeCount or 0
		self.fields.Button_like:setString(tostring(likeCount))
	end
	self:updateMap()
end
function ManorMyLayoutSingle:updateMap()
	local _UPVALUE0_, map
	if self.layoutData then
		map, _UPVALUE0_ = self.layoutData.map, self.layoutData.map
		map = self.layoutData.map or nil
	end
	self.fields.Com_mapLayout:initLayoutMap(map)
end
function ManorMyLayoutSingle:isLayoutComplete()
	if not self.layoutData then
		return false
	end
	if not self.layoutData.map then
		local manorCityUtil, map = self.layoutData.map, self.layoutData.map
	end
	return manorCityUtil.isLayoutComplete(map)
end
function ManorMyLayoutSingle:getGardenMap()
	return self.fields.Com_mapLayout:getMapData()
end
return ManorMyLayoutSingle

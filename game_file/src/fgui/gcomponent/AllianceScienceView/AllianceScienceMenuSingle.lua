local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local AllianceScienceMenuSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceScienceView/AllianceScienceMenuSingle", AllianceScienceMenuSingle)
_ENV = fgui.register_extension
fgui.register_extension.RECOMMEND = 1
fgui.register_extension.OPEN = 2
local fgui.register_extension.LOCK, SingleDataType = 3, fgui.register_extension
function AllianceScienceMenuSingle:onInit()
	self.fields.Sprite_arr:fixPos()
	self.fields.Sprite_icon:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.Text_lv:fixPos()
	self.isLaunched = false
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
	self.fields.Panel_touch:addClickListener(handler(self, self.btnClickCallBack))
end
function AllianceScienceMenuSingle:onShow()
end
function AllianceScienceMenuSingle:initData(singleData)
	self.tableSingleData = singleData
	local singleDataType = singleData.singleDataType
	self.fields.Sprite_icon:setVisible(false)
	self:updateOtherUI()
	if singleDataType == SingleDataType.RECOMMEND then
		local strDes = i18n("alliance_text_01") .. string.format("(%d/%d)", #singleData.data, 2)
		self.fields.Text_des:setString(strDes)
		self.fields.Sprite_icon:setVisible(true)
	else
		self.fields.Text_lv:setString(tostring(singleData.index))
	end
	self:initScience()
	print("self.isLaunched", self.isLaunched, singleDataType)
	if not self.isLaunched then
		self:removeScience()
	end
end
function AllianceScienceMenuSingle:onItemRender(index, target)
	local v = self.tableSingleData.data[index + 1]
	if not self.tableSingleData.isOpened then
		_UPVALUE0_ = self.tableSingleData.isOpened
		v, self.tableSingleData.isOpened.id = self.tableSingleData.isOpened, v
	end
	_UPVALUE0_ = nil
	;(nil).data = v
	;(nil).isOpened = self.tableSingleData.isOpened
	target:initData(nil)
end
function AllianceScienceMenuSingle:setState(state)
	print("self.isLaunched", self.isLaunched, state, self.tableSingleData.index)
	if self.isLaunched == state then
		return
	end
	if not state then
		self:removeScience()
		self.fields.Sprite_arr:setRotation(0)
	else
		self:initScience()
		self.fields.Sprite_arr:setRotation(-90)
	end
	self.isLaunched = state
end
function AllianceScienceMenuSingle:updateNextGroup(isOpened)
	if isOpened and self.tableSingleData.isOpened == false then
		self.tableSingleData.isOpened = true
		for i, v in ipairs(self.tableSinglePoint) do
			v:updateData()
		end
	end
	self:updateOtherUI()
end
function AllianceScienceMenuSingle:updateOtherUI()
	if self.tableSingleData.isOpened then
		self.fields.Text_des:setString("")
	else
		local gametop = gModuleMgr.getObject("gametop")
		local allianceScience = gametop.playertop_:getModule("allianceScience")
		local curLv = allianceScience:getCurSciTotalLv()
		_ENV = nil
		;(nil).cur = curLv
		;(nil).need = self.tableSingleData.needLv
		self.fields.Text_des:setString(i18n("common_text_278", nil))
	end
end
function AllianceScienceMenuSingle:initScience()
	self.fields.List:setVisible(true)
	self.fields.List:setNumItems(#self.tableSingleData.data)
	self.fields.List:resizeToFit(#self.tableSingleData.data)
	self:setHeight(56 + self.fields.List:getHeight())
end
function AllianceScienceMenuSingle:removeScience()
	self:setHeight(56)
	self.fields.List:setVisible(false)
end
function AllianceScienceMenuSingle:getOffsetBySid(sid)
	for i, v in ipairs(self.tableSingleData.data) do
		if type(v) == "table" and v.id and v.id == sid or type(v) == "number" and v == sid then
			return 56 + i * 110
		end
	end
	return 0
end
function AllianceScienceMenuSingle:btnClickCallBack()
	SoraDPlaySound()
	if self.tableSingleData.data and #self.tableSingleData.data > 0 then
		local firstData = self.tableSingleData.data[1]
		local firstID = self.tableSingleData.isOpened and firstData.id or firstData
		if not allianceDesRead.isScience(firstID) then
			SoraDUpdateDownload(true, true)
			return
		end
	end
	self:setState(not self.isLaunched)
end
return AllianceScienceMenuSingle

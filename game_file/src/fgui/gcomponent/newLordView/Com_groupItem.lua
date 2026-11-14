local combinationCtrl = SoraDGetCtrl("combinationCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_groupItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_groupItem", Com_groupItem)
function Com_groupItem:onInit()
	_UPVALUE4_ = nil
	self.imgs, (nil)[1] = nil, "frame_zxtq_bg_zi_01.png"
	self.imgs, (nil)[2] = nil, "frame_zxtq_bg_h_01.png"
	self.imgs, (nil)[3] = nil, "frame_zxtq_bg_g_01.png"
	self.imgs, (nil)[4] = nil, "frame_zxtq_bg_r_01.png"
	self.fields.Panel_select:setScaleY(0)
	self.fields.Button_select:setString(i18n("common_text_480"))
	self.fields.Button_select:addClickListener(handler(self, self.btnSelectClick))
end
function Com_groupItem:onShow()
end
function Com_groupItem:initData(setID, index, handle)
	self.setID = setID
	self.index = index
	self.handle = handle
	self.fields.icon:setSpriteFrame(self.imgs[self.index])
	self.fields.Sprite_icon:setSpriteFrame(string.format("icon_zxtq_%02d.png", self.index))
	self.fields.Panel_select:initData(self.setID, self.index, handler(self, self.closePanelSelect))
	self:setBtnName(self.setID)
end
function Com_groupItem:setBtnName(setID)
	if 0 < setID then
		local setName = combinationCtrl:getSetName(self.index, setID)
		self.fields.Button_select:setString(setName)
	else
		self.fields.Button_select:setString(i18n("common_text_480"))
	end
end
function Com_groupItem:closePanelSelect(setID)
	local _setID = tonumber(setID) or self.setID
	self.fields.Panel_select:runAction(ffa.seq(ffa.scaleTo(0.2, 1.0, 0.0), ffa.callFunc(function()
		self.fields.Panel_select:getDisplayObject():InvalidateBatchingState()
	end)))
	if self.handle then
		self.handle(self.index, _setID)
	end
	self:setBtnName(_setID)
end
function Com_groupItem:openPanelSelect()
	self.fields.Panel_select:runAction(ffa.seq(ffa.scaleTo(0.2, 1.0, 1.0), ffa.callFunc(function()
		self.fields.Panel_select:getDisplayObject():InvalidateBatchingState()
	end)))
end
function Com_groupItem:btnSelectClick()
	SoraDPlaySound()
	self:openPanelSelect()
end
return Com_groupItem

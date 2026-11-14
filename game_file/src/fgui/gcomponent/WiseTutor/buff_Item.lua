local buildLogic = include("buildLogic")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local buffDesRead = include("buffDesRead")
local baseComponent = require("fgui.base.baseComponent")
local buff_Item = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WiseTutor/buff_Item", buff_Item)
fgui.register_extension("ui://WiseTutor/buff_Item2", buff_Item)
fgui.register_extension("ui://ArtisanHouse/buff_Item", buff_Item)
function buff_Item:onInit()
	self:fixChildrenPos()
end
function buff_Item:onShow()
end
function buff_Item:initData(icon, buffID, isAnother)
	if buffID == nil then
		self:setVisible(false)
		return
	end
	self:setVisible(true)
	self.fields.buff_Icon:setSpriteFrame(icon)
	local effectType = buffltCtrl:getEffectType(buffID)
	local buffNum1 = buffltCtrl:getEffect(buffID)
	local title, _ = buffDesRead.getTitleBase(effectType, true)
	local value = buffDesRead.getTitleValueWithValue(effectType, buffNum1, true)
	buffltCtrl = nil
	;(nil).title = title
	buffltCtrl, buffltCtrl, (nil).value = nil, nil, value
	buffltCtrl, (nil).value, (nil).color = nil, nil, isAnother and "#70C723" or "#006E00"
	;(nil).__default, (nil).color = nil, isAnother and "#B4AA87" or "#66320C"
	self.fields.Text_Buff:setString(i18n_html("common_text_3904", nil, nil))
end
function buff_Item:initData2(icon, buffID, color1, color2)
	if buffID == nil then
		self:setVisible(false)
		return
	end
	self:setVisible(true)
	self.fields.buff_Icon:setSpriteFrame(icon)
	local effectType = buffltCtrl:getEffectType(buffID)
	local buffNum1 = buffltCtrl:getEffect(buffID)
	local title, _ = buffDesRead.getTitleBase(effectType, true)
	local value = buffDesRead.getTitleValueWithValue(effectType, buffNum1, true)
	buffltCtrl = nil
	;(nil).title = title
	buffltCtrl, buffltCtrl, (nil).value = nil, nil, value
	buffltCtrl, (nil).value, (nil).color = nil, nil, color1
	;(nil).__default, (nil).color = nil, color2
	self.fields.Text_Buff:setString(i18n_html("common_text_3904", nil, nil))
end
return buff_Item

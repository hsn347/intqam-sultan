local itemDesRead = include("itemDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local ComBanquetType = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://ManorSocial/ComBanquetType", ComBanquetType)
function ComBanquetType:onInit()
	self.fields.btnUse:addClickListener(handler(self, self.onClickUse))
	self.fields.btnUse:setTitle(i18n("common_text_314"))
	self:fixChildrenPos()
end
function ComBanquetType:onShow()
end
function ComBanquetType:onClickUse()
	SoraDPlaySound()
	if not self.data then
		return
	end
	if backpackCtrl:getItemCount(self.data.banquetItem) == 0 then
		_ENV = nil
		;(nil).name = itemDesRead.getName(self.data.banquetItem)
		SoraDShowMsgTip(i18n("farmland_text_88", nil))
		return
	end
	if manorCityCtrl:getMapObjByBid(MANOR_BUILD_ID.BANQUET) then
		SoraDShowMsgTip(i18n("Socialize_text_38"))
		return
	end
	if self.param.isInVisit then
		SoraDShowMsgTip(i18n("Socialize_text_37"))
		return
	end
	self.param.callback(self.data.banquetType, self.param.comMap)
	uiManager:close("BanquetTypeView")
end
function ComBanquetType:initData(data, param)
	self.data = data
	self.param = param
	local itemId = self.data.banquetItem
	self.fields.comItem:initData(itemId)
	self.fields.title:setString(itemDesRead.getName(itemId))
	local count = backpackCtrl:getItemCount(itemId)
	itemDesRead = itemDesRead.getName(itemId)
	itemDesRead, itemDesRead, itemDesRead.getName(itemId).count = itemDesRead.getName(itemId)
	itemDesRead.getName(itemId).count, itemDesRead.getName(itemId).color = itemDesRead.getName(itemId)
	self.fields.txtNum:setString(i18n_html("common_text_1377", itemDesRead.getName(itemId)))
	self.fields.btnUse:setGrayed(count == 0)
end
return ComBanquetType

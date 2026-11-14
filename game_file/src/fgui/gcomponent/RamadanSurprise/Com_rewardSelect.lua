local publicRead = include("publicRead")
local ramadanSurpriseltCtrl = include("ramadanSurpriseltCtrl")
local ramadanSurpriseCtrl = SoraDGetCtrl("ramadanSurpriseCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_rewardSelect = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RamadanSurprise/Com_rewardSelect", Com_rewardSelect)
function Com_rewardSelect:onInit()
	self:addClickListener(handler(self, self.onClickSelect))
	self.fields.Text_get:setString(i18n("common_text_1892"))
end
function Com_rewardSelect:initData(index)
	self.index = index
	self.data = ramadanSurpriseltCtrl.getSelectRewardByIndex(index)
	dump(self.data, "Com_rewardSelect:initData")
	self.fields.title:setString(self.data.integral)
	if ramadanSurpriseCtrl:isSelectedAlready() then
		local subIndex = ramadanSurpriseCtrl:getSelectedIndexByLevel(index)
		self:setResIcon(subIndex)
	elseif ramadanSurpriseCtrl:getUserSelectByLevel(index) then
		local subIndex = ramadanSurpriseCtrl:getUserSelectByLevel(index)
		self:setResIcon(subIndex)
	end
	if ramadanSurpriseCtrl:getSelectedStateByLevel(index) == 1 then
		self.fields.resIcon:setAlpha(0.51)
		self.controllers.c1:setSelectedIndex(2)
		self:setTouchable(false)
	end
end
function Com_rewardSelect:setResIcon(subIndex)
	self.controllers.c1:setSelectedIndex(1)
	local itemID = ramadanSurpriseltCtrl.getSelectedIconByIndex(self.index, subIndex)
	self.fields.resIcon:setURL(publicRead.getIcon(itemID))
end
function Com_rewardSelect:onClickSelect()
	_ENV = nil
	;(nil).index = self.index
	;(nil).title = i18n("ramadan_surprise_02")
	;(nil).integral = self.data.integral
	publicRead = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	;(nil).itemList = serviceFunctions.tableFormat(self.data.gift, nil)
	;(nil).tip = i18n("ramadan_surprise_03")
	local (nil).btnHandle, param = function(level, curSelect)
		local itemID = ramadanSurpriseltCtrl.getSelectedIconByIndex(level, curSelect)
		self.fields.resIcon:setURL(publicRead.getIcon(itemID))
		self.controllers.c1:setSelectedIndex(1)
		ramadanSurpriseCtrl:setUserSelect(level, curSelect)
		if ramadanSurpriseCtrl:isSelectedAlready() then
			ramadanSurpriseCtrl:sendRewardChangeMsg(level, curSelect)
		elseif ramadanSurpriseCtrl:isUseSelectAll() then
			ramadanSurpriseCtrl:sendRewardSetMsg(ramadanSurpriseCtrl:getUserSelect())
		end
	end, nil
	uiManager:show("SelfSelectReward", param):setOwnerKey(self)
end
function Com_rewardSelect:onShow()
end
return Com_rewardSelect

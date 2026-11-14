local baseComponent = require("fgui.base.baseComponent")
local Com_settingItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/Com_settingItem", Com_settingItem)
function Com_settingItem:onInit()
	self.fields.Check_tick:addClickListener(handler(self, self.onTickClick))
end
function Com_settingItem:onShow()
end
function Com_settingItem:initData(data)
	self.category = data.category
	self.fields.icon:setURL(data.icon)
	self.fields.title:setString(i18n(data.name))
	_ENV = i18n(data.name)
	i18n(data.name).byUID = true
	if not SoraDConfigGet("Game:Recharge:hideCategory~table", i18n(data.name)) then
		local _ENV, hideCategoryList = SoraDConfigGet("Game:Recharge:hideCategory~table", i18n(data.name)), SoraDConfigGet("Game:Recharge:hideCategory~table", i18n(data.name))
	end
	self.fields.Check_tick:setSelected(not hideCategoryList[tostring(self.category)])
end
function Com_settingItem:onTickClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:Recharge:hideCategory~table", nil) then
		local _ENV, hideCategoryList = SoraDConfigGet("Game:Recharge:hideCategory~table", nil), SoraDConfigGet("Game:Recharge:hideCategory~table", nil)
	end
	hideCategoryList[tostring(self.category)] = not self.fields.Check_tick:isSelected()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:Recharge:hideCategory~table", hideCategoryList, nil)
	if self.fields.Check_tick:isSelected() then
		_ENV = hideCategoryList
		hideCategoryList.byUID = true
		if not SoraDConfigGet("Game:Recharge:hideGift~table", hideCategoryList) then
			local _ENV, hideList = SoraDConfigGet("Game:Recharge:hideGift~table", hideCategoryList), SoraDConfigGet("Game:Recharge:hideGift~table", hideCategoryList)
		end
		for rid, _ in pairs(hideList) do
			local category = SoraDGetGiftCategory(tonumber(rid))
			local categoryEx = SoraDGetGiftCategoryEx(tonumber(rid))
			print("category========", rid, category, categoryEx)
			if category and category == tonumber(self.category) or categoryEx and categoryEx == tonumber(self.category) then
				hideList[tostring(rid)] = nil
			end
		end
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:Recharge:hideGift~table", hideList, nil)
	end
	_ENV = SoraDConfigSet
	SoraDConfigSet.msg = "MESSAGE_UI_RECHARGECENTER_HIDE_GIFT"
	SoraDSendMessage(SoraDConfigSet)
end
return Com_settingItem

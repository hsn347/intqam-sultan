local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local baseComponent = require("fgui.base.baseComponent")
local WarGemItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WarGem/WarGemItem", WarGemItem)
function WarGemItem:registerEvent()
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_DATA", handler(self, self.onUpdateData))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_DATA_BAG", handler(self, self.onUpdateData))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_FILER_SETTING", handler(self, self.updateDataSetting))
end
function WarGemItem:onInit()
	self.btnFiler = self.fields.Button_filer
	self.btnFiler:addClickListener(handler(self, self.OnBtnFilerClick))
end
function WarGemItem:onShow()
	self:initData()
end
function WarGemItem:onUpdateData()
	self:updateData()
end
function WarGemItem:initData(...)
	self:updateBtnStatus()
	self:updateData()
end
function WarGemItem:updateBtnStatus(...)
	if warGemCtrl:isHasFiler() then
		self.btnFiler:setBtnColorIndex(0)
		self.btnFiler:setTitleText(i18n("gem_btn_02"))
	else
		self.btnFiler:setBtnColorIndex(2)
		self.btnFiler:setTitleText(i18n("gem_btn_01"))
	end
end
function WarGemItem:updateDataSetting(...)
	self:updateData()
	self:updateBtnStatus()
	self.fields.scroll:jumpTop()
end
function WarGemItem:updateData(...)
	local warGemCtrl, tableItemsData
	local data = warGemCtrl:getGemBagList()
	if warGemCtrl:isHasFiler() then
		local wargemResRead = include("wargemResRead")
		local olddata = clone(data)
		table.filter(olddata, function(v, k)
			local isFiler = warGemCtrl:isGemFiler(v.id)
			return isFiler
		end)
		local warGemCtrl, newData = table.filter, table.filter
		for _, v in pairs(olddata) do
			table.insert(newData, v)
		end
		tableItemsData = newData
	else
		tableItemsData = data
	end
	for __, v in ipairs(data) do
		v.tag = warGemCtrl:canGemComposite(v.id)
		v.new = warGemCtrl:isGemNew(v.id)
	end
	self.fields.scroll:initWarGemData(tableItemsData)
end
function WarGemItem:OnBtnFilerClick()
	SoraDPlaySound()
	if warGemCtrl:isHasFiler() then
		warGemCtrl:resetGemFilerType()
		self:updateDataSetting()
	else
		_ENV = nil
		;(nil).settingType = 1
		uiManager:show("WarGemSettingView", nil)
	end
end
return WarGemItem

local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_tabShop = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://bagView/Com_tabShop", Com_tabShop)
function Com_tabShop:onInit()
	_ENV, _ENV = nil, nil
	;(nil).title = i18n("common_text_123")
	;(nil).tag = 1
	;(nil).newTagKey = "resource_item_list"
	_ENV, (nil)[1], (nil).tableKey = nil, nil, "resource"
	;(nil).title = i18n("common_text_310")
	;(nil).tag = 2
	;(nil).newTagKey = "battle_item_list"
	_ENV, (nil)[2], (nil).tableKey = nil, nil, "battle"
	;(nil).title = i18n("common_text_311")
	;(nil).tag = 3
	;(nil).newTagKey = "buff_item_list"
	_ENV, (nil)[3], (nil).tableKey = nil, nil, "gain"
	;(nil).title = i18n("common_text_312")
	;(nil).tag = 4
	;(nil).newTagKey = "other_item_list"
	self.textCfg, (nil)[4], (nil).tableKey = nil, nil, "other"
	for k, v in ipairs(self.textCfg) do
		self.fields["Button_right" .. k]:setTag(v.tag)
		self.fields["Button_right" .. k]:setString(v.title)
		self.fields["Button_right" .. k]:fixPos()
		self.fields["Button_right" .. k]:setTabClickCallback(handler(self, self.onTabClick))
	end
end
function Com_tabShop:onShow()
end
function Com_tabShop:getTabKey(tag)
	return self.textCfg[tag].tableKey
end
function Com_tabShop:getTagKey(key)
	for k, v in ipairs(self.textCfg) do
		if v.tableKey == key then
			return v.tag
		end
	end
end
function Com_tabShop:updateTab(tag)
	for i = 1, 4 do
		self.fields["Button_right" .. i]:setSelected(tag)
	end
end
function Com_tabShop:updateNew(tag)
	for i = 1, 4 do
		local isNew = shopltCtrl:getShopNewTag(self.textCfg[i].newTagKey)
		self.fields["Button_right" .. i]:setNewVisible(isNew)
	end
	shopltCtrl:updateShopNewTagTime(tag, shopltCtrl:getShopNewTag(self.textCfg[tag].newTagKey))
end
function Com_tabShop:setTabClickCallback(callback)
	self.tabClickCallback = callback
end
function Com_tabShop:onTabClick(tag)
	if self.tabClickCallback then
		self.tabClickCallback(tag)
	end
end
return Com_tabShop

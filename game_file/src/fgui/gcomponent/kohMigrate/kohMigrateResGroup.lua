local resDesRead = include("resDesRead")
local kohMigrateRead = include("kohMigrateRead")
local baseComponent = require("fgui.base.baseComponent")
local kohMigrateResGroup = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://kohMigrate/kohMigrateResGroup", kohMigrateResGroup)
function kohMigrateResGroup:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function kohMigrateResGroup:onShow()
end
function kohMigrateResGroup:initViewScale(scale)
	self.scale = scale or 1
	self:initResourceGroup()
end
function kohMigrateResGroup:initResourceGroup()
	local ARC = kohMigrateRead.getMigrantResourcesConfig()
	local kohMigrateRead, config
	local curLv, beginIndex
	for i, v in ipairs(ARC) do
		if curLv == nil then
			curLv = v.ghLevel[1]
			beginIndex = i
		end
		if curLv ~= v.ghLevel[1] then
			kohMigrateRead = nil
			;(nil).beginIndex = beginIndex
			;(nil).endIndex = i - 1
			table.insert(config, nil)
			curLv = v.ghLevel[1]
			beginIndex = i
		end
		if i == #ARC then
			kohMigrateRead = nil
			;(nil).beginIndex = beginIndex
			;(nil).endIndex = i
			table.insert(config, nil)
		end
	end
	self.config = config
	self.fields.List:setNumItems(#self.config)
	self.fields.List:resizeToFit(#self.config)
	self.fields.List:setScale(self.scale)
	self:setHeight(self.fields.List:getHeight() * self.scale)
end
function kohMigrateResGroup:onItemRenderer(index, obj)
	local isRA = SoraDFIsRA()
	if not isRA then
		obj:fixChildrenPos()
	end
	local ARC = kohMigrateRead.getMigrantResourcesConfig()
	local v = self.config[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	local ghLevel = ARC[v.endIndex].ghLevel
	local titleStr = string.format("%s:%d-%d", i18n("recharge_label_022"), ghLevel[1], ghLevel[2])
	_fields.Text_warLv:setString(titleStr)
	_fields.Text_lv:setString(i18n("arossDesc_text_005"))
	local resources = ARC[v.endIndex].resources
	local _ENV, resConfig = _fields.Text_lv, _fields.Text_lv
	for i = 1, #resources / 2 do
		local resId = resources[i * 2 - 1]
		if SoraDResIsLock(resId) then
			_ENV = i18n("arossDesc_text_005")
			i18n("arossDesc_text_005").id = resId
			i18n("arossDesc_text_005").count = resources[i * 2]
			table.insert(resConfig, i18n("arossDesc_text_005"))
		end
	end
	local cellW = 520
	if 0 < #resConfig then
		cellW = 520 / #resConfig
	end
	_fields.List_res:setItemRenderer(function(index, obj)
		if not isRA then
			obj:fixChildrenPos()
		end
		local data = resConfig[index + 1]
		obj:setString("(M)")
		obj:setIcon(resDesRead.getIcon(data.id))
		obj:setWidth(cellW)
	end)
	_fields.List_res:setNumItems(#resConfig)
	_fields.List_value:setItemRenderer(function(index, obj)
		if not isRA then
			obj:fixChildrenPos()
		end
		local data = ARC[v.beginIndex + index]
		local obj_fields = fguiHelper.get_fields(obj)
		obj_fields.Image_white:setVisible(index % 2 == 0)
		obj_fields.Text_lv:setString(data.zzLevel)
		obj_fields.List:setItemRenderer(function(_index, _obj)
			if not isRA then
				_obj:fixChildrenPos()
			end
			local value = data.resources[(_index + 1) * 2] / 1000000
			_obj:setString(string.formatnumberthousands(value))
			_obj:setWidth(cellW)
		end)
		obj_fields.List:setNumItems(#resConfig)
	end)
	local count = v.endIndex - v.beginIndex + 1
	_fields.List_value:setNumItems(count)
	_fields.List_value:resizeToFit(count)
end
return kohMigrateResGroup

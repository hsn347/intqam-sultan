local baseComponent = require("fgui.base.baseComponent")
local Com_WTV_tech = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWatchTower/Com_WTV_tech", Com_WTV_tech)
_ENV = fgui.register_extension
fgui.register_extension.SKILL = 1
local fgui.register_extension.TECH, NAME_TYPE = 2, fgui.register_extension
function Com_WTV_tech:onInit()
	self:fixChildrenPos()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_WTV_tech:onShow()
end
function Com_WTV_tech:initData(info)
	if self.isComInited then
		return
	end
	if info ~= nil then
		self.datas, _ENV = self.isComInited, self.isComInited
		for k, v in pairs(info) do
			table.insert(self.datas, v)
		end
	end
	self.isComInited = true
	local row = self.datas and #self.datas or 0
	if info == nil or row == 0 then
		if info == nil then
			_ENV = table.insert
			table.insert.level = WATCH_TOWER_VIEW_SCIENCE
			self.fields.txt_lock:setString(i18n("common_text_596", table.insert))
		else
			self.fields.txt_lock:setString(i18n("common_text_1458"))
		end
		self.fields.txt_lock:setVisible(true)
		self.fields.list:setVisible(false)
		return
	end
	self.fields.txt_lock:setVisible(false)
	self.fields.list:setVisible(true)
	local nums = math.ceil(row / 2)
	self.fields.list:setNumItems(nums)
end
function Com_WTV_tech:onItemRenderer(index, obj)
	local data = self.datas[index * 2 + 1]
	local data2 = self.datas[index * 2 + 2]
	obj:initData(data, data2, index, NAME_TYPE.TECH)
end
return Com_WTV_tech

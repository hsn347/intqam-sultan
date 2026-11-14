local equipmentltCtrl = include("equipmentltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_show = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WeaponEnhance/Com_show", Com_show)
function Com_show:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_show:onShow()
end
function Com_show:onItemRenderer(index, obj)
	obj:initData(self.data[index + 1], self.quality)
end
function Com_show:initData(quality, data)
	self.quality = quality
	self.fields.com_title:initData(quality)
	self.data, _ENV = self.fields.com_title.initData, self.fields.com_title.initData
	for k, v in ipairs(data) do
		_ENV = nil
		;(nil).sType = 0
		;(nil).lv = v.level
		;(nil).slv = v.slv
		;(nil).nextSlv = equipmentltCtrl.getNextSumLv(quality, v.level, v.slv)
		table.insert(self.data, nil)
		local growth = equipmentltCtrl.getGrowth(quality, v.level, v.slv)
		if growth then
			for ki, vi in ipairs(growth) do
				_ENV = nil
				;(nil).sType = 1
				;(nil).buffType = vi.buffType
				;(nil).buffVal = vi.buffVal
				table.insert(self.data, nil)
			end
		else
			_ENV = ipairs(growth)
			ipairs(growth).sType = 2
			table.insert(self.data, ipairs(growth))
		end
	end
	self.fields.List:setNumItems(#self.data)
end
return Com_show

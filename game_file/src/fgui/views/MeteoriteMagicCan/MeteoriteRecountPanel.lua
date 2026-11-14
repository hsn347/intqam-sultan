local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MeteoriteRecountPanel = class("MeteoriteRecountPanel", baseFguiPanel)
local meteorMagicCtrl = SoraDGetCtrl("meteorMagicCtrl")
local meteorMagicRead = include("meteorMagicRead")
function MeteoriteRecountPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("MeteoriteRecountPanel:ctor", self.viewName)
end
function MeteoriteRecountPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MeteoriteRecountPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======MeteoriteRecountPanel:onInit")
	self.fields.Com_title:initData(i18n("meteoritesmagic_text_29"), handler(self, self.onClickClose))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
end
function MeteoriteRecountPanel:onShow()
	print("=======MeteoriteRecountPanel:onShow")
	self.curProjectID = self.param.curProjectID
	self.allRecountData, _ENV, self.buffList = meteorMagicCtrl:getBuffListByProjectID(self.curProjectID), meteorMagicCtrl:getBuffListByProjectID(self.curProjectID), meteorMagicCtrl:getBuffListByProjectID(self.curProjectID)
	_ENV = self.curProjectID
	self.curProjectID.title = i18n("meteoritesmagic_text_30")
	table.insert(self.allRecountData, self.curProjectID)
	local _ENV, tmpData = table.insert, table.insert
	for k, v in pairs(self.buffList) do
		for k1, v1 in pairs(v) do
			if not tmpData[k1] then
				tmpData[k1] = 0
			end
			tmpData[k1] = tmpData[k1] + v1
		end
	end
	local _ENV, tmpData2 = (for generator), pairs(self.buffList)
	for k1, v1 in pairs(tmpData) do
		_ENV = nil
		;(nil).buffType = k1
		;(nil).effectType = meteorMagicRead.getBuffEffectType(k1)
		;(nil).value = v1
		;(nil).order = meteorMagicRead.getBuffOrder(k1)
		table.insert(tmpData2, nil)
	end
	table.sort(tmpData2, function(a, b)
		return a.order < b.order
	end)
	for i, v in ipairs(tmpData2) do
		table.insert(self.allRecountData, v)
	end
	for k, v in pairs(self.buffList) do
		print(k, "k = = = =")
		local title = meteorMagicRead.getMagicTree(k).name
		_ENV = meteorMagicRead.getBuffOrder(k1)
		meteorMagicRead.getBuffOrder(k1).title = i18n(title)
		table.insert(self.allRecountData, (meteorMagicRead.getBuffOrder(k1)))
		local _ENV, tmpData = table.insert, table.insert
		for k1, v1 in pairs(v) do
			meteorMagicCtrl = nil
			;(nil)[1] = k1
			;(nil)[2] = meteorMagicRead.getBuffEffectType(k1)
			;(nil)[3] = meteorMagicRead.getBuffEffectType(k1)
			dump(nil, "meteorMagicRead.getBuffEffectType(k1)")
			_ENV = "meteorMagicRead.getBuffEffectType(k1)"
			;("meteorMagicRead.getBuffEffectType(k1)").buffType = k1
			;("meteorMagicRead.getBuffEffectType(k1)").effectType = meteorMagicRead.getBuffEffectType(k1)
			;("meteorMagicRead.getBuffEffectType(k1)").value = v1
			;("meteorMagicRead.getBuffEffectType(k1)").order = meteorMagicRead.getBuffOrder(k1)
			table.insert(tmpData, "meteorMagicRead.getBuffEffectType(k1)")
		end
		table.sort(tmpData, function(a, b)
			return a.order < b.order
		end)
		for i, v in ipairs(tmpData) do
			table.insert(self.allRecountData, v)
		end
	end
	self.fields.scroll:setNumItems(#self.allRecountData)
end
function MeteoriteRecountPanel:onItemRenderer(index, obj)
	local realIdx = self.allRecountData[index + 1].title == nil and index or index + 1
	obj:initData(self.allRecountData[index + 1], realIdx % 2 ~= 0)
end
return MeteoriteRecountPanel

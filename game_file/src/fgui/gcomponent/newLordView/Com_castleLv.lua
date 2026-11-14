local buildLogic = include("buildLogic")
local cityltCtrl = include("cityltCtrl")
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local divineBeastRead = include("divineBeastRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_castleLv = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_castleLv", Com_castleLv)
function Com_castleLv:onInit()
	self:fixChildrenPos()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_castleLv:onShow()
end
function Com_castleLv:initData(data, isSelf)
	self.textDats, _ENV = nil, nil
	local castlelv = isSelf and SoraDGetCastleLv() or data.base.castlelv or 0
	local warLv = buildLogic.transformBuildLvToWarLv(castlelv)
	local starLv = isSelf and SoraDGetBuildStarLv() or data.base.starLv or 0
	local jinnOne = isSelf and magicLampCtrl:getJinnLv(gJinnType.JINN_ONE) or data.base.jinnList and data.base.jinnList["1"] and data.base.jinnList["1"].lv or 0
	local jinnTwo = isSelf and magicLampCtrl:getJinnLv(gJinnType.JINN_TWO) or 0
	local divineID = divineBeastRead.getDefaultDivineID()
	local beastStepLv = isSelf and divineBeastCtrl:getStepLv(divineID) or -1
	magicLampCtrl = divineID
	divineID[1] = divineBeastCtrl:getIsUnlock(divineID)
	divineID[2] = divineID
	dump(divineID, "divineBeastCtrl:getIsUnlock")
	dump(beastStepLv, "beastStepLv")
	_ENV = beastStepLv
	beastStepLv.castlelv = castlelv
	beastStepLv.warLv = warLv
	beastStepLv.starLv = starLv
	beastStepLv.jinnOne = jinnOne
	beastStepLv.jinnTwo = jinnTwo
	beastStepLv.beastStepLv = beastStepLv
	dump(beastStepLv, "Com_castleLv:initData")
	dump(data, "Com_castleLv:initData")
	if warLv == 0 then
		_ENV = "Com_castleLv:initData"
		;("Com_castleLv:initData").icon = "icon_castle.png"
		;("Com_castleLv:initData").text = castlelv
		table.insert(self.textDats, "Com_castleLv:initData")
	end
	if 0 < warLv then
		_ENV = "Com_castleLv:initData"
		;("Com_castleLv:initData").icon = "301101.png"
		;("Com_castleLv:initData").text = warLv
		table.insert(self.textDats, "Com_castleLv:initData")
	end
	if 0 < starLv then
		_ENV = "Com_castleLv:initData"
		;("Com_castleLv:initData").icon = cityltCtrl.getBuildStarImage(starLv)
		;("Com_castleLv:initData").text = starLv
		table.insert(self.textDats, "Com_castleLv:initData")
	end
	if 0 < jinnOne then
		_ENV = "Com_castleLv:initData"
		;("Com_castleLv:initData").icon = "icon_xinxi_sdyd.png"
		;("Com_castleLv:initData").text = jinnOne
		table.insert(self.textDats, "Com_castleLv:initData")
	end
	if 0 <= beastStepLv then
		_ENV = "Com_castleLv:initData"
		;("Com_castleLv:initData").icon = "icon_junwang_shenshou.png"
		;("Com_castleLv:initData").text = beastStepLv
		table.insert(self.textDats, "Com_castleLv:initData")
	end
	if 0 < jinnTwo then
		_ENV = "Com_castleLv:initData"
		;("Com_castleLv:initData").icon = "icon_junwang_shendeng.png"
		;("Com_castleLv:initData").text = jinnTwo
		table.insert(self.textDats, "Com_castleLv:initData")
	end
	self.fields.list:setNumItems(#self.textDats)
end
function Com_castleLv:onItemRenderer(index, obj)
	local data = self.textDats[index + 1]
	obj:fixChildrenPos()
	obj:setIcon(data.icon)
	obj:setTitle(data.text)
end
return Com_castleLv

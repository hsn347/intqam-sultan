local cityCtrl = SoraDGetCtrl("cityCtrl")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local buildLogic = include("buildLogic")
local buildRead = include("buildDescribeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local cityInfoViewPanel = class("cityInfoViewPanel", baseFguiPanel)
function cityInfoViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("cityInfoViewPanel:ctor", self.viewName)
end
function cityInfoViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function cityInfoViewPanel:onInit()
	print("=======cityInfoViewPanel:onInit")
	self.tableRes, _ENV, self.isHideCurrentSceneView = print, print, true
	self.fields.Com_title:initData("", handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
end
function cityInfoViewPanel:onListRenderer(index, obj)
	obj:initData(self.tableRes[index + 1])
end
function cityInfoViewPanel:onShow()
	print("=======cityInfoViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	local warLv = SoraDGetCastleWarLv()
	if 0 < warLv then
		_ENV = nil
		;(nil).build = buildRead.getName(BUILDID.CASTLE)
		;(nil).lv = warLv
		self.fields.Com_title:updateTitle(i18n("common_text_1957", nil))
	else
		_ENV = i18n("common_text_1957", nil)
		i18n("common_text_1957", nil).name = buildRead.getName(BUILDID.CASTLE)
		i18n("common_text_1957", nil).lv = SoraDGetCastleLv()
		self.fields.Com_title:updateTitle(i18n("common_text_334", i18n("common_text_1957", nil)))
	end
	self:initData()
end
function cityInfoViewPanel:initData()
	_UPVALUE5_ = nil
	;(nil)[1] = gIDDef.WOOD
	;(nil)[2] = gIDDef.FOOD
	;(nil)[3] = gIDDef.IRON
	;(nil)[4] = gIDDef.MITHRIL
	local (nil)[5], tableResType = gIDDef.CRYSTAL, nil
	local resCountTable = self:returnResCount(tableResType)
	local _ENV, resData = self, self
	for i, v in ipairs(tableResType) do
		_ENV = nil
		;(nil).resid = v
		;(nil).resper = resCountTable[v]
		;(nil).islock = not SoraDResIsLock(v)
		table.insert(resData, nil)
	end
	self.tableRes = resData
	self.fields.List:setNumItems(#self.tableRes)
end
function cityInfoViewPanel:returnResCount(tableResType)
	local _ENV, reTable
	for _, resid in pairs(tableResType) do
		reTable[resid] = 0
		local bid = buildLogic.getBuildID(resid)
		local bCellList = cityCtrl:getBuildCellList(bid)
		for k, v in pairs(bCellList) do
			local buildData = buildLogic.getResOutputHour(tonumber(v.info.bid), tonumber(v.info.lv), tonumber(v.info.iid))
			reTable[resid] = reTable[resid] + buildData.total
		end
	end
	return reTable
end
return cityInfoViewPanel

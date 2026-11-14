local footballElfRead = include("footballElfRead")
local footballElfCtrl = SoraDGetCtrl("footballElfCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_elfSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://FootballSpirit/Com_elfSingle", Com_elfSingle)
function Com_elfSingle:onInit()
	self.fields.mv_gj:setAllFrameName("dh_shijiebeik_%.2d.png", 1)
	self.isOnlyShow = false
	self.fields.list_free:setItemRenderer(handler(self, self.onItemFreeRenderer))
	self.fields.list_pay:setItemRenderer(handler(self, self.onItemPayRenderer))
	self:fixChildrenPos()
	self.fields.n27:fix()
	self.fields.mv_gj:fix()
end
function Com_elfSingle:onShow()
end
function Com_elfSingle:onItemFreeRenderer(index, obj)
	obj:initData(self.normalReward[index + 1], self.level, false, self.isOnlyShow)
end
function Com_elfSingle:onItemPayRenderer(index, obj)
	obj:initData(self.seniorReward[index + 1], self.level, true, self.isOnlyShow)
end
function Com_elfSingle:initData(data)
	self.level = data.level
	self.isOnlyShow = false
	self.fields.title:setString(self.level)
	_UPVALUE2_ = self.level
	self.level[1] = "id"
	self.level[2] = "count"
	self.normalReward = serviceFunctions.tableFormat(data.normalReward, self.level)
	_UPVALUE2_ = self.level
	self.level[1] = "id"
	self.level[2] = "count"
	self.seniorReward = serviceFunctions.tableFormat(data.seniorReward, self.level)
	self.fields.list_free:setNumItems(#self.normalReward)
	self.fields.list_pay:setNumItems(#self.seniorReward)
	self.fields.mv_gj:setVisible(true)
	self.controllers.c1:setSelectedIndex(self.level % 2 == 1 and 0 or 1)
end
function Com_elfSingle:initExtra()
	self.isOnlyShow = true
	local maxCfgLv = footballElfRead.getMaxExpCfgLv(footballElfCtrl:getClassType())
	local lv, leftExp, nextExp = footballElfRead.getExpLv(footballElfCtrl:getExp(), footballElfCtrl:getClassType())
	local next5Lv = math.max(5, math.ceil(lv / 5) * 5)
	if lv % 5 == 0 then
		next5Lv = (math.ceil(lv / 5) + 1) * 5
	else
		next5Lv = math.ceil(lv / 5) * 5
	end
	local showLv = math.min(next5Lv, maxCfgLv)
	self.level = showLv
	local cfgList = footballElfRead.getExpCfg(footballElfCtrl:getClassType())
	print("showLv====", showLv, maxCfgLv, lv, next5Lv)
	local data = cfgList[showLv]
	if maxCfgLv <= lv and 0 <= leftExp then
		self.fields.title:setString(showLv .. "+")
	else
		self.fields.title:setString(showLv)
	end
	_ENV = showLv
	showLv[1] = "id"
	showLv[2] = "count"
	self.normalReward = serviceFunctions.tableFormat(data.normalReward, showLv)
	_ENV = showLv
	showLv[1] = "id"
	showLv[2] = "count"
	self.seniorReward = serviceFunctions.tableFormat(data.seniorReward, showLv)
	self.fields.list_free:setNumItems(#self.normalReward)
	self.fields.list_pay:setNumItems(#self.seniorReward)
	self.fields.mv_gj:setVisible(false)
	self.controllers.c1:setSelectedIndex(2)
end
return Com_elfSingle

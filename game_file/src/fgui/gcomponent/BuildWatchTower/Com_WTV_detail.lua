local baseComponent = require("fgui.base.baseComponent")
local Com_WTV_detail = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWatchTower/Com_WTV_detail", Com_WTV_detail)
function Com_WTV_detail:onInit()
end
function Com_WTV_detail:onShow()
end
function Com_WTV_detail:initMassData(myQueueObj, slaveQueue)
	_UPVALUE1_ = nil
	self.queueDatas, (nil)[1] = nil, myQueueObj
	self.fields.list:setVisible(true)
	self.fields.bg:setVisible(false)
	self.fields.txt_noarmy:setVisible(false)
	for k, v in pairs(slaveQueue) do
		table.insert(self.queueDatas, v:getFilterDataByWatchTower())
	end
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onMassItemRenderer))
	self.fields.list:setNumItems(#self.queueDatas)
	local totalArmyNum = 0
	for i, v in ipairs(self.queueDatas) do
		local _data = v:getFrom()
		if _data then
			totalArmyNum = totalArmyNum + (_data.totalCount or 0)
		end
	end
	return totalArmyNum
end
function Com_WTV_detail:initSingleData(myQueueObj)
	local armyData = myQueueObj:getFromArmy()
	if armyData and next(armyData) then
		self.fields.list:setVisible(true)
		self.fields.bg:setVisible(false)
		self.fields.txt_noarmy:setVisible(false)
		_UPVALUE1_ = self.fields.txt_noarmy.setVisible
		self.singleDats, self.fields.txt_noarmy.setVisible[1] = self.fields.txt_noarmy.setVisible, myQueueObj
		self.fields.list:setItemRenderer(handler(self, self.onSingleItemRender))
		self.fields.list:setNumItems(#self.singleDats)
	else
		self.fields.list:setVisible(false)
		self.fields.bg:setVisible(true)
		self.fields.txt_noarmy:setVisible(true)
		_ENV = handler(self, self.onSingleItemRender)
		handler(self, self.onSingleItemRender).level = WATCH_TOWER_VIEW_ARMYCLASS
		self.fields.txt_noarmy:setString(i18n("common_text_596", handler(self, self.onSingleItemRender)))
	end
end
function Com_WTV_detail:clearAll()
	self.fields.list:setItemRenderer(handler(self, self.onSingleItemRender))
	self.fields.list:setNumItems(0)
end
function Com_WTV_detail:onMassItemRenderer(index, obj)
	local data = self.queueDatas[index + 1]
	obj:initMassArmyData(data, false)
end
function Com_WTV_detail:onSingleItemRender(index, obj)
	local data = self.singleDats[index + 1]
	obj:initSingleArmyData(data, false)
end
return Com_WTV_detail

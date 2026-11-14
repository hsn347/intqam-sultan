local deadArmyDetailView = class("deadArmyDetailView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("deadArmyDetailView")
	end
	return target
end)
function deadArmyDetailView:ctor()
	_ENV = nil
	;(nil)[gDeadArmySource.battle] = "common_text_4733"
	;(nil)[gDeadArmySource.woundedArmyFull] = "common_text_4734"
	self.titleCfg, (nil)[gDeadArmySource.batteryAttack] = nil, "common_text_4735"
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_4736"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_army")
	self.Node_title = SoraDGetChildByName(self.scroll, "Node_title")
	SoraDGetChildByName(self.Node_title, "Text_army"):setString(i18n("recharge_label_003"))
	SoraDGetChildByName(self.Node_title, "Text_num"):setString(i18n("common_text_2507"))
	self.Node_title:setVisible(false)
	self.Node_army = SoraDGetChildByName(self.scroll, "Node_army")
	self.Node_army:setVisible(false)
end
function deadArmyDetailView:initData(data)
	local sourceNum = 0
	local armyNum = 0
	local _ENV, tableList
	for k, v in pairs(gDeadArmySource) do
		if data[tostring(v)] then
			sourceNum = sourceNum + 1
			tableList[v], _ENV, armyNum = table.nums(data[tostring(v)]), table.nums(data[tostring(v)]), armyNum + table.nums(data[tostring(v)])
			for ki, vi in pairs(data[tostring(v)]) do
				_ENV = nil
				;(nil).id = tonumber(ki)
				;(nil).count = vi
				table.insert(tableList[v], nil)
			end
			table.sort(tableList[v], function(a, b)
				return a.id < b.id
			end)
		end
	end
	local scrollH = math.max(self.scroll:getContentSize().height, 90 * sourceNum + 90 * armyNum)
	self.scroll:setInnerContainerSize(cc.size(533, scrollH))
	local t_index = 1
	local a_index = 1
	local aCount = 0
	_UPVALUE3_ = cc.size(533, scrollH)
	cc.size(533, scrollH)[1] = gDeadArmySource.battle
	cc.size(533, scrollH)[2] = gDeadArmySource.woundedArmyFull
	local cc.size(533, scrollH)[3], showList = gDeadArmySource.batteryAttack, cc.size(533, scrollH)
	for k, v in ipairs(showList) do
		if tableList[v] then
			local node_title = t_index == 1 and self.Node_title or self.Node_title:clone()
			node_title:setVisible(true)
			if 1 < t_index then
				node_title:addTo(self.scroll)
			end
			local Text_dead = SoraDGetChildByName(node_title, "Text_dead")
			Text_dead:setString(i18n(self.titleCfg[v]))
			node_title:setPositionY(scrollH - 90 * t_index - 90 * aCount)
			for ki, vi in ipairs(tableList[v]) do
				local node_army = a_index == 1 and self.Node_army or self.Node_army:clone()
				node_army:setVisible(true)
				if 1 < a_index then
					node_army:addTo(self.scroll)
				end
				local text_dead = SoraDGetChildByName(node_army, "text_dead")
				text_dead:setString(string.formatnumberthousands(vi.count))
				local nodeArmy = SoraDGetExtendChildFromCCSByName(node_army, "CCS_commonArmySingle_node")
				_ENV = string.formatnumberthousands(vi.count)
				string.formatnumberthousands(vi.count).id = vi.id
				nodeArmy:initData(string.formatnumberthousands(vi.count))
				node_army:setPositionY(scrollH - 90 * t_index - 90 * a_index)
				a_index = a_index + 1
			end
			t_index = t_index + 1
			aCount = aCount + #tableList[v]
		end
	end
end
return deadArmyDetailView

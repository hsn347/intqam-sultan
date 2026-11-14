local baseComponent = require("fgui.base.baseComponent")
local Activity_9001619_Node_single = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001619_Read = include("activity_9001619_Read")
fgui.register_extension("ui://Activity_9001619/Activity_9001619_Node_single", Activity_9001619_Node_single)
function Activity_9001619_Node_single:onInit()
	self:fixChildrenPos(true)
end
function Activity_9001619_Node_single:onShow()
end
function Activity_9001619_Node_single:initData(data)
	local lampInfo = data
	dump(lampInfo, "lampInfo", 10)
	if lampInfo then
		local isGold = index == 1
		do
			local tableItem = SoraDGetChildsArrayByName(self, "CCS_starRhapsodyLamp_award_", 3, 1, true)
			for i, v in ipairs(tableItem) do
				if lampInfo.colorComb[i] then
					v:setLampColor(lampInfo.colorComb[i], isGold)
				end
			end
		end
		do
			local tableItem = SoraDGetChildsArrayByName(self, "CCS_commonItemAward_", 4, 1, true)
			for i, v in ipairs(tableItem) do
				local item = lampInfo.reward[i]
				if item then
					v:setVisible(true)
					v:initData(item.id, item.count)
				else
					v:setVisible(false)
				end
			end
		end
		local nodeGold = SoraDGetChildByName(self, "Node_title_gold")
		local nodeNormal = SoraDGetChildByName(self, "Node_title_normal")
		nodeGold:setVisible(isGold)
		nodeNormal:setVisible(not isGold)
		local txtTitleLevel
		if isGold then
			txtTitleLevel = SoraDGetChildByName(nodeGold, "Text_title_level")
		else
			txtTitleLevel = SoraDGetChildByName(nodeNormal, "Text_title_level")
		end
		local name = activity_9001619_Read:getAwardNmae(lampInfo.type)
		txtTitleLevel:setString(name)
	end
end
return Activity_9001619_Node_single

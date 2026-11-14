local allianceDesRead = include("allianceDesRead")
local allianceWarehouseUseSingle = class("allianceWarehouseUseSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceWarehouseUseSingle")
	end
	return target
end)
function allianceWarehouseUseSingle:ctor()
	self.itemArray, _ENV = nil, nil
	self.ccs_head = SoraDGetExtendChildFromCCSByName(self, "CCS_commonHead_head")
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Node_cost = SoraDGetChildByName(self, "Node_cost")
	self.Node_res = SoraDGetChildByName(self, "Node_res")
	self.itemArray[1] = self.Node_res
end
function allianceWarehouseUseSingle:getSingleH()
	return self.isShowTime and 150 or 110
end
function allianceWarehouseUseSingle:initData(data)
	self.isShowTime = data.isShowTime or false
	self.Node_time:setVisible(self.isShowTime)
	self.ccs_head:setScale(1.0)
	self.ccs_head:setHeadSprite(data.iconID, data.avatar)
	self.ccs_head:setPlayerID(data.uid)
	self.Text_time:setString(data.date)
	_ENV = nil
	;(nil).var1 = data.nickName
	;(nil).var2 = allianceDesRead.getBuildName(data.bid)
	self.Text_des:setString(i18n("alliance_stronghold_text_005", nil))
	local _ENV, costRes = self.Text_des.setString, self.Text_des.setString
	costRes[gIDDef.ALLIANCE_SCORE] = data.costBonus
	for k, v in ipairs(data.costRes) do
		costRes[v.id] = v.count
	end
	_ENV, _ENV = ipairs(data.costRes)
	ipairs(data.costRes).id = gIDDef.FOOD
	ipairs(data.costRes).png = "icon_small_food.png"
	_ENV, ipairs(data.costRes)[1], ipairs(data.costRes).scale = ipairs(data.costRes)
	ipairs(data.costRes).id = gIDDef.WOOD
	ipairs(data.costRes).png = "icon_small_wood.png"
	_ENV, ipairs(data.costRes)[2], ipairs(data.costRes).scale = ipairs(data.costRes)
	ipairs(data.costRes).id = gIDDef.IRON
	ipairs(data.costRes).png = "icon_small_iron.png"
	_ENV, ipairs(data.costRes)[3], ipairs(data.costRes).scale = ipairs(data.costRes)
	ipairs(data.costRes).id = gIDDef.MITHRIL
	ipairs(data.costRes).png = "icon_small_silver.png"
	_ENV, ipairs(data.costRes)[4], ipairs(data.costRes).scale = ipairs(data.costRes)
	ipairs(data.costRes).id = gIDDef.ALLIANCE_SCORE
	ipairs(data.costRes).png = "icon_alliance_point.png"
	ipairs(data.costRes)[5], ipairs(data.costRes).scale = ipairs(data.costRes)
	local costIDArray = ipairs(data.costRes)
	for k, v in ipairs(self.itemArray) do
		v:setVisible(false)
	end
	for k, v in ipairs(costIDArray) do
		if self.itemArray[k] then
			self.itemArray[k]:setVisible(true)
		else
			self.itemArray[k] = self.Node_res:clone()
			self.itemArray[k]:setPosition(0, 0)
			self.itemArray[k]:addTo(self.Node_cost)
		end
		local icon_res = SoraDGetChildByName(self.itemArray[k], "icon_res")
		local Text_res = SoraDGetChildByName(self.itemArray[k], "Text_res")
		icon_res:setSpriteFrame(v.png)
		icon_res:setScale(v.scale)
		local costNum = costRes[v.id] or 0
		Text_res:setString("-" .. SoraDConvertNumberWithUnit(costNum))
		self.itemArray[k]:setPosition(SoraDFPosX(-90 * (k - 1), 0), 0)
	end
end
return allianceWarehouseUseSingle

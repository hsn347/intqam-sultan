local baseComponent = require("fgui.base.baseComponent")
local allianceWarehouseUseSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceWarehouseView/allianceWarehouseUseSingle", allianceWarehouseUseSingle)
local allianceDesRead = include("allianceDesRead")
function allianceWarehouseUseSingle:onInit()
	self:fixChildrenPos()
	self.itemArray, _ENV = self.fixChildrenPos, self.fixChildrenPos
	self.ccs_head = SoraDGetChildByName(self, "CCS_commonHead_head")
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Text_cost = SoraDGetChildByName(self, "Text_cost")
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Node_cost = SoraDGetChildByName(self, "Node_cost")
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
end
function allianceWarehouseUseSingle:onShow()
end
function allianceWarehouseUseSingle:getSingleH()
	return self.isShowTime and 150 or 110
end
function allianceWarehouseUseSingle:initData(data)
	self.isShowTime = data.isShowTime or false
	self.Node_time:setVisible(self.isShowTime)
	self.ccs_head:setHeadSprite(data.iconID, data.avatar)
	self.ccs_head:setPlayerID(data.uid)
	self.Text_cost:setString(i18n("worldboss_text_03"))
	self.Text_time:setString(data.date)
	_ENV = i18n("worldboss_text_03")
	i18n("worldboss_text_03").var1 = data.nickName
	i18n("worldboss_text_03").var2 = allianceDesRead.getBuildName(data.bid)
	self.Text_des:setString(i18n("alliance_stronghold_text_005", i18n("worldboss_text_03")))
	local _ENV, costRes = self.Text_des.setString, self.Text_des.setString
	costRes[gIDDef.ALLIANCE_SCORE] = data.costBonus
	for k, v in ipairs(data.costRes) do
		costRes[v.id] = v.count
	end
	_ENV, _ENV, self.costRes = ipairs(data.costRes)
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
	self.costIDArray = costIDArray
	self.fields.list:setNumItems(#self.costIDArray)
end
function allianceWarehouseUseSingle:onItemRenderer(index, obj)
	local v = self.costIDArray[index + 1]
	obj:fixChildrenPos(true)
	local icon_res = SoraDGetChildByName(obj, "icon_res")
	local Text_res = SoraDGetChildByName(obj, "Text_res")
	icon_res:setSpriteFrame(v.png)
	icon_res:setScale(v.scale)
	local costNum = self.costRes[v.id] or 0
	Text_res:setString("-" .. SoraDConvertNumberWithUnit(costNum))
end
return allianceWarehouseUseSingle

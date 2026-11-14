local pickupStarsAgainRead = include("pickupStarsAgainRead")
local pickupStarsAgainCtrl = SoraDGetCtrl("pickupStarsAgainCtrl")
local findMonsterCtrl = SoraDGetCtrl("findMonsterCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local PickupStarsAgainMainCollection = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://PickupStarsAgain/PickupStarsAgainMainCollection", PickupStarsAgainMainCollection)
function PickupStarsAgainMainCollection:onInit()
	self.fields.Button_explore:setString(i18n("pickup_star_027"))
	self.fields.Text_reward:setString(i18n("pickup_star_009"))
	self.fields.Button_explore:addClickListener(handler(self, self.onClickExplore))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_explore:getGroup():ensureBoundsCorrect()
end
function PickupStarsAgainMainCollection:onClickExplore()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	if kingdomMapCtrl:hasDesertMeteoriteQueue() then
		SoraDShowMsgTip(i18n("pickup_star_029"))
		return
	end
	local cityPos = cityCtrl:getCurCityPos()
	findMonsterCtrl:sendSearchMapType(gMapObjTypeDef.desertMeteorite, nil, nil, nil, nil, cityPos.x, cityPos.y, nil, true)
end
function PickupStarsAgainMainCollection:onItemRenderer(index, obj)
	obj:initData(self.rewards[2 * index + 1], self.rewards[2 * index + 2])
end
function PickupStarsAgainMainCollection:onShow()
end
function PickupStarsAgainMainCollection:updateUI()
	self.fields.Text_desc:setString(i18n("pickup_star_008"))
	self.rewards, _ENV = self.fields.Text_desc.setString, self.fields.Text_desc.setString
	local desertMeteoriteList = pickupStarsAgainRead:getDesetMeteorites()
	for _, v in ipairs(desertMeteoriteList) do
		table.merge(self.rewards, v.Reward)
	end
	self.fields.List_reward:setNumItems(#self.rewards / 2)
	local exploreLeftTime = pickupStarsAgainCtrl:getExploreLeftTime()
	_ENV = table.merge
	table.merge.time = SoraDConvertSecondToString(exploreLeftTime)
	self.fields.Text_exploreTime:setString(i18n("pickup_star_010", table.merge))
	self.fields.Button_explore:setTouchable(0 < exploreLeftTime)
	self.fields.Button_explore:setReddot(pickupStarsAgainCtrl:canExploreDesertMeteorite())
	self.fields.Button_explore:setGrayed(exploreLeftTime <= 0)
end
return PickupStarsAgainMainCollection

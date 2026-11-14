local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local babelTowerCtrl = SoraDGetCtrl("babelTowerCtrl")
local babelTowerRead = gModuleMgr.sharedMgr("babelTowerRead")
local babelTowerFloorAward = class("babelTowerFloorAward", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("babelTowerFloorAward")
end)
function babelTowerFloorAward:ctor(properties)
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.textMonterName = SoraDGetChildByName(self.node, "Text_monterName")
	self.textMonterTalk = SoraDGetChildByName(self.node, "Text_monterTalk")
	self.textMonterTalk:setString(i18n("Promise_Summit_text_64"))
	self.scrollItem = SoraDGetChildByName(self.node, "ScrollView_list")
	self.scrollItem = include("commonAutoScrollList").new(self.scrollItem)
	self.scrollItem:setSingleCreate(handler(self, self.createSingle))
	self.scrollItem:setSingleRefresh(handler(self, self.refreshSingle))
	self.nodeSingle = SoraDGetChildByName(self.node, "Node_Single")
	self.panelInside = SoraDGetChildByName(self, "Node_other")
	self.title = SoraDGetChildByName(self, "Text_title")
	self.title:setString(i18n("Promise_Summit_text_16"))
	self.txtOther = SoraDGetChildByName(self, "Text_other")
	self.txtOther:setString(i18n("Promise_Summit_text_41"))
	self.txtOtherTip = SoraDGetChildByName(self.panelInside, "Text_Floor")
	self.txtFloorTitle = SoraDGetChildByName(self, "Text_floor")
	self.txtFloorTitle:setString(i18n("Promise_Summit_text_63"))
	self:addButterfly()
end
function babelTowerFloorAward:initData(floor)
	self.awardList = babelTowerRead:getTowerAward()
	self.scrollItem:updateScrollView(cc.size(500, 100), self.awardList, 1)
	self.nowFloor = floor
	self.maxNum = babelTowerRead:getTowerNum()
	local tmpFloor = math.ceil(floor / 10) * 10
	tmpFloor = math.min(self.maxNum, tmpFloor)
	self.curPage = tmpFloor * 0.1
	self:initAwardNode(self.panelInside)
	babelTowerRead = nil
	;(nil).num = self.curPage * 10
	self.txtOtherTip:setString(i18n("Promise_Summit_text_17", nil))
end
function babelTowerFloorAward:refreshSingle(parent, data)
	dump(data, "data", 10)
	local textFloor = SoraDGetChildByName(parent, "Text_Floor")
	local textAwardTitle = SoraDGetChildByName(parent, "Text_AwardTitle")
	local nodeAward = SoraDGetChildByName(parent, "Node_Award")
	textAwardTitle:setString(i18n("Promise_Summit_text_12"))
	_ENV = i18n("Promise_Summit_text_12")
	i18n("Promise_Summit_text_12").num1 = data.floor[1]
	i18n("Promise_Summit_text_12").num2 = data.floor[2]
	textFloor:setString(i18n("Promise_Summit_text_39", i18n("Promise_Summit_text_12")))
	_UPVALUE2_ = i18n("Promise_Summit_text_39", i18n("Promise_Summit_text_12"))
	i18n("Promise_Summit_text_39", i18n("Promise_Summit_text_12"))[1] = "id"
	i18n("Promise_Summit_text_39", i18n("Promise_Summit_text_12"))[2] = "count"
	local rewardList = serviceFunctions.tableFormat(data.boxReward, i18n("Promise_Summit_text_39", i18n("Promise_Summit_text_12")))
	local rewardNodeList = nodeAward:getChildren()
	for i, v in ipairs(rewardList) do
		local single
		if rewardNodeList[i] then
			single = rewardNodeList[i]
		else
			single = include("commonItemAward").new()
			single:setPosition(0, 0)
			single:setScale(0.55)
			single:setBaseScale(1.0)
			single:setOwnScroll(self.scrollItem)
			single:addTo(nodeAward)
		end
		single:initData(v.id, v.count)
	end
	SoraDToCenter(nodeAward, 80, SoraDFIsRA())
end
function babelTowerFloorAward:createSingle()
	local single = self.nodeSingle:clone()
	return single
end
function babelTowerFloorAward:addButterfly()
	local spBufffly = display.newSprite("dh_xuyuanshuhd_00.png")
	spBufffly:addTo(self.node)
	spBufffly:setPosition(-100, 340)
	local frames = display.newFrames("dh_xuyuanshuhd_%.2d.png", 0, 21)
	local animation = display.newAnimation(frames, 2.45 / #frames)
	spBufffly:playAnimationForever(animation)
end
function babelTowerFloorAward:initAwardNode(parent)
	_UPVALUE2_ = babelTowerRead
	babelTowerRead[1] = "id"
	babelTowerRead[2] = "count"
	self.reward = serviceFunctions.tableFormat(babelTowerRead:getBoxReward(self.curPage * 10), babelTowerRead)
	local nodeAward = SoraDGetChildByName(parent, "Node_Award")
	nodeAward:removeAllChildren()
	if next(self.reward) then
		for i, v in ipairs(self.reward) do
			local single = include("commonItemAward").new()
			single:setScale(0.55)
			single:setOwnView(self)
			single:setPosition(0, 0)
			single:addTo(nodeAward)
			single:initData(v.id, v.count)
		end
	end
	SoraDautoSortPos(nodeAward, 4, 1, cc.size(80, 100), SoraDFIsRA())
end
return babelTowerFloorAward

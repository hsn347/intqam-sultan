local raidersLostArkRewardListView = class("raidersLostArkRewardListView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("raidersLostArkRewardListView")
	end
	return target
end)
local raidersLostArkRead = include("raidersLostArkRead")
local publicRead = include("publicRead")
local raidersLostArkCtrl = SoraDGetCtrl("raidersLostArkCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local MAX_AWARD_NUM = 8
function raidersLostArkRewardListView:ctor()
	self:initControls()
end
function raidersLostArkRewardListView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function raidersLostArkRewardListView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.awardArray, _ENV = SoraDGetAllChildFromWidget, SoraDGetAllChildFromWidget
	self.text_ins:setString(i18n("Martial_arts_text_05"))
	self.image_box:setContentSize(cc.size(326, 294))
	self.image_box:setScale(0.8)
	self.image_box:setPositionY(self.image_box:getPositionY() + 50)
	self.activityID = gActivityTimeActivityID.RAIDERS_LOST_ARK
end
function raidersLostArkRewardListView:initData(chooseIndex)
	self.chooseIndex = chooseIndex
	if not self.chooseIndex then
		return
	end
	local chestInfo = raidersLostArkRead:getTreasureChestInfo(self.chooseIndex)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local rewardList = serviceFunctions.tableFormat(chestInfo.reward, nil)
	self.image_box:loadTexture(chestInfo.icon, ccui.TextureResType.plistType)
	local rowNum = math.ceil(#rewardList / 4)
	local maxHeight = (rowNum - 1) * 110 + 110
	local panelHeight = SoraDGetChildByName(self.Image_14, "panelHeight")
	panelHeight:setHeight(maxHeight)
	self.Image_14:getScrollPane().isCustomInnerContainerSize = false
	self.Image_14:EnsureBoundsCorrect()
	for k, v in ipairs(rewardList) do
		if not self.awardArray[k] then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setName("award_" .. k)
			self.awardArray[k]:setScale(1.0)
			self.awardArray[k]:setBaseScale(1.0)
			self.awardArray[k]:setOwnView(self)
			self.awardArray[k]:setPosition(SoraDFIsRA() and 62 + (3 - (k - 1) % 4) * 135 or 62 + (k - 1) % 4 * 135, maxHeight - (math.ceil(k / 4) - 1) * 110 - 50)
			self.awardArray[k]:addTo(self.Image_14)
		end
		if self.awardArray[k] then
			self.awardArray[k]:initData(v.id, v.count)
		end
	end
	if #self.awardArray > #rewardList then
		for k = #self.awardArray, #rewardList + 1, -1 do
			self.awardArray[k]:setVisible(false)
		end
	end
end
function raidersLostArkRewardListView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return raidersLostArkRewardListView

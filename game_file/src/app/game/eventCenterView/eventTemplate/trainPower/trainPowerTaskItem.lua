local trainPowerCtrl = SoraDGetCtrl("trainPowerCtrl")
local eventQuestRead = include("eventQuestRead")
local trainPowerTaskItem = class("trainPowerTaskItem", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("trainPowerTaskItem")
	end
	local commonTaskSingle = include("commonTaskSingle")
	target = commonTaskSingle.new(target)
	return target
end)
function trainPowerTaskItem:ctor()
	self.award, _UPVALUE0_ = nil, nil
end
function trainPowerTaskItem:onMessageListener()
end
function trainPowerTaskItem:initData(data, otherData)
	self.scheduBgColor = "#D7C3A5"
	self.scheduColor = "#ad2626"
	self.scheduValeColor = "#A9997F"
	self.scroll = otherData.scroll
	self.textGot = SoraDGetChildByName(self, "Text_Got")
	self.Image_state = SoraDGetChildByName(self, "Image_state")
	self.Node_award = SoraDGetChildByName(self, "Node_award")
	self.node = SoraDGetChildByName(self, "CCS_commonItemAward_1")
	self.Node_effect = SoraDGetChildByName(self, "Node_effect")
	self.Node_effect:setVisible(false)
	SoraDCreatAnimation(self.__cname, self, true)
	self.node:setVisible(false)
	self:initData_imp(data, otherData)
	if self.taskStatus == gBtnTargetStatusDef.GO and not eventQuestRead.isNeedShowGo(data.taskID) then
		self.Button_go:setVisible(false)
	else
		self.Button_go:setVisible(true)
	end
	if self.textGot then
		self.textGot:setVisible(self.taskStatus == gBtnTargetStatusDef.GOT)
		self.textGot:setString(i18n("common_text_1892"))
	end
	self.Image_state:loadTexture(self.taskStatus == gBtnTargetStatusDef.GOT and "frame_cz_tab_02.png" or "frame_cz_tab_01.png", ccui.TextureResType.plistType)
end
function trainPowerTaskItem:setAward()
	for i = 1, 5 do
		if self.awardArray[i] then
			self.awardArray[i]:setVisible(false)
		end
	end
	local rewardData = self.data.award
	for index = 1, table.nums(rewardData) do
		local itemAward = self.award[index]
		if itemAward then
			itemAward:initData(rewardData[index].id, rewardData[index].count)
		else
			itemAward = include("commonItemAward").new()
			itemAward:setRealScale(1)
			itemAward:setOwnScroll(self.scroll)
			itemAward:setPosition(0, 0)
			itemAward:addTo(self.Node_award)
			itemAward:initData(rewardData[index].id, rewardData[index].count)
			self.award[index] = itemAward
		end
	end
	SoraDToCenter(self.Node_award, 125, SoraDFIsRA())
end
function trainPowerTaskItem:doAction()
	local taskID = self.data.taskID
	trainPowerCtrl:reqClaimReward(taskID)
end
function trainPowerTaskItem:skipTo(taskDes)
	local guideId = self.data.guideId
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	local tbParam = mildGuideManager:splitGuideParam(guideId)
	dump(self.data, "self.data", 10)
	dump(taskDes)
	if guideId then
		local lang = taskDes[1]
		if not lang or lang == "" then
			lang = "NA"
		end
		_ENV = 10
		;(10).num = taskDes.num or ""
		;(10).lv = taskDes.lv or ""
		tbParam.msg = i18n(lang, 10)
		print(tbParam.msg)
		tbParam.minLv = taskDes.lv
		local ret, notNeedClose = mildGuideManager:starMildByNewPlayerQuestID(tbParam.id, tbParam)
		print("ret,notNeedClose", ret, notNeedClose, tbParam.id, taskDes)
		if not notNeedClose then
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function trainPowerTaskItem:setBtnStatus()
	self.Node_effect:setVisible(false)
	self.Button_go:setTouchEnabled(self.taskStatus ~= gBtnTargetStatusDef.GOT)
	self.Button_go:setTitleText(self.taskStatus == gBtnTargetStatusDef.GO and i18n("common_text_477") or self.taskStatus == gBtnTargetStatusDef.GET and i18n("common_text_1146") or self.taskStatus == gBtnTargetStatusDef.GOT and i18n("common_text_1892"))
	self.Button_go:setTitleColor(self.taskStatus == gBtnTargetStatusDef.GOT and cc.c3b(120, 120, 120) or cc.c3b(255, 255, 255))
	if self.taskStatus == gBtnTargetStatusDef.GOT then
		self.Button_go:loadTextures("btn_gray_small.png", "btn_gray_small.png", "btn_gray_small.png", ccui.TextureResType.plistType)
	elseif self.taskStatus == gBtnTargetStatusDef.GO then
		self.Button_go:loadTextures("btn_yellow_small_01.png", "btn_yellow_small_01.png", "btn_yellow_small_01.png", ccui.TextureResType.plistType)
	else
		self.Node_effect:setVisible(true)
		self.Button_go:loadTextures("btn_green_small_01.png", "btn_green_small_01.png", "btn_green_small_01.png", ccui.TextureResType.plistType)
	end
end
return trainPowerTaskItem

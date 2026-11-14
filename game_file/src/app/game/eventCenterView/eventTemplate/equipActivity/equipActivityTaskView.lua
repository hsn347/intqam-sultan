local weaponSprctrumCtrl = SoraDGetCtrl("weaponSprctrumCtrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local weaponSprctrumRead = include("weaponSprctrumRead")
local publicRead = include("publicRead")
local equipActivityTaskView = class("equipActivityTaskView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("equipActivityTaskView")
	end
	return target
end)
function equipActivityTaskView:ctor()
	self:setBackGround(127.5)
	self.activityID = gActivityTimeActivityID.EQUIP_ACTIVITY
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.ccs_title:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("ramadan_text_20"))
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Text_des:setString(i18n("spectrum_text_07"))
	self.Text_title = SoraDGetChildByName(self, "Text_title")
	self.Text_title:setString(i18n("spectrum_text_03"))
	self.Text_Task = SoraDGetChildByName(self, "Text_Task")
	self.Text_Task:setString(i18n("common_text_675"))
	self.Panel_reward = SoraDGetChildByName(self, "Panel_reward")
	self.Panel_reward = include("commonBtnInstance").new(self.Panel_reward)
	self.scroll = SoraDGetChildByName(self, "Bottom_Size_ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("equipActivityTaskSingle")
	self.ccs_Progress = SoraDGetExtendChildFromCCSByName(self, "CCS_equipActivityQuestBar_bar")
	self.Node_etBox = SoraDGetChildByName(self, "Node_etBox")
	local et_box = SoraDCreatAnimation("animationEquipTypeBox")
	et_box:addTo(self.Node_etBox)
	local effectUI = include("effectUI")
	local coolSquare = effectUI.getCoolSuqare()
	coolSquare:setPosition(-1, 4)
	coolSquare:setScale(1.5)
	coolSquare:addTo(self.Node_etBox)
	self.Node_etBox:setVisible(false)
	self.Image_box = SoraDGetChildByName(self, "Image_box")
	self.Text_num = SoraDGetChildByName(self, "Text_num")
	self.Text_claimed = SoraDGetChildByName(self, "Text_claimed")
	self.Text_claimed:setString(i18n("common_text_1892"))
	self.Text_claimed:setVisible(false)
	self:suitView()
	self:initEffect()
end
function equipActivityTaskView:suitView()
	self.scroll:setContentSize(cc.size(534, display.height - 535))
end
function equipActivityTaskView:initEffect()
	local et_jinzitaloading_09 = SoraDGetChildByName(self, "et_jinzitaloading_09")
	et_jinzitaloading_09:setAutoCull(false)
	local Node_etB = SoraDGetChildByName(self, "Node_etB")
	local et_etB = SoraDCreatAnimation("animationEquipTypeBottom")
	et_etB:addTo(Node_etB)
	local Node_etT = SoraDGetChildByName(self, "Node_etT")
	local et_etT = SoraDCreatAnimation("animationEquipTypeTop")
	et_etT:addTo(Node_etT)
end
function equipActivityTaskView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_VIEW", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function equipActivityTaskView:judgeClose()
	if self.activityID and not clientEventMgr.judgeIsOpen(self.activityID) then
		self:removeFromParent()
	end
end
function equipActivityTaskView:refreshData(target, data)
	SoraDCloseLoading(self)
	if data and data.activityID == self.activityID then
		self:initData(self.taskType)
	end
end
function equipActivityTaskView:initData(taskType)
	self.taskType = taskType
	self.ccs_title:setTitle(i18n(weaponSprctrumRead.getTypeConfig(self.taskType).title))
	local questData = activityTaskComponentCtrl:getQuestData(self.activityID)
	self.questList = weaponSprctrumRead.getTypeTask(self.taskType)
	self.curFinish = 0
	for k, v in ipairs(self.questList) do
		v.cur = questData.questProgress[tostring(v.questID)] or 0
		v.status = gBtnTargetStatusDef.GO
		if questData.claimedQuest[tostring(v.questID)] then
			v.status = gBtnTargetStatusDef.GOT
		elseif v.cur >= v.aim then
			v.status = gBtnTargetStatusDef.GET
		end
		if questData.finishedQuest[tostring(v.questID)] then
			self.curFinish = self.curFinish + 1
		end
	end
	table.sort(self.questList, function(a, b)
		if a.status == b.status then
			return a.questID < b.questID
		else
			return a.status < b.status
		end
	end)
	_ENV = self.curFinish + 1
	;(self.curFinish + 1).scroll = self.scroll
	;(self.curFinish + 1).view = self
	self.scroll:updateScrollView(cc.size(534, 130), self.questList, 1, self.curFinish + 1)
	self.typeReward = weaponSprctrumRead.getTypeReward(self.taskType)
	self.Text_num:setString(self.typeReward[2])
	self.Image_box:loadTexture(publicRead.getIcon(self.typeReward[1]), ccui.TextureResType.plistType)
	self:setBarPercent()
end
function equipActivityTaskView:setBarPercent()
	local cur = self.curFinish
	local total = 4
	local showCur = math.min(cur, total)
	self.ccs_Progress:setPercent(showCur * 100 / total, cur, total)
	local ret = false
	local isClaimed = weaponSprctrumCtrl:getClaimStatus(self.taskType)
	if 100 <= self.ccs_Progress:getPercent() and not isClaimed then
		ret = true
	end
	self.Node_etBox:setVisible(ret)
	self.Image_box:getVirtualRenderer():setState(isClaimed and 1 or 0)
	self.Text_claimed:setVisible(isClaimed)
	if ret then
		self.Panel_reward:setHandle(handler(self, self.onRewardTouchClick))
	else
		self.Panel_reward:setItemInfo(self, self.typeReward[1], self.typeReward[2])
	end
end
function equipActivityTaskView:onRewardTouchClick(target, event)
	weaponSprctrumCtrl:sendReqGetWeaponThemeReward(self.taskType)
end
function equipActivityTaskView:btnHelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "common_text_3657"
		;("common_text_3657")[1] = i18n("spectrum_text_01")
		;("common_text_3657")[2] = i18n("spectrum_text_01")
		SoraDShowFixWindow(i18n("common_text_3657"), "common_text_3657")
	end
end
return equipActivityTaskView

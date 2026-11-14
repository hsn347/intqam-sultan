local gametop = gModuleMgr.getObject("gametop")
local mileStoneCtrl = gametop.playertop_:getModule("mileStoneCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local legendMDesRead = include("legendMDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_MilepostItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChronicleView/Com_MilepostItem", Com_MilepostItem)
function Com_MilepostItem:onInit()
	self:fixChildrenPos()
	self.isRewardGray = false
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Button_Lock:addClickListener(handler(self, self.onUnlockClick))
	self.fields.Button_reward:setString(i18n("common_text_677"))
	self.fields.Button_reward:addClickListener(handler(self, self.onRewardClick))
	self.fields.Text_completed:setString(i18n("Anchor_text_21"))
end
function Com_MilepostItem:onShow()
end
function Com_MilepostItem:onItemRederer(index, target)
	target:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
	target:setGrayed(self.isRewardGray)
end
function Com_MilepostItem:initData(data)
	self.data = data
	self.info = legendMDesRead.getMileStoneInfo(self.data.taskID)
	self.fields.imgBuild:setSpriteFrame(self.info.icon)
	self.fields.Text_name:setString(i18n(self.info.name))
	self.fields.Text_des:setString(i18n(self.info.des))
	self.taskData = mileStoneCtrl:getTaskData(self.data.taskID)
	mileStoneCtrl = self.data.taskID
	self.data.taskID[1] = "id"
	self.data.taskID[2] = "count"
	self.rewardList = serviceFunctions.tableFormat(self.data.award, self.data.taskID)
	local unlock = legendMDesRead.getMileStoneUnlockCfg(self.data.index)
	if unlock and next(unlock) then
		self.unlockType = unlock[1]
		self.unlockID = unlock[2]
		self.fields.Button_Lock:setIcon(self.info.unlockicon)
		self.fields.Button_Lock:setVisible(true)
	else
		self.fields.Button_Lock:setVisible(false)
	end
	if not self.taskData or self.taskData and not self.taskData.deadlineTime then
		self.controllers.c1:setSelectedIndex(4)
		self.isRewardGray = true
		self.fields.Button_Lock:setGrayed(true)
	else
		self.isRewardGray = false
		self.fields.Button_Lock:setGrayed(false)
		if self.taskData.status == "end" then
			if self.taskData.finishAids then
				local ownTarget = self.taskData.finishAids[tostring(allianceMgr:getOwnAid())] or 0
				if self.taskData.completeTime and 0 < self.taskData.completeTime and ownTarget >= self.data.conditionnum[1] then
					if mileStoneCtrl:isRewarded(self.data.taskID) then
						self.controllers.c1:setSelectedIndex(1)
						legendMDesRead = allianceMgr:getOwnAid()
						allianceMgr:getOwnAid().var = "\n" .. os.date("%Y/%m/%d", self.taskData.completeTime)
						self.fields.Text_date:setString(i18n("alliance_stronghold_text_069", allianceMgr:getOwnAid()))
					else
						self.controllers.c1:setSelectedIndex(2)
					end
				else
					self.controllers.c1:setSelectedIndex(0)
					legendMDesRead = i18n("alliance_stronghold_text_069", allianceMgr:getOwnAid())
					i18n("alliance_stronghold_text_069", allianceMgr:getOwnAid()).var = ownTarget
					i18n("alliance_stronghold_text_069", allianceMgr:getOwnAid()).var1 = self.data.conditionnum[1]
					self.fields.Text_pro:setString(i18n("alliance_stronghold_text_070", i18n("alliance_stronghold_text_069", allianceMgr:getOwnAid())))
				end
			elseif self.taskData.completeTime and 0 < self.taskData.completeTime then
				if mileStoneCtrl:isRewarded(self.data.taskID) then
					self.controllers.c1:setSelectedIndex(1)
					legendMDesRead = i18n("alliance_stronghold_text_070", i18n("alliance_stronghold_text_069", allianceMgr:getOwnAid()))
					i18n("alliance_stronghold_text_070", i18n("alliance_stronghold_text_069", allianceMgr:getOwnAid())).var = "\n" .. os.date("%Y/%m/%d", self.taskData.completeTime)
					self.fields.Text_date:setString(i18n("alliance_stronghold_text_069", i18n("alliance_stronghold_text_070", i18n("alliance_stronghold_text_069", allianceMgr:getOwnAid()))))
				else
					self.controllers.c1:setSelectedIndex(2)
				end
			else
				self.controllers.c1:setSelectedIndex(0)
				local conditionnum = self.data.conditionnum[1]
				legendMDesRead = i18n("alliance_stronghold_text_069", i18n("alliance_stronghold_text_070", i18n("alliance_stronghold_text_069", allianceMgr:getOwnAid())))
				i18n("alliance_stronghold_text_069", i18n("alliance_stronghold_text_070", i18n("alliance_stronghold_text_069", allianceMgr:getOwnAid()))).var = self.taskData.complete
				i18n("alliance_stronghold_text_069", i18n("alliance_stronghold_text_070", i18n("alliance_stronghold_text_069", allianceMgr:getOwnAid()))).var1 = conditionnum
				self.fields.Text_pro:setString(i18n("alliance_stronghold_text_070", i18n("alliance_stronghold_text_069", i18n("alliance_stronghold_text_070", i18n("alliance_stronghold_text_069", allianceMgr:getOwnAid())))))
			end
		elseif self.taskData.finishAids then
			local ownTarget = self.taskData.finishAids[tostring(allianceMgr:getOwnAid())] or 0
			if self.taskData.completeTime and 0 < self.taskData.completeTime and ownTarget >= self.data.conditionnum[1] then
				if mileStoneCtrl:isRewarded(self.data.taskID) then
					self.controllers.c1:setSelectedIndex(1)
					legendMDesRead = allianceMgr:getOwnAid()
					allianceMgr:getOwnAid().var = "\n" .. os.date("%Y/%m/%d", self.taskData.completeTime)
					self.fields.Text_date:setString(i18n("alliance_stronghold_text_069", allianceMgr:getOwnAid()))
				else
					self.controllers.c1:setSelectedIndex(2)
				end
			else
				self.controllers.c1:setSelectedIndex(3)
				legendMDesRead = i18n("alliance_stronghold_text_069", allianceMgr:getOwnAid())
				i18n("alliance_stronghold_text_069", allianceMgr:getOwnAid()).var = ownTarget
				i18n("alliance_stronghold_text_069", allianceMgr:getOwnAid()).var1 = self.data.conditionnum[1]
				self.fields.Text_proing:setString(i18n("alliance_stronghold_text_070", i18n("alliance_stronghold_text_069", allianceMgr:getOwnAid())))
				self.fields.Text_time:beginTime(self.taskData.deadlineTime - serviceFunctions.systemTime())
			end
		elseif self.taskData.completeTime and 0 < self.taskData.completeTime then
			if mileStoneCtrl:isRewarded(self.data.taskID) then
				self.controllers.c1:setSelectedIndex(1)
				legendMDesRead = serviceFunctions.systemTime()
				serviceFunctions.systemTime().var = "\n" .. os.date("%Y/%m/%d", self.taskData.completeTime)
				self.fields.Text_date:setString(i18n("alliance_stronghold_text_069", (serviceFunctions.systemTime())))
			else
				self.controllers.c1:setSelectedIndex(2)
			end
		else
			self.controllers.c1:setSelectedIndex(3)
			local conditionnum = self.data.conditionnum[1]
			legendMDesRead = i18n("alliance_stronghold_text_069", (serviceFunctions.systemTime()))
			i18n("alliance_stronghold_text_069", (serviceFunctions.systemTime())).var = self.taskData.complete
			i18n("alliance_stronghold_text_069", (serviceFunctions.systemTime())).var1 = conditionnum
			self.fields.Text_proing:setString(i18n("alliance_stronghold_text_070", i18n("alliance_stronghold_text_069", (serviceFunctions.systemTime()))))
			self.fields.Text_time:beginTime(self.taskData.deadlineTime - serviceFunctions.systemTime())
		end
	end
	self.fields.List:setNumItems(#self.rewardList)
	self.fields.List:resizeToFit(#self.rewardList)
end
function Com_MilepostItem:onRewardClick()
	print("领奖")
	mileStoneCtrl:reqReward(self.data.taskID)
end
function Com_MilepostItem:onUnlockClick()
	print("显示解锁信息")
	dump(self.info, "self.info========")
	local name = i18n(self.info.unlockname)
	local des = i18n(self.info.unlockdes)
	local panel = include("commonPromptBoxTitle").new()
	_ENV = nil
	;(nil).title = name
	;(nil).content = des
	;(nil).yes = i18n("common_text_204")
	;(nil).handle = function()
	end
	panel:initData(nil)
	panel:show()
end
return Com_MilepostItem

local allianceDesRead = include("allianceDesRead")
local allianceltCtrl = include("allianceltCtrl")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local baseComponent = require("fgui.base.baseComponent")
local AllianceScienceSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceScienceView/AllianceScienceSingle", AllianceScienceSingle)
function AllianceScienceSingle:onInit()
	self:fixChildrenPos()
	self.fields.bg:fix()
	self.fields.bar:fixChildrenPos()
	self.fields.Text_notice:setString(i18n("common_text_283"))
	self.fields.Panel_touch:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Button_studying:setString(i18n("common_text_062"))
	self.fields.Button_studying:addClickListener(handler(self, self.btnStudyingClickCallBack))
	self.fields.Button_speed:setString(i18n("common_text_018"))
	self.fields.Button_speed:addClickListener(handler(self, self.btnSpeedClickCallBack))
	self.fields.Text_time:setTimeUpdateListener(handler(self, self.openTimeUp))
	self.labelStudyTime = self.fields.Button_studying:getChild("Text_Time")
	self.fields.List_Star:setItemRenderer(handler(self, self.onItemStarRender))
end
function AllianceScienceSingle:onShow()
end
function AllianceScienceSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_DONATE_SUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_STUDY_BACK", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_STUDY_END", handler(self, self.updateData))
end
function AllianceScienceSingle:updateData(target, data)
	if target == nil or self.singleData and data and data.sciid == self.singleData.data.id then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceScience = gametop.playertop_:getModule("allianceScience")
		self.singleData.data = allianceScience:getScienceData(self.singleData.data.id)
		self:updateView()
		if (data.msg == "MESSAGE_ALLIANCE_STUDY_BACK" or data.msg == "MESSAGE_ALLIANCE_STUDY_END") and self.handle then
			self.handle()
		end
	end
	SoraDCloseLoading()
end
function AllianceScienceSingle:initData(singleData)
	self.singleData = singleData
	self:updateView()
end
function AllianceScienceSingle:updateView()
	if self.singleData.data.isRecommended then
		self.fields.Sprite_recommand:setVisible(true)
	else
		self.fields.Sprite_recommand:setVisible(false)
	end
	local maxLv = allianceltCtrl.scienceAttr(self.singleData.data.id, gAScienceInfo.MAXLV)
	self.maxStar = allianceltCtrl.scienceAttr(self.singleData.data.id, gAScienceInfo.MAXSTAR)
	allianceltCtrl = nil
	;(nil).level = 0
	self.fields.Label_science:setString(i18n("common_text_420", nil))
	self.fields.Label_science:setIcon(allianceDesRead.getScienceIcon(self.singleData.data.id))
	self.fields.Text_name:setString(allianceDesRead.getScienceName(self.singleData.data.id))
	if self.singleData.isOpened then
		if maxLv <= self.singleData.data.lv then
			self.controllers.c1:setSelectedIndex(1)
		else
			local gametop = gModuleMgr.getObject("gametop")
			local memberMgr = gametop.playertop_:getModule("memberMgr")
			if self.singleData.data.star >= self.maxStar then
				local allianceScience = gametop.playertop_:getModule("allianceScience")
				self.queue = allianceScience:queryQueue(SCIENCE_RESEARCH_QUEUE)
				if self.queue and self.queue.data.sciid == self.singleData.data.id then
					if allianceltCtrl.getSciStarLvUpCanSpeed(self.singleData.data.id, self.singleData.data.lv, self.singleData.data.star) and permissionCtrl:hasPlayerPermission(gAPermission.ALLIANCE_TECHNOLOGY_SPEED_UP) then
						self.controllers.c1:setSelectedIndex(4)
					else
						self.controllers.c1:setSelectedIndex(5)
						allianceltCtrl = allianceDesRead.getScienceName(self.singleData.data.id)
						allianceDesRead.getScienceName(self.singleData.data.id).level = self.singleData.data.lv + 1
						self.fields.Label_science_next:setString(i18n("common_text_420", allianceDesRead.getScienceName(self.singleData.data.id)))
						self.fields.Label_science_next:setIcon(allianceDesRead.getScienceIcon(self.singleData.data.id))
					end
					local time = self.queue.timerNode.timer:getRemainTime()
					if 0 < time then
						self.fields.Text_time:beginTime(time)
					end
					self.fields.bar:setMax(self.queue.totaltime)
				elseif self.queue == nil then
					self.fields.List_Star:setNumItems(self.maxStar)
					self.controllers.c1:setSelectedIndex(3)
					if memberMgr:getOwnMember():getProperty("rank") >= gAllianceRank.R4 then
						self.fields.Button_studying:setVisible(true)
						local leftTime, activitytime = allianceScience:getScienceTechTime(self.singleData.data.id)
						self.labelStudyTime:setString(SoraDConvertSecondToString(leftTime))
						if leftTime ~= activitytime then
							self.fields.Button_studying:setString(SoraDConvertSecondToString(leftTime))
							self.labelStudyTime:setString(SoraDConvertSecondToString(activitytime))
							self.fields.Button_studying:getController("c1"):setSelectedIndex(1)
						else
							self.fields.Button_studying:setString(i18n("common_text_062"))
							self.fields.Button_studying:getController("c1"):setSelectedIndex(0)
						end
					else
						self.fields.Button_studying:setVisible(false)
					end
				end
			else
				self.fields.List_Star:setNumItems(self.maxStar)
				self.controllers.c1:setSelectedIndex(0)
			end
		end
		allianceltCtrl = 0
		;(0).level = self.singleData.data.lv
		self.fields.Label_science:setString(i18n("common_text_420", 0))
	else
		self.controllers.c1:setSelectedIndex(2)
	end
end
function AllianceScienceSingle:openTimeUp(time)
	self.fields.bar:setValue(self.queue.totaltime - time)
	local goldPay = serviceFunctions.timeConvertToGold(time)
	self.fields.Button_speed:setCostTitle(tostring(math.floor(goldPay)))
	if time <= 0 then
		self:updateView()
	end
end
function AllianceScienceSingle:onItemStarRender(index, target)
	local showType = 0
	if self.singleData.data.star >= self.maxStar then
		showType = 3
	elseif index + 1 <= self.singleData.data.star then
		showType = 1
	elseif index + 1 == self.singleData.data.star + 1 then
		showType = 2
	end
	target:getController("c1"):setSelectedIndex(showType)
end
function AllianceScienceSingle:btnStudyingClickCallBack()
	SoraDPlaySound()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	self.queue = allianceScience:queryQueue(SCIENCE_RESEARCH_QUEUE)
	if self.queue then
		SoraDShowMsgTip(i18n("common_text_653"), nil, button)
	elseif include("pyramidWarltCtrl").checkPwXianXiaSai() then
		_ENV = button
		button.tech = include("allianceDesRead").getScienceName(self.singleData.data.id)
		SoraDShowMsgBox(i18n("common_text_859", button), i18n("common_text_204"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				SoraDShowLoading()
				local gametop = gModuleMgr.getObject("gametop")
				local allianceScience = gametop.playertop_:getModule("allianceScience")
				allianceScience:reqResearchSci(self.singleData.data.id)
			end
		end)
	end
end
function AllianceScienceSingle:btnSpeedClickCallBack()
	SoraDPlaySound()
	if self.queue then
		_ENV = "common_text_4722"
		;("common_text_4722").speedUpName = i18n("common_text_018")
		;("common_text_4722").isBySelf = false
		SoraDShowSpeedUpBox(self.queue, handler(self, self.speedUpCallBack), i18n("common_text_4722"), "common_text_4722")
	end
end
function AllianceScienceSingle:speedUpCallBack(type)
	if type == MSGBOX_CALLBACK_SPEEDUP then
		SoraDGetCtrl("allianceMgr"):reqSpeedAllianceScience()
	end
end
function AllianceScienceSingle:btnClickCallBack()
	SoraDPlaySound()
	if self.singleData.isOpened then
		_ENV = nil
		;(nil).data = self.singleData.data
		uiManager:show("AllianceScienceInfo", nil)
	else
		SoraDShowMsgTip(i18n("notice_0081"), nil, button)
	end
end
return AllianceScienceSingle

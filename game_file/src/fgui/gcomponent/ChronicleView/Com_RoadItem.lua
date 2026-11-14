local gametop = gModuleMgr.getObject("gametop")
local legendMCtrl = gametop.playertop_:getModule("legendMCtrl")
local legendMDesRead = include("legendMDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_RoadItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChronicleView/Com_RoadItem", Com_RoadItem)
function Com_RoadItem:onInit()
	self.fields.Button_View:setTitleText(i18n("common_text_829"))
	self.fields.Button_View:addClickListener(handler(self, self.onClick_btnView))
	self.fields.Button_View:setSwallowTouches(true)
	self.fields.Button:addClickListener(handler(self, self.onClick_Panel))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.text_reward:setString(i18n("common_text_4458"))
end
function Com_RoadItem:onShow()
end
function Com_RoadItem:initData(data)
	self.data = data
	self.cfgData = self.data.data
	self.pageType = self.data.pageType
	self.achieveID = self.data.data.achievementID
	if self.pageType == legendMDesRead.PageType.ALLIANCEROAD then
		self.serverData = legendMCtrl:getAllianceAchieveDataById(self.achieveID)
		self.controllers.c2:setSelectedIndex(0)
	elseif self.pageType == legendMDesRead.PageType.SERVERROAD then
		self.serverData = legendMCtrl:getKingdomAchieveDataById(self.achieveID)
		self.controllers.c2:setSelectedIndex(1)
	end
	self.fields.txt_title:setString(i18n(self.cfgData.achiName))
	self.fields.text_des:setString(i18n(self.cfgData.slogan))
	self.fields.text_cond:setString(i18n(self.cfgData.achiDes))
	_ENV = i18n(self.cfgData.achiDes)
	i18n(self.cfgData.achiDes)[1] = "id"
	i18n(self.cfgData.achiDes)[2] = "count"
	self.rewards = serviceFunctions.tableFormat(self.cfgData.achievementRewards, i18n(self.cfgData.achiDes))
	self.fields.List:setNumItems(#self.rewards)
	self.fields.txt_buff:setString(i18n(self.cfgData.buffName))
	self:updateStatus()
end
function Com_RoadItem:updateStatus()
	self.fields.Button_Item:getTransition("t0"):stop()
	if self.serverData.status == gKingChroniclesAchieveStatus.COMPLETED then
		local isShowFull = false
		if self:isRewardGeted() then
			self.controllers.c1:setSelectedIndex(2)
		else
			self.controllers.c1:setSelectedIndex(0)
			if self.pageType == legendMDesRead.PageType.ALLIANCEROAD then
				local joinTime = self:getAllianceJoinTime()
				if joinTime > self.serverData.finishTime then
					self.fields.button_info:setVisible(false)
					isShowFull = true
				end
			end
			self.fields.Button_Item:getTransition("t0"):play(-1, 0, 0, -1)
		end
		if self.cfgData.view == 1 then
			self.fields.Button_View:setVisible(true)
		else
			self.fields.Button_View:setVisible(false)
		end
		local finishTime = self.serverData.finishTime or 0
		if isShowFull then
			_ENV = -1
			;(-1).time = legendMCtrl:getHistoryYearFull(self.serverData.finishTime, true)
			self.fields.txt_complish:setString(i18n("history_text_59", -1))
		else
			_ENV = i18n("history_text_59", -1)
			i18n("history_text_59", -1).time = legendMCtrl:getHistoryYear(finishTime)
			self.fields.txt_complish:setString(i18n("history_text_17", i18n("history_text_59", -1)))
		end
	else
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Button_View:setVisible(false)
		local conditionnum = self.cfgData.conditionnum
		if 0 < conditionnum then
			local curNum = self.serverData.curNum
			self.fields.txt_progress:setString(string.format([[
%s/%s
%s]], string.formatnumberthousands(curNum), string.formatnumberthousands(conditionnum), i18n("common_text_2139")))
		end
	end
end
function Com_RoadItem:getAllianceJoinTime()
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local jointime = memberMgr:getOwnMember():getProperty("joinTime")
	return jointime
end
function Com_RoadItem:isRewardGeted()
	local isRewardGeted = false
	if self.pageType == legendMDesRead.PageType.ALLIANCEROAD then
		isRewardGeted = legendMCtrl:getIsAllianceAchieveRewardGet(self.achieveID)
	elseif self.pageType == legendMDesRead.PageType.SERVERROAD then
		isRewardGeted = legendMCtrl:getIsKingdomAchieveRewardGet(self.achieveID)
	end
	return isRewardGeted
end
function Com_RoadItem:onItemRederer(index, target)
	target:initData(self.rewards[index + 1].id, self.rewards[index + 1].count)
end
function Com_RoadItem:onClick_btnView()
	dump(self.data, "self.data", 10)
	SoraDPlaySound()
	uiManager:show("LegendMPopList", self.data)
end
function Com_RoadItem:onClick_Panel()
	SoraDPlaySound()
	dump(self.data, "self.dat onClick_Panel")
	dump(self.cfgData, "self.cfgData onClick_Panel")
	dump(self.serverData, "self.serverData onClick_Panel")
	print("self:isRewardGeted()", self:isRewardGeted())
	if self.serverData.status == gKingChroniclesAchieveStatus.COMPLETED and not self:isRewardGeted() then
		local achieveID = self.data.data.achievementID
		print("发起领奖------", achieveID)
		if self.pageType == legendMDesRead.PageType.ALLIANCEROAD then
			local joinTime = self:getAllianceJoinTime()
			if joinTime <= self.serverData.finishTime then
				SoraDShowLoading()
				legendMCtrl:reqAllianceAchieveReward(achieveID)
			end
		elseif self.pageType == legendMDesRead.PageType.SERVERROAD then
			SoraDShowLoading()
			legendMCtrl:reqKingdomAchieveReward(achieveID)
		end
	end
end
return Com_RoadItem

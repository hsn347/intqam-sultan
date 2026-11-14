local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NbulaMileStonePanel = class("NbulaMileStonePanel", baseFguiPanel)
local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
local nebulaMileStoneRead = include("nebulaMileStoneRead")
function NbulaMileStonePanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("NbulaMileStonePanel:ctor", self.viewName)
end
function NbulaMileStonePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NbulaMileStonePanel:onInit()
	print("=======NbulaMileStonePanel:onInit")
	self.fields.Com_title:initData(i18n("alliance_stronghold_text_068"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.bg:setPrivewImage("#bg_lcb_bjt.png", cc.size(852, 1386), true, true)
	self.fields.title_scroll:setItemRenderer(handler(self, self.onTitlesRenderer))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemsRenderer))
	self.fields.scroll2:setItemRenderer(handler(self, self.onChaptersRenderer))
	self.fields.btn_get:setTitle(i18n("common_text_1146"))
	self.fields.btn_get:addClickEventListener(handler(self, self.onClickGot))
	self.fields.text_target:setString(i18n("nebula_milestone_title_0002"))
	self.fields.text_reward:setString(i18n("atlantiswar_text_0019"))
	self.fields.txt_got:setString(i18n("common_text_1892"))
	self.text_time = SoraDCreateTimerLabel(self, self.fields.text_time)
	self.fields.text_reward_tip:setString(i18n("nebula_war_text_0249"))
	nebulaMileStoneCtrl:sendDataMsg()
end
function NbulaMileStonePanel:onShow()
	print("=======NbulaMileStonePanel:onShow")
	self.chapters = nebulaMileStoneRead.getChapters()
	self.fields.scroll2:setNumItems(#self.chapters)
end
function NbulaMileStonePanel:updateView()
	if self.configs == nil then
		self.fields.scroll2:setNumItems(#self.chapters)
		return
	end
	self.infos, _ENV = self.fields.scroll2.setNumItems, self.fields.scroll2.setNumItems
	self.isAllEnd = true
	for k, v in ipairs(self.configs) do
		local _ENV, info
		info.taskCfg = v
		info.data = nebulaMileStoneCtrl:getTaskData(v.milestoneID)
		if not info.data or info.data.status ~= "end" then
			self.isAllEnd = false
		end
		table.insert(self.infos, info)
	end
	table.sort(self.infos, function(a, b)
		return a.taskCfg.prevID < b.taskCfg.prevID
	end)
	self.curBeginIndex = -1
	self:updateCurPage()
end
function NbulaMileStonePanel:updateCurPage()
	for i, v in ipairs(self.infos) do
		if v.data and v.data.status == "begin" then
			self.curBeginIndex = i
			if self.curIdx == -1 then
				self.curIdx = i
			elseif self.curIdx > self.curBeginIndex + 1 then
				self.curIdx = self.curBeginIndex
			end
		end
	end
	if self.curIdx == -1 then
		self.curIdx = self.isAllEnd and #self.infos or 1
		self.curBeginIndex = self.curIdx
	end
	self.curInfo = self.infos[self.curIdx]
	if not self.curInfo then
		return
	end
	dump(self.curInfo, "self.curInfo", 10)
	local taskID = self.curInfo.taskCfg.milestoneID
	local data = self.curInfo.data
	self.taskID = taskID
	self.fields.title_scroll:setNumItems(#self.infos)
	if data == nil or data.status == "prepare" then
		self.fields.text_time:setVisible(false)
		self.fields.text_status:setVisible(true)
		self.fields.text_status:setColor(cc.c3b(255, 1, 1))
		self.fields.text_status:setString(i18n("common_text_699"))
	elseif data.status == "end" then
		self.fields.text_time:setVisible(false)
		self.fields.text_status:setVisible(true)
		self.fields.text_status:setColor(cc.c3b(1, 255, 1))
		self.fields.text_status:setString(i18n("Anchor_text_21"))
	else
		self.fields.text_time:setVisible(true)
		self.fields.text_status:setVisible(false)
		self.fields.text_time:beginTime(data.end_timestamp - serviceFunctions.systemTime())
	end
	self.fields.icon_time:setVisible(self.fields.text_time:isVisible())
	local isCanGetReward = data and data.curCompleteTime ~= 0
	self.isGotReward = isCanGetReward and data and data.status == "end"
	self.controllers.c1:setSelectedIndex(2)
	self.fields.txt_got:setVisible(data.status == "end")
	if self.isGotReward then
		self.fields.txt_got:setString(i18n("common_text_2601"))
		self.fields.txt_got:setColor(cc.c3b(1, 255, 1))
	else
		self.fields.txt_got:setString(i18n("common_text_2139"))
		self.fields.txt_got:setColor(cc.c3b(255, 1, 1))
	end
	self.fields.text_complete_time:setVisible(isCanGetReward)
	if isCanGetReward then
		self.fields.text_complete_time:setString(os.date("!%Y-%m-%d %H:%M:%S ", data.curCompleteTime) .. i18n("common_text_2601"))
	end
	self.fields.text_progress:setVisible(not isCanGetReward and (data == nil or data.status ~= "end"))
	if not isCanGetReward then
		local completeNum = data and data.curComplete or 0
		self.fields.text_progress:setString("(" .. completeNum .. "/" .. self.curInfo.taskCfg.aim[1] .. ")")
	end
	self.fields.text_desc:setString(nebulaMileStoneRead.getDes(taskID))
	_UPVALUE2_ = nebulaMileStoneRead.getDes(taskID)
	nebulaMileStoneRead.getDes(taskID)[1] = "id"
	nebulaMileStoneRead.getDes(taskID)[2] = "count"
	self.rewards = serviceFunctions.tableFormat(self.curInfo.taskCfg.reward, nebulaMileStoneRead.getDes(taskID))
	local funcDes = nebulaMileStoneRead.getFuncDes(taskID)
	self.fields.text_func:setVisible(funcDes ~= nil)
	if funcDes then
		self.fields.text_func:setString(funcDes)
	end
	self.fields.scroll:setNumItems(#self.rewards)
	self.fields.title_scroll:scrollToView(self.curIdx - 1, false, false)
end
function NbulaMileStonePanel:onTitlesRenderer(index, obj)
	local info = self.infos[index + 1]
	obj:setData(info, index == self.curIdx - 1, index + 1 > self.curBeginIndex + 1 and (info.data == nil or info.data.status == "prepare"))
	obj:setClickHandler(handler(self, self.onClicked), index)
end
function NbulaMileStonePanel:onItemsRenderer(index, obj)
	local award = self.rewards[index + 1]
	obj:initData(award.id, award.count, self.isGotReward)
end
function NbulaMileStonePanel:onChaptersRenderer(index, obj)
	obj:initData(self.chapters[index + 1], index + 1)
	obj:setClickHandler(handler(self, self.onChapterClick))
end
function NbulaMileStonePanel:onChapterClick(index)
	self.controllers.c2:setSelectedIndex(1)
	nebulaMileStoneCtrl:sendDataMsg()
	self.configs = nebulaMileStoneRead.getConfigs(index)
	self.curIdx = -1
	self:updateView()
end
function NbulaMileStonePanel:onClicked(button, index)
	self.curIdx = index + 1
	self:updateCurPage()
end
function NbulaMileStonePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("nebula_milestone_rule_0001")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function NbulaMileStonePanel:onClickGot()
	nebulaMileStoneCtrl:sendreceive(self.taskID)
	SoraDMailGainItems(self.rewards, true)
end
function NbulaMileStonePanel:onClickClose()
	if self.configs ~= nil then
		self.controllers.c2:setSelectedIndex(0)
		nebulaMileStoneCtrl:sendDataMsg()
		self.configs = nil
		self.fields.scroll2:setNumItems(#self.chapters)
	else
		self:close()
	end
end
return NbulaMileStonePanel

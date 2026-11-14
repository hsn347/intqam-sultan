local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicBattleAwardDetailView = class("epicBattleAwardDetailView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicBattleAwardDetailView")
	end
	return target
end)
function epicBattleAwardDetailView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("hero_title_02"))
	self.Text_none = SoraDGetChildByName(self, "Text_none")
	self.Text_none:setString(i18n("epicbattle_text_37"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_event")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("epicBattleAwardDetailSingle")
	epicWarCtrl:sendReqLogList()
	SoraDShowLoading(self)
end
function epicBattleAwardDetailView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_LOG_BACK", handler(self, self.initData))
end
function epicBattleAwardDetailView:initData(target, data)
	SoraDCloseLoading(self)
	local eventData = data.logArray
	local ret = true
	if next(eventData) then
		ret = false
	end
	table.sort(eventData, function(a, b)
		return a.time > b.time
	end)
	self.Text_none:setVisible(ret)
	local _ENV, awardList = self.Text_none.setVisible, self.Text_none.setVisible
	local isInList = function(awardList, data)
		local isIn = false
		for k, v in ipairs(awardList) do
			if v.id == data.id then
				isIn = true
				v.count = v.count + data.count
			end
		end
		if not isIn then
			table.insert(awardList, data)
		end
	end
	for k, v in ipairs(eventData) do
		for ki, vi in ipairs(v.logData.reward) do
			isInList(awardList, vi)
		end
	end
	_ENV = ipairs(v.logData.reward)
	ipairs(v.logData.reward).scroll = self.scroll
	ipairs(v.logData.reward).view = self
	self.scroll:updateScrollView(cc.size(514, 90), awardList, 1, ipairs(v.logData.reward))
end
return epicBattleAwardDetailView

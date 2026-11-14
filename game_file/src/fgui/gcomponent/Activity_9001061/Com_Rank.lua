local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local activityCtrl = gametop.playertop_:getModule("activityCtrl")
local activityltCtrl = include("activityltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Rank = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001061/Com_Rank", Com_Rank)
function Com_Rank:onInit()
	self.rankTag = 1
	self:fixChildrenPos()
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Button_viewRank:setString(i18n("common_text_2187"))
	self.fields.Button_viewRank:addClickListener(handler(self, self.onBtnViewRank))
	self.fields.Text_myScore:setString(i18n("common_text_625"))
end
function Com_Rank:onShow()
	self:initPlayerData()
end
function Com_Rank:onItemRederer(index, target)
	target:initData(self.rankData[index + 1])
end
function Com_Rank:setRankTag(rankTag)
	self.rankTag = rankTag
	local rank = ""
	self.rankData, activityCtrl = nil, nil
	if self.rankTag == 1 then
		rank = 1 > activityCtrl.curStageRank and "5000+" or activityCtrl.curStageRank
		self.rankData = activityltCtrl.getStageReward(activityCtrl.curActivityID, activityCtrl.serverLv)
	else
		rank = 1 > activityCtrl.totalRank and "5000+" or activityCtrl.totalRank
		self.rankData = activityltCtrl.getTotalRankReward(activityCtrl.serverLv)
	end
	activityCtrl = nil
	;(nil).rank = rank
	self.fields.Text_rank:setString(i18n("common_text_825", nil))
	self.fields.List:setNumItems(#self.rankData)
	self.fields.List:jumpToTop()
end
function Com_Rank:initPlayerData()
	local lordInfo = lordInfoCtrl:getLordInfo()
	local name = lordInfo.base.nickName
	if lordInfo.abbr and string.len(lordInfo.abbr) > 0 then
		lordInfoCtrl = nil
		;(nil).abbr = lordInfo.abbr
		;(nil).name = name
		name = i18n("common_text_186", nil)
	end
	self.fields.Com_head:setHeadSprite()
	self.fields.Com_head:setPlayerID()
	self.fields.Text_name:setString(name)
end
function Com_Rank:onBtnViewRank()
	SoraDPlaySound()
	_ENV = nil
	;(nil).defaultType = self.rankTag
	uiManager:show("Activity_9001061_Rank", nil)
end
return Com_Rank

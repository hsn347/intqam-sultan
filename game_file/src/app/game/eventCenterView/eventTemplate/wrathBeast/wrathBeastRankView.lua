local gametop = gModuleMgr.getObject("gametop")
local wrathBeastRankSingle = include("wrathBeastRankSingle")
local wrathBeastCtrl = SoraDGetCtrl("wrathBeastCtrl", gametop)
local wrathBeastRankView = class("wrathBeastRankView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("wrathBeastRankView")
	end
	return target
end)
function wrathBeastRankView:ctor()
	self:initWidget()
	wrathBeastCtrl:sendReqRankMsg()
end
function wrathBeastRankView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WRATH_BEAST_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
end
function wrathBeastRankView:initWidget()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("god_beast_text_39"))
	self.Image_info = SoraDGetChildByName(self, "Image_info")
	SoraDGetChildByName(self.Image_info, "Text_name"):setString(i18n("rides_title_03"))
	SoraDGetChildByName(self.Image_info, "Text_score"):setString(i18n("god_beast_text_23"))
	SoraDGetChildByName(self.Image_info, "Text_rank"):setString(i18n("common_text_2193"))
	self.Text_noRecrod = SoraDGetChildByName(self, "Text_noRecrod")
	self.Text_noRecrod:setString(i18n("god_beast_text_16"))
	self.Node_my = SoraDGetChildByName(self, "Node_my")
	self.Node_my = wrathBeastRankSingle.new(self.Node_my)
	self.Node_my:setClickHandle(handler(self, self.click_my_callback))
	self.Node_my:setVisible(false)
	self.Node_single = SoraDGetChildByName(self, "Node_single")
	self.scroll = SoraDGetChildByName(self, "ScrollView_rank")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(function()
		local wrathBeastRankSingle = wrathBeastRankSingle.new(self.Node_single:clone())
		wrathBeastRankSingle:setClickHandle(handler(self, self.click_head_callback))
		return wrathBeastRankSingle
	end)
end
function wrathBeastRankView:initData(target, data)
	if data.name ~= "rank" then
		return
	end
	self.selfRank = wrathBeastCtrl:getActivityData("selfRank")
	local rankData = wrathBeastCtrl:getActivityData("ranks")
	self.rankData = rankData
	wrathBeastCtrl = nil
	;(nil).isSelf = true
	self.Node_my:initData(self.selfRank, nil)
	self.Node_my:setVisible(true)
	if rankData and next(rankData) then
		self.scroll:setVisible(true)
		wrathBeastCtrl = nil
		;(nil).scroll = self.scroll
		;(nil).view = self
		self.scroll:updateScrollView(cc.size(544, 102), rankData, 1, nil)
		self.Text_noRecrod:setVisible(false)
	else
		self.scroll:setVisible(false)
		self.Text_noRecrod:setVisible(true)
	end
end
function wrathBeastRankView:click_my_callback(...)
	local index = self.selfRank.rank
	if self.rankData[index] then
		self.scroll:jumpIndexToTop(index)
	end
end
function wrathBeastRankView:click_head_callback(data)
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl", gametop)
	if data.rank == self.selfRank.rank then
		SoraDOpenLordView(lordInfoCtrl:getLordInfo())
	else
		lordInfoCtrl:getLordInfoByUid(tonumber(data.uid), gametop.playertop_:getKingdomID())
		SoraDShowLoading(self, nil, nil, nil, 15)
	end
end
function wrathBeastRankView:serverMessageGetLordInfo(target, data)
	if data and data.lord then
		SoraDCloseLoading(self)
		SoraDOpenLordView(data.lord)
	end
end
return wrathBeastRankView

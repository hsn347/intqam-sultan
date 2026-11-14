local gametop = gModuleMgr.getObject("gametop")
local collectSalaryARankSingle = include("collectSalaryARankSingle")
local collectSalaryCtrl = SoraDGetCtrl("collectSalaryCtrl", gametop)
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local collectSalaryAllianceRank = class("collectSalaryAllianceRank", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("collectSalaryAllianceRank")
	end
	return target
end)
function collectSalaryAllianceRank:ctor()
	self:initWidget()
end
function collectSalaryAllianceRank:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_COLLECT_RANK_MESSAGE", handler(self, self.initData))
end
function collectSalaryAllianceRank:initWidget()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("treasuremap_text_06"))
	self.Image_info = SoraDGetChildByName(self, "Image_info")
	SoraDGetChildByName(self.Image_info, "Text_name"):setString(i18n("common_text_264"))
	SoraDGetChildByName(self.Image_info, "Text_score"):setString(i18n("common_text_1764"))
	SoraDGetChildByName(self.Image_info, "Text_rank"):setString(i18n("common_text_2193"))
	self.Text_noRecrod = SoraDGetChildByName(self, "Text_noRecrod")
	self.Text_noRecrod:setString(i18n("god_beast_text_16"))
	self.Node_single = SoraDGetChildByName(self, "Node_single")
	self.scroll = SoraDGetChildByName(self, "ScrollView_rank")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(function()
		local rankSingle = collectSalaryARankSingle.new(self.Node_single:clone())
		return rankSingle
	end)
end
function collectSalaryAllianceRank:initData(target, data)
	if data.subMsg ~= "rank_AMRT" then
		return
	end
	self.selfRank = data.selfRank
	if not data.rankData.rankData then
		_ENV = data.rankData.rankData
	end
	self.rankData = data.rankData.rankData
	if self.rankData and next(self.rankData) then
		self.scroll:setVisible(true)
		_ENV = nil
		;(nil).scroll = self.scroll
		;(nil).view = self
		self.scroll:updateScrollView(cc.size(544, 102), self.rankData, 1, nil)
		self.Text_noRecrod:setVisible(false)
	else
		self.scroll:setVisible(false)
		self.Text_noRecrod:setVisible(true)
	end
end
function collectSalaryAllianceRank:click_head_callback(data)
	if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
		print("node is not on view")
		return
	end
	dump(data, "aaa", 10)
	SoraDPlaySound()
	if data.rank == self.selfRank.rank then
		SoraDOpenLordView(lordInfoCtrl:getLordInfo())
	else
		local chatConst = include("chatConst")
		local chatFunctions = include("chatFunctions")
		cityCtrl = "chatFunctions"
		;("chatFunctions")[1] = chatConst.OpId.OpSendEmail
		local ("chatFunctions")[2], menuData = chatConst.OpId.OpViewInfo, "chatFunctions"
		local bIsShield = chatFunctions.getIsShield(data.uid)
		if bIsShield == true then
			table.insert(menuData, chatConst.OpId.OpUnShield)
		elseif bIsShield == false then
			table.insert(menuData, chatConst.OpId.OpShield)
		end
		local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
		if curLevel >= CASTLE_LV10_LIMITED then
			table.insert(menuData, chatConst.OpId.OpSendFlower)
		end
		local member = memberMgr:getOwnMember()
		local ownRank = member:getProperty("rank")
		local otherRank = data.rank
		if ownRank >= gAllianceRank.R4 and ownRank > otherRank then
			table.insert(menuData, chatConst.OpId.OnKickOutAlliance)
		end
		_ENV = lordInfoCtrl:getLordInfo()
		lordInfoCtrl:getLordInfo().playerId = data.uid
		lordInfoCtrl:getLordInfo().nickName = data.nickName
		lordInfoCtrl:getLordInfo().allianceAbbr = lordInfoCtrl:getLordInfo().abbr
		SoraDShowPlayerOperatePanel(data.nickName, menuData, lordInfoCtrl:getLordInfo())
	end
end
function collectSalaryAllianceRank:serverMessageGetLordInfo(target, data)
	if data and data.lord then
		SoraDCloseLoading(self)
		SoraDOpenLordView(data.lord)
	end
end
function collectSalaryAllianceRank:setNameData(data)
	if data.title then
		self.ccs_bg:setTitleName(data.title)
	end
	if data.score then
		SoraDGetChildByName(self.Image_info, "Text_score"):setString(data.score)
	end
end
return collectSalaryAllianceRank
